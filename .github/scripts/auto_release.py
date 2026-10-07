#!/usr/bin/env python3
"""Publish every versioned release zip under releases/ as a GitHub release (idempotent),
mark the newest as latest and apply the local retention policy.

Release notes come from the matching CHANGELOG section. A release without a changelog
entry is published with "NO CHANGELOG PROVIDED - REUSING MOST RECENT CHANGELOG" followed by
the most recent older changelog section, instead of being skipped.

Usage:
    python3 .github/scripts/auto_release.py            # publish (needs GH_TOKEN for gh)
    python3 .github/scripts/auto_release.py --dry-run  # preview only, no gh/git writes
"""
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

from packaging.version import InvalidVersion, Version  # type: ignore

PREFIX = "ae3"
CHANGELOG_PATHS = [Path("releases/CHANGELOG.md"), Path("CHANGELOG.md")]
NO_CHANGELOG = "NO CHANGELOG PROVIDED - REUSING MOST RECENT CHANGELOG"
VERSION_TOKEN = re.compile(r"v?(\d+(?:\.\d+){1,3})")

DRY_RUN = "--dry-run" in sys.argv


def run(cmd, check=True):
    """Run a gh/git command; in dry-run mode only print it."""
    if DRY_RUN:
        print(f"   [dry-run] {' '.join(cmd)}")
        return subprocess.CompletedProcess(cmd, 0, b"", b"")
    return subprocess.run(cmd, check=check)


def read_changelog():
    for path in CHANGELOG_PATHS:
        if path.exists():
            try:
                return path.read_text(encoding="utf-8").splitlines()
            except Exception as e:
                print(f"⚠️  Could not read {path}: {e}")
    return []


def changelog_sections():
    """Split the CHANGELOG into [(heading versions, text)] in file order.

    Sections start at '## ' headings, e.g. '## Hotfix 11 (v2.0.0.7)', '## Version: 3.0.0 - Title'
    or '## 1.0.0'; a top-level '# ' heading also ends a section.
    """
    sections = []
    current = None
    for line in read_changelog():
        if line.startswith("## "):
            current = (VERSION_TOKEN.findall(line[3:]), [line.strip()])
            sections.append(current)
        elif line.startswith("# "):
            current = None
        elif current is not None:
            current[1].append(line.rstrip())
    result = []
    for versions, body in sections:
        text = "\n".join(body).strip()
        if text:
            result.append((versions, text))
    return result


def get_changelog_notes(version):
    """Return the CHANGELOG section for a version, or None if there is none.

    An exact version match wins; a 4-part build falls back to its 3-part version.
    """
    sections = changelog_sections()
    parts = version.split(".")
    short = ".".join(parts[:3]) if len(parts) == 4 else None
    for target in [version, short]:
        if target:
            for versions, text in sections:
                if target in versions:
                    return text
    return None


def get_recent_changelog(version):
    """Most recent CHANGELOG section older than the version (by version number);
    the first section in the file when none is older. None without a changelog."""
    sections = changelog_sections()
    if not sections:
        return None
    target = Version(version)
    best = None
    for versions, text in sections:
        for v_str in versions:
            try:
                v = Version(v_str)
            except InvalidVersion:
                continue
            if v < target and (best is None or v > best[0]):
                best = (v, text)
    return best[1] if best else sections[0][1]


def get_version_from_filename(filename):
    """root_mod-1.2.3.4.zip -> '1.2.3.4'; None for non-version names such as -latest.zip."""
    if not (filename.startswith(f"{PREFIX}-") and filename.endswith(".zip")):
        return None
    version = filename[len(PREFIX) + 1:-len(".zip")]
    try:
        Version(version)
    except InvalidVersion:
        return None
    return version


def release_exists(version):
    if DRY_RUN:
        return False
    result = subprocess.run(["gh", "release", "view", version], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return result.returncode == 0


def publish(zip_file, version):
    print(f"🚀 Processing version: {version}")
    notes = get_changelog_notes(version)
    has_notes = notes is not None
    if not has_notes:
        print(f"⚠️  No changelog entry for {version}, reusing the most recent changelog")
        recent = get_recent_changelog(version)
        notes = f"{NO_CHANGELOG}\n\n{recent}" if recent else NO_CHANGELOG
    title = f"Version {version}"

    if release_exists(version):
        print(f"🔄 Release {version} exists, updating...")
        assets_proc = subprocess.run(
            ["gh", "release", "view", version, "--json", "assets", "--jq", ".assets[].name"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        if assets_proc.returncode == 0:
            for asset in assets_proc.stdout.decode().strip().splitlines():
                if asset:
                    print(f"🗑️  Deleting old asset: {asset}")
                    subprocess.run(["gh", "release", "delete-asset", version, asset, "--yes"],
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        run(["gh", "release", "upload", version, str(zip_file), "--clobber"])
        # Keep existing notes when the changelog has nothing for this version
        if has_notes:
            run(["gh", "release", "edit", version, "--title", title, "--notes", notes])
        print(f"✅ Updated release: {version}")
    else:
        print(f"🆕 Creating new release: {version}")
        if DRY_RUN:
            print("   --- release notes ---")
            print("   " + notes.replace("\n", "\n   "))
        run(["gh", "release", "create", version, str(zip_file), "--title", title, "--notes", notes])
        print(f"✅ Created new release: {version}")


def main():
    if DRY_RUN:
        print("🔍 Dry run: nothing will be published or committed")

    releases_dir = Path("releases")
    if not releases_dir.exists():
        print("📁 Releases directory does not exist, nothing to process")
        return

    versioned = []
    for zip_file in releases_dir.glob(f"{PREFIX}-*.zip"):
        version = get_version_from_filename(zip_file.name)
        if version:
            versioned.append((zip_file, version))
        else:
            print(f"ℹ️  Skipping non-versioned file {zip_file.name}")

    if not versioned:
        print("📭 No versioned release files found")
        return

    print(f"📦 Found {len(versioned)} versioned release files")
    for zip_file, version in sorted(versioned, key=lambda item: Version(item[1])):
        publish(zip_file, version)

    newest = max(versioned, key=lambda item: Version(item[1]))[1]
    print(f"🏷️  Marking {newest} as latest...")
    if DRY_RUN or release_exists(newest):
        run(["gh", "release", "edit", newest, "--latest"])
        print(f"✅ Marked {newest} as latest release")
    else:
        print(f"⚠️  Release {newest} does not exist, cannot mark as latest")

    print("🧹 Applying retention policy...")
    apply_retention_policy(versioned)


def apply_retention_policy(versioned):
    """Keep 1 major, 2 minor, 3 patch versions (latest build of each) and delete the rest locally."""
    major_map = defaultdict(list)
    minor_map = defaultdict(list)
    patch_map = defaultdict(list)
    for _, v_str in versioned:
        v = Version(v_str)
        major_map[f"{v.major}"].append(v_str)
        minor_map[f"{v.major}.{v.minor}"].append(v_str)
        patch_map[f"{v.major}.{v.minor}.{v.micro}"].append(v_str)

    kept = set()
    for major in sorted(major_map, key=Version, reverse=True)[:1]:
        minors = sorted({f"{major}.{Version(v).minor}" for v in major_map[major]}, key=Version, reverse=True)[:2]
        for minor in minors:
            patches = sorted({f"{minor}.{Version(v).micro}" for v in minor_map[minor]}, key=Version, reverse=True)[:3]
            for patch in patches:
                builds = sorted(patch_map[patch], key=Version, reverse=True)
                if builds:
                    kept.add(builds[0])

    print(f"🔒 Keeping versions: {sorted(kept, key=Version)}")

    deleted_any = False
    for zip_file, version in versioned:
        if version not in kept:
            print(f"🗑️  Deleting old local archive: {zip_file.name}")
            if not DRY_RUN:
                zip_file.unlink()
            deleted_any = True

    if deleted_any and not DRY_RUN:
        run(["git", "config", "user.name", "github-actions"])
        run(["git", "config", "user.email", "github-actions@github.com"])
        run(["git", "add", "releases/"])
        run(["git", "commit", "-m", "Cleanup: remove old mod releases [skip ci]"])
        run(["git", "push"])
        print("✅ Cleanup committed to repository")
    elif not deleted_any:
        print("✅ No old files to clean up")


if __name__ == "__main__":
    main()

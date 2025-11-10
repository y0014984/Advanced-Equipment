#!/usr/bin/env python3
import re
import os
import sys
import subprocess
from pathlib import Path
from packaging.version import Version # type: ignore
from collections import defaultdict

def get_latest_version():
    """Get the latest version from release files"""
    releases_dir = Path("releases")
    if not releases_dir.exists():
        return None
    
    versioned_zips = list(releases_dir.glob("ae3-*.zip"))
    latest_zip = releases_dir / "ae3-latest.zip"
    versioned_zips = [z for z in versioned_zips if z != latest_zip]
    
    if not versioned_zips:
        return None
    
    def get_version_from_filename(filename):
        try:
            return filename.name.split("ae3-")[1].split(".zip")[0]
        except:
            return None
    
    versions = []
    for zip_file in versioned_zips:
        version = get_version_from_filename(zip_file)
        if version:
            try:
                Version(version)  # Validate version
                versions.append(version)
            except:
                continue
    
    if not versions:
        return None
    
    # Return the highest version
    return sorted(versions, key=Version, reverse=True)[0]

def update_readme_version(version, status="success"):
    """Update version and build status in README.md"""
    readme_path = Path("README.md")
    if not readme_path.exists():
        print("❌ README.md not found")
        return False, None
    
    try:
        with open(readme_path, 'r', encoding='utf-8') as f:
            old_content = f.read()
        
        content = old_content
        
        # Update version badge
        version_badge_pattern = r'!\[version\]\(https://img\.shields\.io/badge/version-[^-]+-blue\)'
        new_version_badge = f'![version](https://img.shields.io/badge/version-{version}-blue)'
        content = re.sub(version_badge_pattern, new_version_badge, content)
        
        # Update build status badge
        if status == "success":
            build_badge = '![build](https://img.shields.io/badge/build-passing-green)'
        else:
            build_badge = '![build](https://img.shields.io/badge/build-failing-red)'
        
        build_badge_pattern = r'!\[build\]\(https://img\.shields\.io/badge/build-(passing|failing)-(green|red)\)'
        content = re.sub(build_badge_pattern, build_badge, content)
        
        # Check if content actually changed
        if content == old_content:
            print("ℹ️  No changes needed in README")
            return True, False  # Success, but no changes
        
        with open(readme_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Updated README with version {version} and status: {status}")
        return True, True  # Success with changes
        
    except Exception as e:
        print(f"❌ Failed to update README: {e}")
        return False, False

def commit_readme_changes(version, status):
    """Commit the updated README back to the repository if there are changes"""
    try:
        # Check if there are any changes to README.md
        result = subprocess.run(
            ["git", "diff", "--quiet", "README.md"], 
            capture_output=True
        )
        
        # If returncode is 1, there are changes
        if result.returncode == 0:
            print("ℹ️  No changes to README.md, skipping commit")
            return True
        
        # Configure git
        subprocess.run(["git", "config", "user.name", "github-actions"], check=True)
        subprocess.run(["git", "config", "user.email", "github-actions@github.com"], check=True)
        
        # Add and commit README
        subprocess.run(["git", "add", "README.md"], check=True)
        
        if status == "success":
            commit_message = f"docs: update README for version {version} [skip ci]"
        else:
            commit_message = f"docs: update README with build failure status [skip ci]"
        
        subprocess.run(["git", "commit", "-m", commit_message], check=True)
        subprocess.run(["git", "push"], check=True)
        
        print(f"✅ Committed README changes to repository")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Git command failed: {e}")
        return False
    except Exception as e:
        print(f"❌ Failed to commit README changes: {e}")
        return False

def main():
    # Get status from command line argument
    status = "success"
    if len(sys.argv) > 1 and sys.argv[1] == "--status":
        status = sys.argv[2] if len(sys.argv) > 2 else "success"
    
    # Get latest version
    latest_version = get_latest_version()
    if not latest_version:
        print("❌ Could not determine latest version")
        # Still update build status even if version can't be determined
        latest_version = "unknown"
    
    print(f"📝 Updating README - Version: {latest_version}, Status: {status}")
    
    # Update README
    success, changes_made = update_readme_version(latest_version, status)
    
    if success:
        if changes_made:
            # Commit changes back to repository
            if not commit_readme_changes(latest_version, status):
                sys.exit(1)
        else:
            print("✅ README is already up to date, no commit needed")
    else:
        print("❌ Failed to update README")
        sys.exit(1)

if __name__ == "__main__":
    main()
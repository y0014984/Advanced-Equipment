/* AE3 networked games - web desktop front end.
 *
 * One bundle serves every game app; the app's own game id picks the board renderer. Nothing here
 * decides anything about a match: the server owns the rules, this only draws what the server sent
 * and posts the move the player made, so a modified client cannot move for an opponent or see a
 * hand it was not dealt. The render loop never calls SQF - a redraw happens when a view arrives.
 *
 * Every game has two drawings of itself: a board of pieces, cards and tokens, and the plain list the
 * terminal shows. Which one is used is the mission's decision, not this file's - the server sends a
 * flag with each view and the list is what a computer with the graphical boards switched off gets.
 *
 * Written in ES5 on purpose, like the rest of the AE3 web UI, and with no external assets: the CEF
 * control cannot resolve relative URLs out of a PBO, so every board is drawn with elements and
 * inline styles.
 */
(function () {
  "use strict";

  // Two glyph sets, the solid one and the hollow one. A white piece is drawn as both: the solid glyph
  // filled white for the body of the piece, with the hollow glyph laid over it for the lines a
  // printed set has inside its outline. The pair shares a font and a width, so the two land on each
  // other exactly. Written as escapes rather than as the characters themselves: the page is handed to
  // the browser without a charset of its own, so a non-ASCII byte in this file arrives mangled.
  var CHESS = {
    k: "\u265A", q: "\u265B", r: "\u265C", b: "\u265D", n: "\u265E", p: "\u265F"
  };

  var CHESS_HOLLOW = {
    k: "\u2654", q: "\u2655", r: "\u2656", b: "\u2657", n: "\u2658", p: "\u2659"
  };

  var FILES = ["a", "b", "c", "d", "e", "f", "g", "h"];

  var UNO_COLOURS = { R: "#c0392b", G: "#27914c", B: "#2061b8", Y: "#d9a311", W: "#2b2b2b" };
  var UNO_COLOUR_NAMES = { R: "Red", G: "Green", B: "Blue", Y: "Yellow" };
  var SEAT_COLOURS = ["#c0392b", "#27914c", "#d9a311", "#2061b8", "#8e44ad", "#16a085", "#d35400", "#7f8c8d"];
  var SHIP_NAMES = ["Carrier", "Battleship", "Cruiser", "Submarine", "Destroyer"];

  // Every instance of every game app that is currently on screen. The bridge has no unsubscribe, so
  // one listener fans out to the live sinks and a closed window takes its sink out again.
  var sinks = [];

  if (window.AE3_gamesBound !== true) {
    window.AE3_gamesBound = true;

    A3.on("games_view", function (payload) {
      if (!payload) return;

      if (payload.kind === "notice") {
        if (window.AE3_toast) AE3_toast(String(payload.text || ""), "warn");
      }

      sinks.slice().forEach(function (sink) {
        try { sink(payload); } catch (e) { console.error(e); }
      });
    });
  }

  // The stylesheet is shared by every open game window and only ever installed once
  if (!document.getElementById("ae3g-style")) {
    var style = document.createElement("style");
    style.id = "ae3g-style";
    style.textContent = [
      ".ae3g-wrap{display:flex;flex-direction:column;gap:8px;height:100%;box-sizing:border-box}",
      ".ae3g-body{flex:1;overflow:auto}",
      ".ae3g-center{display:flex;flex-direction:column;align-items:center;gap:10px}",
      ".ae3g-row{display:flex;gap:10px;flex-wrap:wrap;align-items:flex-start;width:100%}",
      ".ae3g-col{display:flex;flex-direction:column;gap:6px}",
      ".ae3g-head{font-weight:bold;margin:2px 0}",
      ".ae3g-note{opacity:.7;font-size:12px}",
      ".ae3g-board{display:grid;border-radius:6px;overflow:hidden;box-shadow:0 2px 10px rgba(0,0,0,.45)}",
      ".ae3g-sq{position:relative;display:flex;align-items:center;justify-content:center;cursor:pointer;user-select:none;min-width:0;overflow:hidden}",
      ".ae3g-sq.ae3g-pick{box-shadow:inset 0 0 0 3px #f2c14e}",
      ".ae3g-piece{line-height:1;pointer-events:none;font-size:min(7vw,40px);font-family:'Segoe UI Symbol','DejaVu Sans','Arial Unicode MS','FreeSerif',serif}",
      ".ae3g-white{position:relative;color:#fbfbf9;-webkit-text-stroke:1.4px #1b1b1b;text-shadow:0 1px 1px rgba(0,0,0,.35)}",
      ".ae3g-black{color:#1d1d1d;-webkit-text-stroke:1.2px #000;text-shadow:0 1px 1px rgba(255,255,255,.22)}",
      ".ae3g-detail{position:absolute;left:0;top:0;color:#1b1b1b;-webkit-text-stroke:0;text-shadow:none;pointer-events:none}",
      ".ae3g-disc{width:72%;height:72%;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 2px 3px rgba(0,0,0,.45);box-sizing:border-box}",
      ".ae3g-king{border-width:4px!important;border-style:double!important}",
      ".ae3g-card{width:58px;height:86px;border-radius:8px;display:flex;flex-direction:column;align-items:center;justify-content:center;color:#fff;font-weight:bold;cursor:pointer;box-shadow:0 2px 5px rgba(0,0,0,.45);border:2px solid rgba(255,255,255,.75);box-sizing:border-box}",
      ".ae3g-card.ae3g-flat{cursor:default}",
      ".ae3g-pip{background:rgba(255,255,255,.92);color:#222;border-radius:50%/40%;padding:2px 10px;font-size:18px}",
      ".ae3g-pcard{width:52px;height:76px;border-radius:7px;background:#fbfbf7;color:#1d1d1d;border:1px solid #b9b9ad;display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:bold;box-shadow:0 2px 4px rgba(0,0,0,.4);box-sizing:border-box}",
      ".ae3g-pcard.ae3g-down{background:repeating-linear-gradient(45deg,#334a6b,#334a6b 5px,#24374f 5px,#24374f 10px);color:transparent;border-color:#1b2a3d}",
      ".ae3g-hand{display:flex;flex-wrap:wrap;gap:6px}",
      ".ae3g-ludo{display:grid;grid-template-columns:repeat(15,1fr);grid-template-rows:repeat(15,1fr);width:100%;max-width:620px;max-width:min(620px,74vh);aspect-ratio:1/1;border:2px solid #0d141b;background:#16202b}",
      ".ae3g-cell{position:relative;display:flex;align-items:center;justify-content:center}",
      ".ae3g-live{border:1px solid rgba(0,0,0,.6);box-sizing:border-box}",
      ".ae3g-start{box-shadow:inset 0 0 0 2px #fbfbf7}",
      ".ae3g-token{width:70%;height:70%;border-radius:50%;border:2px solid #10161d;font-size:10px;font-weight:bold;display:flex;align-items:center;justify-content:center;color:#fff;cursor:pointer;box-shadow:0 1px 2px rgba(0,0,0,.6),inset 0 0 0 1px rgba(255,255,255,.55)}",
      ".ae3g-sl{position:relative;display:grid;grid-template-columns:repeat(10,1fr);grid-template-rows:repeat(10,1fr);width:100%;max-width:620px;max-width:min(620px,74vh);aspect-ratio:1/1;border:3px solid #2a2118;background:#2a2118}",
      ".ae3g-slcell{position:relative;display:flex;align-items:flex-start;justify-content:flex-start;font-size:10px;font-weight:bold;color:#5a5346;padding:1px;box-sizing:border-box;border:1px solid rgba(42,33,24,.55)}",
      ".ae3g-slart{position:absolute;left:0;top:0;width:100%;height:100%;pointer-events:none;z-index:1}",
      ".ae3g-slpawns{position:absolute;left:0;right:0;bottom:1px;display:flex;justify-content:center;gap:2px;z-index:2}",
      ".ae3g-slpawn{width:10px;height:10px;border-radius:50%;border:2px solid #16110c;box-shadow:inset 0 0 0 1px rgba(255,255,255,.6)}",
      ".ae3g-grid{display:grid;grid-template-columns:repeat(11,1fr);gap:1px;width:100%;max-width:520px;max-width:min(520px,62vh)}",
      ".ae3g-bscol{flex:1 1 300px;min-width:240px;max-width:560px}",
      ".ae3g-water{aspect-ratio:1/1;background:#1d4663;border-radius:2px}",
      ".ae3g-label{aspect-ratio:1/1;display:flex;align-items:center;justify-content:center;font-size:11px;opacity:.75}",
      ".ae3g-fleetrow{display:flex;align-items:center;gap:6px;cursor:pointer;padding:3px 5px;border-radius:4px}",
      ".ae3g-fleetrow.ae3g-pick{background:rgba(242,193,78,.22)}",
      ".ae3g-throw{font-size:26px;line-height:1.2;font-weight:bold}",
      ".ae3g-seatline{display:flex;align-items:center;gap:6px}",
      ".ae3g-dot{width:10px;height:10px;border-radius:50%;flex:none}"
    ].join("");
    document.head.appendChild(style);
  }

  function esc(s) {
    return String(s == null ? "" : s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }

  function el(tag, cls, text) {
    var node = document.createElement(tag);
    if (cls) node.className = cls;
    if (text != null) node.textContent = text;
    return node;
  }

  function squareName(index) {
    return FILES[index % 8] + String(8 - Math.floor(index / 8));
  }

  // The throw is written out rather than drawn as a hand: the hand characters belong to the emoji
  // font, which the laptop browser does not reach, and a round nobody can read is the whole point of
  // the reveal lost
  function throwName(value) {
    var text = String(value || "");

    if (text === "") return "-";

    return text.charAt(0).toUpperCase() + text.substring(1);
  }

  function seatColour(seat) {
    return SEAT_COLOURS[seat % SEAT_COLOURS.length];
  }

  function tableLabel(row) {
    return String((row && (row.name || row.title)) || (row && row.gameId) || "");
  }

  function makeApp(desc) {
    var extra = desc.extra || {};
    var gameId = extra.gameId || "chess";

    return {
      id: desc.id,
      title: desc.title,
      glyph: desc.glyph || CHESS.r,
      width: extra.width || 880,
      height: extra.height || 760,
      singleton: true,
      showInDock: false,
      showInMenu: true,
      menu: extra.menu || "Games & Entertainment",
      external: true,

      render: function (body, win, args) {
        var state = {
          tableId: (args && args.tableId) || null,
          view: null,
          from: null,
          wild: null,
          ship: 0,
          vertical: false
        };

        body.innerHTML =
          '<div class="ae3g-wrap pad">' +
          '  <div class="toolbar" style="gap:6px;flex-wrap:wrap">' +
          '    <button class="btn accent g-new">New game</button>' +
          '    <button class="btn g-lobby">Lobby</button>' +
          '    <button class="btn g-leave" hidden>Leave table</button>' +
          '    <span class="muted g-status" style="flex:1;text-align:right"></span>' +
          '  </div>' +
          '  <div class="ae3g-body g-body"></div>' +
          '</div>';

        var elBody = body.querySelector(".g-body");
        var elStatus = body.querySelector(".g-status");
        var elLeave = body.querySelector(".g-leave");

        function setStatus(text) {
          elStatus.textContent = text || "";
        }

        function send(cmd, data) {
          A3.send(cmd, data);
        }

        function move(text) {
          send("games_move", { id: state.tableId, move: text });
        }

        function requestLobby() {
          state.tableId = null;
          state.from = null;
          state.wild = null;
          send("games_list", { gameId: gameId });
        }

        function openTable(id) {
          state.tableId = id;
          state.from = null;
          state.wild = null;

          // Remembered on the window, so reopening the app comes back to this match
          win.args = win.args || {};
          win.args.tableId = id;
          if (window.WM && WM.onStateChange) WM.onStateChange();

          send("games_open", { id: id, open: true });
        }

        /* ---- lobby ------------------------------------------------------------------ */

        function renderLobby(payload) {
          elLeave.hidden = true;

          if (payload.enabled === false) {
            elBody.innerHTML = '<div class="pad err">Games are switched off on this computer.</div>';
            return;
          }

          elBody.innerHTML =
            '<div class="ae3g-col">' +
            '  <div class="ae3g-head">Your matches</div><ul class="list g-mine"></ul>' +
            '  <div class="ae3g-head">Open tables</div><ul class="list g-open"></ul>' +
            "</div>";

          var mine = payload.resumable || [];
          var open = payload.joinable || [];
          var elMine = elBody.querySelector(".g-mine");
          var elOpen = elBody.querySelector(".g-open");

          function row(list, table, label, action) {
            var li = document.createElement("li");
            var seated = (table.seated || 0) + "/" + (table.seatCount || 0);

            li.innerHTML =
              '<span style="flex:1">' + esc(tableLabel(table)) + " - " + esc(table.host || "") +
              ' <span class="muted">(' + esc(table.phase || "") + ", " + seated + ")</span></span>";

            var b = el("button", "btn accent", label);
            b.addEventListener("click", function () { action(table); });
            li.appendChild(b);
            list.appendChild(li);
          }

          if (!mine.length) {
            elMine.innerHTML = '<li class="muted pad">No match in progress</li>';
          } else {
            mine.forEach(function (t) {
              row(elMine, t, "Continue", function (table) { openTable(table.id); });
            });
          }

          if (!open.length) {
            elOpen.innerHTML = '<li class="muted pad">No open table on this network</li>';
          } else {
            open.forEach(function (t) {
              row(elOpen, t, "Join", function (table) {
                state.tableId = table.id;
                send("games_join", { id: table.id });
              });
            });
          }

          setStatus(payload.canHost === false ? "Hosting is disabled" : "");
        }

        // Naming a table is what tells four games of chess on one network apart, so the host is
        // asked for one before the table is opened rather than after
        function renderHostForm() {
          elLeave.hidden = true;
          state.tableId = null;

          elBody.innerHTML =
            '<div class="ae3g-col" style="max-width:420px">' +
            '  <div class="ae3g-head">Open a new table</div>' +
            '  <div class="ae3g-note">Give it a name the others will see in their lobby. Leave it blank for the games own name.</div>' +
            '  <input class="g-name" maxlength="40" placeholder="Table name" ' +
            '    style="padding:6px 8px;border-radius:4px;border:1px solid var(--panel,#555);background:transparent;color:inherit">' +
            '  <div class="toolbar"><button class="btn accent g-create">Open table</button>' +
            '  <button class="btn g-cancel">Cancel</button></div>' +
            "</div>";

          var input = elBody.querySelector(".g-name");

          function create() {
            send("games_host", { gameId: gameId, name: input.value || "" });
          }

          input.addEventListener("keydown", function (e) {
            if (e.key === "Enter") create();
          });

          elBody.querySelector(".g-create").addEventListener("click", create);
          elBody.querySelector(".g-cancel").addEventListener("click", requestLobby);

          try { input.focus(); } catch (e) { /* the window may not be focused yet */ }
        }

        // The table's own lobby: who is seated, which side each of them asked for, who moves first,
        // and the practice seats a host may give itself while building a mission
        function renderTableLobby(payload) {
          var seats = payload.seats || [];
          var sideChoice = payload.sideChoice || "none";
          var wrap = el("div", "ae3g-col");

          wrap.appendChild(el("div", "ae3g-head", tableLabel(payload)));
          wrap.appendChild(el("div", "", "Waiting for players. " + seats.length + " of " + (payload.seatCount || 0) + " seats taken, " + (payload.minSeats || 2) + " needed to start."));

          var list = el("ul", "list");

          seats.forEach(function (entry) {
            var index = entry[0] || 0;
            var li = document.createElement("li");
            var dot = el("span", "ae3g-dot");

            dot.style.background = seatColour(index);
            li.appendChild(dot);

            var name = el("span", "", esc(entry[1] || "") + (index === payload.seat ? " (you)" : ""));
            name.style.flex = "1";
            li.appendChild(name);

            if (sideChoice === "colour") {
              li.appendChild(el("span", "muted", "wants " + (entry[2] || "random")));
            }

            if (payload.starter === index) {
              li.appendChild(el("span", "muted", "starts"));
            }

            // Only the host decides the order, and only when the game has one to decide
            if (sideChoice === "starter" && payload.isHost) {
              var pick = el("button", "btn", "Starts first");
              pick.addEventListener("click", function () {
                send("games_option", { id: payload.id, option: "starter", value: String(index) });
              });
              li.appendChild(pick);
            }

            list.appendChild(li);
          });

          wrap.appendChild(list);

          if (sideChoice === "colour") {
            var sides = el("div", "toolbar");

            sides.appendChild(el("span", "muted", "Your side:"));

            ["white", "black", "random"].forEach(function (side) {
              var chosen = seats.filter(function (row) { return row[0] === payload.seat; })[0];
              var b = el("button", "btn" + (chosen && chosen[2] === side ? " accent" : ""), side);

              b.addEventListener("click", function () {
                send("games_option", { id: payload.id, option: "pref", value: side });
              });

              sides.appendChild(b);
            });

            wrap.appendChild(sides);
            wrap.appendChild(el("div", "ae3g-note", "Two players cannot take the same side; the table starts once every choice is a different one."));
          }

          var tools = el("div", "toolbar");

          tools.appendChild(seatNameButton(payload));

          if (payload.isHost) {
            var start = el("button", "btn accent", "Start the match");
            start.addEventListener("click", function () { send("games_start", { id: payload.id }); });
            tools.appendChild(start);

            var rename = el("button", "btn", "Rename");
            rename.addEventListener("click", function () {
              Modal.prompt("Name for this table", payload.name || "").then(function (answer) {
                if (answer == null) return;
                send("games_option", { id: payload.id, option: "name", value: answer });
              });
            });
            tools.appendChild(rename);

            // Extra seats on this same laptop, for setting a game up and playing every side of it
            if (payload.debugSeats) {
              var dummy = el("button", "btn", "Add practice seat");
              dummy.addEventListener("click", function () { send("games_dummy", { id: payload.id }); });
              tools.appendChild(dummy);
            }
          }

          wrap.appendChild(tools);
          wrap.appendChild(el("div", "ae3g-note", "A full table starts itself; the computer hosting it can start it sooner."));

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
          elBody.appendChild(seatSwitcher(payload));

          setStatus("Seat " + (payload.seat + 1));
        }

        // Whoever is at a seat says what to call it. The name rides on the seat rather than on the
        // laptop, so a laptop holding practice seats names each of them separately, and a seat with
        // no name of its own falls back to the name of the computer sitting at it.
        function seatNameButton(payload) {
          var row = (payload.seats || []).filter(function (s) { return s[0] === payload.seat; })[0];
          var b = el("button", "btn", "Name your seat");

          b.addEventListener("click", function () {
            Modal.prompt("Name for your seat, empty for the computer's own name", (row && row[1]) || "").then(function (answer) {
              if (answer == null) return;

              send("games_option", { id: payload.id, option: "seatname", value: answer });
            });
          });

          return b;
        }

        // A laptop holding practice seats plays one of them at a time, and this is how it changes
        // which. A laptop with a single seat never sees it.
        function seatSwitcher(payload) {
          var held = payload.held || [];
          var wrap = el("div", "toolbar");

          if (held.length < 2) return wrap;

          wrap.appendChild(el("span", "muted", "Playing as:"));

          held.forEach(function (index) {
            var seatRow = (payload.seats || []).filter(function (s) { return s[0] === index; })[0];
            var b = el("button", "btn" + (index === payload.seat ? " accent" : ""), (seatRow && seatRow[1]) || ("Seat " + (index + 1)));

            b.addEventListener("click", function () {
              send("games_seat", { id: payload.id, seat: index });
            });

            wrap.appendChild(b);
          });

          return wrap;
        }

        /* ---- boards ----------------------------------------------------------------- */

        function renderChess(payload) {
          var view = payload.view || [];
          var board = String(view[0] || "");
          var seat = payload.seat || 0;
          var inCheck = view[2] === true;
          var flip = seat === 1;
          var grid = el("div", "ae3g-board");

          grid.style.gridTemplateColumns = "repeat(8,1fr)";
          grid.style.width = "100%";
          grid.style.maxWidth = "620px";
          grid.style.maxWidth = "min(620px, 74vh)";

          for (var row = 0; row < 8; row += 1) {
            for (var col = 0; col < 8; col += 1) {
              var r = flip ? 7 - row : row;
              var c = flip ? 7 - col : col;
              var index = r * 8 + c;
              var piece = board.charAt(index) || ".";
              var dark = (r + c) % 2 === 1;
              var cell = el("div", "ae3g-sq");

              cell.setAttribute("data-index", index);
              cell.style.aspectRatio = "1/1";
              cell.style.background = dark ? "#769656" : "#eeeed2";

              var kind = piece.toLowerCase();

              if (CHESS[kind]) {
                // Upper case is white. Both sides are the solid glyph, so a white piece is a white
                // piece rather than an outline of one; the hollow glyph goes over the white body to
                // put its inner lines back.
                var white = piece === piece.toUpperCase();
                var span = el("span", "ae3g-piece " + (white ? "ae3g-white" : "ae3g-black"), CHESS[kind]);

                if (white) span.appendChild(el("span", "ae3g-detail", CHESS_HOLLOW[kind]));

                cell.appendChild(span);
              }

              grid.appendChild(cell);
            }
          }

          var wrap = el("div", "ae3g-center");
          wrap.appendChild(grid);
          wrap.appendChild(el("div", "muted", "You play " + (seat === 1 ? "black" : "white")));

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
          bindSquarePicker();

          if (inCheck) setStatus("You are in check");
        }

        function renderCheckers(payload) {
          var view = payload.view || [];
          var board = String(view[0] || "");
          var seat = payload.seat || 0;
          var flip = seat === 1;
          var grid = el("div", "ae3g-board");

          grid.style.gridTemplateColumns = "repeat(8,1fr)";
          grid.style.width = "100%";
          grid.style.maxWidth = "620px";
          grid.style.maxWidth = "min(620px, 74vh)";

          for (var row = 0; row < 8; row += 1) {
            for (var col = 0; col < 8; col += 1) {
              var r = flip ? 7 - row : row;
              var c = flip ? 7 - col : col;
              var piece = board.charAt(r * 8 + c) || ".";
              var dark = (r + c) % 2 === 1;
              var cell = el("div", "ae3g-sq");

              cell.setAttribute("data-index", r * 8 + c);
              cell.style.aspectRatio = "1/1";
              cell.style.background = dark ? "#8a5a2b" : "#e8c99b";

              if (piece !== ".") {
                var white = piece === "w" || piece === "W";
                var king = piece === "W" || piece === "B";

                // A crowned disc is drawn as a double ring rather than written as a crown character:
                // the board is at the mercy of whatever font the laptop browser has, and a missing
                // glyph would leave a king looking exactly like an ordinary piece
                var disc = el("div", "ae3g-disc" + (king ? " ae3g-king" : ""));

                disc.style.background = white ? "#f2f2ef" : "#2a2a2a";
                disc.style.color = white ? "#8a5a2b" : "#e8c99b";
                disc.style.border = "2px solid " + (white ? "#c9c9c0" : "#111");

                // The ring is drawn in the square's own colour, so it reads on either disc
                if (king) disc.style.borderColor = white ? "#8a5a2b" : "#e8c99b";
                cell.appendChild(disc);
              }

              grid.appendChild(cell);
            }
          }

          var wrap = el("div", "ae3g-center");
          wrap.appendChild(grid);
          wrap.appendChild(el("div", "muted", "Move as two squares, c3d4; a jump is c3e5."));

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
          bindSquarePicker();
        }

        /* ---- uno -------------------------------------------------------------------- */

        function unoFace(card) {
          var colour = card.charAt(0);
          var value = card.substring(1);

          if (colour === "W") return value === "4" ? "+4" : "Wild";
          // Words, not symbols: the enclosing-circle and turn-arrow characters are missing from
          // plenty of fonts, and an unreadable card face is worse than a short label
          if (value === "s") return "Skip";
          if (value === "r") return "Rev";

          return value;
        }

        function unoCard(card, onPlay) {
          var node = el("div", "ae3g-card" + (onPlay ? "" : " ae3g-flat"));
          var colour = card.charAt(0);

          node.style.background = UNO_COLOURS[colour] || "#2b2b2b";

          if (colour === "W") {
            node.style.background = "linear-gradient(135deg,#c0392b 0 25%,#27914c 25% 50%,#2061b8 50% 75%,#d9a311 75% 100%)";
          }

          var face = unoFace(card);
          var pip = el("div", "ae3g-pip", face);

          // A word has to come down in size to sit on a card sized for a number
          if (face.length > 2) {
            pip.style.fontSize = "13px";
            pip.style.padding = "2px 6px";
          }

          node.appendChild(pip);

          if (onPlay) node.addEventListener("click", function () { onPlay(card); });

          return node;
        }

        function renderUno(payload) {
          if (!payload.graphical) return renderUnoText(payload);

          var view = payload.view || [];
          var hand = view[0] || [];
          var counts = view[1] || [];
          var top = String(view[2] || "");
          var colour = String(view[3] || "");
          var wrap = el("div", "ae3g-col");
          var head = el("div", "ae3g-row");
          var pile = el("div", "ae3g-col");

          pile.appendChild(el("div", "ae3g-head", "Pile"));
          pile.appendChild(unoCard(top, null));
          head.appendChild(pile);

          var inPlay = el("div", "ae3g-col");
          inPlay.appendChild(el("div", "ae3g-head", "Colour in play"));

          var swatch = el("div", "ae3g-disc");
          swatch.style.width = "46px";
          swatch.style.height = "46px";
          swatch.style.background = UNO_COLOURS[colour] || "#2b2b2b";
          inPlay.appendChild(swatch);
          inPlay.appendChild(el("div", "muted", UNO_COLOUR_NAMES[colour] || colour));
          head.appendChild(inPlay);

          var seatsCol = el("div", "ae3g-col");
          seatsCol.appendChild(el("div", "ae3g-head", "At the table"));

          counts.forEach(function (n, i) {
            var line = el("div", "ae3g-seatline");
            var dot = el("span", "ae3g-dot");

            dot.style.background = seatColour(i);
            line.appendChild(dot);
            line.appendChild(el("span", payload.turn === i ? "" : "muted", seatName(payload, i) + " - " + n + " cards"));
            seatsCol.appendChild(line);
          });

          head.appendChild(seatsCol);
          wrap.appendChild(head);
          wrap.appendChild(el("div", "ae3g-head", "Your hand"));

          var handWrap = el("div", "ae3g-hand");

          // A wild waiting for its colour is kept here, not in a panel of its own: the board is
          // redrawn from scratch on every state the server sends, and a panel that replaced it was
          // wiped by the next one before the colour could be picked
          if (state.wild !== null && (payload.turn !== payload.seat || hand.indexOf(state.wild) < 0)) {
            state.wild = null;
          }

          hand.forEach(function (card) {
            handWrap.appendChild(unoCard(card, function (played) {
              if (played.charAt(0) !== "W") return move("play " + played);

              state.wild = played;
              renderUno(payload);
            }));
          });

          wrap.appendChild(handWrap);

          if (state.wild !== null) wrap.appendChild(askColour(state.wild));

          var tools = el("div", "toolbar");
          var draw = el("button", "btn accent", "Draw a card");

          draw.addEventListener("click", function () { move("draw"); });
          tools.appendChild(draw);
          wrap.appendChild(tools);

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
        }

        // The colour row for a wild that has been picked up but not yet played. It sits under the
        // hand, so the rest of the board stays readable while the choice is made.
        function askColour(card) {
          var panel = el("div", "ae3g-col");

          panel.appendChild(el("div", "ae3g-head", "Colour for the " + (card === "W4" ? "wild draw four" : "wild")));

          var row = el("div", "toolbar");

          ["R", "G", "B", "Y"].forEach(function (c) {
            var b = el("button", "btn", UNO_COLOUR_NAMES[c]);

            b.style.background = UNO_COLOURS[c];
            b.style.color = "#fff";
            b.addEventListener("click", function () {
              state.wild = null;
              move("play " + card + " " + c);
            });
            row.appendChild(b);
          });

          var cancel = el("button", "btn", "Cancel");

          cancel.addEventListener("click", function () {
            state.wild = null;
            if (state.view) renderTable(state.view);
          });

          row.appendChild(cancel);
          panel.appendChild(row);

          return panel;
        }

        function renderUnoText(payload) {
          var view = payload.view || [];
          var hand = view[0] || [];
          var counts = view[1] || [];
          var html = '<div class="pad" style="padding-left:0">Pile <b>' + esc(String(view[2] || "")) + "</b> - colour in play <b>" + esc(String(view[3] || "")) + "</b></div>";

          html += '<ul class="list">';
          counts.forEach(function (n, i) {
            html += '<li><span style="flex:1">' + esc(seatName(payload, i)) + '</span><span class="muted">' + n + " cards</span></li>";
          });
          html += '</ul><div class="ae3g-head">Your hand</div><div class="toolbar ae3g-hand"></div>';
          html += '<div class="toolbar" style="margin-top:8px"><button class="btn g-draw">Draw a card</button></div>';
          elBody.innerHTML = html;

          var wrap = elBody.querySelector(".ae3g-hand");

          hand.forEach(function (card) {
            var b = el("button", "btn", card);

            b.addEventListener("click", function () {
              if (card.charAt(0) !== "W") return move("play " + card);

              Modal.prompt("Colour for the wild (R, G, B or Y)", "R").then(function (answer) {
                if (!answer) return;
                move("play " + card + " " + answer);
              });
            });

            wrap.appendChild(b);
          });

          elBody.querySelector(".g-draw").addEventListener("click", function () { move("draw"); });
        }

        function seatName(payload, index) {
          var row = (payload.seats || []).filter(function (s) { return s[0] === index; })[0];
          var name = (row && row[1]) || ("Seat " + (index + 1));

          return name + (index === payload.seat ? " (you)" : "");
        }

        /* ---- ludo ------------------------------------------------------------------- */

        // The 52 squares of the shared ring, in the order a token walks them, and the five squares
        // of each seat's own column. The rules count a token's position from its own starting
        // square, so a seat's square n is ring square (seat * 13 + n - 1).
        var LUDO_RING = [
          [1, 6], [2, 6], [3, 6], [4, 6], [5, 6],
          [6, 5], [6, 4], [6, 3], [6, 2], [6, 1], [6, 0],
          [7, 0],
          [8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5],
          [9, 6], [10, 6], [11, 6], [12, 6], [13, 6], [14, 6],
          [14, 7],
          [14, 8], [13, 8], [12, 8], [11, 8], [10, 8], [9, 8],
          [8, 9], [8, 10], [8, 11], [8, 12], [8, 13], [8, 14],
          [7, 14],
          [6, 14], [6, 13], [6, 12], [6, 11], [6, 10], [6, 9],
          [5, 8], [4, 8], [3, 8], [2, 8], [1, 8], [0, 8],
          [0, 7],
          [0, 6]
        ];

        var LUDO_HOME = [
          [[1, 7], [2, 7], [3, 7], [4, 7], [5, 7]],
          [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5]],
          [[13, 7], [12, 7], [11, 7], [10, 7], [9, 7]],
          [[7, 13], [7, 12], [7, 11], [7, 10], [7, 9]]
        ];

        var LUDO_YARD = [[1, 1], [10, 1], [10, 10], [1, 10]];

        function ludoCellOf(seat, position) {
          if (position >= 1 && position <= 51) return LUDO_RING[(seat * 13 + position - 1) % 52];
          if (position >= 52 && position <= 56) return LUDO_HOME[seat % 4][position - 52];
          if (position === 57) return [7, 7];

          return null;
        }

        function renderLudo(payload) {
          if (!payload.graphical) return renderTokensText(payload, "0 is the yard, 57 is home.", true);

          var view = payload.view || [];
          var tokens = view[0] || [];
          var pending = view[2] || 0;
          var board = el("div", "ae3g-ludo");
          var cells = {};
          var x;
          var y;

          for (y = 0; y < 15; y += 1) {
            for (x = 0; x < 15; x += 1) {
              var cell = el("div", "ae3g-cell");

              // Anything that is not track, yard, column or centre stays the board's own dark
              // ground, so the cross reads as a shape instead of as faint lines on cream
              board.appendChild(cell);
              cells[x + "," + y] = cell;
            }
          }

          // The four yards, then the ring and every seat's own column, painted in that seat's colour
          var painted = {};

          tokens.forEach(function (unused, seat) {
            var corner = LUDO_YARD[seat % 4];
            var dx;
            var dy;

            for (dy = 0; dy < 4; dy += 1) {
              for (dx = 0; dx < 4; dx += 1) {
                var key = (corner[0] + dx) + "," + (corner[1] + dy);

                if (cells[key]) {
                  cells[key].style.background = seatColour(seat);
                  cells[key].className = "ae3g-cell ae3g-live";
                  painted[key] = true;
                }
              }
            }

            LUDO_HOME[seat % 4].forEach(function (pos) {
              var homeKey = pos[0] + "," + pos[1];

              if (cells[homeKey]) {
                cells[homeKey].style.background = seatColour(seat);
                cells[homeKey].className = "ae3g-cell ae3g-live";
                painted[homeKey] = true;
              }
            });

            var start = LUDO_RING[(seat * 13) % 52];
            var startKey = start[0] + "," + start[1];

            // The square a seat enters the track on carries a light ring, so the four starts are
            // told apart from that seat's column at a glance
            if (cells[startKey]) {
              cells[startKey].style.background = seatColour(seat);
              cells[startKey].className = "ae3g-cell ae3g-live ae3g-start";
              painted[startKey] = true;
            }
          });

          // Whatever is left of the ring is the shared track
          LUDO_RING.forEach(function (pos) {
            var ringKey = pos[0] + "," + pos[1];

            if (cells[ringKey] && !painted[ringKey]) {
              cells[ringKey].style.background = "#efe9d6";
              cells[ringKey].className = "ae3g-cell ae3g-live";
            }
          });

          var centre = cells["7,7"];

          if (centre) {
            centre.style.background = "#2b3a4a";
            centre.className = "ae3g-cell ae3g-live";
          }

          // Tokens on the board, and the ones still in the yard stacked in their own corner
          tokens.forEach(function (seatTokens, seat) {
            var parked = 0;

            (seatTokens || []).forEach(function (position, index) {
              var target = ludoCellOf(seat, position);
              var slot;

              if (target === null) {
                var corner = LUDO_YARD[seat % 4];
                slot = cells[(corner[0] + (parked % 2) * 2) + "," + (corner[1] + Math.floor(parked / 2) * 2)];
                parked += 1;
              } else {
                slot = cells[target[0] + "," + target[1]];
              }

              if (!slot) return;

              var token = el("div", "ae3g-token", String(index + 1));

              token.style.background = seatColour(seat);
              token.style.position = "absolute";
              token.style.left = (6 + (slot.childNodes.length * 7)) + "%";

              if (seat === payload.seat && pending > 0) {
                token.addEventListener("click", function () { move(String(index + 1)); });
              } else {
                token.style.cursor = "default";
              }

              slot.appendChild(token);
            });
          });

          var wrap = el("div", "ae3g-center");

          wrap.appendChild(board);
          wrap.appendChild(ludoControls(payload, pending));

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
        }

        function ludoControls(payload, pending) {
          var tools = el("div", "toolbar");

          if (pending > 0) {
            tools.appendChild(el("span", "", "Rolled " + pending + " - pick a token"));

            for (var i = 1; i <= 4; i += 1) {
              (function (token) {
                var b = el("button", "btn", "Token " + token);
                b.addEventListener("click", function () { move(String(token)); });
                tools.appendChild(b);
              })(i);
            }

            return tools;
          }

          var roll = el("button", "btn accent", "Roll");
          roll.addEventListener("click", function () { move("roll"); });
          tools.appendChild(roll);

          return tools;
        }

        /* ---- snakes and ladders ------------------------------------------------------ */

        function renderSnakes(payload) {
          if (!payload.graphical) return renderTokensText(payload, "First token to land on 100 exactly wins.", false);

          var view = payload.view || [];
          var positions = view[0] || [];
          var lastRoll = view[2] || 0;
          var jumps = view[4] || [];
          var board = el("div", "ae3g-sl");
          var cells = {};
          var row;
          var col;

          // Square one is the bottom left and the numbering turns at the end of every row, the way
          // the board is printed
          for (row = 9; row >= 0; row -= 1) {
            for (col = 0; col < 10; col += 1) {
              var index = row * 10 + ((row % 2 === 0) ? col : 9 - col) + 1;
              var cell = el("div", "ae3g-slcell", String(index));

              cell.style.background = (row + col) % 2 === 0 ? "#e9e0c8" : "#c9bd9c";
              board.appendChild(cell);
              cells[index] = cell;
            }
          }

          // Ladders and snakes are drawn across the board itself, each from the square it starts on
          // to the square it ends on, so where one goes is read off the board rather than off a
          // label in the corner of a square
          board.appendChild(slArt(jumps));

          positions.forEach(function (square, seat) {
            var cell = cells[square] || null;

            if (cell === null) return;

            var pawns = cell.querySelector(".ae3g-slpawns");

            if (!pawns) {
              pawns = el("div", "ae3g-slpawns");
              cell.appendChild(pawns);
            }

            var pawn = el("div", "ae3g-slpawn");
            pawn.style.background = seatColour(seat);
            pawns.appendChild(pawn);
          });

          var wrap = el("div", "ae3g-center");

          wrap.appendChild(board);

          var legend = el("div", "ae3g-row");

          positions.forEach(function (square, seat) {
            var line = el("div", "ae3g-seatline");
            var dot = el("span", "ae3g-dot");

            dot.style.background = seatColour(seat);
            line.appendChild(dot);
            line.appendChild(el("span", payload.turn === seat ? "" : "muted", seatName(payload, seat) + " - " + (square || 0)));
            legend.appendChild(line);
          });

          wrap.appendChild(legend);

          var tools = el("div", "toolbar");
          var roll = el("button", "btn accent", lastRoll > 0 ? "Roll (last " + lastRoll + ")" : "Roll");

          roll.addEventListener("click", function () { move("roll"); });
          tools.appendChild(roll);
          wrap.appendChild(tools);

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
        }

        // Centre of a square in board units, 0 to 10 across and 0 to 10 down. Square one is the
        // bottom left and the numbering turns at the end of every row, so every other row counts
        // backwards.
        function slCentre(square) {
          var n = square - 1;
          var row = Math.floor(n / 10);
          var col = n % 10;

          if (row % 2 === 1) col = 9 - col;

          return [col + 0.5, 9 - row + 0.5];
        }

        function svgNode(name, attrs) {
          var node = document.createElementNS("http://www.w3.org/2000/svg", name);
          var key;

          for (key in attrs) {
            if (attrs.hasOwnProperty(key)) node.setAttribute(key, String(attrs[key]));
          }

          return node;
        }

        // Every jump as artwork on one overlay: a two-railed ladder up, a coiling snake down. Drawn
        // rather than written, so none of it depends on the laptop having a font or an image.
        function slArt(jumps) {
          var art = svgNode("svg", { "class": "ae3g-slart", viewBox: "0 0 10 10", preserveAspectRatio: "none" });

          jumps.forEach(function (pair) {
            var a = slCentre(pair[0]);
            var b = slCentre(pair[1]);
            var dx = b[0] - a[0];
            var dy = b[1] - a[1];
            var length = Math.sqrt(dx * dx + dy * dy) || 1;
            var ux = dx / length;
            var uy = dy / length;

            if (pair[1] > pair[0]) {
              // Ladder: two rails a fixed distance either side of the line, with rungs between them
              var px = -uy * 0.17;
              var py = ux * 0.17;
              var rungs = Math.max(2, Math.round(length / 0.7));
              var i;

              [1, -1].forEach(function (side) {
                art.appendChild(svgNode("line", {
                  x1: a[0] + px * side, y1: a[1] + py * side,
                  x2: b[0] + px * side, y2: b[1] + py * side,
                  stroke: "#8a5a2b", "stroke-width": 0.13, "stroke-linecap": "round"
                }));
              });

              for (i = 0; i <= rungs; i += 1) {
                var t = 0.06 + (i / rungs) * 0.88;

                art.appendChild(svgNode("line", {
                  x1: a[0] + dx * t + px, y1: a[1] + dy * t + py,
                  x2: a[0] + dx * t - px, y2: a[1] + dy * t - py,
                  stroke: "#c08c46", "stroke-width": 0.1, "stroke-linecap": "round"
                }));
              }

              return;
            }

            // Snake: a curve that leans off the straight line to either side, head on the square it
            // takes a token from
            var ox = -uy * length * 0.22;
            var oy = ux * length * 0.22;

            art.appendChild(svgNode("path", {
              d: "M" + a[0] + " " + a[1] +
                 " C" + (a[0] + dx * 0.33 + ox) + " " + (a[1] + dy * 0.33 + oy) +
                 " " + (a[0] + dx * 0.66 - ox) + " " + (a[1] + dy * 0.66 - oy) +
                 " " + b[0] + " " + b[1],
              fill: "none", stroke: "#1d6b35", "stroke-width": 0.26, "stroke-linecap": "round"
            }));

            art.appendChild(svgNode("circle", {
              cx: a[0], cy: a[1], r: 0.26, fill: "#2e9e4f", stroke: "#123f20", "stroke-width": 0.06
            }));

            [-0.09, 0.09].forEach(function (side) {
              art.appendChild(svgNode("circle", {
                cx: a[0] + side, cy: a[1] - 0.06, r: 0.045, fill: "#16110c"
              }));
            });
          });

          return art;
        }

        function renderTokensText(payload, homeLabel, pickToken) {
          var view = payload.view || [];
          var rows = view[0] || [];
          var pending = view[2] || 0;
          var html = '<ul class="list">';

          rows.forEach(function (entry, i) {
            var text = Array.isArray(entry) ? entry.join(" - ") : String(entry);

            html += '<li><span style="flex:1">' + esc(seatName(payload, i)) + "</span><span>" + esc(text) + "</span></li>";
          });

          html += "</ul>";
          html += '<div class="ae3g-note">' + esc(homeLabel) + "</div>";
          html += '<div class="toolbar"><button class="btn accent g-roll">Roll</button><span class="g-tokens" style="display:flex;gap:6px"></span></div>';
          elBody.innerHTML = html;

          elBody.querySelector(".g-roll").addEventListener("click", function () { move("roll"); });

          // Ludo asks which token to move once a roll is in; snakes and ladders moves by itself
          if (pickToken && pending > 0) {
            var wrap = elBody.querySelector(".g-tokens");

            for (var i = 1; i <= 4; i += 1) {
              (function (token) {
                var b = el("button", "btn", "Token " + token);
                b.addEventListener("click", function () { move(String(token)); });
                wrap.appendChild(b);
              })(i);
            }

            setStatus("Rolled " + pending);
          }
        }

        /* ---- blackjack --------------------------------------------------------------- */

        function playingCard(rank, faceDown) {
          var node = el("div", "ae3g-pcard" + (faceDown ? " ae3g-down" : ""), faceDown ? "" : String(rank));

          return node;
        }

        function renderBlackjack(payload) {
          if (!payload.graphical) return renderBlackjackText(payload);

          var view = payload.view || [];
          var hands = view[0] || [];
          var totals = view[1] || [];
          var dealer = view[2] || [];
          var dealerTotal = view[3] || 0;
          var done = view[4] || [];
          var scores = view[5] || [];
          var side = view[6];
          var wrap = el("div", "ae3g-col");

          wrap.appendChild(el("div", "ae3g-head", "Dealer - " + dealerTotal));

          var dealerRow = el("div", "ae3g-hand");

          dealer.forEach(function (rank) { dealerRow.appendChild(playingCard(rank, false)); });

          // The hole card is not dealt to a client until the round is over, so there is a back to
          // draw rather than a value to hide
          if (side !== -1) dealerRow.appendChild(playingCard("", true));

          wrap.appendChild(dealerRow);

          hands.forEach(function (hand, i) {
            var head = el("div", "ae3g-seatline");
            var dot = el("span", "ae3g-dot");

            dot.style.background = seatColour(i);
            head.appendChild(dot);
            head.appendChild(el("span", side === i ? "ae3g-head" : "", seatName(payload, i) + " - " + (totals[i] || 0) + " - won " + (scores[i] || 0) + (done[i] ? " - done" : "")));
            wrap.appendChild(head);

            var row = el("div", "ae3g-hand");

            hand.forEach(function (rank) { row.appendChild(playingCard(rank, false)); });
            wrap.appendChild(row);
          });

          var tools = el("div", "toolbar");

          if (side === -1) {
            tools.appendChild(actionButton("Deal next round", "deal", true));
          } else {
            tools.appendChild(actionButton("Hit", "hit", true));
            tools.appendChild(actionButton("Stand", "stand", false));
          }

          wrap.appendChild(tools);

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
        }

        function actionButton(label, text, accent) {
          var b = el("button", "btn" + (accent ? " accent" : ""), label);

          b.addEventListener("click", function () { move(text); });

          return b;
        }

        function renderBlackjackText(payload) {
          var view = payload.view || [];
          var hands = view[0] || [];
          var totals = view[1] || [];
          var dealer = view[2] || [];
          var done = view[4] || [];
          var scores = view[5] || [];
          var side = view[6];
          var html = '<div class="pad" style="padding-left:0">Dealer <b>' + esc(dealer.join(" ")) + "</b> (" + (view[3] || 0) + ')</div><ul class="list">';

          hands.forEach(function (hand, i) {
            html +=
              '<li><span style="flex:1">' + esc(seatName(payload, i)) + "</span>" +
              "<span>" + esc(hand.join(" ")) + " (" + (totals[i] || 0) + ")</span>" +
              '<span class="muted" style="margin-left:8px">won ' + (scores[i] || 0) + (done[i] ? ", done" : "") + "</span></li>";
          });

          html += '</ul><div class="toolbar">';
          html += side === -1 ? '<button class="btn accent g-deal">Deal next round</button>' : '<button class="btn accent g-hit">Hit</button><button class="btn g-stand">Stand</button>';
          html += "</div>";
          elBody.innerHTML = html;

          [[".g-deal", "deal"], [".g-hit", "hit"], [".g-stand", "stand"]].forEach(function (pair) {
            var node = elBody.querySelector(pair[0]);

            if (node) node.addEventListener("click", function () { move(pair[1]); });
          });
        }

        /* ---- rock paper scissors ------------------------------------------------------ */

        function renderRps(payload) {
          var view = payload.view || [];
          var own = String(view[0] || "");
          var opponentThrew = view[1] === true;
          var scores = view[2] || [0, 0];
          var round = view[3] || 1;
          var lastThrows = view[5] || ["", ""];
          var lastWinner = view[6] === undefined ? -1 : view[6];
          var seat = payload.seat || 0;
          var wrap = el("div", "ae3g-col");

          wrap.appendChild(el("div", "ae3g-head", "Round " + round + ", score " + (scores[seat] || 0) + " - " + (scores[1 - seat] || 0)));

          // The round that has just been settled, both throws face up, which is the only moment the
          // server sends the other seat's throw at all
          if (lastThrows[0]) {
            var reveal = el("div", "ae3g-row");
            var mine = el("div", "ae3g-col");

            mine.appendChild(el("div", "muted", "You threw"));
            mine.appendChild(el("div", "ae3g-throw", throwName(lastThrows[seat])));
            reveal.appendChild(mine);

            var theirs = el("div", "ae3g-col");

            theirs.appendChild(el("div", "muted", "They threw"));
            theirs.appendChild(el("div", "ae3g-throw", throwName(lastThrows[1 - seat])));
            reveal.appendChild(theirs);

            var verdict = "Drawn round";

            if (lastWinner === seat) verdict = "You won the round";
            if (lastWinner >= 0 && lastWinner !== seat) verdict = "They won the round";

            var result = el("div", "ae3g-col");
            result.appendChild(el("div", "ae3g-head", verdict));
            reveal.appendChild(result);

            wrap.appendChild(reveal);
          }

          wrap.appendChild(el("div", "", "Your throw: " + (own || "not yet")));
          wrap.appendChild(el("div", "muted", "Opponent: " + (opponentThrew ? "has thrown" : "not yet")));

          var tools = el("div", "toolbar");

          ["rock", "paper", "scissors"].forEach(function (name) {
            var b = el("button", "btn" + (own === name ? " accent" : ""), throwName(name));

            b.addEventListener("click", function () { move(name); });
            tools.appendChild(b);
          });

          wrap.appendChild(tools);
          wrap.appendChild(el("div", "ae3g-note", "First to three rounds takes the match."));

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
        }

        /* ---- battleship --------------------------------------------------------------- */

        function waterGrid(cells, onPick) {
          var grid = el("div", "ae3g-grid");
          var i;

          grid.appendChild(el("div", "ae3g-label", ""));

          for (i = 0; i < 10; i += 1) {
            grid.appendChild(el("div", "ae3g-label", "abcdefghij".charAt(i)));
          }

          for (i = 0; i < 100; i += 1) {
            if (i % 10 === 0) grid.appendChild(el("div", "ae3g-label", String(i / 10 + 1)));

            var mark = cells.charAt(i) || ".";
            var cell = el("div", "ae3g-water");

            if (mark === "S") cell.style.background = "#6f7a80";
            if (mark === "x") cell.style.background = "#a03c2e";
            if (mark === "o") cell.style.background = "#2f6f4f";

            if (onPick) {
              cell.style.cursor = "pointer";
              (function (index) {
                cell.addEventListener("click", function () { onPick(index); });
              })(i);
            }

            grid.appendChild(cell);
          }

          return grid;
        }

        function squareOf(index) {
          return "abcdefghij".charAt(index % 10) + String(Math.floor(index / 10) + 1);
        }

        function renderBattleship(payload) {
          var view = payload.view || [];
          var own = String(view[0] || "");
          var shots = String(view[1] || "");
          var phase = String(view[4] || "play");
          var fleet = view[5] || [];
          var ownAfloat = view[6] || 0;
          var enemyAfloat = view[7] || 0;
          var ready = view[8] || [false, false];

          if (phase === "setup") return renderBattleshipSetup(payload, own, fleet, ready);

          var wrap = el("div", "ae3g-row");
          var left = el("div", "ae3g-col ae3g-bscol");

          left.appendChild(el("div", "ae3g-head", "Your waters - " + ownAfloat + " afloat"));
          left.appendChild(waterGrid(own, null));
          wrap.appendChild(left);

          var right = el("div", "ae3g-col ae3g-bscol");

          right.appendChild(el("div", "ae3g-head", "Their waters - " + enemyAfloat + " afloat"));
          right.appendChild(waterGrid(shots, function (index) { move(squareOf(index)); }));
          wrap.appendChild(right);

          var board = el("div", "ae3g-col");

          board.appendChild(wrap);
          board.appendChild(fleetList(fleet, own, -1, null));

          elBody.innerHTML = "";
          elBody.appendChild(board);
        }

        // The fleet as a list with each ship's length and where it sits, which doubles as the picker
        // while the fleet is being laid out
        function fleetList(fleet, cells, picked, onPick) {
          var wrap = el("div", "ae3g-col");

          wrap.appendChild(el("div", "ae3g-head", "Fleet"));

          fleet.forEach(function (ship, index) {
            var length = ship[0] || 0;
            var indices = ship[1] || [];
            var row = el("div", "ae3g-fleetrow" + (index === picked ? " ae3g-pick" : ""));
            var pips = el("div", "", "");

            pips.style.display = "flex";
            pips.style.gap = "2px";

            for (var i = 0; i < length; i += 1) {
              var pip = el("div", "");

              pip.style.width = "10px";
              pip.style.height = "10px";
              pip.style.borderRadius = "2px";
              pip.style.background = indices.length ? "#6f7a80" : "#3b434a";
              pips.appendChild(pip);
            }

            row.appendChild(pips);
            row.appendChild(el("span", "", (SHIP_NAMES[index] || ("Ship " + (index + 1))) + " - " + length));

            var hits = 0;

            indices.forEach(function (at) {
              if ((cells.charAt(at) || ".") === "x") hits += 1;
            });

            if (indices.length === 0) {
              row.appendChild(el("span", "muted", "not placed"));
            } else if (hits >= indices.length) {
              row.appendChild(el("span", "muted", "sunk"));
            } else {
              row.appendChild(el("span", "muted", squareOf(indices[0])));
            }

            if (onPick) {
              row.addEventListener("click", function () { onPick(index); });
            }

            wrap.appendChild(row);
          });

          return wrap;
        }

        function renderBattleshipSetup(payload, own, fleet, ready) {
          var seat = payload.seat || 0;
          var wrap = el("div", "ae3g-row");
          var left = el("div", "ae3g-col ae3g-bscol");

          left.appendChild(el("div", "ae3g-head", "Lay out your fleet"));
          left.appendChild(waterGrid(own, function (index) {
            move("place " + (state.ship + 1) + " " + squareOf(index) + " " + (state.vertical ? "v" : "h"));
          }));
          left.appendChild(el("div", "ae3g-note", "Pick a ship, choose its heading, then click the square its bow sits on."));
          wrap.appendChild(left);

          var right = el("div", "ae3g-col");

          right.appendChild(fleetList(fleet, own, state.ship, function (index) {
            state.ship = index;
            renderBattleshipSetup(payload, own, fleet, ready);
          }));

          var tools = el("div", "toolbar");
          var rotate = el("button", "btn", state.vertical ? "Heading: vertical" : "Heading: horizontal");

          rotate.addEventListener("click", function () {
            state.vertical = !state.vertical;
            renderBattleshipSetup(payload, own, fleet, ready);
          });

          tools.appendChild(rotate);
          tools.appendChild(actionButton("Random", "random", false));
          tools.appendChild(actionButton("Clear", "clear", false));
          right.appendChild(tools);

          var confirm = el("div", "toolbar");

          confirm.appendChild(actionButton("Ready", "ready", true));
          confirm.appendChild(el("span", "muted", ready[1 - seat] ? "Your opponent is ready" : "Your opponent is still placing"));
          right.appendChild(confirm);

          wrap.appendChild(right);

          elBody.innerHTML = "";
          elBody.appendChild(wrap);
        }

        /* ---- shared ------------------------------------------------------------------- */

        // Two clicks make a move on a square board: pick a piece, then its destination
        // The outline marks the square a move is being built from, so it has to go the moment that
        // square stops being the answer - including when the move it was part of is refused, which
        // sends no new board back to redraw over it
        function clearPick() {
          var marked = elBody.querySelectorAll(".ae3g-sq.ae3g-pick");
          var i;

          for (i = 0; i < marked.length; i += 1) {
            marked[i].classList.remove("ae3g-pick");
          }

          state.from = null;
        }

        function bindSquarePicker() {
          var squares = elBody.querySelectorAll(".ae3g-sq");
          var i;

          for (i = 0; i < squares.length; i += 1) {
            squares[i].addEventListener("click", function () {
              var index = parseInt(this.getAttribute("data-index"), 10);

              // Clicking the chosen square again is how a wrong pick is taken back
              if (state.from === index) {
                clearPick();
                return;
              }

              if (state.from === null) {
                state.from = index;
                this.classList.add("ae3g-pick");
                return;
              }

              var text = squareName(state.from) + squareName(index);

              clearPick();
              move(text);
            });
          }
        }

        function renderTable(payload) {
          state.tableId = payload.id;
          elLeave.hidden = false;

          // The board is rebuilt from scratch below, so a square picked against the old one is gone
          state.from = null;

          if (payload.phase === "lobby") {
            renderTableLobby(payload);
            return;
          }

          switch (payload.gameId) {
            case "chess": renderChess(payload); break;
            case "checkers": renderCheckers(payload); break;
            case "uno": renderUno(payload); break;
            case "ludo": renderLudo(payload); break;
            case "snakesladders": renderSnakes(payload); break;
            case "blackjack": renderBlackjack(payload); break;
            case "rps": renderRps(payload); break;
            case "battleship": renderBattleship(payload); break;
            default: elBody.innerHTML = '<div class="pad muted">This game has no board view yet.</div>';
          }

          // Under the board: what this seat is called, and - for a host playing several seats from
          // one laptop - which of them is being played
          var seatTools = el("div", "toolbar");

          seatTools.appendChild(seatNameButton(payload));
          elBody.appendChild(seatTools);

          var switcher = seatSwitcher(payload);

          if (switcher.childNodes.length) elBody.appendChild(switcher);

          if (payload.status) elBody.appendChild(el("div", "ae3g-note", payload.status));

          if (payload.phase === "over") {
            setStatus(payload.winner === -2 ? "Draw" : (payload.winner === payload.seat ? "You won" : "You lost"));
            return;
          }

          setStatus(payload.turn === payload.seat || payload.turn === -1 ? "Your move" : "Waiting for the other player");
        }

        function onView(payload) {
          if (payload.kind === "lobby") {
            state.view = payload;
            renderLobby(payload);
            return;
          }

          if (payload.kind === "table") {
            // A view for a different table arrives when several matches are open at once
            if (state.tableId && payload.id !== state.tableId) return;

            state.view = payload;
            renderTable(payload);
          }
        }

        sinks.push(onView);

        body.querySelector(".g-new").addEventListener("click", renderHostForm);

        body.querySelector(".g-lobby").addEventListener("click", function () {
          if (state.tableId) send("games_open", { id: state.tableId, open: false });
          requestLobby();
        });

        elLeave.addEventListener("click", function () {
          if (!state.tableId) return;

          send("games_leave", { id: state.tableId });
          requestLobby();
        });

        win.app.onClose = function () {
          var at = sinks.indexOf(onView);
          if (at >= 0) sinks.splice(at, 1);

          // Closing the window keeps the seat: the match waits to be picked up again, and only the
          // power the game was drawing goes away
          if (state.tableId) send("games_open", { id: state.tableId, open: false });
        };

        if (state.tableId) {
          openTable(state.tableId);
        } else {
          requestLobby();
        }
      }
    };
  }

  window.AE3_makeGameApp = makeApp;
})();

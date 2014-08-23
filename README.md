Pack/Lock/Move Script



What it does:

This script allows the admin to define objects, vehicles, really any item in the game to be moveable, lockable, and packable into vehicles.


Installation instructions:
1. Unzip the file "PLM.zip" to root of your MISSION PBO/directory
2. Modify your desription.ext file to inlclude this line at the top:

#include "PLM\transport\dlg_vehicle_content.h


3. Modify your init.sqf to include this line at the bottom

[] execVM "PLM\init.sqf";

4. Modify the confg.cfg file to your liking (file is commented for easy setup)

5. Enjoy



Features:
1. Admin definable list of vehicles and their capacities
2. Admin definable list of packables and their weights
3. Ability to move any item by carrying 
4. Ability to lock and unlock items into place
5. Ability to rotate objects during placement


Changelog

1.0 - Initial release


Credits

This script is an extracted and translated version of the packing system implemented in the R3F_LOG_ARTY script.  Full credit is given to those authors.
Thanks to all the other script writers whose scripts I'm using on my server!

/**
 * 
 * This file contains the configuration variables of the packing system.
 * 
 * Important note : All the classes names which inherits from the ones used in configuration variables will be also available.
 */

/*
 * There are two ways to manage new objects with this PLM system. The first is to add these objects in the
 * following appropriate lists. The second is to create a new external file in the /addons_config/ directory,
 * according to the same scheme as the existing ones, and to add a #include at the end of this file.
 * 
 */

 //Global config variables
 
 //Location of installed files - modify this to match your server and fle placement
 PLM_GVAR_install_dir = "PLM\";
 
 //Allow things to be locked?
 PLM_GVAR_objects_lockable = true;
 
 //Can player move items while on a ladder (default = false = no)
 PLM_GVAR_move_on_ladder = false;
 
 //List of possible sidearms in your game.  This is important because it plays the correct animation if you're moving too fast when you have your gun out.
 PLM_GVAR_sidearms = ["M9", "M9SD", "Colt1911", "Makarov", "MakarovSD", "Sa61_EP1", "UZI_EP1", "UZI_SD_EP1", "revolver_EP1", "revolver_gold_EP1", "glock17_EP1"];
 
 
 

/****** LOAD IN VEHICLE ******/

/*
 * This section use a quantification of the volume and/or weight of the objets.
 * The arbitrary reference used is : an ammo box of type USVehicleBox "weighs" 12 units.
 * 
 * Note : the priority of a declaration of capacity to another corresponds to their order in the tables.
 *   For example : the "Truck" class is in the "Car" class (see http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
 *   If "Truck" is declared with a capacity of 140 before "Car". And if "Car" is declared after "Truck" with a capacity of 40,
 *   Then all the sub-classes in "Truck" will have a capacity of 140. And all the sub-classes of "Car", except the ones
 *   in "Truck", will have a capacity of 40.
 * 
 */

/**
 * List of class names of (ground or air) vehicles which can transport transportable objects.
 * The second element of the array is the load capacity (in relation with the capacity cost of the objects).
 * 
 */
PLM_CFG_transporters = [
	["CH47_base_EP1", 80],
	["AH6_Base_EP1", 25],
	["Mi17_base", 60],
	["Mi24_Base", 50],
	["UH1H_base", 35],
	["UH1_Base", 30],
	["UH60_Base", 40],
	["An2_Base_EP1", 40],
	["C130J", 150],
	["MV22", 80],
	["ATV_Base_EP1", 5],
	["HMMWV_Avenger", 5],
	["HMMWV_M998A2_SOV_DES_EP1", 12],
	["HMMWV_Base", 18],
	["Ikarus", 50],
	["Lada_base", 10],
	["LandRover_Base", 15],
	["Offroad_DSHKM_base", 15],
	["Pickup_PK_base", 15],
	["S1203_TK_CIV_EP1", 20],
	["SUV_Base_EP1", 15],
	["SkodaBase", 10],
	["TowingTractor", 5],
	["Tractor", 5],
	["KamazRefuel", 10],
	["Kamaz_Base", 50],
	["MAZ_543_SCUD_Base_EP1", 10],
	["MtvrRefuel", 10],
	["MTVR", 50],
	["GRAD_Base", 10],
	["Ural_Base", 35],
	["Ural_ZU23_Base", 20],
	["Ural_CDF", 50],
	["Ural_INS", 50],
	["UralRefuel_Base", 10],
	["V3S_Refuel_TK_GUE_EP1", 10],
	["V3S_Civ", 50],
	["V3S_Base_EP1", 50],
	["UAZ_Base", 10],
	["VWGolf", 8],
	["Volha_TK_CIV_Base_EP1", 8],
	["BRDM2_Base", 15],
	["BTR40_MG_base_EP1", 15],
	["BTR60_TK_EP1", 25],
	["BTR90_Base", 25],
	["GAZ_Vodnik_HMG", 25],
	["LAV25_Base", 25],
	["StrykerBase_EP1", 25],
	["hilux1_civil_1_open", 12],
	["hilux1_civil_3_open_EP1", 12],
	["Motorcycle", 5],
	["2S6M_Tunguska", 10],
	["M113_Base", 12],
	["M1A1", 5],
	["M2A2_Base", 15],
	["MLRS", 8],
	["T34", 5],
	["T55_Base", 5],
	["T72_Base", 5],
	["T90", 5],
	["AAV", 12],
	["BMP2_Base", 7],
	["BMP3", 7],
	["ZSU_Base", 5],
	["Ship", 10],
	["Fort_Crate_wood", 20],
	["Misc_cargo_cont_tiny", 40],
	["BAF_Merlin_HC3_D",75],
	["Ka60_Base_PMC", 40],
	["ArmoredSUV_Base_PMC", 12],
	["BAF_Jackal2_BASE_D", 15]
];

/**
 * List of class names of transportable objects.
 * The second element of the array is the cost capacity (in relation with the capacity of the vehicles).
 * 
 */
 
PLM_CFG_transportable_objects =  [
	["HMMWV_Base", 80],
	["HMMWV_Avenger", 80],
	["HMMWV_M998A2_SOV_DES_EP1", 80],
	["USBasicAmmunitionBox",12],
	["USOrdnanceBox",5],
	["RUBasicAmmunitionBox",12],
	["LocalBasicAmmunitionBox",12],
	["GuerillaCacheBox",12],
	["ReammoBox_EP1",12],
	["MMT_Civ",3]
];

/****** MOVABLE-BY-PLAYER OBJECTS ******/

/**
 * List of class names of objects moveables by player.
 * ex. Ammo boxes, buildables, furniture, anything really
 */

PLM_CFG_moveable_objects = [
	"USBasicAmmunitionBox",
	"USOrdnanceBox",
	"RUBasicAmmunitionBox",
	"LocalBasicAmmunitionBox",
	"GuerillaCacheBox",
	"ReammoBox_EP1",
	"MMT_Civ"

];

/*
 * List of files adding objects in the arrays of items defined in this file (ex. OverPoch items)
 * Add an include to the new file here if you want to use the packing system with a new addon.
 * 
 */
#include "addons_config\arma2_CO_objects.sqf"
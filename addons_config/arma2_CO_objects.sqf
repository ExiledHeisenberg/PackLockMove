/**
 * 
 * This file adds the ArmA 2 and Arrowhead objetcs in the configuration variables of the logistics system.
 * 
 * Important note : All the classes names which inherits from the ones used in configuration variables will be also available.
 */



/****** LOAD IN VEHICLE / CHARGER DANS LE VEHICULE ******/

/*
 * This section use a quantification of the volume and/or weight of the objets.
 * The arbitrary referencial used is : an ammo box of type USSpecialWeaponsBox "weights" 5 units.
 * 
 * 
 * Note : the priority of a declaration of capacity to another corresponds to their order in the tables.
 *   For example : the "Truck" class is in the "Car" class (see http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
 *   If "Truck" is declared with a capacity of 140 before "Car". And if "Car" is declared after "Truck" with a capacity of 40,
 *   Then all the sub-classes in "Truck" will have a capacity of 140. And all the sub-classes of "Car", excepted the ones
 *   in "Truck", will have a capacity of 40.
 * 
 */

/**
 * List of class names of (ground or air) vehicles which can transport transportable objects.
 * The second element of the arrays is the load capacity (in relation with the capacity cost of the objects).
 * 
 */
PLM_CFG_transporters = PLM_CFG_transporters +
[

];

/**
 * List of class names of transportable objects.
 * The second element of the arrays is the cost capacity (in relation with the capacity of the vehicles).
 * 
 */
PLM_CFG_transportable_objects = PLM_CFG_transportable_objects +
[

];


/****** MOVABLE-BY-PLAYER OBJECTS ******/

/**
 * List of class names of objects moveable by player.
 */
PLM_CFG_moveable_objects = PLM_CFG_moveable_objects +
[

];
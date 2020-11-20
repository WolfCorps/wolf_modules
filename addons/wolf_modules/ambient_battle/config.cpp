
class CfgPatches
{
	class WOLF_Modules
	{
		requiredAddons[] = {"A3_Data_F_Oldman_Loadorder"};
		units[] = {"ModuleAmbientBattles"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class WOLF
	{
		class a
		{
			class ambientbattles {file = "WOLF_Modules\ambient_battles.sqf";};
		};
	};
	
};

class CfgVehicles 
	{
		class ModuleDescription;
		class Module_F;
		class ModuleAmbientBattles: Module_F
		{
			author = "Wolf Corps";
			_generalMacro = "ModuleAmbientBattles";
			scope = 2;
			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Ambient Battles";
			category = "Effects";
			function = "WOLF_fnc_ambientbattles";
			is3DEN = 1;
			isGlobal = 0;
			isTriggerActivated = 1;
			class Arguments
			{
				class distance
				{
					displayName = "Distance";
					description = "Distance of Sounds (closer means louder)";
					class values
					{                  
						class 50
                        {
                            name = "50 meters";
                            value = "50";
                            default = 1;
                        };
                        class 100
                        {
                            name = "100 meters";
                            value = "100";
                        };
                        class 150
                        {
                            name = "150 meters";
                            value = "150";
                        };
                        class 200
                        {
                            name = "200 meters";
                            value = "200";
                        };
                        class 250
                        {
                            name = "250 meters";
                            value = "250";
                        };
                        class 300
                        {
                            name = "300 meters";
                            value = "300";
                        };
                        class 350
                        {
                            name = "350 meters";
                            value = "350";
                        };
                        class 400
                        {
                            name = "400 meters";
                            value = "400";
                        };
                        class 450
                        {
                            name = "450 meters";
                            value = "450";
                        };
                        class 500
                        {
                            name = "500 meters";
                            value = "500";
                        };
                        class 550
                        {
                            name = "550 meters";
                            value = "550";
                        };
                        class 600
                        {
                            name = "600 meters";
                            value = "600";
                        };
					};
				};
				class duration
				{
					displayName = "Duration";
					description = "Duration of Sounds in Minutes";
					class values
					{                  
						class 1
                        {
                            name = "1 minute";
                            value = "60";
                            default = 1;
                        };
                        class 2
                        {
                            name = "2 minutes";
                            value = "120";
                        };
                        class 5
                        {
                            name = "5 minutes";
                            value = "300";
                        };
                        class 10
                        {
                            name = "10 minutes";
                            value = "600";
                        };
                        class 30
                        {
                            name = "30 minutes";
                            value = "1800";
                        };
                        class 60
                        {
                            name = "60 minutes";
                            value = "3600";
                        };
                        class 120
                        {
                            name = "120 minutes";
                            value = "7200";
                        };
                        class Infinite
                        {
                            name = "Infinite";
                            value = "25555555";
                        };
                        
					};
				};
				class maxdistance
				{
					displayName = "Maximum distance";
					description = "Maximum distance to the module to play sound for the player. If player exceeds the range the sound will be stopped.";
					class values
					{                  
						class 1000
                        {
                            name = "1000 meters";
                            value = "1000";                       
                        };
                        class 2000
                        {
                            name = "1500 meters";
                            value = "1500";
                        };
                        class 2000
                        {
                            name = "2000 meters";
                            value = "2000";
                        };
                        class 2500
                        {
                            name = "2500 meters";
                            value = "2500";
                        };
                        class 3000
                        {
                            name = "3000 meters";
                            value = "3000";
                            default = 1; 
                        };
                        class 3500
                        {
                            name = "3500 meters";
                            value = "3500";
                        };
                        class 4000
                        {
                            name = "4000 meters";
                            value = "4000";
                        }; 
                        class 5000           
                        {
                            name = "5000 meters";
                            value = "5000";
                        }; 
					};
				};
			};
			class ModuleDescription: ModuleDescription
			{
				position = 1;
				description = "Create ambient battle sounds. Sound center is module position.";
			};
		};
	};
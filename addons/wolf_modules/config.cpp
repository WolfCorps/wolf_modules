
class CfgPatches
{
    class WOLF_Modules
    {
        requiredAddons[] = {"A3_Data_F_Oldman_Loadorder"};
        units[] = {"ModuleAmbientBattles"};
        weapons[] = {};
        requiredVersion = 2.20;
    };
};

class CfgFunctions
{
    class IRN
    {
        class ambient_battle
        {
            file = "z\wolf\modules\ambient_battle";
            class ambientbattles;
            class calcSoundPos;
            class spawnSalvo;
            class remoteSound;
        };
    };


    class wolf_tasksystem
    {
        class task_system
        {
            file = "z\wolf\modules\tasksystem";
            class init { preInit = 1; };
            class createRandomTask; // wolf_tasksystem_fnc_createRandomTask
            class createTaskLocation;
            class registerTaskType;
            class selectTaskType;
            class startNewTask;
            class updateActiveTasks;
        };
    };

    class wolf_unitRecording
    {
        class stuff
        {
            file = "z\wolf\modules\functions";
            class onLoadUnitRecordingButton; // wolf_unitRecording_fnc_onLoadUnitRecordingButton
            class onClickUnitRecordingButton; // wolf_unitRecording_fnc_createRandomTask
        };
    };

    class wolf_smoothTeleport
    {
        class stuff
        {
            file = "z\wolf\modules\functions";
            class module { file = "z\wolf\modules\functions\fn_moduleSmoothTeleport.sqf"; }; // wolf_smoothTeleport_fnc_module
            class doTeleport { file = "z\wolf\modules\functions\fn_doTeleport.sqf"; }; // wolf_smoothTeleport_fnc_doTeleport
        };
    };
};

class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
            class AttributesBase
            {
                class Default;
                class Edit;                    // Default edit box (i.e. text input field)
                class Combo;                // Default combo box (i.e. drop-down menu)
                class Checkbox;                // Default checkbox (returned value is Boolean)
                class CheckboxNumber;        // Default checkbox (returned value is Number)
                class ModuleDescription;    // Module description
                class Units;                // Selection of units on which the module is applied
            };

            // Description base classes (for more information see below):
            class ModuleDescription
            {
                class AnyBrain;
            };
    };

    class ModuleAmbientBattles: Module_F
    {
        author = "Wolf Corps";
        _generalMacro = "ModuleAmbientBattles";
        scope = 2;
        icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
        portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
        displayName = "Ambient Battles";
        category = "Effects";
        function = "IRN_fnc_ambientbattles";
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
                    class 1500
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

    class wolf_ModuleSmoothTeleport: Module_F
    {
        author = "Wolf Corps";
        scope = 2;
        icon = "IconTimeline";
        portrait = "";
        displayName = "Smooth Teleport";
        category = "MissionFlow";
        function = "wolf_smoothTeleport_fnc_module";
        is3DEN = 1;
        isGlobal = 1;
        isTriggerActivated = 0; // We set up the triggers by ourselves
        isDisposable = 1;

        canSetArea = 1; // Allows for setting the area values in the Attributes menu in 3DEN
        canSetAreaShape = 1;

        class AttributeValues
        {
            // This section allows you to set the default values for the attributes menu in 3DEN
            size3[] = { 10, 10, -1 };        // 3D size (x-axis radius, y-axis radius, z-axis radius)
            isRectangle = 0;                // Sets if the default shape should be a rectangle or ellipse
        };

        // Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
        class Attributes : AttributesBase
        {
            class TeleportName : Edit
            {
                displayName = "TeleportName";
                tooltip = "Name of the teleport, must have two modules that teleport back and forth";
                property = "wolf_TeleportName";
                defaultValue = """""";
                expression = "_this setVariable ['%s',_value];";
            };

            class ModuleDescription : ModuleDescription {}; // Module description should be shown last
        };

        class ModuleDescription: ModuleDescription
        {
            position = 0; // Position doesn't matter
            description = "Smooth teleports to other module with same teleport name";
        };
    };








};


class RscButton;
class RscStandardDisplay;

class wolf_unitRecording: RscButton
{
    idc = 33501;
    onLoad = "_this call wolf_unitRecording_fnc_onLoadUnitRecordingButton";
    action = "call wolf_unitRecording_fnc_onClickUnitRecordingButton";
    text = "Start unit recording";
    x = "1.2";
    y = "(6 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY))";
    w = "(10 * (((safezoneW / safezoneH) min 1.2) / 40))";
    h = "(1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))";
    deletable = 1;
};
class RscDisplayMPInterrupt: RscStandardDisplay
{
    class controls
    {
        class wolf_unitRecording_ : wolf_unitRecording {};
    };
};
//class RscDisplayInterruptEditorPreview: RscStandardDisplay
//{
//	class controls
//	{
//		class wolf_unitRecording_ : wolf_unitRecording {};
//	};
//};
class RscDisplayInterrupt: RscStandardDisplay
{
    class controls
    {
        class wolf_unitRecording_ : wolf_unitRecording {};
    };
};

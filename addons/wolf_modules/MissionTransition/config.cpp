#include "\a3\3den\ui\macros.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "\a3\ui_f\hpp\definecommongrids.inc"
#include "\a3\ui_f\hpp\defineresincl.inc"
#include "\a3\ui_f\hpp\defineresincldesign.inc"


class CfgPatches
{
    class WOLF_Modules_MissionTransition
    {
        requiredAddons[] = {"A3_Data_F_Oldman_Loadorder", "wolf_logistics_main", "ace_cargo", "ace_refuel", "tfar_core"};
        units[] = {}; // These are only for zeus, which we don't want
        weapons[] = {};
        requiredVersion = 2.20;
    };
};

class CfgFunctions
{
    class wolf_MissionTransition
    {
        class MissionTransition
        {
            file = "z\wolf\modules\MissionTransition";
            class init { postInit = 1; }; // wolf_MissionTransition_fnc_init
            class client_enteredEndZone {};
            class client_applyLoadout {}; // wolf_MissionTransition_fnc_client_applyLoadout
            class server_storeClientLoadout {}; // wolf_MissionTransition_fnc_server_storeClientLoadout

            class server_fetchClientLoadout {}; // wolf_MissionTransition_fnc_server_fetchClientLoadout
            class server_serializeVehicle {}; // wolf_MissionTransition_fnc_server_serializeVehicle
            class server_deserializeVehicle {}; // wolf_MissionTransition_fnc_server_deserializeVehicle

            class moduleExit { };
            class moduleEntry { };
        };
    };
};

class ctrlMenu;

class Display3DEN
{
    class ContextMenu: ctrlMenu
    {
        class Items
        {
            #if 0
            items[] +=
            {
                "wolf_AddToFavorites",
                "wolf_AddToFavorites2"
            };

            class wolf_AddToFavorites
            {
                action = "systemChat str _this";
                text = "WOLF TEST";
                picture = "\a3\ui_f_curator\data\displays\rscdisplaycurator\moderecent_ca.paa";
                conditionShow = "hoverObject + hoverLogic + hoverMarker";
                wikiDescription = "babab";
                value = 0;
                shortcuts[] = {INPUT_CTRL_OFFSET + DIK_K};
            };

            class wolf_AddToFavorites2
            {

                action = "systemChat str _this";
                text = "WOLF TEST 2";
                picture = "\a3\ui_f_curator\data\displays\rscdisplaycurator\moderecent_ca.paa";
                conditionShow = "script1";
                conditionScript1 = "_this isKindOf 'wolf_ModuleMissionTransitionExit'";
                wikiDescription = "babab";
                value = 0;
            };
            #endif
        };
    };
};

class Cfg3DEN
{
    class Connections
    {
        class wolf_CustomConnectionPlayer
        {
            displayName = "Connect Player zone";
            condition1 = "script1";
            condition2 = "trigger";

            conditionScript1 = "_thisType == 'Logic' && {_this isKindOf 'wolf_ModuleMissionTransitionExit'}";

            property = "wolf_CustomConnection";
            data = "wolf_CustomConnectionPlayer";
            color[] = { 1, 0, 1, 1 };
            cursor = "3DENConnectSync";
            expression = "_v = _entity0 getVariable ['wolf_playerZones', []]; _v pushBack _entity1; _entity0 setVariable ['wolf_playerZones', _v];";
        };

        class wolf_CustomConnectionVehZone
        {
            displayName = "Connect vehicle spot";
            condition1 = "script1";
            condition2 = "trigger";

            conditionScript1 = "_thisType == 'Logic' && {_this isKindOf 'wolf_ModuleMissionTransitionExit'}";

            property = "wolf_CustomConnection";
            data = "wolf_CustomConnectionVehZone";
            color[] = { 1, 1, 0, 1 };
            cursor = "3DENConnectSync";
            expression = "_v = _entity0 getVariable ['wolf_vehZones', []]; _v pushBack _entity1; _entity0 setVariable ['wolf_vehZones', _v];";
        };

        class wolf_CustomConnectionVehSpot
        {
            displayName = "Connect vehicle spot";
            condition1 = "script1";
            condition2 = "marker";

            conditionScript1 = "_thisType == 'Logic' && {_this isKindOf 'wolf_ModuleMissionTransitionEntry'}";

            property = "wolf_CustomConnection";
            data = "wolf_CustomConnectionVehSpot";
            color[] = { 1, 1, 0, 1 };
            cursor = "3DENConnectSync";
            expression = "_v = _entity0 getVariable ['wolf_vehSpots', []]; _v pushBack _entity1; _entity0 setVariable ['wolf_vehSpots', _v];";
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

    class wolf_ModuleMissionTransitionExit: Module_F
    {
        author = "Wolf Corps";
        scope = 2;
        icon = "\a3\Modules_F_Curator\Data\iconEndMission_ca.paa";
        portrait = "\a3\Modules_F_Curator\Data\portraitEndMission_ca.paa";
        displayName = "Mission transition (Exit)";
        category = "MissionFlow";
        function = "wolf_MissionTransition_fnc_moduleExit";
        is3DEN = 1;
        isGlobal = 1;
        isTriggerActivated = 0; // We set up the triggers by ourselves
        isDisposable = 1;

        canSetArea = 0; // Allows for setting the area values in the Attributes menu in 3DEN
        canSetAreaShape = 0;

        //class AttributeValues
        //{
        //    // This section allows you to set the default values for the attributes menu in 3DEN
        //    size3[] = { 10, 10, -1 };        // 3D size (x-axis radius, y-axis radius, z-axis radius)
        //    isRectangle = 1;                // Sets if the default shape should be a rectangle or ellipse
        //};



        // Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
        class Attributes : AttributesBase
        {
            class ExcludedPlayers : Edit
            {
                displayName = "Excluded players";
                tooltip = "Variable names of players that don't need to be in the area too end the mission.";
                property = "wolf_excludedPlayers";
                control = "EditArray";
                defaultValue = "[]";
                expression = "_this setVariable ['%s',_value];";
            };

            class FollowupMission : Edit
            {
                displayName = "Followup Mission";
                tooltip = "Filename of mission that should be switched to, once all players are saved";
                property = "wolf_nextMission";
                defaultValue = """""";
                expression = "_this setVariable ['%s',_value];";
            };

            class ModuleDescription : ModuleDescription {}; // Module description should be shown last
        };


        class ModuleDescription: ModuleDescription
        {
            position = 0; // Position doesn't matter
            description = "Any unit that enters the area (connected trigger), will have their loadout saved on the server, and get their screen blacked out. Once all players are saved, the server will trigger a mission transition. Multiple 'vehicle zone' trigger areas can be connected, all vehicles inside them will be saved too.";
        };
    };

    class wolf_ModuleMissionTransitionEntry: Module_F
    {
        author = "Wolf Corps";
        scope = 2;
        icon = "IconTimeline";
        portrait = "";
        displayName = "Mission transition (Entry)";
        category = "MissionFlow";
        function = "wolf_MissionTransition_fnc_moduleEntry";
        is3DEN = 1;
        isGlobal = 1;
        isTriggerActivated = 0; // We set up the triggers by ourselves
        isDisposable = 1;

        canSetArea = 0; // Allows for setting the area values in the Attributes menu in 3DEN
        canSetAreaShape = 0;

        //class AttributeValues
        //{
        //    // This section allows you to set the default values for the attributes menu in 3DEN
        //    size3[] = { 10, 10, -1 };        // 3D size (x-axis radius, y-axis radius, z-axis radius)
        //    isRectangle = 1;                // Sets if the default shape should be a rectangle or ellipse
        //};

        // Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
        class Attributes : AttributesBase
        {
            class ModuleDescription : ModuleDescription {}; // Module description should be shown last
        };


        class ModuleDescription: ModuleDescription
        {
            position = 0; // Position doesn't matter
            description = "Loads previously saved players and vehicles at mission start. The players will spawn in the area of this module, vehicles will spawn on connected map markers. Connect multiple map markers for vehicle spawn positions via right-click -> connect.";
        };
    };
};

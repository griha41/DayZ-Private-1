startLoadingScreen ["", "DayZ_loadingScreen"];
enableSaving [false, false];

dayZ_instance = 1;
hiveInUse = true;
initialized = false;
dayz_previousID = 0;

call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				// Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";					// Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	// Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";					// Compile regular functions
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

player setVariable ["BIS_noCoreConversations", true];
enableRadio false; // Disable global chat radio messages

if (isServer) then { 		// If mission is loaded by server execute the server monitor
	hiveInUse = true;
	_serverMonitor = [] execVM "\z\addons\dayz_server\system\server_monitor.sqf";
};

if (!isDedicated) then {  	// If mission is loaded by a player execute the player monitor
	0 fadeSound 0;
	0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED", 60];
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";

	// Create burn effect for each helicopter wreck
	{
		nul = [_x, 2, time, false, false] spawn BIS_Effects_Burn;
	} forEach allMissionObjects "UH1Wreck_DZ";
};

#include "gcam\gcam_config.hpp"
#include "gcam\gcam_functions.sqf"

#ifdef GCAM
	#ifdef DEBUG
		diag_log ("DEBUG: INITIALIZING GCAM");
	#endif
	
	waitUntil {(!isNull Player) and (alive Player) and (player == player)};
	_uid = (getPlayerUID vehicle player);
	_isAdmin = (serverCommandAvailable "#kick");

	if (_isAdmin) then // && ((_uid) in ADMINS)
	{
		waituntil {!(IsNull (findDisplay 46))};
		(findDisplay 46) displayAddEventHandler ["keyDown", "_this call fnc_keyDown"];

		#ifdef DEBUG
			diag_log format ["GCAM keyevent loaded for admin: %1", _uid];
		#endif
	};
#endif

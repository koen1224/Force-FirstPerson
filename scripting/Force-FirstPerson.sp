#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>

ConVar g_cv_ForceFP;

public Plugin myinfo =
{
	name        = "Force FirstPerson",
	author      = "koen#4977",
	description = "Force players to use first person when they spawn",
	version     = "0.1",
	url         = "https://steamcommunity.com/id/fungame1224/"
};

public void OnPluginStart()
{
	// Register force first person command
	RegAdminCmd("sm_forcefp", Command_ForceFP, ADMFLAG_BAN, "Force all clients on the server to enter firstperson");
	
	// Declare convars
	g_cv_ForceFP = CreateConVar("sm_force_firstperson", "1", "Force all players to enter first person when they spawn? (0 - Disable | 1 - Enable)", _, true, 0.0, true, 1.0);
	AutoExecConfig(true, "Force_FirstPerson");
	
	// Hook player spawn event
	HookEvent("player_spawn", Event_PlayerSpawn);
}

// Hook playerspawn event and force clients firstperson if cvar is set to 1
public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	// If forced firstperson is disabled, then just return
	if (!g_cv_ForceFP.BoolValue)
		return;
	
	// Force all spawning clients to first person
	ClientCommand(GetClientOfUserId(event.GetInt("userid")), "firstperson");
}

// Force firstperson admin command
public Action Command_ForceFP(int client, int args)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		ClientCommand(i, "firstperson");
	}
	PrintToChat(client, "[Force FP] Forced all clients to enter firstperson!");
	return Plugin_Handled;
}
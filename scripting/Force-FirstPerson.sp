#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>

ConVar g_cvForce;
bool g_bForce;

public Plugin myinfo =
{
    name = "Force Firstperson",
    author = "koen",
    description = "Force firstperson perspective for spawning players",
    version = "0.2",
    url = "https://github.com/notkoen"
};

public void OnPluginStart()
{
    // Register force first person command
    RegAdminCmd("sm_forcefp", Command_ForceFP, ADMFLAG_BAN, "Force all clients on the server to enter firstperson");
    
    // Declare convars
    g_cvForce = CreateConVar("sm_force_firstperson", "1", "Force players to firstperson (0 - Disable, 1 - Enable)", _, true, 0.0, true, 1.0);
    g_bForce = g_cvForce.BoolValue;
    HookConVarChange(g_cvForce, OnConvarChange);

    AutoExecConfig(true, "Force_FirstPerson");
    
    // Hook player spawn event
    HookEvent("player_spawn", Event_PlayerSpawn);
}

// Hook convar change should the cvar be changed midway through
public void OnConvarChange(Handle cvar, const char[] oldValue, const char[] newVaule)
{
    if (cvar == g_cvForce)
        g_bForce = g_cvForce.BoolValue;
}

// Hook playerspawn event and force clients firstperson if cvar is set to 1
public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    // If forced firstperson is disabled, then just return
    if (!g_bForce)
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
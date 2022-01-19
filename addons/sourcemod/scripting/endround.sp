#include <sourcemod>
#include <autoexecconfig>
#include <cstrike>

#pragma newdecls required

public Plugin myinfo =
{
    name = "endround",
    author = "tmick0",
    description = "Provides an alternative to endround which does not require sv_cheats",
    version = "0.1",
    url = "github.com/tmick0/sm_endround"
};

#define CVAR_BLOCKHOOK "sm_endround_blockhook"
#define CMD_ENDROUND "sm_endround"

// convars
ConVar CvarBlockHook;

// plugin state
bool BlockHook;

public void OnPluginStart() {
    // init config
    AutoExecConfig_SetCreateDirectory(true);
    AutoExecConfig_SetCreateFile(true);
    AutoExecConfig_SetFile("plugin_endround");
    CvarBlockHook = AutoExecConfig_CreateConVar(CVAR_BLOCKHOOK, "0", "allow (0) or disallow (1) the CS_OnTerminateRound callback");
    AutoExecConfig_ExecuteFile();
    AutoExecConfig_CleanFile();

    // init hooks
    HookConVarChange(CvarBlockHook, CvarsUpdated);
    RegAdminCmd(CMD_ENDROUND, CmdEndRound, ADMFLAG_GENERIC, "ends the current round with a draw");

    // initialize configuration
    SetCvars();
}

void CvarsUpdated(ConVar convar, const char[] oldvalue, const char[] newvalue) {
    SetCvars();
}

void SetCvars() {
    BlockHook = GetConVarInt(CvarBlockHook) != 0;
}

Action CmdEndRound(int client, int argc) {
    CS_TerminateRound(0, CSRoundEnd_Draw, BlockHook);
}

/** Disclaimer, majority of the code here is re-used code from Vee's BeTheMerc and Grenade plugin. Credits to her for providing a huge base for this rewritten version. **/
/** And rewritten by TheBluekr (again) **/

#include <sourcemod>
#include <betheclass>
#include <tf2attributes>
#include <tf2>
#include <tf2_stocks>
#include <sdktools>

#define Throw_Sound 				"weapons/grenade_throw.wav"
#define Prime_Sound					"misc/timer.mp3"
#define NoThrow_Sound				"common/wpn_denyselect.wav"
#define Recharge_Sound				"player/recharged.wav"

#define Merc_Model					"models/player/merc_deathmatch2-fix.mdl" // V2 with grenade animation
#define Grenade_Model				"models/custom/ivory/enh_grenade/grenade.mdl"

#define Grenade_Trail_Red			"stunballtrail_red_crit"
#define Grenade_Trail_Blu			"stunballtrail_blue_crit"

#define Soldier_Model				"models/player/soldier.mdl"

public Plugin myinfo = {
	name = "BTC Mercenary subplugin",
	author = "TheBluekr",
	description = "Addon for Be The Class Hub",
	version = "0.1",
	url = "https://github.com/TheBluekr/TF2-betheclass"
};

enum /* CvarName */ {
	MercenaryLimit,
	MercenaryGrenade,
	MercenaryGrenadeRegen,
	MercenaryGrenadeInterval,
	MaxBTCMercConVars
};

enum /** HUDs **/ {
	GrenadeHUD,
	MaxBTCMercHUDs
};

Handle /** Handles **/
	g_hSDKPlaySpecificSequence,
	g_hSDKGetMaxAmmo;

enum struct BTCGlobals_Mercenary {
	Handle m_hHUDs[MaxBTCMercHUDs];
	ConVar m_hCvars[MaxBTCMercConVars];
}

BTCGlobals_Mercenary g_btc_mercenary;

public void OnPluginStart() {
	g_btc_mercenary.m_hCvars[MercenaryLimit] = CreateConVar("btc_mercenary_limit", "3", "Limit for amount of mercenaries", FCVAR_NOTIFY, true, 0.0, false, 0.0);
	g_btc_mercenary.m_hCvars[MercenaryGrenade] = CreateConVar("btc_mercenary_grenade", "2", "Grenade stock limit for mercenaries", FCVAR_NOTIFY, true, 0.0, false, 0.0);
	g_btc_mercenary.m_hCvars[MercenaryGrenadeRegen] = CreateConVar("btc_mercenary_grenade_regen", "60.0", "Regen interval for grenades for mercenaries", FCVAR_NOTIFY, true, 0.0, false, 0.0);
	g_btc_mercenary.m_hCvars[MercenaryGrenadeInterval] = CreateConVar("btc_mercenary_grenade_interval", "2.5", "Time between the throwing of grenades for mercenaries", FCVAR_NOTIFY, true, 0.0, false, 0.0);

	//for( int i; i<MaxBTCMercHUDs; i++ )
		//g_btc_mercenary.m_hHUDs[i] = CreateHudSynchronizer();
	g_btc_mercenary.m_hHUDs[GrenadeHUD] = CreateHudSynchronizer();

	HookEvent("item_pickup", OnItemPickUp, EventHookMode_Pre);
}

public void OnAllPluginsLoaded()
{
	// Taking the SDK calls from STT, thanks for linking me this Ivory -Blue
	Handle hGamedata = LoadGameConfigFile("betheclass");
	if(hGamedata == INVALID_HANDLE) {
		LogMessage("Failed to load gamedata: betheclass.txt!");
		return;
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGamedata, SDKConf_Signature, "CTFPlayer::GetMaxAmmo");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	g_hSDKGetMaxAmmo = EndPrepSDKCall();
	if(g_hSDKGetMaxAmmo == INVALID_HANDLE) {
		LogMessage("Failed to create call: CTFPlayer::GetMaxAmmo!");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGamedata, SDKConf_Signature, "CTFPlayer::PlaySpecificSequence");
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	g_hSDKPlaySpecificSequence = EndPrepSDKCall();
	if(g_hSDKPlaySpecificSequence == INVALID_HANDLE) {
		LogMessage("Failed to create call: CTFPlayer::PlaySpecificSequence!");
	}
	CloseHandle(hGamedata);
}

methodmap CMercenary < BTCBaseClass
{
	public CMercenary(const int ind, bool uid=false)
	{
		return view_as<CMercenary>( BTCBaseClass(ind, uid) );
	}
	property int iGrenadeStock
	{
		public get()
		{
			return this.GetPropInt("iGrenadeStock");
		}
		public set(const int val)
		{
			this.SetPropInt("iGrenadeStock", val);
		}
	}
	property float fGrenadeCooldown
	{
		public get()
		{
			return this.GetPropFloat("fGrenadeCooldown");
		}
		public set(const float val)
		{
			this.SetPropFloat("fGrenadeCooldown", val);
		}
	}
	property float fGrenadeThrowCooldown
	{
		public get()
		{
			return this.GetPropFloat("fGrenadeThrowCooldown");
		}
		public set(const float val)
		{
			this.SetPropFloat("fGrenadeThrowCooldown", val);
		}
	}
	public void UpdateHUD(Handle hHUD, const char[] text, float x, float y, float holdTime, int r, int g, int b, int a, int effect, float fxTime, float fadeIn, float fadeOut)
	{
		SetHudTextParams(x, y, holdTime, r, g, b, a, effect, fxTime, fadeIn, fadeOut);
		ShowSyncHudText(this.index, hHUD, text);
	}
	public void OnSpawn()
	{
		TF2Attrib_RemoveAll(this.index);
		TF2_SetPlayerClass(this.index, TFClass_Soldier, _, false);
		SetBaseSpeed(this.index, 300.0);
		TF2Attrib_SetByName(this.index, "max health additive penalty", -50.0);
		SetEntityHealth(this.index, GetEntProp(this.index, Prop_Data, "m_iMaxHealth"));

		this.RemoveAllItems(true);

		// Grenades
		this.iGrenadeStock = g_btc_mercenary.m_hCvars[MercenaryGrenade].IntValue;
		this.fGrenadeThrowCooldown = 0.0;
		this.fGrenadeCooldown = 0.0;

		SetVariantString(Merc_Model);
		AcceptEntityInput(this.index, "SetCustomModel");
		SetEntProp(this.index, Prop_Send, "m_bUseClassAnimations", 1);
		this.SpawnWeapon("tf_weapon_scattergun", 1153, 1, 0, "2030 ; 1 ; 808 ; 0 ; 1 ; 1 ; 6 ; 0.75 ; 106 ; 0.75 ; 547 ; 1");
		this.SpawnWeapon("tf_weapon_smg", 1098, 1, 0, "306 ; 0 ; 647 ; 0 ; 392 ; 0.5 ; 4 ; 1.2 ; 2 ; 1.5 ; 106 ; 0.5 ; 96 ; 3.0 ; 144 ; 1 ; 51 ; 0 ; 78 ; 6.25");
		this.SpawnWeapon("tf_weapon_shovel", 30758, 1, 0, "2030 ; 1 ; 149 ; 3 ; 851 ; 1.15 ; 1 ; 0.9 ; 851 ; 1,4375‬");
		this.SpawnWeapon("tf_weapon_grapplinghook", 1152, 1, 0, "547 ; 1 ; 199 ; 1 ; 289 ; 1");
		//this.SpawnWeapon(merc.index, "tf_weapon_spellbook", 1132, 1, 0, "547 ; 0 ; 199 ; 0 ; 289 ; 1 ; 643 ; 0.125 ; 280 ; 2");
		SetAmmo(this.index, TFWeaponSlot_Primary, 20);
		SetAmmo(this.index, TFWeaponSlot_Secondary, 200); /// Bug fix, Merc spawns with 32 ammo on secondary
	}
	public void OnDeath(BTCBaseClass attacker, Event event)
	{
		this.UpdateHUD(g_btc_mercenary.m_hHUDs[GrenadeHUD], "", 0.75, 0.85, 0.5, 255, 255, 255, 255, 2, 0.0, 0.0, 0.0);
	}
	public void OnKill(BTCBaseClass victim, Event event)
	{
		if(event.GetInt("damagebits") == 32) {
			event.SetInt("customkill", TF_CUSTOM_TAUNT_GRENADE);
			event.SetString("weapon_logclassname", "merc_grenade");
		}
	}
	public void OnItemPickUp(char item[64], Event event)
	{
		if(StrEqual(item, "ammopack_small", false)) {
			/// Fix for receiving 31 ammo instead of 32
			int ammo = GetAmmo(this.index, TFWeaponSlot_Secondary);
			int maxAmmo = SDK_GetMaxAmmo(this.index, TFWeaponSlot_Secondary);
			if(ammo < maxAmmo)
				SetAmmo(this.index, TFWeaponSlot_Secondary, ammo+1);
		}
	}
	public void Think()
	{
		if(!IsClientAlive(this.index))
			return;
	
		char GrenadeHUDText[255]; // Display of current amount grenades
		Format(GrenadeHUDText, sizeof(GrenadeHUDText), "Grenades: %i\nCooldown: %.1f", this.iGrenadeStock, this.fGrenadeCooldown);
		this.UpdateHUD(g_btc_mercenary.m_hHUDs[GrenadeHUD], GrenadeHUDText, 0.75, 0.85, 0.5, 255, 255, 255, 255, 2, 0.0, 0.0, 0.0);

		char sModel[128];
		GetEntPropString(this.index, Prop_Data, "m_ModelName", sModel, sizeof(sModel)); // Get the complete Modelname.
		if(StrEqual(sModel, Soldier_Model, false)) { // Bug fix, removing custom models turns the player to default soldier model
			SetVariantString(Merc_Model);
			AcceptEntityInput(this.index, "SetCustomModel");
			SetEntProp(this.index, Prop_Send, "m_bUseClassAnimations", 1);
		}

		this.fGrenadeCooldown -= 0.1;
		if(this.fGrenadeCooldown < 0.0)
			this.fGrenadeCooldown = 0.0;
		this.fGrenadeThrowCooldown -= 0.1;
		if(this.fGrenadeThrowCooldown < 0.0)
			this.fGrenadeThrowCooldown = 0.0;

		if(this.iGrenadeStock < g_btc_mercenary.m_hCvars[MercenaryGrenade].IntValue && this.fGrenadeCooldown <= 0.0) {
			this.iGrenadeStock++;
			if(this.iGrenadeStock < g_btc_mercenary.m_hCvars[MercenaryGrenade].IntValue) /// In case we're still below max
				this.fGrenadeCooldown = g_btc_mercenary.m_hCvars[MercenaryGrenadeRegen].FloatValue;
			EmitSoundToClient(this.index, Recharge_Sound);
		}
		int iWeapon = GetEntPropEnt(this.index, Prop_Send, "m_hActiveWeapon");
		int iGrapplinghook = FindGrapplingHook(this.index);
		if(!iWeapon || !IsValidEdict(iWeapon)) /// Invalid weapon is equipped/active, we should stop here
			return;
		if((GetClientButtons(this.index) & IN_ATTACK2) && this.fGrenadeThrowCooldown <= 0.0)
		{
			RequestFrame(GrenadeThrow, this);
			this.fGrenadeThrowCooldown = g_btc_mercenary.m_hCvars[MercenaryGrenadeInterval].FloatValue;
		}
		if((GetClientButtons(this.index) & IN_ATTACK3) && IsValidEntity(iGrapplinghook) && iWeapon != iGrapplinghook)
		{
			FakeClientCommand(this.index, "use tf_weapon_grapplinghook");
		}
	}
}

public CMercenary ToCMercenary(const BTCBaseClass guy)
{
	return view_as<CMercenary>(guy);
}

int g_iMercID;

public void OnLibraryAdded(const char[] name) {
	if( StrEqual(name, "BeTheClass") ) {
		g_iMercID = BTC_RegisterPlugin("mercenary");
		LoadBTCHooks();
	}
}

public void LoadBTCHooks()
{
	if(!BTC_HookEx(OnCallDownload, Mercenary_OnCallDownloads))
		LogError("Error loading OnCallDownload forwards for Mercenary subplugin.");
	if(!BTC_HookEx(OnClassThink, Mercenary_OnClassThink))
		LogError("Error loading OnClassThink forwards for Mercenary subplugin.");
	if(!BTC_HookEx(OnClassSpawn, Mercenary_OnClassSpawn))
		LogError("Error loading OnClassSpawn forwards for Mercenary subplugin.");
	if(!BTC_HookEx(OnClassDeath, Mercenary_OnClassDeath))
		LogError("Error loading OnClassDeath forwards for Mercenary subplugin.");
	if(!BTC_HookEx(OnClassMenu, Mercenary_OnClassMenu))
		LogError("Error loading OnClassMenu forwards for Mercenary subplugin.");
	if(!BTC_HookEx(OnClassResupply, Mercenary_OnClassResupply))
		LogError("Error loading OnClassResupply forwards for Mercenary subplugin.");
}

stock bool IsMercenary(const BTCBaseClass player) {
	return player.GetPropInt("iClassType") == g_iMercID;
}

public void Mercenary_OnCallDownloads() {
	// Precache particle systems
	PrecacheParticleSystem(Grenade_Trail_Red);
	PrecacheParticleSystem(Grenade_Trail_Blu);
	
	// Precache models
	PrecacheModel(Merc_Model, true);
	PrecacheModel(Grenade_Model, true);
	
	// Precache sounds
	PrecacheSound(Throw_Sound, true);
	PrecacheSound(NoThrow_Sound, true);
	PrecacheSound(Recharge_Sound, true);
	PrecacheSound(Prime_Sound, true);
}

public void Mercenary_OnClassMenu(Menu &menu)
{
	char tostr[10]; IntToString(g_iMercID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "Mercenary");
}

public void Mercenary_OnClassThink(const BTCBaseClass player) {
	if(!IsMercenary(player))
		return;
	ToCMercenary(player).Think();
}

public Action Mercenary_OnClassSpawn(const BTCBaseClass player, Event event) {
	if(player.GetPropInt("iPresetType") != g_iMercID) {
		ToCMercenary(player).UpdateHUD(g_btc_mercenary.m_hHUDs[GrenadeHUD], "", 0.75, 0.85, 0.5, 255, 255, 255, 255, 2, 0.0, 0.0, 0.0);
		return Plugin_Continue;
	}
	player.SetPropInt("iClassType", g_iMercID);
	ToCMercenary(player).OnSpawn();
	return Plugin_Handled;
}

public void Mercenary_OnClassDeath(const BTCBaseClass attacker, const BTCBaseClass victim, Event event) {
	if(IsMercenary(attacker))
		ToCMercenary(attacker).OnKill(victim, event);
	else if (IsMercenary(victim))
		ToCMercenary(victim).OnDeath(attacker, event);
}

public Action Mercenary_OnClassResupply(const BTCBaseClass player, Event event) {
	if(!IsMercenary(player))
		return Plugin_Continue;
	ToCMercenary(player).OnSpawn();
	return Plugin_Handled;
}

public Action OnItemPickUp(Event event, const char[] eventName, bool dontBroadcast)
{
	BTCBaseClass player = BTCBaseClass(GetEventInt(event, "userid"), true);
	if(!IsMercenary(player))
		return Plugin_Continue;
	char item[64];
	GetEventString(event, "item", item, sizeof(item));
	ToCMercenary(player).OnItemPickUp(item, event);
	return Plugin_Continue;
}

stock void GrenadeThrow(CMercenary merc) {
	if(merc.iGrenadeStock <= 0) {
		EmitSoundToClient(merc.index, NoThrow_Sound, merc.index, _, _, _, 1.0);
		merc.fGrenadeThrowCooldown = 0.5;
		return;
	}
	SDK_PlaySpecificSequence(merc.index, "grenade_throw");
	float pos[3], endPos[3], angle[3], vecs[3];
	GetClientEyePosition(merc.index, pos);
	GetClientEyeAngles(merc.index, angle);
	GetAngleVectors(angle, vecs, NULL_VECTOR, NULL_VECTOR);
	Handle trace = TR_TraceRayFilterEx(pos, angle, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);
	if(TR_DidHit(trace))
		TR_GetEndPosition(endPos, trace);
	CloseHandle(trace);
	if(GetVectorDistance(endPos, pos, false) < 45.0) {
		EmitSoundToClient(merc.index, NoThrow_Sound, merc.index, _, _, _, 1.0);
		return;
	}

	pos[0] += vecs[0]*32.0;
	pos[1] += vecs[1]*32.0;
	ScaleVector(vecs, 1000.0); /// Throw speed scale

	int iGrenade;
	switch(merc.Team) {
		case TFTeam_Red:	iGrenade = SpawnGrenade(merc.index, Grenade_Model, Grenade_Trail_Red, false); // Should return -1 if unsuccesful
		case TFTeam_Blue:	iGrenade = SpawnGrenade(merc.index, Grenade_Model, Grenade_Trail_Blu, false);
	}
	if(iGrenade == -1) { /// Invalid spawn
		EmitSoundToClient(merc.index, NoThrow_Sound, merc.index, _, _, _, 1.0);
		return;
	}
	DispatchSpawn(iGrenade);
	SetEntProp(iGrenade, Prop_Data, "m_takedamage", 0);
	TeleportEntity(iGrenade, pos, NULL_VECTOR, vecs);
	EmitSoundToClient(merc.index, Prime_Sound, iGrenade, _, _, _, 1.0);
	SetPawnTimer(GrenadeExplode, 3.8, EntIndexToEntRef(iGrenade));
	if(merc.fGrenadeCooldown <= 0.0 && merc.iGrenadeStock == g_btc_mercenary.m_hCvars[MercenaryGrenade].IntValue) /// Assuming we were on the maximum grenades there should be no cooldown (yet)
		merc.fGrenadeCooldown = g_btc_mercenary.m_hCvars[MercenaryGrenadeRegen].FloatValue;
	merc.iGrenadeStock--;
}

stock void GrenadeExplode(int iRef)
{
	int iGrenade = EntRefToEntIndex(iRef);
	if(!IsValidEntity(iGrenade))
		return;
	int client = GetEntPropEnt(iGrenade, Prop_Data, "m_hOwnerEntity");
	if(!IsValidClient(client)) {
		AcceptEntityInput(iGrenade, "Kill");
		return;
	}
	if (GetMaxEntities() - GetEntityCount() < 200)
	{
		ThrowError("[BeTheClass] Cannot spawn initial explosion, too many entities exist. Try reloading the map.");
		AcceptEntityInput(iGrenade, "Kill");
		return;
	}
	
	float pos[3];
	GetEntPropVector(iGrenade, Prop_Data, "m_vecOrigin", pos);
	pos[2] += 32.0;
	int team = GetClientTeam(client);
	AcceptEntityInput(iGrenade, "Kill");
	if(team == view_as<int>(TFTeam_Spectator) && !IsClientAlive(client))
		return;
	if(BTCBaseClass(client).iClassType != g_iMercID)
		return;
	
	int explosion = CreateEntityByName("env_explosion");
	if(explosion != -1)
	{
		DispatchKeyValue(explosion, "iMagnitude", "450");
		DispatchKeyValue(explosion, "iRadiusOverride", "200");
		DispatchKeyValue(explosion, "spawnflags", "0");
		DispatchKeyValue(explosion, "rendermode", "5");
		SetEntProp(explosion, Prop_Send, "m_iTeamNum", team);
		SetEntPropEnt(explosion, Prop_Data, "m_hOwnerEntity", client);
		//SetEntProp(explosion, Prop_Send, "m_bCritical", (GetURandomFloatRange(0.0, 100.0) <= 2.0) ? 1 : 0, 1)
		DispatchSpawn(explosion);
		ActivateEntity(explosion);
		TeleportEntity(explosion, pos, NULL_VECTOR, NULL_VECTOR);				
		AcceptEntityInput(explosion, "Explode");
		RequestFrame(EntityCleanup, EntIndexToEntRef(explosion));
	}
	else
		ThrowError("[BeTheClass] Failed to spawn grenade explosion");
}

public bool TraceEntityFilterPlayer(int entity, int contentsMask)
{
	return entity > MaxClients || !entity;
}

/// Setup SDK calls
void SDK_PlaySpecificSequence(int client, const char[] strSequence)
{
	if(g_hSDKPlaySpecificSequence != INVALID_HANDLE)
	{
		SDKCall(g_hSDKPlaySpecificSequence, client, strSequence);
	}
}

int SDK_GetMaxAmmo(int client, int iSlot)
{
	int iWeapon = GetPlayerWeaponSlot(client, iSlot);
	int iAmmoType = GetEntProp(iWeapon, Prop_Send, "m_iPrimaryAmmoType");
	if(g_hSDKGetMaxAmmo != INVALID_HANDLE && iAmmoType > -1)
		return SDKCall(g_hSDKGetMaxAmmo, client, iAmmoType, -1);
	
	return -1;
}

/// Stocks
stock bool IsValidClient(int clientIdx, bool isPlayerAlive=false)
{
	if (clientIdx <= 0 || clientIdx > MaxClients) return false;
	if(isPlayerAlive) return IsClientInGame(clientIdx) && IsPlayerAlive(clientIdx);
	return IsClientInGame(clientIdx);
}

stock bool IsClientAlive(int client)
{
	if (client > 0 && IsValidClient(client) && IsClientConnected(client) && !IsFakeClient(client) && IsClientInGame(client) && IsPlayerAlive(client))
		return true;
	return false;
}

stock void SetPawnTimer(Function func, float thinktime = 0.1, any param1 = -999, any param2 = -999)
{
	DataPack thinkpack = new DataPack();
	thinkpack.WriteFunction(func);
	thinkpack.WriteCell(param1);
	thinkpack.WriteCell(param2);

	CreateTimer(thinktime, DoThink, thinkpack, TIMER_DATA_HNDL_CLOSE);
}

public Action DoThink(Handle hTimer, DataPack hndl)
{
	hndl.Reset();

	Function pFunc = hndl.ReadFunction();
	Call_StartFunction( null, pFunc );

	any param1 = hndl.ReadCell();
	if ( param1 != -999 )
		Call_PushCell(param1);

	any param2 = hndl.ReadCell();
	if ( param2 != -999 )
		Call_PushCell(param2);

	Call_Finish();
	return Plugin_Continue;
}

stock int SpawnGrenade(int client, char[] model, char[] trail, bool GFE) // GFE (leaked TF2C grenade properties)
{
	// Make sure we don't crash the map with entities
	if (GetMaxEntities() - GetEntityCount() < 200)
	{
		ThrowError("Cannot create Grenade, too many entities exist. Try reloading the map.");
		return -1;
	}
	int entity = CreateEntityByName("prop_physics_override");
	if(IsValidEntity(entity))
	{
		DispatchKeyValue(entity, "model", model);
		DispatchKeyValue(entity, "solid", "6");
		if(GFE)
		{
			SetEntityGravity(entity, 0.5); // Gravity, copied over from leaked source code
			SetEntPropFloat(entity, Prop_Data, "m_flFriction", 0.8); // Friction, copied over from leaked source code
			SetEntPropFloat(entity, Prop_Send, "m_flElasticity", 0.45); // Elasticity, copied over from leaked source code
		}
		SetEntProp(entity, Prop_Data, "m_CollisionGroup", 1);
		SetEntProp(entity, Prop_Data, "m_usSolidFlags", 0x18);
		SetEntProp(entity, Prop_Data, "m_nSolidType", 6);
		switch(TF2_GetClientTeam(client))
		{
			case TFTeam_Red:	DispatchKeyValue(entity, "skin", "0");
			case TFTeam_Blue:	DispatchKeyValue(entity, "skin", "1");
		}
		DispatchKeyValue(entity, "renderfx", "0");
		DispatchKeyValue(entity, "rendercolor", "255 255 255");
		DispatchKeyValue(entity, "renderamt", "255");					
		SetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity", client);
		SpawnParticle(trail, _, _, entity, _, _, _, _);
		return entity;
	}
	return -1;
}

stock void EntityCleanup(int iRef) {
	int iEntity = EntRefToEntIndex(iRef);
	if(IsValidEntity(iEntity)) {
		AcceptEntityInput(iEntity, "Kill");
	}
}

stock int SpawnParticle(const char[] particleName, float durationTime = 0.0, bool startSpawn = true, int attachEnt = 0, const char[] attachBone = "", float effectPos[3] = NULL_VECTOR, float effectAng[3] = NULL_VECTOR, float effectVel[3] = NULL_VECTOR)
{
	int particle = CreateEntityByName("info_particle_system");
	if(IsValidEdict(particle))
	{
		float pos[3], ang[3];

		if(StrEqual(attachBone, ""))
		{
			GetEntPropVector(attachEnt, Prop_Send, "m_vecOrigin", pos);
			AddVectors(pos, effectPos, pos);
			GetEntPropVector(attachEnt, Prop_Send, "m_angRotation", ang);
			AddVectors(ang, effectAng, ang);
			TeleportEntity(particle, pos, ang, effectVel);
		}

		char tName[32];
		GetEntPropString(attachEnt, Prop_Data, "m_iName", tName, sizeof(tName));
		DispatchKeyValue(particle, "targetname", "tf2particle");
		DispatchKeyValue(particle, "parentname", tName);
		DispatchKeyValue(particle, "effect_name", particleName);
		DispatchSpawn(particle);

		if (attachEnt != 0)
		{
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", attachEnt, particle, 0);
			
			if (!StrEqual(attachBone, ""))
			{
				SetVariantString(attachBone);
				AcceptEntityInput(particle, "SetParentAttachment", attachEnt, particle, 0);
				TeleportEntity(particle, effectPos, effectAng, effectVel);
			}
		}
		ActivateEntity(particle);
		
		if (startSpawn)
		{
			AcceptEntityInput(particle, "start");
		}
		
		if (durationTime > 0.0)
		{
			SetPawnTimer(RemoveParticle, durationTime, particle);
		}
		
		return particle;
	}
	return -1;
}

public void RemoveParticle(any particle)
{
	if (IsValidEntity(particle))
	{
		char classname[32];
		GetEdictClassname(particle, classname, sizeof(classname));
		if(StrEqual(classname, "info_particle_system", false))
		{
			AcceptEntityInput(particle, "stop");
			AcceptEntityInput(particle, "Kill");
		}
	}
}

stock void PrecacheParticleSystem(const char[] p_strEffectName)
{
	static s_numStringTable = INVALID_STRING_TABLE;
	if (s_numStringTable == INVALID_STRING_TABLE)
	{
		s_numStringTable = FindStringTable("ParticleEffectNames");
	}
	AddToStringTable(s_numStringTable, p_strEffectName);
}

stock void SetAmmo(const int client, const int slot, const int ammo)
{
	int weapon = GetPlayerWeaponSlot(client, slot);
	if (IsValidEntity(weapon)) {
		int iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		int iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		SetEntData(client, iAmmoTable+iOffset, ammo, 4, true);
	}
}

stock int GetAmmo(const int client, const int slot)
{
	if (!IsValidClient(client))
		return 0;
	int weapon = GetPlayerWeaponSlot(client, slot);
	if (IsValidEntity(weapon)) {
		int iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		int iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		return GetEntData(client, iAmmoTable+iOffset);
	}
	return 0;
}

stock int FindGrapplingHook(int iClient)
{
	int grapplinghook = -1;
	while ((grapplinghook = FindEntityByClassname(grapplinghook, "tf_weapon_grapplinghook")) != -1)
	{
		if (IsValidEntity(grapplinghook) && GetEntPropEnt(grapplinghook, Prop_Send, "m_hOwnerEntity") == iClient)
			if(!GetEntProp(grapplinghook, Prop_Send, "m_bDisguiseWeapon"))
				return grapplinghook;
	}
	return -1;
}

stock void SetBaseSpeed(int iClient, float fSpeed)
{
	if (!IsValidClient(iClient))
		return;
	float fBaseSpeed;
	switch(TF2_GetPlayerClass(iClient)) {
		case TFClass_Scout:
			fBaseSpeed = 400.0;
		case TFClass_Sniper:
			fBaseSpeed = 300.0;
		case TFClass_Soldier:
			fBaseSpeed = 240.0;
		case TFClass_DemoMan:
			fBaseSpeed = 280.0;
		case TFClass_Medic:
			fBaseSpeed = 320.0;
		case TFClass_Heavy:
			fBaseSpeed = 230.0;
		case TFClass_Pyro:
			fBaseSpeed = 300.0;
		case TFClass_Spy:
			fBaseSpeed = 300.0;
		case TFClass_Engineer:
			fBaseSpeed = 300.0;
		case TFClass_Unknown:
			fBaseSpeed = 250.0;
		default:
			return;
	}
	float attribSpeed = fSpeed/fBaseSpeed; // Calc percentage
	if (attribSpeed >= 1.0)
		TF2Attrib_SetByDefIndex(iClient, 107, attribSpeed);
	else
		TF2Attrib_SetByDefIndex(iClient, 54, attribSpeed);
}
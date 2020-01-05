// Define sounds
#define SOUND_RECHARGE			"misc/halloween/spelltick_set.wav"
#define SOUND_SPELL_RARE		"vo/merasmus/rare_spell.wav"

// Define models
#define Wizard_Model			"models/ivory/wizards/fix/v2/merasmus.mdl"

methodmap CWizard < BaseClass
{
	public CWizard(const int ind, bool uid=false)
	{
		return view_as<CWizard>( BaseClass(ind, uid) );
	}
	property float fMana
	{
		public get()
		{
			float i; hPlayerFields[this.index].GetValue("fMana", i);
			return i;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fMana", val);
		}
	}
	property float fCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fCooldown", val);
		}
	}
	property float fAntiSpamCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fAntiSpamCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fAntiSpamCooldown", val);
		}
	}
	property float fFireCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fFireCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fFireCooldown", val);
		}
	}
	property int iFireCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iFireCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iFireCharges", val);
		}
	}
	property float fBatsCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fBatsCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fBatsCooldown", val);
		}
	}
	property int iBatsCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iBatsCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iBatsCharges", val);
		}
	}
	property float fUberCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fUberCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fUberCooldown", val);
		}
	}
	property int iUberCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iUberCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iUberCharges", val);
		}
	}
	property float fJumpCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fJumpCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fJumpCooldown", val);
		}
	}
	property int iJumpCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iJumpCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iJumpCharges", val);
		}
	}
	property float fInvisCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fInvisCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fInvisCooldown", val);
		}
	}
	property int iInvisCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iInvisCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iInvisCharges", val);
		}
	}
	property float fMeteorCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fMeteorCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fMeteorCooldown", val);
		}
	}
	property int iMeteorCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iMeteorCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iMeteorCharges", val);
		}
	}
	property float fMonoCooldown
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fMonoCooldown", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fMonoCooldown", val);
		}
	}
	property int iMonoCharges
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iMonoCharges", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iMonoCharges", val);
		}
	}
	property int iSelectedSpell
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iSelectedSpell", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iSelectedSpell", val);
		}
	}
	property int iSpelltype
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iSpelltype", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iSpelltype", val);
		}
	}
	property int iCastSound
	{
		public get()
		{
			int i; hPlayerFields[this.index].GetValue("iCastSound", i);
			return i;
		}
		public set(const int val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("iCastSound", val);
		}
	}
	property float fInvisBonus
	{
		public get()
		{
			float f; hPlayerFields[this.index].GetValue("fInvisBonus", f);
			return f;
		}
		public set(const float val)
		{
			int player = this.index;
			if( !player )
				return;
			hPlayerFields[player].SetValue("fInvisBonus", val);
		}
	}

	public void Init()
	{
		this.fMana = 0.0;
		this.fCooldown = 0.0;
		this.fAntiSpamCooldown = 0.0;
		this.fFireCooldown = 0.0;
		this.fBatsCooldown = 0.0;
		this.fUberCooldown = 0.0;
		this.fJumpCooldown = 0.0;
		this.fInvisCooldown = 0.0;
		this.fMeteorCooldown = 0.0;
		this.fMonoCooldown = 0.0;
		//SpellCharges
		this.iFireCharges = 0; //Fire
		this.iBatsCharges = 0; //Bats
		this.iUberCharges = 0; //Uber
		this.iJumpCharges = 0; //Jump
		this.iInvisCharges = 0; //Invis
		this.iMeteorCharges = 0; //Meteor
		this.iMonoCharges = 0; //Mono
		//Others
		this.iSelectedSpell = 1;
		this.iCastSound = 0;
		this.iSpelltype = 0;
		this.fInvisBonus = 0.0;
	}

	public void OnSpawn()
	{
		SetPawnTimer(SetupWizard, 0.25, this);
	}

	public void OnDeath(BaseClass attacker, BaseClass victim, Event event) {
		float victimpos[3];
		if (IsClientHere(attacker.index))
		{
			if(IsPlayerAlive(attacker.index) && victim.index != attacker.index && IsClientHere(victim.index))
			{
				GetClientAbsOrigin(victim.index, victimpos);
				char killSound[35];
				Format(killSound, sizeof(killSound), "vo/halloween_merasmus/sf12_combat_idle0%i.mp3", GetRandomInt(1, 2));
				EmitSoundToAll(killSound, attacker.index, _, _, _, 0.5, _, _, victimpos, _, false);
				// Begin cleaning the HUD handles
				SetHudTextParams(0.0, -1.0, 0.5, 0, 255, 0, 255, 2, 0.0, 0.0, 0.0);
				ShowSyncHudText(victim.index, SpellHUD, "");
				ShowSyncHudText(victim.index, CoolHUD, "");
			}
		}
	}

	public void OnKill(BaseClass attacker, BaseClass victim, Event event)
	{
	}

	public void OnVoiceMenu(const char[] szCmd1, const char[] szCmd2)
	{
		if(szCmd1[0] == '0' && szCmd2[0] == '0' && this.fAntiSpamCooldown <= GetEngineTime()) // Medic call
		{
			if(this.iSelectedSpell <= 1)
				this.iSelectedSpell = 7;
			else
				this.iSelectedSpell--;
			RequestFrame(ResetSpellCharges, this.index);
		}
	}

	public void Think()
	{
		this.UpdateHUD();
		
		char sModel[128];
		GetEntPropString(this.index, Prop_Data, "m_ModelName", sModel, sizeof(sModel)); // Get the complete Modelname.
		if(StrEqual(sModel, Sniper_Model, false)) { // Bug fix, removing quads turns the player to default sniper model
			SetVariantString(Wizard_Model);
			AcceptEntityInput(this.index, "SetCustomModel");
			SetEntProp(this.index, Prop_Send, "m_bUseClassAnimations", 1);
		}

		if(this.fMana < cvarBTC[WizardMana].FloatValue) // This should reflect the scale a bit better
		{
			this.fMana += cvarBTC[WizardManaRegen].FloatValue * GetTickInterval();
		}
		if(this.fMana > cvarBTC[WizardMana].FloatValue)
			this.fMana = cvarBTC[WizardMana].FloatValue;

		if(this.fFireCooldown <= GetEngineTime() && this.iFireCharges < cvarBTC[WizardFireCharges].IntValue)
		{
			this.iFireCharges++;
			if(this.iFireCharges < cvarBTC[WizardFireCharges].IntValue && cvarBTC[WizardFireCharges].IntValue > 1)
			{
			    this.fFireCooldown = GetEngineTime() + cvarBTC[WizardFireCooldown].FloatValue;
			}
		}
		if(this.fBatsCooldown <= GetEngineTime() && this.iBatsCharges < cvarBTC[WizardBatsCharges].IntValue)
		{
			this.iBatsCharges++;
			if(this.iBatsCharges < cvarBTC[WizardBatsCharges].IntValue && cvarBTC[WizardBatsCharges].IntValue > 1)
			{
			    this.fBatsCooldown = GetEngineTime() + cvarBTC[WizardBatsCooldown].FloatValue;
			}
		}
		if(this.fUberCooldown <= GetEngineTime() && this.iUberCharges < cvarBTC[WizardUberCharges].IntValue)
		{
			this.iUberCharges++;
			if(this.iUberCharges < cvarBTC[WizardUberCharges].IntValue && cvarBTC[WizardUberCharges].IntValue > 1)
			{
			    this.fUberCooldown = GetEngineTime() + cvarBTC[WizardUberCooldown].FloatValue;
			}
		}
		if(this.fJumpCooldown <= GetEngineTime() && this.iJumpCharges < cvarBTC[WizardJumpCharges].IntValue)
		{
			this.iJumpCharges++;
			if(this.iJumpCharges < cvarBTC[WizardJumpCharges].IntValue && cvarBTC[WizardJumpCharges].IntValue > 1)
			{
			    this.fJumpCooldown = GetEngineTime() + cvarBTC[WizardJumpCooldown].FloatValue;
			}
		}
		if(this.fInvisCooldown <= GetEngineTime() && this.iInvisCharges < cvarBTC[WizardInvisCharges].IntValue)
		{
			this.iInvisCharges++;
			if(this.iInvisCharges < cvarBTC[WizardInvisCharges].IntValue && cvarBTC[WizardInvisCharges].IntValue > 1)
			{
			    this.fInvisCooldown = GetEngineTime() + cvarBTC[WizardInvisCooldown].FloatValue;
			}
		}
		if(this.fMeteorCooldown <= GetEngineTime() && this.iMeteorCharges < cvarBTC[WizardMeteorCharges].IntValue)
		{
			this.iMeteorCharges++;
			if(this.iMeteorCharges < cvarBTC[WizardMeteorCharges].IntValue && cvarBTC[WizardMeteorCharges].IntValue > 1)
			{
			    this.fMeteorCooldown = GetEngineTime() + cvarBTC[WizardMeteorCooldown].FloatValue;
			}
		}
		if(this.fMonoCooldown <= GetEngineTime() && this.iMonoCharges < cvarBTC[WizardMonoCharges].IntValue)
		{
			this.iMonoCharges++;
			if(this.iMonoCharges < cvarBTC[WizardMonoCharges].IntValue && cvarBTC[WizardMonoCharges].IntValue > 1)
			{
				this.fMonoCooldown = GetEngineTime() + cvarBTC[WizardMonoCooldown].FloatValue;
			}
		}

		int iSpellbook = FindSpellBook(this.index);

		if((GetClientButtons(this.index) & IN_RELOAD) && this.fAntiSpamCooldown <= GetEngineTime())
		{
			if(this.iSelectedSpell >= 7) // Increase this if we add more
			{
				this.iSelectedSpell = 1;
			}
			else
			{
				this.iSelectedSpell++;
			}
			RequestFrame(ResetSpellCharges, this.index);
			this.fAntiSpamCooldown = GetEngineTime() + 0.3;
		}

		SetEntProp(iSpellbook, Prop_Send, "m_iSelectedSpellIndex", this.iSpelltype); // No need to call it 7 times if we can just set it here

		if((GetClientButtons(this.index) & IN_ATTACK2) && this.IsReady() && !TF2_IsPlayerInCondition(this.index, view_as<TFCond>(50)) && this.fCooldown < GetEngineTime()) { // Cast mechanic
			if(this.iSpelltype == 0 && this.iFireCharges > 0 && this.fMana >= cvarBTC[WizardFireCost].FloatValue) { // Fire spell
				this.fFireCooldown = GetEngineTime() + cvarBTC[WizardFireCooldown].FloatValue;
				this.iFireCharges--;
				this.fMana -= cvarBTC[WizardFireCost].FloatValue;
			}
			else if(this.iSpelltype == 1 && this.iBatsCharges > 0 && this.fMana >= cvarBTC[WizardBatsCost].FloatValue) { // Bats
				this.fBatsCooldown = GetEngineTime() + cvarBTC[WizardBatsCooldown].FloatValue;
				this.iBatsCharges--;
				this.fMana -= cvarBTC[WizardBatsCost].FloatValue;
			}
			else if(this.iSpelltype == 2 && this.iUberCharges > 0 && this.fMana >= cvarBTC[WizardUberCost].FloatValue) { // Uber
				this.fUberCooldown = GetEngineTime() + cvarBTC[WizardUberCooldown].FloatValue;
				this.iUberCharges--;
				this.fMana -= cvarBTC[WizardUberCost].FloatValue;
			}
			else if(this.iSpelltype == 4 && this.iJumpCharges > 0 && this.fMana >= cvarBTC[WizardJumpCost].FloatValue) { // Jump spell
				this.fJumpCooldown = GetEngineTime() + cvarBTC[WizardJumpCooldown].FloatValue;
				this.iJumpCharges--;
				this.fMana -= cvarBTC[WizardJumpCost].FloatValue;
			}
			else if(this.iSpelltype == 5 && this.iInvisCharges > 0 && this.fMana >= cvarBTC[WizardInvisCost].FloatValue) { // Invis
				this.fInvisCooldown = GetEngineTime() + cvarBTC[WizardInvisCooldown].FloatValue;
				this.iInvisCharges--;
				this.fMana -= cvarBTC[WizardInvisCost].FloatValue;
			}
			else if(this.iSpelltype == 9 && this.iMeteorCharges > 0 && this.fMana >= cvarBTC[WizardMeteorCost].FloatValue) { // Meteor Spell
				this.fMeteorCooldown = GetEngineTime() + cvarBTC[WizardMeteorCooldown].FloatValue;
				this.iMeteorCharges--;
				this.fMana -= cvarBTC[WizardMeteorCost].FloatValue;
			}
			else if(this.iSpelltype == 10 && this.iMonoCharges > 0 && this.fMana >= cvarBTC[WizardMonoCost].FloatValue) { // Monoculus
				this.fMonoCooldown = GetEngineTime() + cvarBTC[WizardMonoCooldown].FloatValue;
				this.iMonoCharges--;
				this.fMana -= cvarBTC[WizardMonoCost].FloatValue;
			}
			else {
				return;
			}

			char MedSound[35];
			float fWizardPos[3];

			switch(this.iCastSound) {
				case 0: //Fire spell cast sound
					Format(MedSound, sizeof(MedSound), "vo/merasmus/spell_cast_fire%i.mp3", GetRandomInt(1, 4));
				case 1: //Common spell cast sound
					Format(MedSound, sizeof(MedSound), "vo/merasmus/spell_cast%i.mp3", GetRandomInt(1, 7));
				case 9: //Rare spell cast sound
					Format(MedSound, sizeof(MedSound), "vo/merasmus/spell_cast_rare%i.mp3", GetRandomInt(1, 2));
				default:
					return;
			}
			SetEntProp(iSpellbook, Prop_Send, "m_iSpellCharges", 1);
			GetClientAbsOrigin(this.index, fWizardPos);
			EmitSoundToAll(MedSound, this.index, _, _, _, 0.5, _, _, fWizardPos, _, false);
			FakeClientCommand(this.index, "use tf_weapon_spellbook");
			this.fCooldown = GetEngineTime() + 2.5; // 2.5s before next cast
			SetPawnTimer(ResetSpellCharges, 0.5, this.index);
		}
	}
	public void UpdateHUD()
	{
		SetHudTextParams(-1.0, 0.75, 0.5, 255, 255, 255, 255, 2, 0.0, 0.0, 0.0);
		if(TF2_IsPlayerInCondition(this.index, view_as<TFCond>(50))) { // Sapped
			ShowSyncHudText(this.index, StatusHUD, "Your magic is being jammed! Run Away!");
		}
		else
			ShowSyncHudText(this.index, StatusHUD, "");
		
		char SpellHUDText[255]; // Display of current selected spell
		char CoolHUDText[255];

		float fireCooldown = this.fFireCooldown - GetEngineTime();
		if(fireCooldown < 0.0)
			fireCooldown = 0.0;
		float batsCooldown = this.fBatsCooldown - GetEngineTime();
		if(batsCooldown < 0.0)
			batsCooldown = 0.0;
		float uberCooldown = this.fUberCooldown - GetEngineTime();
		if(uberCooldown < 0.0)
			uberCooldown = 0.0;
		float jumpCooldown = this.fJumpCooldown - GetEngineTime();
		if(jumpCooldown < 0.0)
			jumpCooldown = 0.0;
		float invisCooldown = this.fInvisCooldown - GetEngineTime();
		if(invisCooldown < 0.0)
			invisCooldown = 0.0;
		float meteorCooldown = this.fMeteorCooldown - GetEngineTime();
		if(meteorCooldown < 0.0)
			meteorCooldown = 0.0;
		float monoCooldown = this.fMonoCooldown - GetEngineTime();
		if(monoCooldown < 0.0)
			monoCooldown = 0.0;

		Format(CoolHUDText, sizeof(CoolHUDText), "              (%i) %i\n              (%i) %i\n              (%i) %i\n              (%i) %i\n              (%i) %i\n              (%i) %i\n              (%i) %i\n", this.iFireCharges, RoundToZero(fireCooldown), this.iBatsCharges, RoundToZero(batsCooldown), this.iUberCharges, RoundToZero(uberCooldown), this.iJumpCharges, RoundToZero(jumpCooldown), this.iInvisCharges, RoundToZero(invisCooldown), this.iMeteorCharges, RoundToZero(meteorCooldown), this.iMonoCharges, RoundToZero(monoCooldown));
		switch(this.iSelectedSpell) {
			case 1: {
				Format(SpellHUDText, sizeof(SpellHUDText), ">Fire\n Bats\n Uber\n Jump\n Invis\n Meteor\n Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 0;
				this.iCastSound = 0;
			}
			case 2: {
				Format(SpellHUDText, sizeof(SpellHUDText), " Fire\n>Bats\n Uber\n Jump\n Invis\n Meteor\n Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 1;
				this.iCastSound = 1;
			}
			case 3: {
				Format(SpellHUDText, sizeof(SpellHUDText), " Fire\n Bats\n>Uber\n Jump\n Invis\n Meteor\n Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 2;
				this.iCastSound = 1;
			}
			case 4: {
				Format(SpellHUDText, sizeof(SpellHUDText), " Fire\n Bats\n Uber\n>Jump\n Invis\n Meteor\n Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 4;
				this.iCastSound = 1;
			}
			case 5: {
				Format(SpellHUDText, sizeof(SpellHUDText), " Fire\n Bats\n Uber\n Jump\n>Invis\n Meteor\n Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 5;
				this.iCastSound = 1;
			}
			case 6: {
				Format(SpellHUDText, sizeof(SpellHUDText), " Fire\n Bats\n Uber\n Jump\n Invis\n>Meteor\n Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 9;
				this.iCastSound = 9;
			}
			case 7: {
				Format(SpellHUDText, sizeof(SpellHUDText), " Fire\n Bats\n Uber\n Jump\n Invis\n Meteor\n>Mono\n Mana: %i", RoundToZero(this.fMana));
				this.iSpelltype = 10;
				this.iCastSound = 9;
			}
		}
		SetHudTextParams(0.0, -1.0, 0.5, 0, 255, 0, 255, 2, 0.0, 0.0, 0.0);

		if(IsClientAlive(this.index))
		{
			ShowSyncHudText(this.index, SpellHUD, SpellHUDText);
			ShowSyncHudText(this.index, CoolHUD, CoolHUDText);
		}
	}
	public void OnConditionAdded(TFCond condition)
	{
		switch( condition ) {
			case TFCond_Dazed: {
				float fWizardPos[3];
				GetClientAbsOrigin(this.index, fWizardPos);
				char medSound[35];
				Format(medSound, sizeof(medSound), "vo/merasmus/stunned0%i.mp3", GetRandomInt(1, 3));
				EmitSoundToAll(medSound, this.index, _, _, _, 0.5, _, _, fWizardPos, _, false);
			}
		}
	}
	public void Jam(float duration) {
		TF2_AddCondition(this.index, view_as<TFCond>(50), duration);
		//PrintHintText(this.index, "Your magic is being jammed! Run Away!");
	}
}

public CWizard ToCWizard(const BaseClass guy)
{
	return view_as<CWizard>(guy);
}

public void SetupWizard(CWizard wizard) {
	char sModel[128];
	GetEntPropString(wizard.index, Prop_Data, "m_ModelName", sModel, sizeof(sModel)); // Get the complete Modelname.
	if(!StrEqual(sModel, Wizard_Model, false) && (wizard.iTeam == FF2_GetBossTeam() || FF2_GetBossIndex(wizard.index) != -1))
	{
		wizard.iClassType = None;
		SetHudTextParams(0.0, -1.0, 0.5, 0, 255, 0, 255, 2, 0.0, 0.0, 0.0);
		ShowSyncHudText(wizard.index, SpellHUD, "");
		ShowSyncHudText(wizard.index, CoolHUD, "");
		return;
	}
	if(IsClientHere(wizard.index)) { // Assuming we're using normal or quad model)
		TF2_SetPlayerClass(wizard.index, TFClass_Sniper, _, true);
		//SetEntProp(wizard.index, Prop_Send, "m_iClass", 10);
		TF2Attrib_SetByName(wizard.index, "max health additive bonus", 25.0);
		SetEntityHealth(wizard.index, 200); // Just in case

		wizard.RemoveAllItems();

		//Cooldowns
		wizard.fCooldown = GetEngineTime() + 1.0; // 1s
		wizard.fAntiSpamCooldown = 0.0;
		wizard.fFireCooldown = 0.0;
		wizard.fBatsCooldown = 0.0;
		wizard.fUberCooldown = GetEngineTime() + 15.0;
		wizard.fJumpCooldown = GetEngineTime() + 6.0;
		wizard.fInvisCooldown = GetEngineTime() + 7.0;
		wizard.fMeteorCooldown = GetEngineTime() + 25.0;
		wizard.fMonoCooldown = GetEngineTime() + 20.0;
		//SpellCharges
		wizard.iFireCharges = 2; //Fire
		wizard.iBatsCharges = 1; //Bats
		wizard.iUberCharges = 0; //Uber
		wizard.iJumpCharges = 0; //Jump
		wizard.iInvisCharges = 0; //Invis
		wizard.iMeteorCharges = 0; //Meteor
		wizard.iMonoCharges = 0; //Mono
		//Others
		wizard.fMana = cvarBTC[WizardMana].FloatValue;
		wizard.iSelectedSpell = 1;
		wizard.iCastSound = 0;
		wizard.iSpelltype = 0;
		wizard.fInvisBonus = 0.0;

		SetVariantString(Wizard_Model);
		AcceptEntityInput(wizard.index, "SetCustomModel");
		SetEntProp(wizard.index, Prop_Send, "m_bUseClassAnimations", 1);
		char attribs[128];
		Format(attribs, sizeof(attribs), "124 ; 1 ; 2 ; 1.025 ; 107 ; 1.05 ; 326 ; 1.05 ; 292 ; 106 ; 214 ; %i", GetRandomInt(36000, 99999));
		SpawnWeapon(wizard.index, "tf_weapon_club", 880, 1, 13, attribs);
		SpawnWeapon(wizard.index, "tf_weapon_spellbook", 1070, 1, 0, "124 ; 1 ; 547 ; 0.5")

		//SetAmmo(wizard.index, TFWeaponSlot_Primary, 500);
		//SetAmmo(wizard.index, TFWeaponSlot_Secondary, 500);
	}
}

public void ResetSpellCharges(int iClient) {
	int iSpellbook = FindSpellBook(iClient);
	SetEntProp(iSpellbook, Prop_Send, "m_iSpellCharges", 0);
}

public void AddWizardToDownloads() {
	PrecacheModel(Wizard_Model, true);
}
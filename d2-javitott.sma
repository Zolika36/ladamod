#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <colorchat>
#include <dhudmessage>
#include <engine>
#include <fakemeta>
#include <hamsandwich>
#include <fun>
#include <sqlx>

//+++++++++++++++++++Leírás+++++++++++++++++++++++//

//*Ha használod a módot Annyi vér legyen benned hogy nem irod átt!
//*Sok Dolog Található a Módban Láda, Kulcs, Coin, Egyedi Prefix, Husvéti event, Tojás, Kalapács stb..
//*Ölésekért Jutalmat és Drop esély szertint Kulcs-t, Ládát, Dollárt, és sok mást..
//*Módot Tovább vite/Fejlesztete ~BoNe sok egyedi dolgok vanak benne!
//*Plugin Előző VERSION = 1.1.3 Fejlesztések Kerültek Bele ~BoNe álltal igy a VERSION = 2.5.9
//*Használd Egézségel és Jó játékot ~BoNe


//-----------------------------------PLUGIN, VERSION, AUTHOR----------------------------------------
//---------------------------------------------------------------------------------------------------
new const PLUGIN[] = "Onlyd2_mod";
new const VERSION[] = "2.5.9";
new const AUTHOR[] = "~BoNe"; 

//----------------------------------------------------------------------------------------------------
#pragma semicolon 1
#pragma tabsize 0
#pragma dynamic 84872


//---------------------------Prefix---------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

new const Prefix[] = "[*[xYz]*]~FőMenü"; //Menüben megjelenő prefix
new const regprefix[] = "[*[xYz]*]*~Regisztrácios FőMenü"; //Menüben megjelenő prefix
new const belepprefix[] = "[*[xYz]*]*~Bejelentkezés FőMenü"; //Menüben megjelenő prefix
new const C_Prefix[] = ".::[*[xYz]*]::."; //Chat Prefix


//----------------------------SQL INFÓ------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
new const SQLINFO[][] = { 
"mysql.srkhost.eu", //kiszolgalo 
"u22202_qyMQaJXhD5", //nev
"guneB61EWP0O", //jelszo
"s22202_gardateam" }; //adatbazisnev


//------------------------------Ládák, Skinek Száma-----------------------------------------------------
//------------------------------------------------------------------------------------------------------
#define MAX 68 //Skinek száma
#define LADA 5 //Ládák száma


//-----------------------------Zene Lista---------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
#define File "addons/amxmodx/configs/musiclist.ini"


//-------------------------Fa Láda Dropolás-------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
#define MIN 1
new const Float:DropMester[][] = { 1.0 }; //Fa LLádada droppolLádasi esélye
new const Float:DropEvent[][] = { 0.5 };  //Event LLádada droppolLádasi esélye (Szerveri)


//-------------------------Jogok------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
#define TULAJ ADMIN_IMMUNITY
#define FOADMIN ADMIN_CVAR
#define ADMIN ADMIN_BAN
#define VIP ADMIN_LEVEL_H
#define LIMIT 12000


//---------------------------Drop Esély-----------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
#define DLMIN 1 
#define DLMAX 15
#define KESDROP 1.5 //Kés drop esélye


//----------------------Láda Nevek----------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
new const LadaNevek[][] = { 
"Premium Láda", 
"Shadow Láda", 
"Platinum Láda", 
"Bronz Láda", 
"xYz Láda"

};


//--------------------Adatok----------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
new const Adatok[][] = {
    {CSW_AWP, 6},
    {CSW_KNIFE, 8}
};


//------------------------Kellékek---------------------------------------------------------------------- //Ne nyuj hozzá ha nem érted
//------------------------------------------------------------------------------------------------------
new MusicData[40][3][64], Mp3File[96], MusicNum, PreviousMusic = -1, bool:Off[33], MaxFileLine;
new SayText, Ad;
new Chat_Prefix[32][33], VanPrefix[33], Event[33], g_Id[33], g_Market[2], Mod;
new g_MVP[33], g_MVPoints[33], TopMvp, g_Jutalom[4][33], g_MatchesWon[33], g_QuestMVP[33], g_QuestHead[33], g_Quest[33], g_QuestKills[2][33], g_QuestWeapon[33], g_Erem[33];
new OsszesSkin[MAX][33], Lada[LADA][33], Kulcs[33], Dollar[33], arany[33], Rang[33], Oles[33], Skin[11][33], bool:Gun[33], bool:Hud[33], DropOles[33], D_Oles[33], name[32][33], SMS[33], g_VipTime[33], Vip[33], g_Vip[33], Masodpercek[33], Erteke[33], kicucc[33], kirakva[33], pido;
new bool:Belepve[33], bool:Beirtjelszot[33], bool:Beirtjelszot1[33], bool:Beirtfelhasznalot[33], bool:Beirtfelhasznalot1[33], Regisztralt[33], Felhasznalonev[33][100], Jelszo[33][100], regJelszo[33][100], regFh[33][100], Send[33], TempID;
new Handle:g_SqlTuple;
enum _:TEAMS {TE, CT};
new Temp[192];
static color[10];
enum _:Rangs { Szint[32], Xp[8] };
enum _:Typ {CSW, Anim };

new const Fegyverek[MAX][] =
{
   /*1*/	{ "AK47 | Apocalypse [Limited]" },// 1
	/*2*/	{ "AK47 | Aquamarine" },	// 2
	/*3*/	{ "AK47 | Asiimov" },		// 3
	/*4*/	{ "AK47 | Astronaut" },	// 4
	/*5*/	{ "AK47 | Blue Flame" },	// 5
	/*6*/	{ "AK47 | Coca Cola" },	// 6
	/*7*/	{ "AK47 | Emeraldweb" },	// 7
	/*8*/	{ "AK47 | Fanta" },	// 8
	/*9*/	{ "AK47 | Galaxy" },		// 9
	/*10*/	{ "AK47 | Grapcsh Light" },		// 10 
	/*11*/	{ "AK47 | Indirect" },	// 11
	/*12*/	{ "AK47 | Iron" },	// 12
	/*13*/	{ "AK47 | Lighting" },	// 13
	/*14*/	{ "AK47 | Neon" },		// 14
	/*15*/	{ "AK47 | Neon Electro" },		// 15
	/*16*/	{ "M4A1 | Apocalypse" }, 		// 1
	/*17*/	{ "M4A1 | Asiimov" },		// 2
	/*18*/	{ "M4A1 | Barcelone" },		// 3
	/*19*/	{ "M4A1 | Chanticos" },		// 4
	/*20*/	{ "M4A1 | Chineese Dragon" },		// 5
	/*21*/	{ "M4A1 | Cyrex" },		// 6
	/*22*/	{ "M4A1 | Emerald" },	// 7
	/*23*/	{ "M4A1 | Icarus" },	// 8
	/*24*/	{ "M4A1 | Indirect" },		// 9
	/*25*/	{ "M4A1 | Nuclear" },		// 10
	/*26*/	{ "M4A1 | Phoenix" },		// 11
	/*27*/	{ "M4A1 | Poseidon" },		// 12
	/*28*/	{ "M4A1 | Skull" },	// 13
	/*29*/	{ "M4A1 | Spiritual" },	// 14 
	/*30*/	{ "M4A1 | System Lock" }, 	// 15
	/*31*/	{ "AWP | Asiimov" },		// 1
	/*32*/	{ "AWP | Comicbook" },		// 2
	/*33*/	{ "AWP | De Jackal" },		// 3
	/*34*/	{ "AWP | Dream" },		// 4
	/*35*/	{ "AWP | Electrichive" },		// 5
	/*36*/	{ "AWP | Feverdream" },		// 6
	/*37*/	{ "AWP | Graphite" },	// 7
	/*38*/	{ "AWP | Hyper Beast" },	// 8	
	/*39*/	{ "AWP | Kar98" },	// 9
	/*40*/	{ "AWP | Lightning Strike" },	// 10
	/*41*/	{ "AWP | Manowar" },		// 11
	/*42*/	{ "AWP | Monster" },		// 12
	/*43*/	{ "AWP | Onitaiji" },	// 13
	/*44*/	{ "AWP | Phobos" },	// 14
	/*45*/	{ "AWP | Pitviper" },	// 15
	/*46*/	{ "DEAGLE | Asiimov" },		// 1
	/*47*/	{ "DEAGLE | Black Countrains" },		// 2
	/*48*/	{ "DEAGLE | Engraved" },	// 3
	/*49*/	{ "DEAGLE | Extreme" },		// 4
	/*50*/	{ "DEAGLE | Famosas" },		// 5	
	/*51*/	{ "DEAGLE | Fantazi" },		// 6
	/*52*/ 	{ "DEAGLE | Graan" },		// 7
	/*53*/	{ "DEAGLE | Old Dragon" },		// 8
	/*54*/	{ "DEAGLE | Tone" },	// 9
	/*55*/	{ "DEAGLE | Ultra" },		//10
	/*56*/	{ "KĂ‰S | Adidas" },	// 1
	/*57*/	{ "KĂ‰S | Fidesz" },	// 2
	/*58*/	{ "Karambit | Asiimov" },		// 3
	/*59*/	{ "Karambit | Emerald Brothers" },	// 4
	/*60*/	{ "Karambit | Navi" },	// 5
	/*61*/	{ "Karambit | Neon Skill" },	// 6
	/*62*/	{ "Karambit | Point Disarray" },	// 7
	/*63*/	{ "KĂ‰S | Monalisa" },// 8
	/*64*/	{ "Shadow | Fade" },	// 9
	/*65*/	{ "Skeleton | Blue" },	// 10
	/*66*/	{ "Skeleton | Fade" },	// 11
	/*67*/ 	{ "Skeleton | Lore" },	// 12
	/*68*/	{ "Skeleton | Smerald" }         //13
};
new const m_AK47[][] =
{
	 "models/v_ak47.mdl",
	"models/NemzetiGarda/Ak47/Apocalypse.mdl",
	"models/NemzetiGarda/Ak47/Aquamarine.mdl",
	"models/NemzetiGarda/Ak47/Asiimov.mdl",
	"models/NemzetiGarda/Ak47/Astronaut.mdl",
	"models/NemzetiGarda/Ak47/BlueFlame.mdl",
	"models/NemzetiGarda/Ak47/Coca_Cola.mdl",
	"models/NemzetiGarda/Ak47/Emeraldweb.mdl",
	"models/NemzetiGarda/Ak47/Fanta.mdl",
	"models/NemzetiGarda/Ak47/Galaxy.mdl",
	"models/NemzetiGarda/Ak47/GrapcshLight.mdl",
	"models/NemzetiGarda/Ak47/Indirect.mdl",
	"models/NemzetiGarda/Ak47/Iron.mdl",
         "models/NemzetiGarda/Ak47/Lighting.mdl",
	"models/NemzetiGarda/Ak47/Neon.mdl",
	"models/NemzetiGarda/Ak47/NeonElectro.mdl"
};
new const m_M4A1[][] =
{
	"models/v_m4a1.mdl",
	"models/NemzetiGarda/M4a1/Apocalypse.mdl",
	"models/NemzetiGarda/M4a1/Asiimov.mdl",
	"models/NemzetiGarda/M4a1/Barcelone.mdl",
	"models/NemzetiGarda/M4a1/Chanticos.mdl",
	"models/NemzetiGarda/M4a1/Chineese Dragon.mdl",
	"models/NemzetiGarda/M4a1/Cyrex.mdl",
	"models/NemzetiGarda/M4a1/Emerald.mdl",
	"models/NemzetiGarda/M4a1/Icarus.mdl",
	"models/NemzetiGarda/M4a1/Indirect.mdl",
	"models/NemzetiGarda/M4a1/Nuclear.mdl",
	"models/NemzetiGarda/M4a1/Phoenix.mdl",
	"models/NemzetiGarda/M4a1/Poseidon.mdl",
	"models/NemzetiGarda/M4a1/Skull.mdl",
	"models/NemzetiGarda/M4a1/Spiritual.mdl",
	"models/NemzetiGarda/M4a1/SystemLock.mdl"
};
new const m_AWP[][] =
{
	"models/v_awp.mdl",
	"models/NemzetiGarda/Awp/Asiimov.mdl",
	"models/NemzetiGarda/Awp/Comicbook.mdl",
	"models/NemzetiGarda/Awp/DeJackal.mdl",
	"models/NemzetiGarda/Awp/Dream.mdl",
	"models/NemzetiGarda/Awp/Electrichive.mdl",
	"models/NemzetiGarda/Awp/Feverdream.mdl",
	"models/NemzetiGarda/Awp/Graphite.mdl",
	"models/NemzetiGarda/Awp/HyperBeast.mdl",
	"models/NemzetiGarda/Awp/Kar98.mdl",
	"models/NemzetiGarda/Awp/LightningStrike.mdl",
	"models/NemzetiGarda/Awp/Manowar.mdl",
	"models/NemzetiGarda/Awp/Monster.mdl",
	"models/NemzetiGarda/Awp/Onitaiji.mdl",
	"models/NemzetiGarda/Awp/Phobos.mdl",
	"models/NemzetiGarda/Awp/Pitviper.mdl"
};
new const m_DEAGLE[][] =
{
	"models/v_deagle.mdl",
	"models/NemzetiGarda/Deagle/Asiimov.mdl",
	"models/NemzetiGarda/Deagle/BlackCountrains.mdl",
	"models/NemzetiGarda/Deagle/Engraved.mdl",
	"models/NemzetiGarda/Deagle/Extreme.mdl",
	"models/NemzetiGarda/Deagle/Famosas.mdl",
	"models/NemzetiGarda/Deagle/Fantazi.mdl",
	"models/NemzetiGarda/Deagle/Graan.mdl",
	"models/NemzetiGarda/Deagle/OldDragon.mdl",
	"models/NemzetiGarda/Deagle/Tone.mdl",
	"models/NemzetiGarda/Deagle/Ultra.mdl"
};
new const m_KNIFE[][] =
{
	"models/v_knife.mdl",
	"models/NemzetiGarda/Knife/Adidas.mdl",
	"models/NemzetiGarda/Knife/FIDESZ.mdl",
	"models/NemzetiGarda/Knife/Karambit_Asiimov.mdl",
	"models/NemzetiGarda/Knife/Karambit_Emerald_Brothers.mdl",
	"models/NemzetiGarda/Knife/Karambit_Navi.mdl",
	"models/NemzetiGarda/Knife/Karambit_NeonSkill.mdl",
	"models/NemzetiGarda/Knife/Karambit_PointDisarray.mdl",
	"models/NemzetiGarda/Knife/Monalisa.mdl",
	"models/NemzetiGarda/Knife/Shadow_Fade.mdl",
	"models/NemzetiGarda/Knife/SkeletonBlue.mdl",
	"models/NemzetiGarda/Knife/SkeletonFade.mdl",
	"models/NemzetiGarda/Knife/SkeletonLore.mdl",
	"models/NemzetiGarda/Knife/SkeletonSmerald.mdl"
};
new const Rangok[][Rangs] =
{
	{ "[Újonc][Szint: 1]", 50 },
	{ "[Elismert][Szint: 2]", 100 },
	{ "[Mester][Szint: 3]", 200 },
	{ "[Tehén Pásztor][Szint: 4]", 200 },
	{ "[Szarzsák][Szint: 5]", 300 },
	{ "[Csövesbánat][Szint: 6]", 360 },
	{ "[Hajléktalan][Szint: 7]", 560 },
	{ "[Zsidó][Szint: 8]", 800 },
	{ "[Páóókembör][Szint: 9]", 1204 },
	{ "[Paraszt][Szint: 10]", 1500 },
	{ "[macska][Szint: 11]", 2200 },
	{ "[Büdös][Szint: 12]", 3524 },
	{ "[Szolga][Szint: 13]", 4100 },
	{ "[sztár][Szint: 14]", 5200 },
	{ "[Rendfenttartó][Szint: 15]", 6000 },
	{ "[Buzi][Szint: 16]", 6200 },
	{ "[Alázó][Szint: 17]", 7200 },
	{ "[Gyilkos][Szint: 18]", 9132 },
	{ "[I'm das PRO][Szint: 19]", 10040 },
	{ "[KOCKA][Szint: 20]", 12000 },
	{ "[BÜDÖS KOCKA][Szint: 21]", 14000 },
	{ "[My Hacker][Szint: 22]", 17000 },
	{ "--------------", 0 }
};
public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_impulse(201, "Ellenorzes");  //T Betu Fömenü//
    register_impulse(100, "clcmd_impulse"); //F Betu Skin Vizsg?s//
	register_clcmd("say /menu", "Ellenorzes"); //fömenü//
	register_clcmd("say /add", "addolas"); //Addol?/
    register_clcmd("say /rangok", "rangrendszer"); //Rangok//    
    register_clcmd("say /szabaly", "szabalyzat"); //Szab?//
    register_clcmd("say /dsdd", "korvegiHangok"); //Körv? Hangok//
    register_clcmd("say /adminv1", "AdminMenu", ADMIN_KICK); //Admin Menü//
	register_clcmd("say /rs", "nulla"); //reset Score//     
	register_clcmd("DOLLAR", "lekeres"); //Doll?lek?s//
	register_logevent("RoundEnds", 2, "1=Round_End"); //Hirdeto//
	register_clcmd("say", "sayhook"); //Rangokhoz Chat stb//
	register_clcmd("say_team", "sayhook"); //Rangokhoz Chat stb//
    register_dictionary("round_end_sounds_v3.txt"); //Zene Lang TXT//
	
	register_clcmd("say /roundendsounds", "Toggle"); //Zene ki kapcsol?/
	register_clcmd("say /musiclist", "MusicList"); //Zene Lista//
	SayText = get_user_msgid("SayText"); //Zene Saytext//
	
	set_task(78.9, "Advertising", 789, _, _, "b"); //Hirdető//
         set_task(90.0, "hirdess",_,_,_,"b");
	
	register_logevent("PlayMusic", 2, "1=Round_End"); //Zene Start//
	LoadMusic(); 
	
	register_clcmd("reg_felhsz", "regisztralas_felh"); //Reg Felhasználó//
	register_clcmd("reg_pass", "regisztralas_jelszo"); //Reg Jelszó//
	register_clcmd("belep_felhasz", "bejelentkezes_felh"); //Bejelentkezési Felhasználó//
	register_clcmd("belep_pass", "bejelentkezes_jelszo"); //Bejelentkezési Jelszó//
	register_clcmd("KMENNYISEG", "ObjectSend"); //skin Mennyiség//
	register_clcmd("KMENNYISEGSKIN", "ObjectSendSkin"); //skin Mennyiség//
	register_clcmd("Chat_Prefix", "Chat_Prefix_Hozzaad"); //Chat Prefix "egyedi pp"//
    register_concmd("menu", "AdminMenu", ADMIN_KICK); //Admin menü Jog//
    RegisterHam(Ham_Spawn,"player","nezzedazeventidot",1); //Event Idö//
    RegisterHam(Ham_Spawn,"player","playerSpawn",1); //Player Spawn//

	
	register_event("CurWeapon", "FegyverValtas", "be", "1=1"); //skin fegyver v??/
    register_logevent("autoNews", 2, "1=Round_Start"); //Hirdeto//
    register_logevent("hirdetonews", 2, "1=Round_Start"); //Hirdeto//
	register_event("DeathMsg", "Halal", "a"); //??/

	set_task(1.0, "AutoCheck",_,_,_,"b");
}
stock bool:is_user_steam(id)
{
	static dp_pointer;
     
	if (dp_pointer || (dp_pointer = get_cvar_pointer("dp_r_id_provider")))
	{
		server_cmd("dp_clientinfo %d", id);
		server_exec();
		return (get_pcvar_num(dp_pointer) == 2) ? true : false;
	}
            
	return false;
}	
public Advertising()
{
	new Players[32], PlayersNum, id;
	get_players(Players, PlayersNum, "c");
	for(new i; i < PlayersNum; i++)
	{
		id = Players[i];
		new Message[256];
		if(Ad == 0)
		{
			Ad = 1;
		}
		else if(Ad == 1)
		{
			Ad = 0;
		}
		SendMessage(id, Message);
	}
}
public MusicList(id)
{
	new Motd[1024], Line[256];
	formatex(Line, 255, "<body bgcolor=^"black^">^n");
	add(Motd, 1023, Line, 255);
	formatex(Line, 255, "<span style=^"color:#FFA500;^">^n");
	add(Motd, 1023, Line, 255);
	formatex(Line, 255, "<p align=^"center^"><span style=^"font-size: 20px;^"><strong>Round end Sounds</strong></span></p>^n");
	add(Motd, 1023, Line, 255);
	formatex(Line, 255, "<p align=^"center^"><span style=^"font-size: 10px;^"><strong>by Speedy</strong></span></p>^n");
	add(Motd, 1023, Line, 255);
	formatex(Line, 255, "<p align=^"center^"><span style=^"font-size: 25px;^"><strong>Music List:</strong></span></p>^n");
	add(Motd, 1023, Line, 255);
	
	if(MusicNum > 0)
	{
		for(new Num = 1; Num < MusicNum; Num++)
		{
			formatex(Line, 255, "<span style=^"color:#00FFFF;^">^n");
			add(Motd, 1023, Line, 255);
			formatex(Line, 255, "<p align=^"center^"><span style=^"font-size: 15px;^"><strong>%s - %s</strong></span></p>^n", MusicData[Num][0], MusicData[Num][1]);
			add(Motd, 1023, Line, 255);
		}
	}
	formatex(Line, 255, "</span>^n</body>");
	add(Motd, 1023, Line, 255);
	show_motd(id, Motd, "Music List");
}
public Toggle(id)
{
	new Message[256] ;
	if(Off[id])
	{
		formatex(Message, 255, "%s!y %L", C_Prefix, LANG_SERVER, "ON");
		SendMessage(id, Message);
		Off[id] = false;
	}
	else
	{
		client_cmd(id, "mp3 stop");
		formatex(Message, 255, "%s!y %L", C_Prefix, LANG_SERVER, "OFF");
		SendMessage(id, Message);
		Off[id] = true;
	}
}
public LoadMusic()
{
	new Len, Line[196], Data[3][64];
	MaxFileLine = file_size(File, 1);
	for(new Num; Num < MaxFileLine; Num++)
	{
		MusicNum++;
		read_file(File, Num, Line, 196, Len);
		parse(Line, Data[0], 63, Data[1], 63, Data[2], 63);
		remove_quotes(Line);
		if(Line[0] == ';' || 2 > strlen(Line))
		{
			continue;
		}
		remove_quotes(Data[0]);
		remove_quotes(Data[1]);
		remove_quotes(Data[2]);
		format(MusicData[MusicNum][0], 63, "%s", Data[0]);
		format(MusicData[MusicNum][1], 63, "%s", Data[1]);
		format(MusicData[MusicNum][2], 63, "%s", Data[2]);
	}
	log_amx("Round end sounds v3");
	log_amx("%d loaded music.", MusicNum);
	log_amx("Plugin by: DeRoiD");
}
public PlayMusic() {
	new Num = random_num(1, MusicNum);
	if(MusicNum > 1)
	{
		if(Num == PreviousMusic)
		{
			PlayMusic();
			return PLUGIN_HANDLED;
		}
	}
	formatex(Mp3File, charsmax(Mp3File), "sound/%s", MusicData[Num][2]);
	new Players[32], PlayersNum, id;
	get_players(Players, PlayersNum, "c");
	for(new i; i < PlayersNum; i++)
	{
		id = Players[i];
		if(Off[id])
		{
			continue;
		}
		client_cmd(id, "mp3 play %s", Mp3File);
		new Message[256] ;
		if(strlen(MusicData[Num][0]) > 3 && strlen(MusicData[Num][1]) > 3)
		SendMessage(id, Message);
	}
	PreviousMusic = Num;
	return PLUGIN_HANDLED;
}
public hirdess()
{
   // ColorChat(0, GREEN, "^2%s Mód ^3Developer:^2~BoNe", C_Prefix);

    ColorChat(0, GREEN, "^3Facebook csoportunk: ^4-HAMAROSAN-", C_Prefix);
}
public playerSpawn(id)
{
if(!is_user_alive(id)) 
{
return PLUGIN_HANDLED;
}
//resetModels(id);
vipCheck(id);

return PLUGIN_HANDLED;
}
public vipCheck(id)
{
if(g_VipTime[id] >= 10) g_Vip[id] = 1;
else g_Vip[id] = 0;
}
public clcmd_impulse(id) {
    const g_id = 43;
    const Activ = 373;
   
    new Vettem = get_pdata_cbase(id, Activ);
    new Wp = get_pdata_int(Vettem, g_id,._linuxdiff = 4);
   
    for(new i;i < sizeof(Adatok);i++) {
        if(Wp == Adatok[i][CSW]) {
            WeaponAnim(id, .iAnim = (Adatok[i][Anim]));
            return PLUGIN_HANDLED;
        }
    }
    return PLUGIN_CONTINUE;
}
stock WeaponAnim(id, iAnim) {
    entity_set_int(id, EV_INT_weaponanim, iAnim);
    message_begin(MSG_ONE,SVC_WEAPONANIM,_,id);
    write_byte(iAnim);
    write_byte(entity_get_int(id, EV_INT_body));
    message_end();
    return PLUGIN_HANDLED;
}
public nulla(id)
{
if(!Belepve[id])
	{
		ColorChat(id, GREEN, "^4%s ^1Először jelenkezz be!",C_Prefix);
		return PLUGIN_HANDLED;
	}
new nev[32];
get_user_name(id, nev, 31);
set_user_frags(id, 0);
cs_set_user_deaths(id, 0);
set_user_frags(id, 0);
cs_set_user_deaths(id, 0);	
ColorChat(0, GREEN,"%s %s ^3Nullázta a StatisztiKáját", C_Prefix, nev);
}
public addolas(id)
{
if(get_user_flags(id) & ADMIN_IMMUNITY)
{
	for(new i;i < MAX; i++)
	OsszesSkin[i][id]++;
	for(new i;i < LADA; i++)
	Lada[i][id] += 200;
	Kulcs[id] += 2000;
	Dollar[id] += 5032;
    SMS[id] += 5032;
	ColorChat(id, GREEN, "%s ^1Addoltál magadnak!!!", C_Prefix);
}
else
{
	ColorChat(id, GREEN, "%s ^1Nincs jogod ehhez", C_Prefix);
}
}
public AutoCheck()
{
new p[32],n;
get_players(p,n,"ch");
for(new i=0;i<n;i++)
{
new id = p[i];
if(Hud[id])
{
	InfoHud(id);
}
}
}
public InfoHud(id)
{
	new Target = pev(id, pev_iuser1) == 4 ? pev(id, pev_iuser2) : id;
	
	if(is_user_alive(id))
	{
		if(Belepve[id]) {
		        new iMasodperc, iPerc, iOra, Nev[32];
		        get_user_name(id, Nev, 31);
		        iMasodperc = Masodpercek[id] + get_user_time(id);
		        iPerc = iMasodperc / 60;
		        iOra = iPerc / 60;
		        iMasodperc = iMasodperc - iPerc * 60;
		        iPerc = iPerc - iOra * 60;
		
		        set_hudmessage(random(255), random(255), random(255), 0.01, 0.15, 0, 6.0, 1.1, 0.0, 0.0, -1);
		        show_hudmessage(id, "Köszöntelek a szerveren!^n^nNév: [%s]^nRang: [%s]^nÖlés: [%d]^nDollár: [%d$]^nCoin: [%d$]^nJátszott idő: [%d Óra %d Perc]", Nev, Rangok[Rang[id]][Szint], Oles[id], Dollar[id], SMS[id], iOra, iPerc);
	    }
	     else {
			set_hudmessage(random(255), random(255), random(255), 0.01, 0.15, 0, 6.0, 1.1, 0.0, 0.0, -1);
			show_hudmessage(id, "még nem regisztráltál!");
		}
	}
	else
	{
		if(Belepve[Target]) {
		        new iMasodperc, iPerc, iOra;
		        iMasodperc = Masodpercek[Target] + get_user_time(Target);
		        iPerc = iMasodperc / 60;
		        iOra = iPerc / 60;
		        iMasodperc = iMasodperc - iPerc * 60;
		        iPerc = iPerc - iOra * 60;
		
		        set_hudmessage(random(255), random(255), random(255), 0.01, 0.15, 0, 6.0, 1.1, 0.0, 0.0, -1);
		        show_hudmessage(id, "Nézett játékos adatai!^nRang: [%s]^nÖlés: [%d]^nDollár: [%d$]^nCoin: [%d$]^n^nJátszott idő: [%d Óra %d Perc]", Rangok[Rang[Target]][Szint], Oles[Target], Dollar[id], SMS[id], iOra, iPerc);
		}
		else {
			set_hudmessage(random(255), random(255), random(255), 0.01, 0.15, 0, 6.0, 1.1, 0.0, 0.0, -1);
			show_hudmessage(id, "A nézett játékos nincsen bejelentkezve!");
		}
	} 
}
public nezzedazeventidot(id){
    IdoEllenorzes(id);
}
public IdoEllenorzes(id)
{
	new hour, minute, second;
	time(hour, minute, second);
	
	if(0 <= hour && 15 > hour)
	{
	Mod = 1;
	set_dhudmessage(random(256), random(256), random(256), -1.0, 0.20, 0, 6.0, 6.0);
	show_dhudmessage(id, "Jelenleg: Drop Event");
	}
	
	if(10 <= hour && 11 > hour)
	{
	Mod = 2;
	set_dhudmessage(random(256), random(256), random(256), -1.0, 0.20, 0, 6.0, 6.0);
	show_dhudmessage(id, "Jelenleg: Kulcs Event");
	}
	
	if(20 <= hour && 21 > hour)
	{
	Event[id] = 3;
	set_dhudmessage(random(256), random(256), random(256), -1.0, 0.20, 0, 6.0, 6.0);
	show_dhudmessage(id, "Jelenleg: Fa Láda Event");
	}
	
	if(21 <= hour && 22 > hour)
	{
	Event[id] = 2;
	set_dhudmessage(random(256), random(256), random(256), -1.0, 0.20, 0, 6.0, 6.0);
	show_dhudmessage(id, "Jelenleg: Gyémánt Láda Event");
	}
	
	return PLUGIN_HANDLED;
}
public plugin_precache(){
	new Len, Line[196], Data[3][64], Download[40][64];
	MaxFileLine = file_size(File, 1);
	for(new Num = 0; Num < MaxFileLine; Num++)
	{
		read_file(File, Num, Line, 196, Len);
		parse(Line, Data[0], 63, Data[1], 63, Data[2], 63);
		remove_quotes(Line);
		if(Line[0] == ';' || 2 > strlen(Line))
		{
			continue;
		}
		remove_quotes(Data[2]);
		format(Download[Num], 63, "%s", Data[2]);
		precache_sound(Download[Num]);
	}
	for(new i;i < sizeof(m_AK47); i++)
	{
		precache_model(m_AK47[i]);
	}
	for(new i;i < sizeof(m_M4A1); i++)
	{
		precache_model(m_M4A1[i]);
	}
	for(new i;i < sizeof(m_AWP); i++)
	{
		precache_model(m_AWP[i]);
	}
	for(new i;i < sizeof(m_DEAGLE); i++)
	{
		precache_model(m_DEAGLE[i]);
	}
	for(new i;i < sizeof(m_KNIFE); i++)
	{
		precache_model(m_KNIFE[i]);
	}
}
stock SendMessage(id, const MessageData[]) {
	static Message[256];
	vformat(Message, 255, MessageData, 3);
	replace_all(Message, 255, "!g", "^4");
	replace_all(Message, 255, "!y", "^1");
	replace_all(Message, 255, "!t", "^3");
	message_begin(MSG_ONE_UNRELIABLE, SayText, _, id);
	write_byte(id);
	write_string(Message);
	message_end();	
}
public FegyverValtas(id)
{
	new fgy = get_user_weapon(id);
	
	for(new i;i < sizeof(m_AK47); i++)
	{
		if(Skin[0][id] == i && fgy == CSW_AK47 && Gun[id] == 1)
		{
			set_pev(id, pev_viewmodel2, m_AK47[i]);
		}
	}
	for(new i;i < sizeof(m_M4A1); i++)
	{
		if(Skin[1][id] == i && fgy == CSW_M4A1 && Gun[id] == 1)
		{
			set_pev(id, pev_viewmodel2, m_M4A1[i]);
		}
	}
	for(new i;i < sizeof(m_AWP); i++)
	{
		if(Skin[2][id] == i && fgy == CSW_AWP && Gun[id] == 1)
		{
			set_pev(id, pev_viewmodel2, m_AWP[i]);
		}
	}
	for(new i;i < sizeof(m_DEAGLE); i++)
	{
		if(Skin[3][id] == i && fgy == CSW_DEAGLE && Gun[id] == 1)
		{
			set_pev(id, pev_viewmodel2, m_DEAGLE[i]);
		}
	}
	for(new i;i < sizeof(m_KNIFE); i++)
	{
		if(Skin[4][id] == i && fgy == CSW_KNIFE && Gun[id] == 1)
		{
			set_pev(id, pev_viewmodel2, m_KNIFE[i]);
		}
}
}
public Halal()
{
    new Gyilkos = read_data(1);
    new Aldozat = read_data(2);
    new pPont;
	
    pPont += random_num(DLMIN, DLMAX);
   
    if(Gyilkos == Aldozat)
        return PLUGIN_HANDLED;
       
    Dollar[Gyilkos] += pPont;
	g_MVPoints[Gyilkos]++;
	

    ColorChat(Gyilkos, GREEN, "^3.::[*[xYz]*]::.^1 Amiért megöltél egy ellenséget, kaptál ^4+1^1 ölést, ^4%d^1 Dollárt.", pPont);
   
    Oles[Gyilkos]++;
	DropOles[Gyilkos]++;

    /*
    Arany találat Ölésekért*/
    arany[Gyilkos]++;
    set_dhudmessage(random(256), random(256), random(256), -1.0, 0.20, 0, 6.0, 3.0);
    show_dhudmessage(Gyilkos, "+%d Arany", arany);
	
	if(g_Quest[Gyilkos] == 1) Quest(Gyilkos);
   
    while(Oles[Gyilkos] >= Rangok[Rang[Gyilkos]][Xp])
        Rang[Gyilkos]++;

	LadaDropEllenor(Gyilkos);
    return PLUGIN_HANDLED;
}

public eventCaseOpen(id)
{
new randomPP = random_num(5,25);
new randomKey = random_num(2,4);
new name[32];
get_user_name(id, name, charsmax(name));

if(Lada[4][id] >= 1 && Kulcs[id] >= 1)
{
	switch(random_num(0,1))
	{
		case 0:
		{
			Lada[4][id]--;
			Kulcs[id]--;
			SMS[id] += randomPP;
			ColorChat(0, GREEN, "%s ^3%s^1 nyitott ^4%d^1 xyzskinek Pontot a ^3Bronz Ládából", C_Prefix, name, randomPP);
		}
		case 1:
		{
			Lada[4][id]--;
			Kulcs[id]--;
			Kulcs[id] += randomKey;
			ColorChat(0, GREEN, "%s ^3%s^1 nyitott ^4%d^1 Kulcsot a ^3Bronz Ládából", C_Prefix, name, randomKey);
		}
	}
}
}
public LadaDropEllenor(id)
{
new Nev[32]; get_user_name(id, Nev, 31);
new Float:RandomSzam = random_float(0.01, 100.00);
new LadaID = random_num(0,3);

if(Mod == 0)
	{		if(RandomSzam <= DropEvent[0][0] && Event[id] == 2)
		{
			Lada[4][id] ++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[4][0]);
		}
		else if(RandomSzam <= DropMester[0][0] && Event[id] == 3)
		{
			Lada[1][id] ++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[1][0]);
		}
		if(DropOles[id] == 4)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] == 9)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] >= 11)
		{
			Kulcs[id]++;
			DropOles[id] = 0;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4Kulcs^1-t.", C_Prefix, Nev);
}
if(Mod == 1)
	{
		if(RandomSzam <= DropEvent[0][0] && Event[id] == 2)
		{
			Lada[4][id] ++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[4][0]);
		}
		if(RandomSzam <= DropMester[0][0] && Event[id] == 3)
		{
			Lada[3][id] ++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[3][0]);
		}
		if(DropOles[id] == 2)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] == 5)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] == 9)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] == 10)
		{
			Kulcs[id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4Kulcs^1-t", C_Prefix, Nev);
		}
		if(DropOles[id] == 11)
		{	
			Kulcs[id]++;
			DropOles[id] = 0;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4Kulcs^1-t.", C_Prefix, Nev);
		}
	}
if(Mod == 2)
	{
		if(RandomSzam <= DropEvent[0][0] && Event[id] == 2)
		{
			Lada[4][id] ++;
			ColorChat(0, GREEN, "%s^3%s ^3Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[4][0]);
		}
		if(RandomSzam <= DropMester[0][0] && Event[id] == 3)
		{
			Lada[2][id] ++;
			ColorChat(0, GREEN, "%s^3%s ^3Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[2][0]);
		}
		if(DropOles[id] == 2)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] == 5)
		{
			Lada[LadaID][id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4%s^1-t.", C_Prefix, Nev, LadaNevek[LadaID][0]);
		}
		if(DropOles[id] == 9)
		{
			Kulcs[id]++;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4Kulcs^1-t.", C_Prefix, Nev);
		}
		if(DropOles[id] >= 11)
		{
			Kulcs[id]++;
			DropOles[id] = 0;
			ColorChat(0, GREEN, "%s^3%s ^1Talált egy: ^4Kulcs^1-t.", C_Prefix, Nev);
			}
}
}
}
public AdminMenu(id)
{

    new menu = menu_create("\r.::[*[xYz]*]::. Admin-menü", "AdminMenu_handler");

    menu_additem(menu, "\r{\yKirugás menü\r}", "1", 0);
    menu_additem(menu, "\r{\yBan menü\r}", "2", 0);
    menu_additem(menu, "\r{\yUnban menü\r}", "7", 0);
    menu_additem(menu, "\r{\yMegütés/Megölés menü\r}", "3", 0);
    menu_additem(menu, "\r{\yCsapat menü\r}", "4", 0);
    menu_additem(menu, "\r{\yPálya választás\r}", "5", 0);
    menu_additem(menu, "\r{\yPálya szavazás\r}", "6", 0);
    
    menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);

    menu_display(id, menu, 0);
}
public AdminMenu_handler(id, menu, item)
{
  
    if( item == MENU_EXIT )
    {
        menu_destroy(menu);
 
        return PLUGIN_HANDLED;
    }


    new data[6], szName[64];
    new access, callback;

    menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
    
    new key = str_to_num(data);

    switch(key)
    {
        case 1:
        {
         client_cmd(id, "amx_kickmenu");
        }
        case 2:
        {
         client_cmd(id, "amx_banmenu");
        }
        case 3:
        {
         client_cmd(id, "amx_slapmenu");
        }
        case 4:
        {
         client_cmd(id, "amx_teammenu");
        }
        case 5:
        {
         client_cmd(id, "amx_mapmenu");
        }
        case 6:
        {
         client_cmd(id, "amx_votemapmenu");
        }
        case 7:
        {
         client_cmd(id, "amx_unbanmenu");
        }
    }

    menu_destroy(menu);
    return PLUGIN_HANDLED;
}
public ObjectSend(id)
{
new Data[121];
new SendName[32], TempName[32];

read_args(Data, charsmax(Data));
remove_quotes(Data);
get_user_name(id, SendName, 31);
get_user_name(TempID, TempName, 31);

if(str_to_num(Data) < 1) 
	return PLUGIN_HANDLED;

if(Send[id] == 1 && Dollar[id] >= str_to_num(Data))
{
	Dollar[TempID] += str_to_num(Data);
	Dollar[id] -= str_to_num(Data);
	ColorChat(0, GREEN, "%s ^3%s ^1Küldött ^4%d$ -t ^3%s^1-nak", C_Prefix, SendName, str_to_num(Data), TempName);
}
if(Send[id] == 2 && Kulcs[id] >= str_to_num(Data))
{
	Kulcs[TempID] += str_to_num(Data);
	Kulcs[id] -= str_to_num(Data);
	ColorChat(0, GREEN, "%s ^3%s ^1Küldött ^4%d Kulcs^1-t ^3%s^1-nak", C_Prefix, SendName, str_to_num(Data), TempName);
}
if(Send[id] == 3 && SMS[id] >= str_to_num(Data))
{
	SMS[TempID] += str_to_num(Data);
	SMS[id] -= str_to_num(Data);
	ColorChat(0, GREEN, "%s^3%s ^1Küldött ^4%d xyzskinek Pont-t^1-ot ^3%s^1-nak", C_Prefix, SendName, str_to_num(Data), TempName);
}
for(new i;i < LADA; i++) 
{
	if(Send[id] == i + 4 && Lada[i][id] >= str_to_num(Data))
	{
		Lada[i][TempID] += str_to_num(Data);
		Lada[i][id] -= str_to_num(Data);
		ColorChat(0, GREEN, "%s ^3%s ^1Küldött ^4%d %s^1-t ^3%s^1-nak", C_Prefix, SendName, str_to_num(Data), LadaNevek[i], TempName);
	}
}
return PLUGIN_HANDLED;
}
public Ellenorzes(id)
{
if(Belepve[id] == false)
{
	Menu_Fo(id);
}
else
{
	Fomenu(id);
}
}
new const REGMENU[][][] = { { "\dNem Regisztrált", "\wKijelentkezve" } };
public Menu_Regisztracio(id) 
{
	new String[121], Nev[32];
	get_user_name(id, Nev, 31);
	formatex(String, charsmax(String), "%s \r- \dRegisztráció^n%s", regprefix, REGMENU[0][Regisztralt[id]]);
	new menu = menu_create(String, "Menu_Regisztracio_h");
	
	if(Regisztralt[id] == 0)
	{
	formatex(String, charsmax(String), "\r{\yFelhasználónév\r}: \r%s^n", regFh[id]);
	menu_additem(menu, String, "1",0);
	formatex(String, charsmax(String), "\r{\yJelszó\r}: \r%s^n", regJelszo[id]);
	menu_additem(menu, String, "2",0);
	}
	else
	{
	formatex(String, charsmax(String), "\rNév: \d%s^n\wTe már regisztráltál a szerverre.", Nev, regFh[id]);
	menu_additem(menu, String, "",0);
	}
	
	if(Beirtfelhasznalot[id] == true && Beirtjelszot[id] == true)
	{
	formatex(String, charsmax(String), "\r{\yRegisztráció\r}");
	menu_additem(menu, String, "3",0);
	}
	
	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public Menu_Regisztracio_h(id, menu, item)
{
if(item == MENU_EXIT)
{
menu_destroy(menu);
return;
}

new data[9], szName[64];
new access, callback;
menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
new key = str_to_num(data);

switch(key) 
{
	case 1:
	{
		client_cmd(id, "messagemode reg_felhsz");
	}
	case 2:
	{
		client_cmd(id, "messagemode reg_pass");
	}
	case 3:
	{
		Regisztralt[id] = 1;
                ColorChat(id, GREEN, "^4%s^1Sikeresen regisztráltál!",  C_Prefix);
		SQL_Update_Reg(id);
	}
}
}
public Menu_Bejelentkezes(id) 
{
	new String[121];
	formatex(String, charsmax(String), "%s \r- \dBejelentkezés^n%s", belepprefix, REGMENU[0][Regisztralt[id]]);
	new menu = menu_create(String, "Menu_Bejelentkezes_h");
	
	formatex(String, charsmax(String), "\r{\yFelhasználónév\r}: \r%s^n", Felhasznalonev[id]);
	menu_additem(menu, String, "1",0);
	formatex(String, charsmax(String), "\r{\yJelszó\r}: \r%s^n", Jelszo[id]);
	menu_additem(menu, String, "2",0);
	
	formatex(String, charsmax(String), "\r{\yBejelentkezés\r}");
	menu_additem(menu, String, "3",0);
	
	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public Menu_Bejelentkezes_h(id, menu, item)
{
if(item == MENU_EXIT)
{
menu_destroy(menu);
return;
}

new data[9], szName[64], Nev[32];
get_user_name(id, Nev, 31);
new access, callback;
menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
new key = str_to_num(data);

switch(key) 
	{
		case 1:
		{
		client_cmd(id, "messagemode belep_felhasz");
		}
		case 2:
		{
		client_cmd(id, "messagemode belep_pass");
		}
		case 3:
        {
			if(equali(Jelszo[id], regJelszo[id]) && (equali(Felhasznalonev[id], regFh[id])))
			{
            Belepve[id] = true;
            ColorChat(id, GREEN, "%s ^1Üdv Ujra itt ^4%s", C_Prefix, Nev);
			if(Vip[id] > 1) Vip[id] = 1;
			if(get_user_flags(id) & ADMIN) ColorChat(0, GREEN, "%s ^1Egy ^4Admin ^1bejelentkezett:^3 %s", C_Prefix, Nev);
			if(get_user_flags(id) & VIP && Vip[id] == 1) ColorChat(0, GREEN, "%s ^1Egy ^4VIP ^1bejelentkezett:^3 %s", C_Prefix, Nev);
			}
			else
			{
			ColorChat(id, GREEN, "%s ^1Hibás Felhasználónév vagy Jelszó.", C_Prefix);
			}
        }
	}
}
public Menu_Fo(id) 
{
	new String[121];
	formatex(String, charsmax(String), "%s \r- \dRegisztrálj, Vagy jelentkezz be!", Prefix, REGMENU[0][Regisztralt[id]]);
	new menu = menu_create(String, "Menu_Fo_h");
	
	formatex(String, charsmax(String), "\r{\yRegisztáció\r}^n^n");
	menu_additem(menu, String, "2",0);
	formatex(String, charsmax(String), "\r{\yBejelentkezés\r}");
	menu_additem(menu, String, "1",0);

	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public Menu_Fo_h(id, menu, item)
{
if(item == MENU_EXIT)
{
menu_destroy(menu);
return;
}

new data[9], szName[64];
new access, callback;
menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
new key = str_to_num(data);

switch(key) 
	{
	case 1: Menu_Bejelentkezes(id);
	case 2: Menu_Regisztracio(id);
	}
}
public regisztralas_felh(id)
{
    new adat[32];
    new hosszusag = strlen(adat);
    read_args(adat, charsmax(adat));
    remove_quotes(adat);
    if(hosszusag >= 5) 
	{
        regFh[id] = adat;
        Beirtfelhasznalot[id] = true;
        Menu_Regisztracio(id);
    }
    else 
	{
        regFh[id] = adat;
        Beirtfelhasznalot[id] = true;
        Menu_Regisztracio(id);
    }
    return PLUGIN_CONTINUE;
}
public regisztralas_jelszo(id)
{
    new adat[32];
    new hosszusag = strlen(adat);
    read_args(adat, charsmax(adat));
    remove_quotes(adat);
    if(hosszusag >= 5) {
        regJelszo[id] = adat;
        Beirtjelszot[id] = true;
        Menu_Regisztracio(id);
    }
    else {
        regJelszo[id] = adat;
        Beirtjelszot[id] = true;
        Menu_Regisztracio(id);
    }
    return PLUGIN_CONTINUE;
}
public bejelentkezes_jelszo(id)
{
    new adat[32];
    new hosszusag = strlen(adat);
    read_args(adat, charsmax(adat));
    remove_quotes(adat);
    if(hosszusag >= 5) {
        Jelszo[id] = adat;
        Beirtjelszot1[id] = true;
        Menu_Bejelentkezes(id);
    }
    else {
        Jelszo[id] = adat;
        Beirtjelszot1[id] = true;
        Menu_Bejelentkezes(id);
    }
    return PLUGIN_CONTINUE;
}
public bejelentkezes_felh(id)
{
new adat[32];
new hosszusag = strlen(adat);
read_args(adat, charsmax(adat));
remove_quotes(adat);
if(hosszusag >= 5) 
{
Felhasznalonev[id] = adat;
Beirtfelhasznalot1[id] = true;
Menu_Bejelentkezes(id);
}
else 
{
Felhasznalonev[id] = adat;
Beirtfelhasznalot1[id] = true;
Menu_Bejelentkezes(id);
}
return PLUGIN_CONTINUE;
}
public Fomenu(id)
{
	new String[121];
	format(String, charsmax(String), "%s^n\dDollár: \r$%d \y| \dxYz Pont: \r%d", Prefix, Dollar[id], SMS[id]);
	new menu = menu_create(String, "Fomenu_h");
	
    menu_additem(menu, "\y»\r{\yRaktár\r}", "1", 0);
	menu_additem(menu, "\y»\r{\yLáda Nyitás\r}", "2", 0);
	menu_additem(menu, "\y»\r{\yPiac\r}", "3", 0);
	menu_additem(menu, "\y»\r{\yKüldetések\r}", "8", 0);
    menu_additem(menu, "\y»\r{\yKaszinó Játékok\r}", "9", 0);
	format(String, charsmax(String), "\y»\r{\yBeállítások\r}", Rangok[Rang[id]][Szint], Rangok[Rang[id]+1][Szint], Oles[id], Rangok[Rang[id]][Xp]);
	menu_additem(menu, String, "5", 0);
	
	menu_display(id, menu, 0);
}
public Fomenu_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
		new randomKills = random_num(5,25);
         new randomWeapon = random_num(0,5);
	new randomHead = random_num(0,1);
	new randomLada = random_num(0,4);
	new randomKulcs = random_num(0,4);
	new randomPremium = random_num(10,20);
	new randomDollar = random_num(3,10);
	
	switch(key)
	{
		case 1: Raktar(id);
		case 2: LadaEloszto(id);
		case 3: Piac(id);
		case 5: bealitasok(id);
                  case 7:	AdminMenu(id);
		case 8:
		{
		if(g_Quest[id] == 0)
		{
			g_QuestKills[0][id] = randomKills;
			g_QuestWeapon[id] = randomWeapon;
			g_QuestHead[id] = randomHead;
				
			g_Jutalom[0][id] = randomDollar;
			g_Jutalom[1][id] = randomLada;
			g_Jutalom[2][id] = randomKulcs;
			g_Jutalom[3][id] = randomPremium;
			g_Quest[id] = 1;
				openQuestMenu(id);
			}
			else
			{
				openQuestMenu(id);
			}	
		}
	}
}
public openQuestMenu(id)
{
	new String[121];
    formatex(String, charsmax(String), "%s\w Küldetések^n\wDollár: \r%3.2f $\y |\d-\y|\w Befejezett kuldeteseid:\r %d", Prefix, Dollar[id], g_QuestMVP[id]);
	new menu = menu_create(String, "h_openQuestMenu");
	
	new const QuestWeapons[][] = { "AK47", "M4A1", "AWP", "DEAGLE", "USP", "Nincs" };
	new const QuestHeadKill[][] = { "Nincs", "Csak fejlövés" };
	
	formatex(String, charsmax(String), "\dFeladat: \yÖlj meg %d játékost \d[\yMég %d ölés\d]", g_QuestKills[0][id], g_QuestKills[0][id]-g_QuestKills[1][id]);
	menu_additem(menu, String, "0",0);
	formatex(String, charsmax(String), "\dÖlés Korlát: \y%s", QuestHeadKill[g_QuestHead[id]]);
	menu_additem(menu, String, "0",0);
	formatex(String, charsmax(String), "\dFegyver Korlát: \y%s \d[\rCsak ezzel a fegyverrel ölhetsz\d]^n", QuestWeapons[g_QuestWeapon[id]]);
	menu_additem(menu, String, "0",0);
		formatex(String, charsmax(String), "\wJutalom:^n\y- Dollár [%d]^n- Láda [%d DB]^n- Kulcs [%d DB]^n- Küldetés Pont [+1]", g_Jutalom[0][id], g_Jutalom[1][id], g_Jutalom[2][id]);
	menu_additem(menu, String, "0",0);
	formatex(String, charsmax(String), "\rKüldetés kihagyása \d");
	menu_additem(menu, String, "1",0);
	
	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public h_openQuestMenu(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{
		case 0: openQuestMenu(id);
		case 1:
		{
		if(SMS[id] >= 0)
		{
			g_QuestKills[1][id] = 0;
			g_QuestWeapon[id] = 0;
			g_Quest[id] = 0;
			SMS[id] -= 0;
			ColorChat(id, GREEN, "%s ^1Kihagytad ezt a küldetést", C_Prefix);
			}
		else ColorChat(id, GREEN, "%s ^1Nincs elég^3 SMS-ed", C_Prefix);
		}
	}
}
public m_Bolt(id)
{
	new String[121];
	formatex(String, charsmax(String), "%s \r- \dBolt^n\yDollár: \d%d \d| Coin: \r%d$", Prefix, Dollar[id], SMS[id]);
	new menu = menu_create(String, "mh_Bolt");
	
    menu_additem(menu, "Prefix \rVásárlás\r[\y1000$/DB\w]", "7", 0);
	menu_additem(menu, "Kulcs \r[1200 \rDollár\r]", "1", 0);
	menu_additem(menu, "Mester Láda \r[500 \rDollár\r]", "3", 0);
	menu_additem(menu, "Prémium Láda \r[550 \rDollár\r]", "4", 0);
	
        menu_display(id, menu, 0);

	return PLUGIN_HANDLED;
}
public mh_Bolt(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{
                case 7: egyediprefixmenu(id);
		case 1:
		{
			if(Dollar[id] >= 1200)
			{
				Dollar[id] -= 1200;
				Kulcs[id] ++;
				ColorChat(id, GREEN, "%s ^1Vásároltál egy ^4Kulcs^1^1-t", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs Elég Dollárod!", C_Prefix);
				m_Bolt(id);
			}
		}
		
		case 3:
		{
			if(Dollar[id] >= 500)
			{
				Dollar[id] -= 500;
				Lada[0][id] ++;
				ColorChat(id, GREEN, "%s ^1Vásároltál egy ^4Mester Láda^1-t", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs Elég Dollárod!", C_Prefix);
				m_Bolt(id);
			}
		}
		
		case 4:
		{
			if(Dollar[id] >= 450)
			{
				Dollar[id] -= 450;
				Lada[1][id] ++;
				ColorChat(id, GREEN, "%s ^1Vásároltál egy ^4Prémium Láda^1-t", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs Elég Dollárod!", C_Prefix);
			}	m_Bolt(id);     
                }             				
        }
}
public korvegiHangok(id)
{
new String[121];
formatex(String, charsmax(String), "[%s] \r- \dKorvegi Hangok", Prefix);
new menu = menu_create(String, "Fomenu_h");

menu_additem(menu, "\raim\y", "0", 0);
menu_additem(menu, "\rakkor\y", "0", 0);
menu_additem(menu, "\rcsa\y", "0", 0);
menu_additem(menu, "\rcsalo\y", "0", 0);
menu_additem(menu, "\rcsaltal\y", "0", 0);
menu_additem(menu, "\rennyi\y", "0", 0);
menu_additem(menu, "\reridj\y", "0", 0);
menu_additem(menu, "\rfulke\y", "0", 0);
menu_additem(menu, "\rhali\y", "0", 0);
menu_additem(menu, "\rlol\y", "0", 0);
menu_additem(menu, "\ranyad\y", "0", 0);
menu_additem(menu, "\rprofik\y", "0", 0);
menu_additem(menu, "\rakkor\y", "0", 0);
menu_additem(menu, "\rbaszakodni\y", "0", 0);
menu_additem(menu, "\rcfg\y", "0", 0);
menu_additem(menu, "\rcookie\y", "0", 0);
menu_additem(menu, "\rcsiter\y", "0", 0);
menu_additem(menu, "\rgolyo\y", "0", 0);
menu_additem(menu, "\rhihihi\y", "0", 0);
menu_additem(menu, "\rjuj\y", "0", 0);
menu_additem(menu, "\rkuss\y", "0", 0);
menu_additem(menu, "\rkutya\y", "0", 0);
menu_additem(menu, "\rlalala\y", "0", 0);
menu_additem(menu, "\rmadar\y", "0", 0);
menu_additem(menu, "\rmegollek\y", "0", 0);
menu_additem(menu, "\rmigiri\y", "0", 0);
menu_additem(menu, "\rpofadat\y", "0", 0);
menu_additem(menu, "\rszabaly\y", "0", 0);
menu_additem(menu, "\rszemet\y", "0", 0);
menu_additem(menu, "\rszeva\y", "0", 0);
menu_additem(menu, "\rtanulj\y", "0", 0);
menu_additem(menu, "\rtesco\y", "0", 0);
menu_additem(menu, "\rvazze\y", "0", 0);

menu_display(id, menu, 0);
return PLUGIN_HANDLED;
}
public szabalyzat(id)
{
new String[121];
formatex(String, charsmax(String), "[%s] \r- \dSzabályzat", Prefix);
new menu = menu_create(String, "Fomenu_h");

menu_additem(menu, "\rTILOS \wNe anyázd A társad!\y", "0", 0);
menu_additem(menu, "\rTILOS \wne Beszélj Csunyán!\y", "0", 0);
menu_additem(menu, "\rTILOS \wA csalás\y", "0", 0);
menu_additem(menu, "\rTILOS \wA bugoltalás!", "0", 0);
menu_additem(menu, "\rTILOS \wAz admin-adminok Szidása!", "0", 0);
menu_additem(menu, "\rTILOS \wA Szerver Szidása!", "0", 0);
menu_additem(menu, "\rTILOS \wNe Campelj!\y", "0", 0);
menu_additem(menu, "\rTILOS \wNe légy Fajgyülölö!", "0", 0);

menu_display(id, menu, 0);
return PLUGIN_HANDLED;
}
public rangrendszer(id)
{
new String[121];
formatex(String, charsmax(String), "[%s] \r- \dRangok", Prefix);
new menu = menu_create(String, "Fomenu_h");

menu_additem(menu, "\yElismert \y\w100 Ölés\y", "7", 0);
menu_additem(menu, "\yMester \y\w200 Ölés\y", "7", 0);
menu_additem(menu, "\yTehén Pásztor \y\w250 Ölés\y", "7", 0);
menu_additem(menu, "\ySzarzsák \y\w300 Ölés\y", "7", 0);
menu_additem(menu, "\yCsövesbánat \y\w360 Ölés\y", "7", 0);
menu_additem(menu, "\yBánattudja mi a nevem? \y\w420 Ölés\y", "7", 0);
menu_additem(menu, "\yHajléktalan \y\w560 Ölés\y", "7", 0);
menu_additem(menu, "\yZsidó \y\w800 Ölés\y)", "7", 0);
menu_additem(menu, "\yPáóókembör \y\w1204 Ölés\y", "7", 0);
menu_additem(menu, "\yParaszt \y\w1500 Ölés\y", "7", 0);
menu_additem(menu, "\ymacska \y\w2200 Ölés\y", "7", 0);
menu_additem(menu, "\yElbűvölő Szökevény \y\w3000 Ölés\y", "7", 0);
menu_additem(menu, "\yBüdös \y\w3524 Ölés\y", "7", 0);
menu_additem(menu, "\ySzolga \y\w4100 Ölés\y", "7", 0);
menu_additem(menu, "\ysztár \y\w5200 Ölés\y", "7", 0);
menu_additem(menu, "\yRendfenttartó \y\w6000 Ölés\y", "7", 0);
menu_additem(menu, "\yBuzi \y\w6200 Ölés\y", "7", 0);
menu_additem(menu, "\yAlázó \y\w7200 Ölés\y", "7", 0);
menu_additem(menu, "\yGyilkos \y\w9132 Ölés\y", "7", 0);
menu_additem(menu, "\yI'm das PRO \y\w10040 Ölés\y", "7", 0);
menu_additem(menu, "\yKOCKA \y\w12000 Ölés\y", "7", 0);
menu_additem(menu, "\yBÜDÖS KOCKA \y\w14000 Ölés\y", "7", 0);
menu_additem(menu, "\yMy Hacker \y\w17000 Ölés\y", "7", 0);


menu_display(id, menu, 0);
return PLUGIN_HANDLED;
}
public bealitasok(id){
			
	new iMasodperc, iPerc, iOra, Nev[32];
	get_user_name(id, Nev, 31);
	iMasodperc = Masodpercek[id] + get_user_time(id);
	iPerc = iMasodperc / 60;
	iOra = iPerc / 60;
	iMasodperc = iMasodperc - iPerc * 60;
	iPerc = iPerc - iOra * 60;
	get_user_name(id, Nev, 31);
	new szMenu[121];
	format(szMenu, charsmax(szMenu), "\d\r%s \wProfil/Beállítások", Prefix);
	new menu = menu_create(szMenu, "hStatus");
	new String[131];

	formatex(szMenu, charsmax(szMenu), "Felhasználónév \r%s \d(Játékos neved: \r%s\d)", Felhasznalonev[id], Nev);
	menu_additem(menu, szMenu, "0", 0);
	formatex(szMenu, charsmax(szMenu), "Rangod: \r%s", Rangok[Rang[id]][Szint]);
	menu_additem(menu, szMenu, "1", 0);
	formatex(szMenu, charsmax(szMenu), "Kővetkező \rRangod: \d%s \y[\w%d/%d\y]", Rangok[Rang[id]+1][Szint], Oles[id], Rangok[Rang[id]][Xp]);
	menu_additem(menu, szMenu, "2", 0);
	formatex(szMenu, charsmax(szMenu), "Játszott idő: \r%d Órád %d Perc", iOra, iPerc);
	menu_additem(menu, szMenu, "3", 0);
	if(!Hud[id]) formatex(szMenu, charsmax(szMenu), "Szerver HUD: \rBE \y| \dKI");
	else formatex(szMenu, charsmax(szMenu), "Szerver HUD: \dBE \y| \rKI");
	menu_additem(menu, szMenu, "4", 0);
	if(!Gun[id]) formatex(szMenu, charsmax(szMenu), "Skinek: \rBE \y| \dKI");
	else formatex(szMenu, charsmax(szMenu), "Skinek: \dBE \y| \rKI");
	menu_additem(menu, szMenu, "5", 0);
	formatex(String, charsmax(String), "\ySkinek Visszaállítása Alaphelyzetbe");
	menu_additem(menu, String, "6",0);

	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public hStatus(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_CONTINUE;
	}

	if(item == 4) {
		if(!Hud[id]) Hud[id] = true;
		else Hud[id] = false;
	}
	if(item == 5) {
		if(!Gun[id]) Gun[id] = true;
		else Gun[id] = false;
	}
	if(item == 6) { 
			for(new i;i < MAX; i++)
			Skin[i][id] = 0;
			ColorChat(id, GREEN, "%s^1 Sikeresen visszaállítottad az összes skined az alap modellekre!", C_Prefix);
		}

	bealitasok(id);
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public LadaEloszto(id)
{
		new cim[121];
		format(cim, charsmax(cim), "[%s]^nLáda Nyitás", Prefix);
		new menu = menu_create(cim, "LadaEloszto_h");
		
		menu_additem(menu, "\y»\r{\yPremium Láda\r}", "1", 0);                            
		menu_additem(menu, "\y»\r{\yShadow Láda\r}", "2", 0);
		menu_additem(menu, "\y»\r{\yPlatinum Láda\r}", "3", 0);
		menu_additem(menu, "\y»\r{\yBronz Láda\r}", "4", 0);
		menu_additem(menu, "\y»\r{\yxYz Láda\r}", "5", 0);

		
		menu_display(id, menu, 0);
}
public LadaEloszto_h(id, menu, item){
		if(item == MENU_EXIT)
		{
			menu_destroy(menu);
			return;
		}
		
		new data[9], szName[64];
		new access, callback;
		menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
		new key = str_to_num(data);
		
		switch(key)
		{
			    case 1: Lada1(id);
				case 2: Lada2(id);
				case 3: Lada3(id);
				case 4: Lada4(id);
				case 5: Lada5(id);
			}
}
public Lada1(id)
{
		    new szMenu[121];
	        format(szMenu, charsmax(szMenu), "\d\r%s \wPremium Láda", Prefix);
	        new menu = menu_create(szMenu, "Lada1_h");
		
	        formatex(szMenu, charsmax(szMenu), "\wPremium \rLádád: \d[%d Darab\r]", Lada[0][id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\wKulcsod: \d[%d Darab\r]^n", Kulcs[id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\yPremium \wLáda \rVásárlás \d(-350$)");
	        menu_additem(menu, szMenu, "2", 0);
			formatex(szMenu, charsmax(szMenu), "\yKulcs \rVásárlás \d(-350$)^n^n");
	        menu_additem(menu, szMenu, "3", 0);
			formatex(szMenu, charsmax(szMenu), "\rNyitás");
	        menu_additem(menu, szMenu, "1", 0);
		
		menu_display(id, menu, 0);
}
public Lada1_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{	   
			case 1:
			{
				if(Lada[0][id] >= 1 && Kulcs[id] >= 1)
				{
					Lada[0][id]--;
					Kulcs[id]--;
					Talal(id);
					Lada1(id);
				}
				else
				{
					Lada1(id);
					ColorChat(id, GREEN, "%s ^1Nincs Ládád Vagy Kulcsod!!", C_Prefix);
			            }
		           }
		  case 2:
		{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Lada[0][id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Premium Ládát", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			                           }
			          }	 
			case 3:
			{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Kulcs[id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Kulcs-t!", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			     }
		}
	}	
}
public Lada2(id)
{
		    new szMenu[121];
	        format(szMenu, charsmax(szMenu), "\d\r%s \wShadow Láda", Prefix);
	        new menu = menu_create(szMenu, "Lada2_h");
		
	        formatex(szMenu, charsmax(szMenu), "\wShadow \rLádád: \d[%d Darab\r]", Lada[1][id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\wKulcsod: \d[%d Darab\r]^n", Kulcs[id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\yShadow \wLáda \rVásárlás \d(-350$)");
	        menu_additem(menu, szMenu, "2", 0);
			formatex(szMenu, charsmax(szMenu), "\yKulcs \rVásárlás \d(-350$)^n^n");
	        menu_additem(menu, szMenu, "3", 0);
			formatex(szMenu, charsmax(szMenu), "\rNyitás");
	        menu_additem(menu, szMenu, "1", 0);
		
		menu_display(id, menu, 0);
}
public Lada2_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{	   
			case 1:
			{
				if(Lada[1][id] >= 1 && Kulcs[id] >= 1)
				{
					Lada[1][id]--;
					Kulcs[id]--;
					Talal(id);
					Lada2(id);
				}
				else
				{
					Lada2(id);
					ColorChat(id, GREEN, "%s ^1Nincs Ládád Vagy Kulcsod!!", C_Prefix);
			            }
		           }
		  case 2:
		{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Lada[1][id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Shadow Ládát", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			                           }
			          }	 
			case 3:
			{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Kulcs[id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Kulcs-t!", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			     }
		}
	}	
}
public Lada3(id)
{
		    new szMenu[121];
	        format(szMenu, charsmax(szMenu), "\d\r%s \wPlatinum Láda", Prefix);
	        new menu = menu_create(szMenu, "Lada3_h");
		
	        formatex(szMenu, charsmax(szMenu), "\wPlatinum \rLádád: \d[%d Darab\r]", Lada[2][id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\wKulcsod: \d[%d Darab\r]^n", Kulcs[id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\yPlatinum \wLáda \rVásárlás \d(-350$)");
	        menu_additem(menu, szMenu, "2", 0);
			formatex(szMenu, charsmax(szMenu), "\yKulcs \rVásárlás \d(-350$)^n^n");
	        menu_additem(menu, szMenu, "3", 0);
			formatex(szMenu, charsmax(szMenu), "\rNyitás");
	        menu_additem(menu, szMenu, "1", 0);
		
		    menu_display(id, menu, 0);
}
public Lada3_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{	   
			case 1:
			{
				if(Lada[2][id] >= 1 && Kulcs[id] >= 1)
				{
					Lada[2][id]--;
					Kulcs[id]--;
					Talal(id);
					Lada3(id);
				}
				else
				{
					Lada3(id);
					ColorChat(id, GREEN, "%s ^1Nincs Ládád Vagy Kulcsod!!", C_Prefix);
			            }
		           }
		  case 2:
		{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Lada[2][id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Platinum Ládát", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			                           }
			          }	 
			case 3:
			{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Kulcs[id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Kulcs-t!", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			     }
		}
	}	
}
public Lada4(id)
{
		    new szMenu[121];
	        format(szMenu, charsmax(szMenu), "\d\r%s \wBronz Láda", Prefix);
	        new menu = menu_create(szMenu, "Lada4_h");
		
	        formatex(szMenu, charsmax(szMenu), "\wBronz \rLádád: \d[%d Darab\r]", Lada[3][id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\wKulcsod: \d[%d Darab\r]^n", Kulcs[id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\yBronz \wLáda \rVásárlás \d(-350$)");
	        menu_additem(menu, szMenu, "2", 0);
			formatex(szMenu, charsmax(szMenu), "\yKulcs \rVásárlás \d(-350$)^n^n");
	        menu_additem(menu, szMenu, "3", 0);
			formatex(szMenu, charsmax(szMenu), "\rNyitás");
	        menu_additem(menu, szMenu, "1", 0);
		
		    menu_display(id, menu, 0);
}
public Lada4_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{	   
			case 1:
			{
				if(Lada[3][id] >= 1 && Kulcs[id] >= 1)
				{
					Lada[3][id]--;
					Kulcs[id]--;
					Talal(id);
					Lada4(id);
				}
				else
				{
					Lada4(id);
					ColorChat(id, GREEN, "%s ^1Nincs Ládád Vagy Kulcsod!!", C_Prefix);
			            }
		           }
		  case 2:
		{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Lada[3][id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Bronz Ládát", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			                           }
			          }	 
			case 3:
			{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Kulcs[id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Kulcs-t!", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			     }
		}
	}	
}
public Lada5(id)
{
		    new szMenu[121];
	        format(szMenu, charsmax(szMenu), "\d\r%s \wxYz Láda", Prefix);
	        new menu = menu_create(szMenu, "Lada5_h");
		
	        formatex(szMenu, charsmax(szMenu), "\wxYz \rLádád: \d[%d Darab\r]", Lada[4][id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\wKulcs: \d[%d Darab\r]^n", Kulcs[id]);
	        menu_additem(menu, szMenu, "0", 0);
			formatex(szMenu, charsmax(szMenu), "\yxYz \wLáda \rVásárlás \d(-350$)");
	        menu_additem(menu, szMenu, "2", 0);
			formatex(szMenu, charsmax(szMenu), "\yKulcs \rVásárlás \d(-350$)^n^n");
	        menu_additem(menu, szMenu, "3", 0);
			formatex(szMenu, charsmax(szMenu), "\rNyitás");
	        menu_additem(menu, szMenu, "1", 0);
		
		menu_display(id, menu, 0);
}
public Lada5_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{	   
			case 1:
			{
				if(Lada[4][id] >= 1 && Kulcs[id] >= 1)
				{
					Lada[4][id]--;
					Kulcs[id]--;
					Talal(id);
					Lada5(id);
				}
				else
				{
					Lada5(id);
					ColorChat(id, GREEN, "%s ^1Nincs Ládád Vagy Kulcsod!!", C_Prefix);
			            }
		           }
		  case 2:
		{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Lada[4][id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 xYz Ládát", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			                           }
			          }	 
			case 3:
			{
			    if(Dollar[id] >= 350)
			    {
	            Dollar[id] -= 350;
				Kulcs[id] += 1;
				ColorChat(id, GREEN, "%s ^1Vettél +1 Kulcs-t!", C_Prefix);
			}
			else
			{
				ColorChat(id, GREEN, "%s ^1Nincs elég Dollárod", C_Prefix);
			     }
		}
	}	
}
public Talal(id)
{
new Nev[32]; get_user_name(id, Nev, 31);
new Float:Szam = random_float(0.01,100.0);
new FegyverID = random_num(0, 55);
new KesID = random_num(56, MAX);

if(Szam <= KESDROP)
{
	OsszesSkin[KesID][id]++;
	ColorChat(id, GREEN, "%s ^1Nyitottál egy ^4%s ^1skint", C_Prefix, Fegyverek[KesID]);
	ColorChat(0, GREEN, "%s ^3%s ^1Nyitott egy kést", C_Prefix, Nev);
}
else
{
	OsszesSkin[FegyverID][id]++;
	ColorChat(id, GREEN, "%s ^1Nyitottál egy ^4%s ^1skint", C_Prefix, Fegyverek[FegyverID]);
}
}
public Raktar(id)
{ 
    new String[121];
	formatex(String, charsmax(String), "%s \w- \dRaktár^n\dDollárod: \y%d$", Prefix, Dollar[id]);
	new menu = menu_create(String, "Raktar_h");
	
	for(new i;i < sizeof(Fegyverek); i++)
	{
		if(OsszesSkin[i][id] > 0)
		{
			new Sor[6]; num_to_str(i, Sor, 5);
			formatex(String, charsmax(String), "%s \d| \y%d DB", Fegyverek[i][0], OsszesSkin[i][id]);
			menu_additem(menu, String, Sor);
		}
	}
	menu_display(id, menu, 0);
}      
public Raktar_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key) {
		case 0: Skin[0][id] = 1;
		case 1: Skin[0][id] = 2;
		case 2: Skin[0][id] = 3;
		case 3: Skin[0][id] = 4;
		case 4: Skin[0][id] = 5;
		case 5: Skin[0][id] = 6;
		case 6: Skin[0][id] = 7;
		case 7: Skin[0][id] = 8;
		case 8: Skin[0][id] = 9;
		case 9: Skin[0][id] = 10;
		case 10: Skin[0][id] = 11;
		case 11: Skin[0][id] = 12;
		case 12: Skin[0][id] = 13;
		case 13: Skin[0][id] = 14;
		case 14: Skin[0][id] = 15;
		case 15: Skin[1][id] = 1;
		case 16: Skin[1][id] = 2;
		case 17: Skin[1][id] = 3;
		case 18: Skin[1][id] = 4;
		case 19: Skin[1][id] = 5;
		case 20: Skin[1][id] = 6;
		case 21: Skin[1][id] = 7;
		case 22: Skin[1][id] = 8;
		case 23: Skin[1][id] = 9;
		case 24: Skin[1][id] = 10;
		case 25: Skin[1][id] = 11;
		case 26: Skin[1][id] = 12;
		case 27: Skin[1][id] = 13;
		case 28: Skin[1][id] = 14;
		case 29: Skin[1][id] = 15;
		case 30: Skin[2][id] = 1;
		case 31: Skin[2][id] = 2;
		case 32: Skin[2][id] = 3;
		case 33: Skin[2][id] = 4;
		case 34: Skin[2][id] = 5;
		case 35: Skin[2][id] = 6;
		case 36: Skin[2][id] = 7;
		case 37: Skin[2][id] = 8;
		case 38: Skin[2][id] = 9;
		case 39: Skin[2][id] = 10;
		case 40: Skin[2][id] = 11;
		case 41: Skin[2][id] = 12;
		case 42: Skin[2][id] = 13;
		case 43: Skin[2][id] = 14;
		case 44: Skin[2][id] = 15;
		case 45: Skin[3][id] = 1;
		case 46: Skin[3][id] = 2;
		case 47: Skin[3][id] = 3;
		case 48: Skin[3][id] = 4;
		case 49: Skin[3][id] = 5;
		case 50: Skin[3][id] = 6;
		case 51: Skin[3][id] = 7;
		case 52: Skin[3][id] = 8;
		case 53: Skin[3][id] = 9;
		case 54: Skin[3][id] = 10;
		case 55: Skin[4][id] = 1;
		case 56: Skin[4][id] = 2;
		case 57: Skin[4][id] = 3;
		case 58: Skin[4][id] = 4;
		case 59: Skin[4][id] = 5;
		case 60: Skin[4][id] = 6;
		case 61: Skin[4][id] = 7;
		case 62: Skin[4][id] = 8;
		case 63: Skin[4][id] = 9;
		case 64: Skin[4][id] = 10;
		case 65: Skin[4][id] = 11;
		case 66: Skin[4][id] = 12;
		case 67: Skin[4][id] = 13;
}
}
public egyediprefixmenu(id)
{
    new String[121];
    if(VanPrefix[id] >= 1)
    {
    format(String, charsmax(String), "[%s]^n\wHasználatban lévő Prefixed: \r%s", Prefix, Chat_Prefix[id]);
    }
    else
    {
    format(String, charsmax(String), "[%s]^n\wHasználatban lévő Prefixed: \rNincs", Prefix);
    }
    new menu = menu_create(String, "h_Prefix");
   
    formatex(String, charsmax(String), "Prefix Hozzáadása \w[\y1000$/DB\w]^n^nHozzáadási lehetőségek: \r%d/%d", VanPrefix[id], LIMIT);
    menu_additem(menu, String, "1",0);
   
    menu_display(id, menu, 0);
}
 
public h_Prefix(id, menu, item)
{
if(item == MENU_EXIT)
{
menu_destroy(menu);
return;
}
 
new data[9], szName[64], Nev[32];
get_user_name(id, Nev, 31);
new access, callback;
menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
new key = str_to_num(data);
 
switch(key)
    {
			case 1:
        {
		    if(Dollar[id] >= 1000)
			{
            client_cmd(id, "messagemode Chat_Prefix");
			Dollar[id] -= 1000;
			ColorChat(id, GREEN, "%s^1Vettél egy prefixet! Semmi csúnya, és Adminhoz tartozó dolgot ne írj! = ^3Kitíltás Jár!", C_Prefix);
			}
			else
			{
			ColorChat(id, GREEN, "%s^1Nincs elég dollárod", C_Prefix);
			}
			}
			
    }
}
public Chat_Prefix_Hozzaad(id)
{
new Data[32];
new hosszusag = strlen(Data);
read_args(Data, charsmax(Data));
remove_quotes(Data);
 
if(hosszusag >= 7)
{
    Chat_Prefix[id] = Data;
    VanPrefix[id]++;
    egyediprefixmenu(id);
}
else
{
    Chat_Prefix[id] = Data;
    VanPrefix[id]++;
    egyediprefixmenu(id);
}
return PLUGIN_CONTINUE;	
}
public Piac(id)
{
	new String[121];
	format(String, charsmax(String), "%s \w- \dPiac^n\dDollár: \y%d$", Prefix, Dollar[id]);
	new menu = menu_create(String, "Piac_h");
	new PiacID = g_Market[0] + g_Market[1];
	
	if(g_Market[0] > 0 || g_Market[1] > 0) format(String,charsmax(String),"\y»\r{\yVásárlás\r}", PiacID);
	else 
	format(String,charsmax(String),"\y»\r{\yVásárlás\r}");
	menu_additem(menu,String,"1");
	menu_additem(menu, "\y»\r{\yBolt NEW\r}", "2", 0);
	menu_additem(menu, "\y»\r{\yEladás\r}", "6", 0);
	menu_additem(menu, "\y»\r{\yTárgy Küldés\r}", "4", 0);
	menu_additem(menu, "\y»\r{\ySkin Küldés\r}", "5", 0);
	menu_additem(menu, "\y»\r{\yLomtár\r}", "7", 0);


	menu_display(id, menu, 0);
}
public Piac_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1: Vasarlas(id);
		case 2: m_Bolt(id);
		case 4: SendMenu(id);
		case 5: SkinSend(id);
		case 6: Eladas(id);
		case 7: Kuka(id);
	}
}
public SkinSend(id) {
	new cim[121], Menu;
	Menu = menu_create("\y|#xyzskinek*| \w- \dKüldés", "SendHandlerSkin");
	
	for(new i;i < sizeof(Fegyverek); i++)
	{
		if(OsszesSkin[i][id] > 0)
		{
		new Sor[6]; num_to_str(i, Sor, 5);
		formatex(cim, charsmax(cim), "%s \d| \y%d DB", Fegyverek[i][0], OsszesSkin[i][id]);
		menu_additem(Menu, cim, Sor);
		}
	}
	
	menu_display(id, Menu, 0);
	return PLUGIN_HANDLED;
}
public SendHandlerSkin(id, Menu, item) {
	if(item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return PLUGIN_HANDLED;
	}
	
	new Data[9], szName[64];
	new access, callback;
	menu_item_getinfo(Menu, item, access, Data,charsmax(Data), szName,charsmax(szName), callback);
	new Key = str_to_num(Data);
	
	Send[id] = Key;
	
	PlayerChooseSkin(id);
	return PLUGIN_HANDLED;
}		
public SendMenu(id) 
{
	new String[121];
	format(String, charsmax(String), "%s \w- \dTárgyak Küldése", Prefix);
	new menu = menu_create(String, "SendHandler");
	
	format(String, charsmax(String), "Dollár \y%d$", Dollar[id]);
	menu_additem(menu, String, "0", 0);
	format(String, charsmax(String), "Kulcs \y%dDB", Kulcs[id]);
	menu_additem(menu, String, "1", 0);
        format(String, charsmax(String), "Coin \d[\r%d DB\d]", SMS[id]);
	menu_additem(menu, String, "2", 0);
	format(String, charsmax(String), "%s \d[\r%d \dDB]", LadaNevek[0][0], Lada[0][id]);
	menu_additem(menu, String, "4", 0);
	format(String, charsmax(String), "%s \d[\r%d \dDB]", LadaNevek[1][0], Lada[1][id]);
	menu_additem(menu, String, "5", 0);
	format(String, charsmax(String), "%s \d[\r%d \dDB]", LadaNevek[2][0], Lada[2][id]);
	menu_additem(menu, String, "6", 0);
	format(String, charsmax(String), "%s \d[\r%d \dDB]", LadaNevek[3][0], Lada[3][id]);
	menu_additem(menu, String, "7", 0);
	format(String, charsmax(String), "%s \d[\r%d \dDB]", LadaNevek[4][0], Lada[4][id]);
	menu_additem(menu, String, "8", 0);
	
	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public SendHandler(id, Menu, item) {
	if(item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return PLUGIN_HANDLED;
	}
	
	new Data[9], szName[64];
	new access, callback;
	menu_item_getinfo(Menu, item, access, Data,charsmax(Data), szName,charsmax(szName), callback);
	new Key = str_to_num(Data);
	
	Send[id] = Key+1;
	
	PlayerChoose(id);
	return PLUGIN_HANDLED;
}
public Eladas(id) {
	new cim[121], ks1[121], ks2[121];
	format(cim, charsmax(cim), "%s \w- \dEladás", Prefix);
	new menu = menu_create(cim, "eladas_h" );
	
	if(kirakva[id] == 0){
		for(new i=0; i < MAX; i++) {
			if(kicucc[id] == 0) format(ks1, charsmax(ks1), "\wVálaszd ki a Tárgyat!");
			else if(kicucc[id] == i) format(ks1, charsmax(ks1), "\wTárgy: \y%s", Fegyverek[i-1][0]);
		}
		menu_additem(menu, ks1 ,"0",0);
	}
	if(kirakva[id] == 0){
		format(ks2, charsmax(ks2), "\rÁra: \y%d$", Erteke[id]);
		menu_additem(menu,ks2,"1",0);
	}
	if(Erteke[id] != 0 && kirakva[id] == 0)
	{
		menu_additem(menu,"\wMehet a piacra!","2",0);
	}
	if(Erteke[id] != 0 && kirakva[id] == 1)
		menu_additem(menu,"\wVisszavonás","-2",0);
	
	menu_setprop(menu, MPROP_EXITNAME, "Kilépés");
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, menu, 0);
}
public eladas_h(id, menu, item){
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[9], szName[64], name[32];
	get_user_name(id, name, charsmax(name));
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{
		case -2:{
			kirakva[id] = 0;
			kicucc[id] = 0;
			Erteke[id] = 0;
		}
		case 0:{
			fvalaszt(id);
		}
		case 1:{
			client_cmd(id, "messagemode DOLLAR");
		}
		case 2:{
			for(new i=0; i < MAX; i++)
			{
				if(kicucc[id] == i && OsszesSkin[i-1][id] >= 1)
				{
					ColorChat(0, GREEN, "%s ^3%s ^1Kirakott egy ^3%s^1-t a piacra^3 %d$.", C_Prefix, name, Fegyverek[i-1][0], Erteke[id]);
					kirakva[id] = 1;
				}
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public Kuka(id)
{
	new String[121];
	formatex(String, charsmax(String), "%s \w- \dLomtár", Prefix);
	new menu = menu_create(String, "Kuka_h");
	
	for(new i;i < sizeof(Fegyverek); i++)
	{
		if(OsszesSkin[i][id] > 0)
		{
			new Sor[6]; num_to_str(i, Sor, 5);
			formatex(String, charsmax(String), "%s \d| \y%d DB", Fegyverek[i][0], OsszesSkin[i][id]);
			menu_additem(menu, String, Sor);
		}
	}
	menu_display(id, menu, 0);
}
public Kuka_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	OsszesSkin[key][id] --;
	ColorChat(id, GREEN, "%s ^1Törölted a ^3%s ^1skined.", C_Prefix, Fegyverek[key][0]);
	Kuka(id);
}
public PlayerChoose(id)
{
	new String[121];
	format(String, charsmax(String), "%s \w- \dVálassz Játékost", Prefix);
	new Menu = menu_create(String, "PlayerHandler");
	
	new players[32], pnum, tempid;
	new szName[32], szTempid[10];
	get_players(players, pnum);
	
	for( new i; i<pnum; i++ )
	{
		tempid = players[i];
		{
			get_user_name(tempid, szName, charsmax(szName));
			num_to_str(tempid, szTempid, charsmax(szTempid));
			menu_additem(Menu, szName, szTempid, 0);
		}
	}
	
	menu_display(id, Menu, 0);
	return PLUGIN_HANDLED;
}
public PlayerHandler(id, Menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(Menu);
		return PLUGIN_HANDLED;
	}
	new Data[6], szName[64];
	new access, callback;
	menu_item_getinfo(Menu, item, access, Data,charsmax(Data), szName,charsmax(szName), callback);
	TempID = str_to_num(Data);
	
	client_cmd(id, "messagemode KMENNYISEG");
	
	menu_destroy(Menu);
	return PLUGIN_HANDLED;
}
public PlayerChooseSkin(id)
{
	new Menu = menu_create("\y|#xyzskinek*|\w- \dVálassz Játékost", "PlayerHandlerSkin");
	new players[32], pnum, tempid;
	new szName[32], szTempid[10];
	get_players(players, pnum);
	
	for( new i; i<pnum; i++ )
	{
		tempid = players[i];
		{
			get_user_name(tempid, szName, charsmax(szName));
			num_to_str(tempid, szTempid, charsmax(szTempid));
			menu_additem(Menu, szName, szTempid, 0);
		}
	}
	
	menu_display(id, Menu, 0);
	return PLUGIN_HANDLED;
}
public PlayerHandlerSkin(id, Menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(Menu);
		return PLUGIN_HANDLED;
	}
	new Data[6], szName[64];
	new access, callback;
	menu_item_getinfo(Menu, item, access, Data,charsmax(Data), szName,charsmax(szName), callback);
	TempID = str_to_num(Data);
	
	client_cmd(id, "messagemode KMENNYISEGSKIN");
	
	menu_destroy(Menu);
	return PLUGIN_HANDLED;
}
public ObjectSendSkin(id)
{
	new Data[121];
	new SendName[32], TempName[32];
	
	read_args(Data, charsmax(Data));
	remove_quotes(Data);
	get_user_name(id, SendName, 31);
	get_user_name(TempID, TempName, 31);

	if(str_to_num(Data) < 1) 
		return PLUGIN_HANDLED;

	for(new i;i < MAX; i++) 
	{
		if(Send[id] == i && OsszesSkin[i][id] >= str_to_num(Data))
		{
			OsszesSkin[i][TempID] += str_to_num(Data);
			OsszesSkin[i][id] -= str_to_num(Data);
			ColorChat(0, GREEN, "%s ^3%s ^1Küldött %d^3 %s^1 skint^3 %s^1-nak.", C_Prefix, SendName, str_to_num(Data), Fegyverek[i], TempName);
		}
	}
	return PLUGIN_HANDLED;
}
public fvalaszt(id) {
	new szMenuTitle[ 121 ],cim[121];
	format( szMenuTitle, charsmax( szMenuTitle ), "%s \w- \dVálassz Fegyvert", Prefix);
	new menu = menu_create( szMenuTitle, "fvalaszt_h" );
	
	for(new i=0; i < MAX; i++) {
		if(OsszesSkin[i][id] > 0) {
			new Num[6];
			num_to_str(i, Num, 5);
			formatex(cim, charsmax(cim), "%s \d| \y%d DB", Fegyverek[i][0], OsszesSkin[i][id]);
			menu_additem(menu, cim, Num);
		}
	}
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, menu, 0);
	
}
public fvalaszt_h(id, menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	kicucc[id] = key+1;
	Eladas(id);
}
public lekeres(id) {
	new ertek, adatok[32];
	read_args(adatok, charsmax(adatok));
	remove_quotes(adatok);
	
	ertek = str_to_num(adatok);
	
	new hossz = strlen(adatok);
	
	if(hossz > 7)
	{
		client_cmd(id, "messagemode DOLLAR");
	}
	else if(ertek < 500)
	{
		ColorChat(id, GREEN, "%s ^1Nem tudsz eladni fegyvert ^3500? ^1alatt.", C_Prefix);
		Eladas(id);
	}
	else
	{
		Erteke[id] = ertek;
		Eladas(id);
	}
}
public Vasarlas(id)
{      
	new mpont[512], menu, cim[121];
	static players[32],temp[10],pnum;  
	get_players(players,pnum,"c");
	
	format(cim, charsmax(cim), "%s \w- \dVásárlás^n\dDollár: \y%d$", Prefix, Dollar[id]);
	menu = menu_create(cim, "vasarlas_h" );
	
	for (new i; i < pnum; i++)
	{
		if(kirakva[players[i]] == 1 && Erteke[players[i]] > 0)
		{
			for(new a=0; a < MAX; a++) {
				if(kicucc[players[i]] == a)
					formatex(mpont,256,"%s \rára: \y%d$", Fegyverek[a-1][0], Erteke[players[i]]);
			}
			
			num_to_str(players[i],temp,charsmax(temp));
			menu_additem(menu, mpont, temp);
		}
	}
	menu_setprop(menu, MPROP_PERPAGE, 6);
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL );
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}  
public vasarlas_h(id,menu, item){
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return;
	}
	if(pido != 0){
		Vasarlas(id);
		return;
	}
	new data[6] ,szName[64],access,callback;
	new name[32], name2[32];
	get_user_name(id, name, charsmax(name));
	
	menu_item_getinfo(menu, item, access, data, charsmax(data), szName, charsmax(szName), callback);
	
	new player = str_to_num(data);
	get_user_name(player, name2, charsmax(name2));
	pido = 2;
	set_task(2.0, "vido");
	
	for(new i=0; i < MAX; i++) {
		if(Dollar[id] >= Erteke[player] && kicucc[player] == i && kirakva[player] == 1)
		{
			kirakva[player] = 0;
			ColorChat(0, GREEN, "%s ^3%s ^1vett egy ^4%s^1-t ^3%s^1-tól ^4%d$^1-ért!",C_Prefix, name, Fegyverek[i-1][0], name2, Erteke[player]);
			Dollar[player] += Erteke[player];
			Dollar[id] -= Erteke[player];
			OsszesSkin[i-1][id] ++;
			OsszesSkin[i-1][player] --;
			kicucc[player] = 0;
			Erteke[player] = 0;
		}
	}
}
public vido()
{
	pido = 0;
}

public client_disconnect(id){
	if(!is_user_bot(id))
	{
		Update(id);
	}
       Belepve[id] = false;
       Beirtjelszot[id] = false;
       Beirtjelszot1[id] = false;
       Beirtfelhasznalot[id] = false;
       Beirtfelhasznalot1[id] = false;

      regFh[id][0] = EOS;
      regJelszo[id][0] = EOS;
      Felhasznalonev[id][0] = EOS;
      Jelszo[id][0] = EOS;
      g_Id[id] = 0;

      VanPrefix[id] = 0;
      Chat_Prefix[id] = "";
      Dollar[id] = 0;
      SMS[id] = 0;
	  arany[id] = 0;
	  g_MVP[id] = 0;
      Rang[id] = 0;
      Oles[id] = 0;
      Kulcs[id] = 0; 
      Masodpercek[id] = 0;
      Regisztralt[id] = 0;
	  g_Quest[id] = 0;
      g_QuestWeapon[id] = 0;
      g_QuestMVP[id] = 0;
      g_QuestHead[id] = 0;
      g_Erem[id] = 0;
      g_MatchesWon[id] = 0;

	for(new i;i < MAX; i++)
	OsszesSkin[i][id] = 0;

	for(new i;i < LADA; i++)
	Lada[i][id] = 0;

	copy(name[id], charsmax(name[]), "");
}

public client_putinserver(id){
	if(!is_user_bot(id))
	{
		get_user_name(id, name[id], charsmax(name));
		Load(id);
		Load_Register(id);
	}
	Gun[id] = true;
	Hud[id] = true;
	Belepve[id] = false;
	Felhasznalonev[id] = "";
	Jelszo[id] = "";
}

public plugin_cfg()
{
	g_SqlTuple = SQL_MakeDbTuple(SQLINFO[0], SQLINFO[1], SQLINFO[2], SQLINFO[3]);
	Create_Table_Register();
	Create_Table_Others();
}

public Create_Table_Register(){
	static Query[10048];
	new Len;
	
	Len += formatex(Query[Len], charsmax(Query), "CREATE TABLE IF NOT EXISTS `hwd_regtabla`");
	Len += formatex(Query[Len], charsmax(Query)-Len, "(`Nev` varchar(32) NOT NULL, ");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Felhasznalonev` varchar(32) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Jelszo` varchar(32) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Player_IP` varchar(35) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Player_SteamID` varchar(35) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Regisztralt` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY)");
	
	SQL_ThreadQuery(g_SqlTuple, "createTableThread", Query);
}

public Create_Table_Others(){
	static Query[10048];
	new Len;
	
	Len += formatex(Query[Len], charsmax(Query), "CREATE TABLE IF NOT EXISTS `hwd_cucmentes`");
	Len += formatex(Query[Len], charsmax(Query)-Len, "(`Nev` varchar(32) NOT NULL, ");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Masodpercek` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`SMS` int(11) NOT NULL,"); 
	Len += formatex(Query[Len], charsmax(Query)-Len, "`arany` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`MVP` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Dollars` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Szint` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Oles` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`DropOles` int(11) NOT NULL,");
        Len += formatex(Query[Len], charsmax(Query)-Len, "`vanprefix` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`prefixneve` varchar(32) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Vip` int(11) NOT NULL,");
		Len += formatex(Query[Len], charsmax(Query)-Len, "`QuestH` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`QuestMVP` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`QuestNeed` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`QuestHave` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`QuestWeap` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`QuestHead` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Jut1` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Jut2` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Jut3` int(11) NOT NULL,");
	Len += formatex(Query[Len], charsmax(Query)-Len, "`NyertM` int(11) NOT NULL,"); 
	
	for(new i;i < MAX; i++)
		Len += formatex(Query[Len], charsmax(Query)-Len, "`F%d` int(11) NOT NULL,", i);
	for(new i;i < LADA; i++)
		Len += formatex(Query[Len], charsmax(Query)-Len, "`L%d` int(11) NOT NULL,", i);
	for(new i;i < 11; i++)
		Len += formatex(Query[Len], charsmax(Query)-Len, "`S%d` int(11) NOT NULL,", i);
	
	Len += formatex(Query[Len], charsmax(Query)-Len, "`Kulcs` int(11) NOT NULL, `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY)");
	
	SQL_ThreadQuery(g_SqlTuple, "createTableThread", Query);
}

public Load(id) {
	static Query[10048];
	new Data[1], Name[32];
	get_user_name(id, Name, 31);
	Data[0] = id;

	formatex(Query, charsmax(Query), "SELECT * FROM `hwd_cucmentes` WHERE Nev = ^"%s^";", name[id]);
	SQL_ThreadQuery(g_SqlTuple, "QuerySelectData", Query, Data, 1);
}

public QuerySelectData(FailState, Handle:Query, Error[], Errcode, Data[], DataSize, Float:Queuetime) {
	if(FailState == TQUERY_CONNECT_FAILED || FailState == TQUERY_QUERY_FAILED) {
		log_amx("%s", Error);
		return;
	}
	else {
		new id = Data[0];
 
		if(SQL_NumRows(Query) > 0) {
			Rang[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Szint"));
			Dollar[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Dollars"));
			SMS[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "SMS"));
			arany[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "arany"));
			g_MVP[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "MVP"));
			Oles[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Oles"));
			D_Oles[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "DropOles"));
			Vip[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Vip"));
			Masodpercek[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Masodpercek"));
                        VanPrefix[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "vanprefix"));
			SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "prefixneve"), Chat_Prefix[id], charsmax(Chat_Prefix[]));
						g_Quest[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "QuestH"));
				g_QuestKills[0][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "QuestNeed"));
				g_QuestKills[1][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "QuestHave"));
				g_QuestWeapon[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "QuestWeap"));
				g_QuestHead[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "QuestHead"));
				g_QuestMVP[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "QuestMVP"));
				g_Jutalom[0][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Jut1"));
				g_Jutalom[1][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Jut2"));
				g_Jutalom[2][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Jut3"));
			g_MatchesWon[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "NyertM"));
			
			for(new i;i < MAX; i++)
			{
				new String[64];
				formatex(String, charsmax(String), "F%d", i);
				OsszesSkin[i][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, String));
			}
			for(new i;i < LADA; i++)
			{
				new String[64];
				formatex(String, charsmax(String), "L%d", i);
				Lada[i][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, String));
			}
			for(new i;i < 11; i++)
			{
				new String[64];
				formatex(String, charsmax(String), "S%d", i);
				Skin[i][id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, String));
			}
			
			Kulcs[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Kulcs"));
		}
		else
		{
			Save(id);
		}
	}
}

public Load_Register(id){
	static Query[10048];
	new Data[1], Name[32];
	get_user_name(id, Name, 31);
	Data[0] = id;

	formatex(Query, charsmax(Query), "SELECT * FROM `hwd_regtabla` WHERE Nev = ^"%s^";", name[id]);
	SQL_ThreadQuery(g_SqlTuple, "QuerySelectDataRegister", Query, Data, 1);
}

public QuerySelectDataRegister(FailState, Handle:Query, Error[], Errcode, Data[], DataSize, Float:Queuetime) {
	if(FailState == TQUERY_CONNECT_FAILED || FailState == TQUERY_QUERY_FAILED) {
		log_amx("%s", Error);
		return;
	}
	else {
		new id = Data[0];
 
		if(SQL_NumRows(Query) > 0) {
			SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Felhasznalonev"), regFh[id], charsmax(regFh[]));
			SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Jelszo"), regJelszo[id], charsmax(regJelszo[]));
			Regisztralt[id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "Regisztralt"));
		}
		else
		{
			Save_Register(id);
		}
	}
}

public Save(id){
	static Query[256];
	 
	formatex(Query, charsmax(Query), "INSERT INTO `hwd_cucmentes` (`Nev`) VALUES (^"%s^");", name[id]);
	SQL_ThreadQuery(g_SqlTuple, "QuerySetData", Query);
}

public Save_Register(id){
	static Query[256];
	
	new sPlayer_IP[35], sPlayer_SteamID[35];
	get_user_ip(id, sPlayer_IP, charsmax(sPlayer_IP), 1);
	get_user_authid(id, sPlayer_SteamID, charsmax(sPlayer_SteamID));
	
	formatex(Query, charsmax(Query), "INSERT INTO `hwd_regtabla` (`Nev`, `Player_IP`, `Player_SteamID` ) VALUES (^"%s^", ^"%s^", ^"%s^");", name[id], sPlayer_IP, sPlayer_SteamID);
	SQL_ThreadQuery(g_SqlTuple, "QuerySetData", Query);
}

public SQL_Update_Reg(id){
	static Query[10048];
	new Len;

	Len += formatex(Query[Len], charsmax(Query), "UPDATE `hwd_regtabla` SET Felhasznalonev = ^"%s^", ", regFh[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Jelszo = ^"%s^", ", regJelszo[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Regisztralt = ^"%i^" WHERE Nev = ^"%s^";", Regisztralt[id], name[id]);

	SQL_ThreadQuery(g_SqlTuple, "QuerySetData", Query);
}

public Update(id)
{
	static Query[10048];
	new Len;
	
	Len += formatex(Query[Len], charsmax(Query), "UPDATE `hwd_cucmentes` SET Dollars = ^"%i^", ",Dollar[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Szint = ^"%i^", ", Rang[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Oles = ^"%i^", ", Oles[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "DropOles = ^"%i^", ", D_Oles[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Masodpercek = ^"%i^", ", Masodpercek[id]+get_user_time(id));
	Len += formatex(Query[Len], charsmax(Query)-Len, "SMS = ^"%i^", ", SMS[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "arany = ^"%i^", ", arany[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "MVP = ^"%i^", ", g_MVP[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Vip = ^"%i^", ", Vip[id]-get_user_time(id));
       	Len += formatex(Query[Len], charsmax(Query)-Len, "vanprefix = ^"%i^", ", VanPrefix[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "prefixneve = ^"%s^", ", Chat_Prefix[id]);
		Len += formatex(Query[Len], charsmax(Query)-Len, "QuestH = '%i', ", g_Quest[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "QuestMVP = '%i', ", g_QuestMVP[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "QuestNeed = '%i', ", g_QuestKills[0][id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "QuestHave = '%i', ", g_QuestKills[1][id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "QuestWeap = '%i', ", g_QuestWeapon[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "QuestHead = '%i', ", g_QuestHead[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Jut1 = '%i', ", g_Jutalom[0][id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Jut2 = '%i', ", g_Jutalom[1][id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Jut3 = '%i', ", g_Jutalom[2][id]); 
	Len += formatex(Query[Len], charsmax(Query)-Len, "NyertM = '%i', ", g_MatchesWon[id]); 
	
	for(new i=0;i < MAX; i++)
		Len += formatex(Query[Len], charsmax(Query)-Len, "F%d = ^"%i^", ", i, OsszesSkin[i][id]);
		
	for(new i;i < LADA; i++)
		Len += formatex(Query[Len], charsmax(Query)-Len, "L%d = ^"%i^", ", i, Lada[i][id]);
		
	for(new i;i < 11; i++)
		Len += formatex(Query[Len], charsmax(Query)-Len, "S%d = ^"%i^", ", i, Skin[i][id]);
	
	Len += formatex(Query[Len], charsmax(Query)-Len, "Kulcs = ^"%i^" WHERE Nev = ^"%s^";", Kulcs[id], name[id]);
	
	SQL_ThreadQuery(g_SqlTuple, "QuerySetData", Query);
}

public createTableThread(FailState, Handle:Query, Error[], Errcode, Data[], DataSize, Float:Queuetime) {
	if(FailState == TQUERY_CONNECT_FAILED)
		set_fail_state("[HIBA*] NEM TUDTAM CSATLAKOZNI AZ ADATBAZISHOZ!");
	else if(FailState == TQUERY_QUERY_FAILED)
		set_fail_state("Query Error");
	if(Errcode)
		log_amx("[HIBA*] HIBAT DOBTAM: %s",Error);
}

public QuerySetData(FailState, Handle:Query, Error[], Errcode, Data[], DataSize, Float:Queuetime) {
	if(FailState == TQUERY_CONNECT_FAILED || FailState == TQUERY_QUERY_FAILED) {
		log_amx("%s", Error);
		return;
	}
}

public plugin_end() {
	SQL_FreeHandle(g_SqlTuple);
}
public sayhook(id)
{
if(!Belepve[id])
	{
		ColorChat(id, GREEN, "^4%s ^1Először jelenkezz be!",C_Prefix);
		return PLUGIN_HANDLED;
	}
	new message[192], Name[32], none[2][32], chat[192];
	read_args(message, 191);
	remove_quotes(message);
	
	formatex(none[0], 31, ""), formatex(none[1], 31, " ");
	
	if (message[0] == '@' || message[0] == '/' || message[0] == '#' || message[0] == '!' || equal (message, ""))
		return PLUGIN_HANDLED;
	
	if(!equali(message, none[0]) && !equali(message, none[1]))
	{
		get_user_name(id, Name, 31);
		if(is_user_alive(id))
		{
 			if(Regisztralt[id] == 0)
			formatex(chat, 191, "^x04[Nem Regisztrált]^x03%s^x01: %s", Name, message);
			else if(get_user_flags(id) & TULAJ && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x04[Tulajdonos][%s][%s]^3%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & TULAJ && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x04[Tulajdonos][%s]^3%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
                        else if(get_user_flags(id) & FOADMIN && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x04[Föadmin][%s][%s]^x03%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & FOADMIN && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x04[Föadmin][%s]^x03%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & ADMIN && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x04[Admin][%s][%s]^x03%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & ADMIN && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x04[Admin][%s]^x03%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & VIP && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x04[VIP][%s][%s]^x03%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & VIP && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x04[VIP][%s]^x03%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(is_user_alive(id) && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x04[%s][%s]^x03%s^x01: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(is_user_alive(id) && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x04[Játékos][%s]^x03%s^x01: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(Regisztralt[id] == 1)
				formatex(chat, 191, "^x04[Kijelentkezve]^x03 %s^x01: %s", Name, message);
		}
		else {
			get_user_team(id, color, 9);
			if(Regisztralt[id] == 0)
			formatex(chat, 191, "^x01*Halott*^x04[Nem Regisztrált]^x03 %s^x01: %s", Name, message);
			else if(get_user_flags(id) & TULAJ && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x01*Halott*^x04[Tulajdonos][%s][%s]^3%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & TULAJ && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x01*Halott*^x04[Tulajdonos][%s]^3%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
                        else if(get_user_flags(id) & FOADMIN && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x01*Halott*^x04[Föadmin][%s][%s]^x03%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & FOADMIN && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x01*Halott*^x04[Föadmin][%s]^x03%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
                        else if(get_user_flags(id) & ADMIN && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x01*Halott*^x04[Admin][%s][%s]^x03%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & ADMIN && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x01*Halott*^x04[Admin][%s]^x03%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & VIP && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x01*Halott*^x04[VIP][%s][%s]^x03%s^x04: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(get_user_flags(id) & VIP && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x01*Halott*^x04[VIP][%s]^x03%s^x04: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(Dollar[id] >= 0 && VanPrefix[id] >= 1)
				formatex(chat, 191, "^x01*Halott*^x04[%s][%s]^x03%s^x01: %s", Chat_Prefix[id], Rangok[Rang[id]][Szint], Name, message);
			else if(Dollar[id] >= 0 && VanPrefix[id] >= 0)
				formatex(chat, 191, "^x01*Halott*^x04[Játékos][%s]^x03%s^x01: %s", Rangok[Rang[id]][Szint], Name, message);
			else if(Regisztralt[id] == 1)
				formatex(chat, 191, "^x01*Halott*^x04[Kijelentkezve]^x03 %s^x01: %s", Name, message);
		}
		
		
		switch(cs_get_user_team(id))
		{
			case 1: ColorChat(0, RED, chat);
			case 2: ColorChat(0, BLUE, chat);
		}
		if(cs_get_user_team(id) == CS_TEAM_SPECTATOR)
			ColorChat(0, GREY, chat);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}
public sendmessage(color[])
{
	new teamName[10];
	for(new player = 1; player < get_maxplayers(); player++)
	{
		get_user_team (player, teamName, 9);
		teamf (player, color);
		elkuldes(player, Temp);
		teamf(player, teamName);
	}
}
public teamf(player, team[])
{
	message_begin(MSG_ONE, get_user_msgid("TeamInfo"), _, player);
	write_byte(player);
	write_string(team);
	message_end();
}
public elkuldes(player, Temp[])
{
	message_begin( MSG_ONE, get_user_msgid( "SayText" ), _, player);
	write_byte( player );
	write_string( Temp );
	message_end();
}
public RoundEnds()
{
	new players[32], num;
	get_players(players, num);
	SortCustom1D(players, num, "SortMVPToPlayer");
 
	TopMvp = players[0];
 
	new mvpName[32];
	get_user_name(TopMvp, mvpName, charsmax(mvpName));
	
	ColorChat(0, GREEN, "[~xYz*] ^1Ebben a körben a legjobb játékos ^3%s ^1volt! ^1(^4+1 MVP^1)", mvpName);
	g_MVP[TopMvp]++;
}
public SortMVPToPlayer(id1, id2){
	if(g_MVPoints[id1] > g_MVPoints[id2]) return -1;
	else if(g_MVPoints[id1] < g_MVPoints[id2]) return 1;
 
	return 0;
}
public Quest(id)
{
	new HeadShot = read_data(3);
	new randomCaseAll = random_num(0,4);
	new name[32]; get_user_name(id, name, charsmax(name));
	
	if(g_QuestHead[id] == 1 && (HeadShot))
{
	if(g_QuestWeapon[id] == 5) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 4 && get_user_weapon(id) == CSW_USP) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 3 && get_user_weapon(id) == CSW_DEAGLE) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 2 && get_user_weapon(id) == CSW_AWP) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 1 && get_user_weapon(id) == CSW_M4A1) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 0 && get_user_weapon(id) == CSW_AK47) g_QuestKills[1][id]++;
}
if(g_QuestHead[id] == 0)
{
	if(g_QuestWeapon[id] == 5) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 4 && get_user_weapon(id) == CSW_USP) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 3 && get_user_weapon(id) == CSW_DEAGLE) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 2 && get_user_weapon(id) == CSW_AWP) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 1 && get_user_weapon(id) == CSW_M4A1) g_QuestKills[1][id]++;
	else if(g_QuestWeapon[id] == 0 && get_user_weapon(id) == CSW_AK47) g_QuestKills[1][id]++;
}
	
	if(g_QuestKills[1][id] >= g_QuestKills[0][id])
	{
		Dollar[id] += g_Jutalom[0][id];
		Lada[randomCaseAll][id] += g_Jutalom[1][id];
		Kulcs[id] += g_Jutalom[2][id];
		Lada[randomCaseAll][id] += g_Jutalom[3][id];
		g_QuestMVP[id]++;
		
		g_QuestKills[1][id] = 0;
		g_QuestWeapon[id] = 0;
		
		g_Quest[id] = 0;
		ColorChat(id, GREEN, "%s ^1A küldetésre kapott jutalmakat megkaptad.", C_Prefix);
		ColorChat(0, GREEN, "%s  ^3%s^1 befejezte a kiszabott küldetéseket. A jutalmakat megkapta", C_Prefix, name);
	}
}
public bomb_planted(id) 
{
    new randomDollar = random_num(3,60);
	new randomsms = random_num(1,15);
	new nev[32]; get_user_name(id, nev, 31);
	g_MVPoints[id] += 3;
	arany[id] += 3;
	Dollar[id] += randomDollar;
	client_cmd(0, "spk rtd_team/planted.wav");
	SMS[id] += randomsms;
	ColorChat(0, GREEN, "%s ^3%s ^1élesítette a bombát kapott (^4+ %d ^3Dollár^1 +^4 %d ^3~Coin* Pont^1)", C_Prefix, nev, randomDollar, randomsms);
}
public bomb_defused(id) 
{
    new randomDollar = random_num(3,60);
	new randomsms = random_num(1,15);
	new nev[32]; get_user_name(id, nev, 31);
	g_MVPoints[id] += 3;
	arany[id] += 4;
	Dollar[id] += randomDollar;
	SMS[id] += randomsms;
	ColorChat(0, GREEN, "%s ^3%s ^1hatástalanította a bombát kapott (^4+ %d ^3Dollárt^1 +^4 %d ^3~Prémium* Pont^1)", C_Prefix, nev, randomDollar, randomsms);	
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1038\\ f0\\ fs16 \n\\ par }
*/

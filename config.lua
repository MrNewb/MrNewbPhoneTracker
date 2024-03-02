--		___  ___       _   _                  _      _____              _         _        		
--		|  \/  |      | \ | |                | |    /  ___|            (_)       | |       		
--		| .  . | _ __ |  \| |  ___ __      __| |__  \ `--.   ___  _ __  _  _ __  | |_  ___ 		
--		| |\/| || '__|| . ` | / _ \\ \ /\ / /| '_ \  `--. \ / __|| '__|| || '_ \ | __|/ __|		
--		| |  | || |   | |\  ||  __/ \ V  V / | |_) |/\__/ /| (__ | |   | || |_) || |_ \__ \		
--		\_|  |_/|_|   \_| \_/ \___|  \_/\_/  |_.__/ \____/  \___||_|   |_|| .__/  \__||___/		
--                                                                  | |              			
--                                                                  |_|              			
--		  Need support? Join our Discord server for help: https://discord.gg/d3Kh2vz3a7
Config = {
	Framework = "qb",											-- set this to either "qb" or "esx"
	Debug = true,												-- set this to true to enable debug mode
	RequiredJob = "police",										-- This is the job name itl check for when using the tracker
	TrackerItem = "tracker",									-- The itemname that would be used for this to work
	Logs = false,												-- set this to the name of the method, pass as string. options are "qb","ox", set to false to disable like Logs = false,
	Notify = "ox",												-- set this to the name of the method, pass as string. options are "ox","qb","ok","sd", "brutal", "mythic", "pnotify"
	Input = "ox",												-- set this to the name of the method, pass as string. options are "ox","qb"
	Phone = "NPWD",												-- set this to the name of the method, pass as string. options are "NPWD","lbphone", "RenewedPhone","OldQsPhone","NewQsPhone","QbPhone","yflip", "RoadPhone", "gks","okok", "jpPhone"
	Alert = "Standalone",										-- set this to the name of the method, pass as string. options are "PsDispatch","Standalone","cd_Dispatch","qs_Dispatch"
	Placeholder = "281-330-8004",								-- This is the placeholder for the inputted phone numbers in oxinput if using it
	Icon = "fas fa-phone",										-- This is the icon that would be used in oxinput if using it
}
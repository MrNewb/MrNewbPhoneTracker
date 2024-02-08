Config = {
	ox_lib = true,											-- set this to true if using ox_lib, if false comment it out in the manifestas well
	Debug = false,          								-- set this to turn on prints
	RequiredJob = "police",									-- This is the job name itl check for and requires the job lock to be true to use
	TrackerItem = "tracker",								-- The item that would be used for this to work

	Logs = {
		EnableLogs = true,										-- set this to true if you want to use logging
		OxLogs = true,											-- set this to true if you want to use ox logs, logging must be enabled for this to work
		QbLogs = false,											-- set this to true if you want to use qb logs, logging must be enabled for this to work
	},

	Notify = {
		OxNotify = true,  										-- set this to true if you want to use ox notifications
		QBNotify = false,  										-- set this to true if you want to use qb notifications
		OKNotify = false,  										-- set this to true if you want to use okok notifications
		SDNotify = false,  										-- set this to true if you want to use SD notifications
	},

	Input = {
		OxInput = true,											-- set this to true if using ox_lib, if false comment it out in the manifest
		QbInput = false,										-- set this to true if using QbInput
	},

	Phone = {
		lbphone = false,										-- set this to true if using lb-phone, thank you loaf for exports that make shit easy
		QbPhone = false,										-- set this to true if using qb-phone or renewed
		NPWD = true,											-- set this to true if using npwd
		QsPhone = false,										-- set this to true if using this...phone
	},

	Alert = {
		PsDispatch = true,										-- set this to true if using this
		Standalone = false,										-- set this to true if using this
		cd_Dispatch = false,									-- set this to true if using this
		qs_Dispatch = false,									-- set this to true if using this
	},

}
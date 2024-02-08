# MrNewbPhoneTracker

MrNewbPhoneTracker is a resource designed to provide a simple and free alternative for tracking phones within your FiveM server. It features an item called "tracker" that, upon use, prompts the user to search and ping a number to see its current location.

I have only tested this on QBX and it worked with the framework functions provided in defualt qb, this is always subject to change.:

## Features

- **Tracker Item**: The resource introduces an item called "tracker" that allows users to search and ping a number for its current location.
- **Job Locking**: The tracker item is job-locked and configurable according to your server's needs.
- **Compatibility**: MrNewbPhoneTrackers is compatible with qb-inventory, ps inventory, and ox_inventory, as well as most other inventories that are qb-based.
- **Community Contribution**: Created as a free alternative, MrNewbPhoneTrackers aims to be a community contribution, offering simplicity and ease of use.
- **Tested Integration**: Compatibility has been tested with qb-phone and npwd, with additional compatibility for qs phone, although optimizations for the latter could be improved.

## Compatibility

- **phones**: MrNewbPhoneTrackers is compatible qb-phone/renewed, npwd, lb-phone, and qs-smartphonepro (at this time).
- **frameworks**: MrNewbPhoneTrackers is compatible qb-core and qbox (at this time).


## NPWD Compatibility Notes

- **Framework Functions**: This resource does not fully leverage QB's framework functions, requiring additional queries for any functionality.

## QS Phone Compatibility Notes

When integrating MrNewbPhoneTracker with the QS Phone, please consider the following:

- **Creator Exports**: The creator does not offer exports like LB, which may affect compatibility with certain functions.
- **Framework Functions**: This resource does not fully leverage QB's framework functions, requiring additional queries for any functionality.
- **Dissapointment**: This resource may have breaking updates on compatability at some point and the method ive used for queries is awful.

## Untested dispatch Compatibility Notes

- **qs dispatch**: Completely untested

- **cd_dispatch**: Completely untested

## Usage

To use MrNewbPhoneTracker, simply install the resource on your FiveM server and configure it according to your preferences in the Config file. 
The tracker item should be available for use by players with the appropriate job permissions (policejob by defualt).

## Contribution

Contributions to MrNewbPhoneTracker are welcome! If you have any suggestions, improvements, or bug fixes, feel free to submit a pull request or open an issue on GitHub.

## Credits

- **Testing on QS Phone**: Special thanks to OnlyCure for testing MrNewbPhoneTracker compatibility with the QS Phone. Your contributions are appreciated!
- **Testing on QB Phone**: Special thanks to inightm4r3 for testing MrNewbPhoneTracker compatibility with the QB Phone. Your contributions are appreciated!
- **Testing on LB Phone**: Special thanks to PriceAlbert for testing MrNewbPhoneTracker compatibility with the LB Phone. Your contributions are appreciated!


## Item Configuration for Old-QBCore/QBX
```lua

	['tracker'] 				 	 = {['name'] = 'tracker', 						['label'] = 'tracker', 		    	 			 ['weight'] = 200, 		['type'] = 'item', 		['image'] = 'tracker.png', 					['unique'] = true,		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,                     ['description'] = 'Property Of LSPD'},

```

## Item Configuration for new-QBCore
```lua

	tracker							= {name = 'tracker',							label = 'tracker',								weight = 200,         	type = 'item',         	image = 'tracker.png',						unique = true,        	useable = true,     	shouldClose = true,       	combinable = nil,                     	description = 'Property Of LSPD'},

```

## Item Configuration for ox_inventory
```lua

	["tracker"] = {
		label = "tracker",
		weight = 200,
		stack = false,
		close = true,
		description = "Property Of LSPD",
	},

```
## Resource support

- **Discord**: I threw up a bland discord to kinda aim for ideas on future releases, mainly just qol stuff and requests that sound fun. Open to collaborations with anyone.

https://discord.gg/ZBKYxB6PzA
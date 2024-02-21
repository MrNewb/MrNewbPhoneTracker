# MrNewbPhoneTracker

MrNewbPhoneTracker is a resource designed to provide a simple and free alternative for tracking phones within your FiveM server. It features an item called "tracker" that, upon use, prompts the user to search and ping a number to see its current location.

I have only tested this on QBX and it worked with the framework functions provided in defualt qb, this is always subject to change.:

## Features

- **Tracker Item**: The resource introduces an item called "tracker" that allows users to search and ping a number for its current location.
- **Job Locking**: The tracker item is job-locked and configurable according to your server's needs.
- **Community Contribution**: Created as a free alternative, MrNewbPhoneTrackers aims to be a community contribution, offering simplicity and ease of use.

## Compatibility

- **phones**: MrNewbPhoneTrackers is compatible qb-phone, renewed, npwd, lb-phone, gks-phone, yflip, RoadPhone, okok-phone, Jp-Phone, old qs-phone and qs-smartphonepro.

- **frameworks**: MrNewbPhoneTrackers is compatible qb-core and qbox.

## QS Smart Phone Pro Compatibility Notes

When integrating MrNewbPhoneTracker with the QS Phone, please consider the following:

- **Creator Exports**: The creator does not offer exports like LB/okok/gks, which may affect compatibility with certain functions.
- **Framework Functions**: This resource does not fully leverage QB's framework functions, requiring additional queries for functionality with this resource.

## YFlip Phone Compatibility Notes

When integrating MrNewbPhoneTracker with the Yflip Phone, please consider the following:

- **Creator Exports**: The creator does not offer exports like LB/okok/gks, which may affect compatibility with certain functions.
- **Framework Functions**: This resource does not fully leverage QB's framework functions, requiring additional queries for functionality with this resource.

## Untested phone Compatibility Notes

- **okok phone**: Completely untested

- **yflip phone**: Completely untested

- **gks-phone**: Completely untested

- **RoadPhone**: Completely untested

## Untested dispatch Compatibility Notes

- **qs dispatch**: Completely untested

- **cd_dispatch**: Completely untested

## Usage

To use MrNewbPhoneTracker, simply install the resource on your FiveM server and configure it according to your preferences in the Config file. 
The tracker item should be available for use by players with the appropriate job permissions (policejob by defualt).

## Contribution

Contributions to MrNewbPhoneTracker are welcome! If you have any suggestions, improvements, or bug fixes, feel free to submit a pull request or open an issue on GitHub.

## Credits

- **Testing on QS Phone**: Thanks to OnlyCure for testing MrNewbPhoneTracker compatibility with the QS Phone.
- **Testing on QB Phone**: Thanks to inightm4r3 for testing MrNewbPhoneTracker compatibility with the QB Phone.
- **Testing on LB Phone**: Thanks to PriceAlbert for testing MrNewbPhoneTracker compatibility with the LB Phone.
- **Better Bridge Methods**: Thanks to Crowley for giving me feedback on improving my bridge functions to return the events vs just passing the events.
- **Better Config Method**: Thanks to Kody for giving me feedback on improving my bridge functions to pass a string vs all the tables in config.


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

extends Node

var selected_mission: int = 0
var intel_collected: bool = false
var mission_complete: bool = false

const MISSIONS := [
    {"title":"DEAD SIGNAL", "location":"Northern mountain border", "objective":"Recover the missing team's encrypted field drive."},
    {"title":"COLD ENTRY", "location":"Remote research facility", "objective":"Rescue an engineer and obtain access credentials."},
    {"title":"BROKEN CONVOY", "location":"Forest highway", "objective":"Intercept the convoy and secure its data case."},
    {"title":"BLACK SITE", "location":"Underground complex", "objective":"Access the communications architecture and escape."},
    {"title":"ECHOES IN THE CITY", "location":"Industrial city district", "objective":"Track the broker and retrieve the hidden ledger."},
    {"title":"IRON VEIL", "location":"Coastal airfield", "objective":"Disable the network relay before transport departs."},
    {"title":"THE LAST KEY", "location":"Offshore platform", "objective":"Secure the master key and decide the server's fate."},
    {"title":"BLACK HORIZON", "location":"Mountain command station", "objective":"Stop activation and expose the conspiracy."}
]

func reset_mission() -> void:
    intel_collected = false
    mission_complete = false

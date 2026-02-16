package knowledge

import (

	"github.com/..../models/model.go"
)

// Enumerate all known android premissions and their metadata
var PermissionDB = map[string]models.PermissionInfo {
	// related to location
	"android.permission.ACCESS_FINE_LOCATION":{
		Name: "", Group: "Location",
		Description: "", DangerLevel: models.DangerDangerous, DangerLabel: "dangerous",
		PotentialRisk: []string{"Tracking user movements" ,"", ""...},
	},
	
	// related to camera & microphone

	// related to contacts

	// related to phone

	// reloated to messages (SMS)

	// related to storage

	// related to sensors

	// related to network

	// special permission refered to root privileges 
}


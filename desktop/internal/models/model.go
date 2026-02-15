package model

import ()

// classification of a permission by dangerousness
type DangerLevel int
const (
	DangerNormal DangerLevel = 0
	DangerWarning DangerLevel = 1
	DangerDangerous DangerLevel = 2
	DangerCritical DangerLevel = 3
)

func (d DangerLevel) String() string{
	switch d {
	case DangerWarning:
		return "warning"
	case DangeDangerous:
		return "dangerous"
	case DangerCritical:
		return "critical"
	default:
		return "normal"
	}
}

// Severity of permission finding on device
type FindingSeverity string
const (
	SeverityInfo FindingSeverity = "info"
	SeverityLow FindingSeverity = "low"
	SeverityMedium FindingSeverity = "medium"
	SeverityHigh FindingSeverity = "high"
	SeverityCritical FindingSeverity = "critical"
)


// protection model level
type DefenseLevel int
const (
	DefenseAdvisory DefenseLevel = 1
	DefenseAssisted DefenseLevel = 2
	DefenseEnforcement DefenseLevel = 3
)


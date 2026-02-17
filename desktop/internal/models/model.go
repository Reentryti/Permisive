package model

import ("time")

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

// permission metadata
type PermissionInfo struct{
	Name string `json:"name"`
	Group string `json:"group"`
	Description string `json:"description"`
	DangerLevel DangerLevel `json:"danger_level"`
	DangerLabel string `json:"danger_lable"`
	Abuse []string `json:"potiental_abuse,omitempty"`
}

// expected permission for an app category
type AppCategory struct{
	Name string `json:"name"`
	Icon string `json:"ison"`
	RequiredPermissions []string `json:"required_permissions"`
	OptionalPermissions []string `json:"optional_permissions"`
	SuspiciousPermissions []string `json:"suspicious_permissions"`
}

// raw data get from ADB
type InstallApp struct{
	PackageName string `json:"package_name"`
	AppName string `json:"app_name"`
	VersionName string `json:"version_name,omitempty"`
	TargetSDK int `json:"target_sdk,omitempty"`
	RequestedPermissions []string `json:"requested_permissions"`
	GrantedPermissions []string `json:"granted_permissions"`
	IsSystemApp bool `json:"is_system_app"`
}

// permission issue found during analysis
type PermissionFinding struct{
	Permission string `json:"permission"`
	ShortName string `json:"short_name"`
	Message string `json:"message"`
	Severity FindindSeverity `json:"severity"`
	Recommendation string `json:"recommendation"`
	ScoreContribution float64 `json:"score_contribution"`
}

// all result from analysing an application
type ScannedApp struct {
	PackageName string `json:"package_name"`
	AppName string `json:"app_name"`
	CategoryName string `json:"category_name"`
	CategoryIcon string `json:"category_icon"`
	RequestedPermissions []string `json:"requested_permissions"`
	GrantedPermissions []string `json:"granted_permissions"`
	RiskScore float64 `json:"risk_score"`
	RiskLevel string `json:"risk_level"`
	Findings []PermissionFinding `json:"findings"`
	DangerousCount int `json:"dangerous_count"`
	IsSystemApp bool `json:"is_system_app"`
	ScannedAt time.Time `json:"scanned_at"`
}

// all result from the full device analysis
type ScanSummary struct{
	TotalApps int `json:"total_apps"`
	ScannedApps int `json:"scanned_apps"`
	LowRiskApps int `json:"low_risk_apps"`
	MediumRiskApps int `json:"medium_risk_apps"`
	HighRiskApps int `json:"high_risk_apps"`
	CriticalRiskApps int `json:"critical_risk_apps"`
	AverageRiskScore float64 `json:"average_risk_score"`
	TopRiskApps []ScannedApp `json:"top_risk_apps"`
	MostAbusedPermissions map[string]int `json:"most_abused_permissions"`
	ThreatVectors ThreatVectors `json:"threat_vectors"`
	PermissionHeatmap []PermissionGroupStat `json:"permission_heatmap"`
	Timestamp time.Time `json:"timestamp"`
}

// categoty of suppose threat vector
type ThreatVectors struct{
	SpywareApps []string `json:"spyware_apps"`
	DataExfiltrationApps []string `json:"data_exfiltration_apps"`
	OverlayApps []string `json:"overlay_apps"`
	DeviceAdminApps []string `json:"device_admin_apps"`
	InstallerApps []string `json:"installer_apps"`
}

// permission group
type PermGroupStat struct{
	Group string `json:"group"`
	AppCount int `json:"app_count"`
	Ratio float64 `json:"ratio"`
}

// android device informations
type DeviceInfo struct{
	Serial string `json:"serial"`
	Model string `json:"model"`
	Manufacturer string `json:"manufacturer"`
	AndroidVersion string `json:"android_version"`
	APILevel string `json:"api_level"`
	Connected bool `json:"connected"`
}

// permission revoke request
type RevokeRequest struct{
	PackageName string `json:"package_name"`
	Permission string `json:"permission"`
}


func (p PermissionInfo) ShortName()string{
	for i := len(p.Name) -1; i>=0; i--{
		if p.Name[i] == '.'{
			return p.Name[i+1:]
		}
	}
	return p.Name
}

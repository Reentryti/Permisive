# PermissionGuard - Permission Based Defense for Android

## Overview
PermissionGuard is an Android security research project that implements a permission-based defense mechanism to prevent mobile attacks before they occur.

Instead of detecting attacks after malicious behaviour is observed, PermissionGuard focuses on reducing the attack surface by enforcing the principle of least privilege on Android applications.
The core idea is simple:
> Most mobile attacks require excessive or unnecessary permissions. If those permissions are never granted, the attack cannot succeed.
The project is designed as an academic prototype, testable in controlled environments such as Waydroid or Android emulators.


## Objectives
- Analyze Android applications and their requested permissions
- Define a baseline of minimal and safe permissions per app category
- Detect over privileged applications
- Prevent or limit abuse by:
  - Warning users
  - Recommending sage permission sets
  - Enforcing restrictions

## Threat Model
### Targetet Threats
- Spyware abusing contacts, SMS, microphone, or storage permissions
- Malware performing data exfiltration via network access
- Trojans hiding legitimate-looking applications
- Over privileged apps increasing attack surface

### Out of Scope
- Baseband / modem attacks
- Hardware level exploits
- Kernel vulnerabilities
- Zero day Android framework exploits


## System Architecture

## Permission Knowledge Base
The knowledge base defines expected minimal permissions for each application category


## Detection & Risk Scoring
Each application is evaluated using a Permission Risk Score
### Scoring Logic
- Required permission score +0
- Optional permission score +1
- Risky/unexpected permission score +3

## Defense Mechanisms
### Level 1 - Advisory Mode (Default)
- Analyze permissions at install or runtime
- Display warnings and explanations
- Recommend safe permission sets

### Level 2 - Assisted Restriction
- Uses Android runtime permissions
- Guides the user to revoke dangerous permissions
- Can leverage Accessibility Service

### Level 3 - Enforcement Mod
- Requires root or custom ROM
- Hooks permission checks
- Blocks dangerous permissions at runtime

## Testing Environment
- Waydroid (primary test environment)
- Android Emulator
- Real device

## Limitations
- Some legimate apps request broad permissions
- Android restricts automated permission control
- Malware may exploit indirect APIs or vulnerabilities
- Knowledge base accuracy directly impacts results

## Academic Context
This project aligns with:
- Principle of Least Privilege
- Mobile attack surface reduction
- Defense in depth strategies
It is suitable for:
- Cybersecurity coursework
- Research prototypes
- Proof of concept demonstrations

## Getting Started

### Prerequisites
- Flutter SDK 3.1+
- Android SDK
- Android device, emulator, or Waydroid

### Install & Run

```bash
# Clone and navigate to project
git clone https://github.com/Reentryti/Permisive.git
cd permission_guard

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build APK
flutter build apk --release

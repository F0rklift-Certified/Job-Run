# JobRun

An iOS app for managing jobs and optimising daily routes using Google Maps Directions API.

## Features

- **Job Management** — Create, edit, and organise jobs with addresses, dates, and notes
- **Calendar View** — View jobs by month or week with an interactive calendar
- **Route Optimisation** — Automatically calculates the most efficient route through your daily jobs
- **Route Map** — Visualise your optimised route on an interactive map
- **Persistent Storage** — Jobs are saved locally on device

## Setup

### Google Maps API Key

This app requires a Google Maps API key with the **Directions API** enabled.

1. Get a key from the [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the **Directions API** for your project
3. Create the secrets config file:
   ```
   cp JobRun/Configurations/Secrets.xcconfig.example JobRun/Configurations/Secrets.xcconfig
   ```
4. Open `JobRun/Configurations/Secrets.xcconfig` and replace `YOUR_API_KEY_HERE` with your key

### Build

1. Open `JobRun.xcodeproj` in Xcode
2. Ensure the **Secrets.xcconfig** is set as the base configuration for the JobRun target (Project > Info > Configurations)
3. Build and run on a simulator or device

## Requirements

- Xcode 26.4+
- iOS 26.4+
- Swift 5.0+

## Project Structure

```
JobRun/
├── Configurations/
│   └── Secrets.xcconfig        # API keys (not tracked in git)
├── Models/
│   └── Job.swift               # Job data model
├── Services/
│   ├── RouteService.swift      # Google Maps Directions API client
│   └── StorageService.swift    # Local persistence
├── ViewModels/
│   ├── JobStore.swift          # Job state management
│   └── RouteViewModel.swift    # Route calculation state
└── Views/
    ├── Calendar/               # Calendar and week strip views
    ├── Job/                    # Job card and form views
    ├── Route/                  # Route map and day route views
    └── Settings/               # App settings
```

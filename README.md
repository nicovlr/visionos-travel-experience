# SpatialTravel

Immersive spatial app prototype for Apple Vision Pro — exploring AR interactions for travel information display.

## Overview

SpatialTravel lets users explore destinations in an immersive 3D environment. Built with RealityKit and SwiftUI, the app uses spatial computing to create an intuitive travel browsing experience.

## Features (WIP)

- [x] Basic spatial window layout
- [x] Destination card components
- [x] Gesture-based navigation (tap, pinch, drag)
- [ ] Immersive space with 3D globe
- [ ] Destination detail panels with volumetric content
- [ ] Flight path visualization
- [ ] Spatial audio for ambient sounds
- [ ] Hand tracking interactions

## Requirements

- Xcode 15.2+
- visionOS 1.0+ SDK
- Apple Vision Pro simulator or device

## Architecture

MVVM with a service layer. Views are split between immersive content (RealityKit) and 2D panels (SwiftUI).

```
SpatialTravel/
├── App/              # App entry, scenes
├── Views/
│   ├── Immersive/    # RealityKit immersive views
│   ├── Panels/       # 2D window panels
│   └── Components/   # Reusable UI bits
├── Models/           # Data models
├── Services/         # API, data loading
├── Resources/        # Assets, USDZ files
└── Utilities/        # Extensions, helpers
```

## Notes

Still early — focusing on getting the spatial interactions right before adding more destinations. The gesture system needs work for edge cases (two-hand gestures especially).

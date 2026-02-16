# SpatialTravel

A visionOS spatial computing prototype built for Apple Vision Pro. Explore travel destinations in an immersive 3D environment using gaze, gestures, and spatial interactions.

Built with **SwiftUI**, **RealityKit**, and the **visionOS SDK**.

## Features

- **Immersive 3D Globe** — Interactive globe entity built with RealityKit, with destination pins placed using geographic coordinate mapping
- **Spatial Gestures** — Drag to rotate the globe, tap to select destinations via `SpatialTapGesture` and `DragGesture` targeted to entities
- **Mixed Immersion** — Seamless transitions between windowed and immersive spaces using `ImmersiveSpace` scenes
- **Spatial UI Panels** — `NavigationSplitView` with detail panels, ornament toolbar, and material-based card components
- **Flight Path Visualization** — Arc point generation between destinations using SLERP interpolation on a unit sphere
- **Spatial Math Utilities** — Geographic-to-cartesian conversion, haversine distance calculation, great circle arc generation with `simd`

## Architecture

MVVM with a protocol-based service layer. State management via `@Observable` and SwiftUI `@Environment`.

```
SpatialTravel/
├── App/              # App entry point, scene definitions, observable state
├── Models/           # Data models (Destination, Coordinate, PriceRange)
├── Services/         # Protocol-based data layer with async interface
├── Utilities/        # Spatial math (SIMD3, SLERP, haversine)
└── Views/
    ├── Components/   # Reusable spatial card with hover/spring animations
    ├── Immersive/    # RealityKit immersive scene (globe, pins, gestures)
    └── Panels/       # 2D window panels (list, detail, custom FlowLayout)
```

## Technical Highlights

| Area | Implementation |
|------|---------------|
| Scene Management | `WindowGroup` + `ImmersiveSpace` with `.mixed` immersion style |
| State | `@Observable` class with environment injection |
| 3D Rendering | RealityKit entities with `PhysicallyBasedMaterial` |
| Input Handling | `SpatialTapGesture`, `DragGesture` targeted to entities via `InputTargetComponent` |
| Collision | `CollisionComponent` with sphere shapes for spatial hit testing |
| Math | `simd` framework — `SIMD3<Float>`, quaternion rotation, SLERP interpolation |
| Layout | Custom `FlowLayout` conforming to SwiftUI `Layout` protocol |
| Testing | Unit tests for spatial math (coordinate conversion, haversine distance, arc generation) |

## Requirements

- Xcode 15.2+
- visionOS 1.0+ SDK
- Apple Vision Pro simulator or device

## Context

Built during an R&D exploration of spatial computing UX patterns for travel applications — combining spatial interactions (gaze, gesture, hand tracking) with information display in mixed reality environments.

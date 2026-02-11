# Development Plan

## Phase 1 — Core spatial UI (current)
- App scaffold with visionOS scenes
- Basic destination model + mock data
- Spatial card layout in a window group
- Tap/pinch gesture handling on cards
- Navigation between list → detail

## Phase 2 — Immersive experience
- Immersive space scene with RealityKit
- 3D globe entity (interactive)
- Pin destinations on globe surface
- Transition animation window → immersive
- Spatial audio per destination region

## Phase 3 — Rich content
- Volumetric destination previews (USDZ)
- Flight path arcs between origin/destination
- Photo gallery in spatial layout
- Weather overlay on globe
- Price comparison panels

## Phase 4 — Polish
- Hand tracking for grab/rotate globe
- Eye tracking highlights
- Accessibility (VoiceOver spatial)
- Performance profiling on device
- TestFlight for internal testing

---

### Open questions
- How to handle heavy USDZ loading without blocking the main actor?
- Look into `RealityView` attachments vs custom entities for info panels
- SharePlay integration worth exploring?

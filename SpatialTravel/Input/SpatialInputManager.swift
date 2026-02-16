import SwiftUI
import RealityKit

/// Protocol defining spatial input capabilities for testability.
protocol SpatialInputHandling {
    func handleTap(on entity: Entity, in appModel: AppModel)
    func handleDrag(translation: SIMD3<Float>, on entity: Entity)
}

/// Coordinates all spatial input methods: system gestures, hand tracking, and gaze.
/// Centralizes input handling logic outside of views for better testability.
@Observable
final class SpatialInputManager: SpatialInputHandling {

    let handTracking = HandTrackingManager()

    private(set) var lastInteractionTime: Date?
    private(set) var activeInputMethod: InputMethod = .indirect

    enum InputMethod: String {
        case indirect   // gaze + pinch (default visionOS input)
        case direct     // hand tracking direct manipulation
        case gesture    // system gesture recognizers
    }

    // MARK: - Gesture Handlers

    func handleTap(on entity: Entity, in appModel: AppModel) {
        lastInteractionTime = .now
        activeInputMethod = .gesture

        if let gazeComponent = entity.components[GazeHighlightComponent.self] {
            selectDestination(id: gazeComponent.destinationID, in: appModel)
        }
    }

    func handleDrag(translation: SIMD3<Float>, on entity: Entity) {
        lastInteractionTime = .now
        activeInputMethod = .gesture

        let sensitivity: Float = 0.005
        let rotation = simd_quatf(angle: translation.x * sensitivity, axis: SIMD3<Float>(0, 1, 0))
        entity.transform.rotation = rotation * entity.transform.rotation
    }

    // MARK: - Selection

    private func selectDestination(id: String, in appModel: AppModel) {
        if let destination = appModel.destinations.first(where: { $0.id.uuidString == id }) {
            appModel.selectDestination(destination)
        }
    }
}

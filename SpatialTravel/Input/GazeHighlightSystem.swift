import RealityKit

/// Component that marks entities as gaze-interactive.
/// Entities with this component will highlight when the user looks at them.
struct GazeHighlightComponent: Component {
    var defaultRadius: Float
    var highlightedRadius: Float
    var destinationID: String
    var isHighlighted: Bool = false

    init(defaultRadius: Float = 0.012, highlightedRadius: Float = 0.018, destinationID: String) {
        self.defaultRadius = defaultRadius
        self.highlightedRadius = highlightedRadius
        self.destinationID = destinationID
    }
}

/// System that smoothly scales destination pins based on gaze highlight state.
/// Works alongside visionOS HoverEffectComponent for visual feedback.
struct GazeHighlightSystem: System {
    static let query = EntityQuery(where: .has(GazeHighlightComponent.self))

    init(scene: RealityKit.Scene) {}

    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard let component = entity.components[GazeHighlightComponent.self] else { continue }

            let targetScale: Float = component.isHighlighted ? 1.5 : 1.0
            let currentScale = entity.scale.x
            let lerped = currentScale + (targetScale - currentScale) * 0.12
            entity.scale = SIMD3<Float>(repeating: lerped)
        }
    }
}

extension GazeHighlightComponent {
    /// Register the component and system with RealityKit. Call once at app startup.
    static func registerSystem() {
        GazeHighlightComponent.registerComponent()
        GazeHighlightSystem.registerSystem()
    }
}

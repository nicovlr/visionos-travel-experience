import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @State private var globeEntity: Entity?
    @State private var inputManager = SpatialInputManager()

    var body: some View {
        RealityView { content, attachments in
            GazeHighlightComponent.registerSystem()

            let globe = makeGlobeEntity()
            globe.position = SIMD3<Float>(0, 1.2, -1.5)
            content.add(globe)
            globeEntity = globe

            let ambientAudio = makeAmbientAudioEntity()
            globe.addChild(ambientAudio)

        } update: { content, attachments in
            if let selected = appModel.selectedDestination,
               let attachment = attachments.entity(for: "destinationInfo") {
                let pinPosition = SpatialMath.geographicToCartesian(
                    latitude: selected.coordinate.latitude,
                    longitude: selected.coordinate.longitude,
                    radius: 0.55
                )
                attachment.position = pinPosition

                if attachment.parent == nil {
                    globeEntity?.addChild(attachment)
                }
            }
        } attachments: {
            if let selected = appModel.selectedDestination {
                Attachment(id: "destinationInfo") {
                    DestinationAttachmentView(destination: selected)
                }
            }
        }
        .gesture(dragGesture)
        .gesture(tapGesture)
        .task {
            await inputManager.handTracking.start()
        }
    }

    // MARK: - Entity Builders

    private func makeGlobeEntity() -> Entity {
        let mesh = MeshResource.generateSphere(radius: 0.4)
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .init(red: 0.15, green: 0.35, blue: 0.65, alpha: 1.0))
        material.roughness = .init(floatLiteral: 0.7)
        material.metallic = .init(floatLiteral: 0.1)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
        entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.4)]))

        for dest in appModel.destinations {
            let pin = makePin(for: dest)
            entity.addChild(pin)
        }

        return entity
    }

    private func makePin(for destination: Destination) -> Entity {
        let pinMesh = MeshResource.generateSphere(radius: 0.012)
        var pinMat = UnlitMaterial()
        pinMat.color = .init(tint: .red)

        let pin = ModelEntity(mesh: pinMesh, materials: [pinMat])

        let pos = SpatialMath.geographicToCartesian(
            latitude: destination.coordinate.latitude,
            longitude: destination.coordinate.longitude,
            radius: 0.41
        )
        pin.position = pos
        pin.name = destination.id.uuidString

        pin.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
        pin.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.02)]))
        pin.components.set(HoverEffectComponent())
        pin.components.set(GazeHighlightComponent(destinationID: destination.id.uuidString))

        return pin
    }

    private func makeAmbientAudioEntity() -> Entity {
        let audioEntity = Entity()
        audioEntity.components.set(SpatialAudioComponent(directivity: .beam(focus: 0.5)))
        audioEntity.position = .zero
        return audioEntity
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                guard let globe = globeEntity else { return }
                inputManager.handleDrag(
                    translation: SIMD3<Float>(Float(value.translation3D.x), 0, 0),
                    on: globe
                )
            }
    }

    private var tapGesture: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                inputManager.handleTap(on: value.entity, in: appModel)
            }
    }
}

// MARK: - Destination Attachment View

/// SwiftUI view displayed as a RealityView attachment next to a destination pin.
struct DestinationAttachmentView: View {
    let destination: Destination

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(destination.name)
                .font(.headline)
            Text(destination.country)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(destination.tagline)
                .font(.caption)
                .foregroundStyle(.tertiary)

            HStack(spacing: 8) {
                Text(destination.priceRange.rawValue)
                    .font(.caption.bold())
                    .foregroundStyle(.green)
                ForEach(destination.tags.prefix(2), id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
        .padding(16)
        .frame(width: 200)
        .glassBackgroundEffect()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(destination.name), \(destination.country). \(destination.tagline)")
    }
}

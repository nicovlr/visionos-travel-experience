import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @State private var globeEntity: Entity?

    var body: some View {
        RealityView { content in
            let globe = makeGlobeEntity()
            globe.position = SIMD3<Float>(0, 1.2, -1.5)
            content.add(globe)
            globeEntity = globe
        } update: { content in
            // update pin positions when selection changes
            // TODO: animate camera to selected destination
        }
        .gesture(dragGesture)
        .gesture(tapGesture)
    }

    private func makeGlobeEntity() -> Entity {
        let mesh = MeshResource.generateSphere(radius: 0.4)
        // using a simple material for now — will add proper earth texture later
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .init(red: 0.15, green: 0.35, blue: 0.65, alpha: 1.0))
        material.roughness = .init(floatLiteral: 0.7)
        material.metallic = .init(floatLiteral: 0.1)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(InputTargetComponent())
        entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.4)]))

        // add destination pins
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

        // convert lat/lon to 3D position on sphere
        let pos = latLonToSpherePosition(
            lat: destination.coordinate.latitude,
            lon: destination.coordinate.longitude,
            radius: 0.41
        )
        pin.position = pos
        pin.name = destination.id.uuidString

        return pin
    }

    private func latLonToSpherePosition(lat: Double, lon: Double, radius: Float) -> SIMD3<Float> {
        let latRad = Float(lat * .pi / 180.0)
        let lonRad = Float(lon * .pi / 180.0)
        let x = radius * cos(latRad) * cos(lonRad)
        let y = radius * sin(latRad)
        let z = -radius * cos(latRad) * sin(lonRad)
        return SIMD3<Float>(x, y, z)
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                guard let globe = globeEntity else { return }
                let delta = value.translation3D
                // rotate globe based on drag — this is rough, needs tuning
                let sensitivity: Float = 0.005
                let rotation = simd_quatf(angle: Float(delta.x) * sensitivity, axis: SIMD3<Float>(0, 1, 0))
                globe.transform.rotation = rotation * globe.transform.rotation
            }
    }

    private var tapGesture: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                let tappedName = value.entity.name
                // find matching destination
                if let dest = appModel.destinations.first(where: { $0.id.uuidString == tappedName }) {
                    appModel.selectedDestination = dest
                }
            }
    }
}

import ARKit
import SwiftUI

/// Manages hand tracking for spatial interactions using ARKit.
/// Detects pinch gestures for selection and hand positions for direct manipulation.
@Observable
final class HandTrackingManager {

    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()

    var leftHandAnchor: HandAnchor?
    var rightHandAnchor: HandAnchor?
    var isPinching: Bool = false
    var pinchPosition: SIMD3<Float>?

    private(set) var isRunning = false

    // MARK: - Lifecycle

    func start() async {
        guard HandTrackingProvider.isSupported else {
            print("[HandTracking] Not supported on this device")
            return
        }

        do {
            try await session.run([handTracking])
            isRunning = true
            await processUpdates()
        } catch {
            print("[HandTracking] Failed to start: \(error.localizedDescription)")
            isRunning = false
        }
    }

    func stop() {
        session.stop()
        isRunning = false
        leftHandAnchor = nil
        rightHandAnchor = nil
        isPinching = false
        pinchPosition = nil
    }

    // MARK: - Processing

    private func processUpdates() async {
        for await update in handTracking.anchorUpdates {
            let anchor = update.anchor
            guard anchor.isTracked else { continue }

            switch anchor.chirality {
            case .left:
                leftHandAnchor = anchor
            case .right:
                rightHandAnchor = anchor
            @unknown default:
                break
            }

            updatePinchState(anchor)
        }
    }

    /// Detect pinch gesture by measuring distance between thumb tip and index finger tip.
    private func updatePinchState(_ anchor: HandAnchor) {
        guard let skeleton = anchor.handSkeleton,
              let thumbTip = skeleton.joint(.thumbTip),
              let indexTip = skeleton.joint(.indexFingerTip),
              thumbTip.isTracked, indexTip.isTracked else {
            return
        }

        let originFromThumb = anchor.originFromAnchorTransform * thumbTip.anchorFromJointTransform
        let originFromIndex = anchor.originFromAnchorTransform * indexTip.anchorFromJointTransform

        let thumbPos = SIMD3<Float>(originFromThumb.columns.3.x,
                                     originFromThumb.columns.3.y,
                                     originFromThumb.columns.3.z)
        let indexPos = SIMD3<Float>(originFromIndex.columns.3.x,
                                     originFromIndex.columns.3.y,
                                     originFromIndex.columns.3.z)

        let distance = simd_distance(thumbPos, indexPos)
        let pinchThreshold: Float = 0.02

        isPinching = distance < pinchThreshold
        if isPinching {
            pinchPosition = (thumbPos + indexPos) / 2.0
        }
    }

    /// Get the world-space position of a specific joint.
    func jointPosition(for joint: HandSkeleton.JointName, chirality: HandAnchor.Chirality) -> SIMD3<Float>? {
        let anchor = chirality == .left ? leftHandAnchor : rightHandAnchor
        guard let anchor,
              let skeleton = anchor.handSkeleton,
              let target = skeleton.joint(joint),
              target.isTracked else {
            return nil
        }

        let transform = anchor.originFromAnchorTransform * target.anchorFromJointTransform
        return SIMD3<Float>(transform.columns.3.x,
                            transform.columns.3.y,
                            transform.columns.3.z)
    }
}

import simd
import Foundation

enum SpatialMath {
    /// Convert geographic coordinates to a point on a unit sphere
    static func geographicToCartesian(latitude: Double, longitude: Double, radius: Double = 1.0) -> SIMD3<Float> {
        let lat = Float(latitude * .pi / 180.0)
        let lon = Float(longitude * .pi / 180.0)
        let r = Float(radius)
        return SIMD3<Float>(
            r * cos(lat) * cos(lon),
            r * sin(lat),
            -r * cos(lat) * sin(lon)
        )
    }

    /// Great circle distance between two coordinates (in km)
    static func haversineDistance(
        from: (lat: Double, lon: Double),
        to: (lat: Double, lon: Double)
    ) -> Double {
        let earthRadius = 6371.0
        let dLat = (to.lat - from.lat) * .pi / 180.0
        let dLon = (to.lon - from.lon) * .pi / 180.0

        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(from.lat * .pi / 180) * cos(to.lat * .pi / 180) *
                sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return earthRadius * c
    }

    /// Generate arc points between two locations (for flight path viz)
    static func arcPoints(
        from start: SIMD3<Float>,
        to end: SIMD3<Float>,
        segments: Int = 32,
        arcHeight: Float = 0.15
    ) -> [SIMD3<Float>] {
        var points: [SIMD3<Float>] = []
        for i in 0...segments {
            let t = Float(i) / Float(segments)
            // slerp on the sphere surface
            let base = slerp(start, end, t: t)
            // add height for the arc
            let heightFactor = sin(t * .pi) * arcHeight
            let lifted = normalize(base) * (length(base) + heightFactor)
            points.append(lifted)
        }
        return points
    }

    private static func slerp(_ a: SIMD3<Float>, _ b: SIMD3<Float>, t: Float) -> SIMD3<Float> {
        let dot = simd_dot(normalize(a), normalize(b))
        let clamped = min(max(dot, -1), 1)
        let omega = acos(clamped)

        if omega < 0.001 {
            // nearly parallel, just lerp
            return a + t * (b - a)
        }

        let sinOmega = sin(omega)
        let factorA = sin((1 - t) * omega) / sinOmega
        let factorB = sin(t * omega) / sinOmega
        return factorA * a + factorB * b
    }
}

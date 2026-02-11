import XCTest
@testable import SpatialTravel

final class SpatialMathTests: XCTestCase {
    func testCartesianConversion_equator() {
        let point = SpatialMath.geographicToCartesian(latitude: 0, longitude: 0)
        XCTAssertEqual(point.x, 1.0, accuracy: 0.001)
        XCTAssertEqual(point.y, 0.0, accuracy: 0.001)
        XCTAssertEqual(point.z, 0.0, accuracy: 0.001)
    }

    func testCartesianConversion_northPole() {
        let point = SpatialMath.geographicToCartesian(latitude: 90, longitude: 0)
        XCTAssertEqual(point.y, 1.0, accuracy: 0.001)
    }

    func testHaversine_parisToLondon() {
        let distance = SpatialMath.haversineDistance(
            from: (lat: 48.8566, lon: 2.3522),
            to: (lat: 51.5074, lon: -0.1278)
        )
        // should be roughly 344 km
        XCTAssertEqual(distance, 344, accuracy: 5)
    }

    func testArcPoints_hasCorrectCount() {
        let start = SpatialMath.geographicToCartesian(latitude: 0, longitude: 0)
        let end = SpatialMath.geographicToCartesian(latitude: 45, longitude: 90)
        let points = SpatialMath.arcPoints(from: start, to: end, segments: 16)
        XCTAssertEqual(points.count, 17) // segments + 1
    }
}

import XCTest
@testable import SpatialTravel

final class DestinationTests: XCTestCase {
    func testSamplesNotEmpty() {
        XCTAssertFalse(Destination.samples.isEmpty)
    }

    func testSamplesHaveUniqueIDs() {
        let ids = Destination.samples.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "Duplicate destination IDs found")
    }

    func testCoordinatesWithinBounds() {
        for dest in Destination.samples {
            XCTAssertTrue((-90...90).contains(dest.coordinate.latitude),
                          "\(dest.name) has invalid latitude: \(dest.coordinate.latitude)")
            XCTAssertTrue((-180...180).contains(dest.coordinate.longitude),
                          "\(dest.name) has invalid longitude: \(dest.coordinate.longitude)")
        }
    }

    func testAllDestinationsHaveTags() {
        for dest in Destination.samples {
            XCTAssertFalse(dest.tags.isEmpty, "\(dest.name) has no tags")
        }
    }

    func testPriceRangeCoverage() {
        let ranges = Set(Destination.samples.map(\.priceRange))
        XCTAssertTrue(ranges.count >= 2, "Samples should cover multiple price ranges")
    }
}

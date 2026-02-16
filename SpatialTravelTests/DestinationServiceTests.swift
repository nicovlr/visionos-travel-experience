import XCTest
@testable import SpatialTravel

final class DestinationServiceTests: XCTestCase {
    func testMockServiceReturnsAllSamples() async throws {
        let service = MockDestinationService()
        let destinations = try await service.fetchDestinations()
        XCTAssertEqual(destinations.count, Destination.samples.count)
    }

    func testMockServiceFetchDetail() async throws {
        let service = MockDestinationService()
        let all = try await service.fetchDestinations()
        let first = all[0]
        let detail = try await service.fetchDetail(for: first.id)
        XCTAssertNotNil(detail)
        XCTAssertEqual(detail?.name, first.name)
    }

    func testMockServiceFetchDetailNonexistent() async throws {
        let service = MockDestinationService()
        let detail = try await service.fetchDetail(for: UUID())
        XCTAssertNil(detail)
    }

    func testLiveServiceSimulatesDelay() async throws {
        let service = DestinationService()
        let start = Date()
        _ = try await service.fetchDestinations()
        let elapsed = Date().timeIntervalSince(start)
        XCTAssertGreaterThanOrEqual(elapsed, 0.2, "Service should simulate network delay")
    }
}

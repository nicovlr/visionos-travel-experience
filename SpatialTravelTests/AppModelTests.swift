import XCTest
@testable import SpatialTravel

final class AppModelTests: XCTestCase {
    func testInitialState() {
        let model = AppModel(service: MockDestinationService())
        XCTAssertNil(model.selectedDestination)
        XCTAssertFalse(model.isShowingDetail)
        XCTAssertTrue(model.destinations.isEmpty)
        if case .idle = model.loadingState {} else {
            XCTFail("Initial loading state should be .idle")
        }
    }

    func testLoadDestinations() async {
        let model = AppModel(service: MockDestinationService())
        await model.loadDestinations()
        XCTAssertFalse(model.destinations.isEmpty)
        if case .loaded = model.loadingState {} else {
            XCTFail("Loading state should be .loaded after successful fetch")
        }
    }

    func testSelectDestination() async {
        let model = AppModel(service: MockDestinationService())
        await model.loadDestinations()
        let dest = model.destinations[0]
        model.selectDestination(dest)
        XCTAssertEqual(model.selectedDestination, dest)
        XCTAssertTrue(model.isShowingDetail)
    }

    func testClearSelection() async {
        let model = AppModel(service: MockDestinationService())
        await model.loadDestinations()
        model.selectDestination(model.destinations[0])
        model.clearSelection()
        XCTAssertNil(model.selectedDestination)
        XCTAssertFalse(model.isShowingDetail)
    }

    func testImmersiveSpaceInitialState() {
        let model = AppModel(service: MockDestinationService())
        if case .closed = model.immersiveSpaceState {} else {
            XCTFail("Immersive space should start closed")
        }
    }
}

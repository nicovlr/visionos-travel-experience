import SwiftUI

@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"

    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }

    enum LoadingState {
        case idle
        case loading
        case loaded
        case error(String)
    }

    var immersiveSpaceState = ImmersiveSpaceState.closed
    var selectedDestination: Destination?
    var isShowingDetail = false
    var loadingState = LoadingState.idle
    var destinations: [Destination] = []

    private let service: DestinationServiceProtocol

    init(service: DestinationServiceProtocol = DestinationService()) {
        self.service = service
    }

    // MARK: - Data Loading

    func loadDestinations() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading

        do {
            destinations = try await service.fetchDestinations()
            loadingState = .loaded
        } catch {
            loadingState = .error(error.localizedDescription)
        }
    }

    // MARK: - Selection

    func selectDestination(_ destination: Destination) {
        selectedDestination = destination
        isShowingDetail = true
    }

    func clearSelection() {
        selectedDestination = nil
        isShowingDetail = false
    }
}

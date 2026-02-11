import Foundation

// will hook this up to a real API later
// for now just wrapping the sample data with async interface

protocol DestinationServiceProtocol {
    func fetchDestinations() async throws -> [Destination]
    func fetchDetail(for id: UUID) async throws -> Destination?
}

final class DestinationService: DestinationServiceProtocol {
    // simulating network delay
    func fetchDestinations() async throws -> [Destination] {
        try await Task.sleep(for: .milliseconds(300))
        return Destination.samples
    }

    func fetchDetail(for id: UUID) async throws -> Destination? {
        try await Task.sleep(for: .milliseconds(150))
        return Destination.samples.first { $0.id == id }
    }
}

// for previews / tests
final class MockDestinationService: DestinationServiceProtocol {
    func fetchDestinations() async throws -> [Destination] {
        Destination.samples
    }

    func fetchDetail(for id: UUID) async throws -> Destination? {
        Destination.samples.first { $0.id == id }
    }
}

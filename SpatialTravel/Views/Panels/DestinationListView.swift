import SwiftUI

struct DestinationListView: View {
    @Environment(AppModel.self) private var appModel
    @State private var searchText = ""

    var filteredDestinations: [Destination] {
        if searchText.isEmpty {
            return appModel.destinations
        }
        let query = searchText.lowercased()
        return appModel.destinations.filter {
            $0.name.lowercased().contains(query) ||
            $0.country.lowercased().contains(query) ||
            $0.tags.contains(where: { $0.lowercased().contains(query) })
        }
    }

    var body: some View {
        List(filteredDestinations, selection: Binding(
            get: { appModel.selectedDestination },
            set: { appModel.selectedDestination = $0 }
        )) { destination in
            DestinationRow(destination: destination)
                .tag(destination)
        }
        .searchable(text: $searchText, prompt: "Search destinations")
        .navigationTitle("Explore")
    }
}

struct DestinationRow: View {
    let destination: Destination

    var body: some View {
        HStack(spacing: 14) {
            // placeholder — will swap for actual images later
            RoundedRectangle(cornerRadius: 8)
                .fill(.quaternary)
                .frame(width: 56, height: 56)
                .overlay {
                    Image(systemName: "photo")
                        .foregroundStyle(.tertiary)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(destination.name)
                    .font(.headline)
                Text(destination.country)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text(destination.priceRange.rawValue)
                        .font(.caption)
                        .foregroundStyle(.green)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(destination.tags.prefix(2).joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

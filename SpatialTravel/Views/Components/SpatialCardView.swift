import SwiftUI

struct SpatialCardView: View {
    let destination: Destination
    let isSelected: Bool
    var onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // image placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .frame(height: 120)
                .overlay {
                    Image(systemName: "airplane")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }

            Text(destination.name)
                .font(.headline)
            Text(destination.country)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(width: 200)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .hoverEffect(.lift)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
        .onTapGesture {
            onTap()
        }
    }
}

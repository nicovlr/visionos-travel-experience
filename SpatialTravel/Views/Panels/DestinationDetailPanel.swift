import SwiftUI

struct DestinationDetailPanel: View {
    let destination: Destination
    @State private var showFullDescription = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerImage
                titleSection
                descriptionSection
                tagsSection
                coordinateInfo

                // TODO: add weather widget, price breakdown, nearby attractions
            }
            .padding(24)
        }
        .navigationTitle(destination.name)
    }

    private var headerImage: some View {
        // placeholder until we get real images or USDZ previews
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 220)
            .overlay {
                VStack {
                    Image(systemName: "globe.europe.africa")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.6))
                    Text(destination.tagline)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(destination.name)
                .font(.largeTitle.bold())
            Text(destination.country)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(destination.priceRange.rawValue)
                .font(.headline)
                .foregroundStyle(.green)
                .padding(.top, 2)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(destination.description)
                .font(.body)
                .lineLimit(showFullDescription ? nil : 3)

            if destination.description.count > 120 {
                Button(showFullDescription ? "Show less" : "Read more") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showFullDescription.toggle()
                    }
                }
                .font(.callout)
            }
        }
    }

    private var tagsSection: some View {
        FlowLayout(spacing: 8) {
            ForEach(destination.tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
    }

    private var coordinateInfo: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(.red)
            Text(String(format: "%.4f, %.4f",
                         destination.coordinate.latitude,
                         destination.coordinate.longitude))
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}

// simple flow layout — might replace with Layout protocol later
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalSize: CGSize = .zero

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            totalSize.width = max(totalSize.width, currentX - spacing)
            totalSize.height = max(totalSize.height, currentY + lineHeight)
        }
        return (totalSize, positions)
    }
}

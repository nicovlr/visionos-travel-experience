import Foundation

struct Destination: Identifiable, Hashable {
    let id: UUID
    let name: String
    let country: String
    let tagline: String
    let description: String
    let imageName: String
    let coordinate: Coordinate
    let priceRange: PriceRange
    let tags: [String]

    struct Coordinate: Hashable {
        let latitude: Double
        let longitude: Double
    }

    enum PriceRange: String, CaseIterable {
        case budget = "$"
        case mid = "$$"
        case premium = "$$$"
        case luxury = "$$$$"
    }
}

extension Destination {
    static let samples: [Destination] = [
        Destination(
            id: UUID(),
            name: "Kyoto",
            country: "Japan",
            tagline: "Ancient temples, modern calm",
            description: "Traditional temples, bamboo groves, and zen gardens set against a backdrop of mountains. Kyoto offers a window into Japan's cultural heritage.",
            imageName: "kyoto",
            coordinate: .init(latitude: 35.0116, longitude: 135.7681),
            priceRange: .mid,
            tags: ["culture", "temples", "nature"]
        ),
        Destination(
            id: UUID(),
            name: "Santorini",
            country: "Greece",
            tagline: "White walls, blue domes",
            description: "Iconic caldera views, whitewashed villages perched on volcanic cliffs. Sunsets here are something else entirely.",
            imageName: "santorini",
            coordinate: .init(latitude: 36.3932, longitude: 25.4615),
            priceRange: .premium,
            tags: ["beach", "romantic", "photography"]
        ),
        Destination(
            id: UUID(),
            name: "Marrakech",
            country: "Morocco",
            tagline: "Colors, spices, chaos",
            description: "Vibrant souks, ornate riads, and the Atlas Mountains on the horizon. A sensory overload in the best way.",
            imageName: "marrakech",
            coordinate: .init(latitude: 31.6295, longitude: -7.9811),
            priceRange: .budget,
            tags: ["culture", "food", "adventure"]
        ),
        Destination(
            id: UUID(),
            name: "Reykjavik",
            country: "Iceland",
            tagline: "Fire and ice",
            description: "Gateway to glaciers, geysers, and the northern lights. Raw, dramatic landscapes that feel otherworldly.",
            imageName: "reykjavik",
            coordinate: .init(latitude: 64.1466, longitude: -21.9426),
            priceRange: .premium,
            tags: ["nature", "adventure", "photography"]
        ),
        Destination(
            id: UUID(),
            name: "Lisbon",
            country: "Portugal",
            tagline: "Tiles, trams, pastéis",
            description: "Hilly streets, azulejo facades, and a food scene that punches way above its weight. Affordable and full of character.",
            imageName: "lisbon",
            coordinate: .init(latitude: 38.7223, longitude: -9.1393),
            priceRange: .budget,
            tags: ["food", "culture", "nightlife"]
        ),
    ]
}

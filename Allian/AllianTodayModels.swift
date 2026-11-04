import SwiftUI

struct AllianPlace: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let emoji: String
    let subtitle: String
    let colors: [Color]
}

struct AllianCountry: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    let food: String
    let fashion: String
    let landmark: String
}

enum HouseLayout: String, CaseIterable, Identifiable {
    case one = "1 Bedroom"
    case two = "2 Bedrooms"
    case three = "3 Bedrooms"
    case four = "4 Bedrooms"

    var id: String { rawValue }
    var rooms: Int {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        }
    }
}

enum RoomChoice: String, CaseIterable, Identifiable {
    case shared = "Share a Room"
    case separate = "Separate Rooms"
    case decideLater = "Choose Later"
    var id: String { rawValue }
}

struct AllianMiniGame: Identifiable, Hashable {
    let id: Int
    let title: String
    let emoji: String
    let kind: MiniGameKind
}

enum MiniGameKind: String, CaseIterable, Hashable {
    case cooking = "Cooking"
    case swimming = "Swimming"
    case fashion = "Fashion"
    case petCare = "Pet Care"
    case building = "Building"
    case art = "Art"
    case adventure = "Adventure"
    case sports = "Sports"
    case dancing = "Dancing"
    case music = "Music"

    var emoji: String {
        switch self {
        case .cooking: return "🍳"
        case .swimming: return "🏊‍♀️"
        case .fashion: return "👗"
        case .petCare: return "🐶"
        case .building: return "🏠"
        case .art: return "🎨"
        case .adventure: return "🌈"
        case .sports: return "⚽️"
        case .dancing: return "💃"
        case .music: return "🎵"
        }
    }
}

struct AllianPalette {
    static let pink = Color(red: 1.00, green: 0.35, blue: 0.69)
    static let purple = Color(red: 0.49, green: 0.31, blue: 0.96)
    static let blue = Color(red: 0.20, green: 0.67, blue: 1.00)
    static let softPink = Color(red: 1.00, green: 0.90, blue: 0.96)
    static let softPurple = Color(red: 0.93, green: 0.89, blue: 1.00)
    static let softBlue = Color(red: 0.88, green: 0.96, blue: 1.00)

    static let mainGradient = LinearGradient(
        colors: [softPink, softPurple, softBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func cardGradient(_ colors: [Color]) -> LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension View {
    func allianCard() -> some View {
        self
            .background(Color.white.opacity(0.94))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 2)
            )
            .shadow(color: AllianPalette.purple.opacity(0.16), radius: 14, x: 0, y: 8)
    }
}

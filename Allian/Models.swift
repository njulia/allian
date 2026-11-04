import SwiftUI

enum MainTab: String, CaseIterable, Identifiable {
    case world, house, avatar, games, phone
    var id: String { rawValue }
    var title: String {
        switch self {
        case .world: return "World"
        case .house: return "House"
        case .avatar: return "Avatar"
        case .games: return "Games"
        case .phone: return "Phone"
        }
    }
    var icon: String {
        switch self {
        case .world: return "globe.europe.africa.fill"
        case .house: return "house.fill"
        case .avatar: return "tshirt.fill"
        case .games: return "gamecontroller.fill"
        case .phone: return "iphone"
        }
    }
}

enum AvatarBase: String, CaseIterable, Identifiable {
    case girl = "Girl"
    case boy = "Boy"
    var id: String { rawValue }
    var emoji: String { self == .girl ? "👧" : "👦" }
}

enum AvatarCategory: String, CaseIterable, Identifiable {
    case hair = "Hair"
    case eyes = "Eyes"
    case eyebrows = "Eyebrows"
    case face = "Face"
    case lips = "Lips"
    case tops = "Tops"
    case cropTops = "Crop Tops"
    case bottoms = "Bottoms"
    case dresses = "Dresses"
    case shoes = "Shoes"
    case hats = "Hats"
    case bags = "Bags"
    case accessories = "Accessories"
    case pets = "Pets"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .hair: return "scissors"
        case .eyes: return "eye.fill"
        case .eyebrows: return "scribble"
        case .face: return "face.smiling"
        case .lips: return "heart.fill"
        case .tops, .cropTops: return "tshirt.fill"
        case .bottoms: return "figure.walk"
        case .dresses: return "sparkles"
        case .shoes: return "shoe.fill"
        case .hats: return "graduationcap.fill"
        case .bags: return "bag.fill"
        case .accessories: return "star.fill"
        case .pets: return "pawprint.fill"
        }
    }
}

struct AvatarOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let hex: String
}

struct WorldPlace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let subtitle: String
    let colors: [String]
}

struct TravelDestination: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    let emoji: String
    let food: String
    let fashion: String
    let colors: [String]
}

struct MiniGame: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let category: String
    let cooperativeTip: String
    let colors: [String]
}

struct HouseStyle: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
}

struct DecorItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let room: String
}

struct FoodItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
}

struct FriendProfile: Identifiable, Hashable {
    let id = UUID()
    let allianName: String
    let emoji: String
    let homeName: String
}

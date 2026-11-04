import SwiftUI
import Combine
import Foundation

@MainActor
final class GameStore: ObservableObject {
    private static let characterSaveKey = "allian.savedCharacter.v1"
    private var persistenceCancellable: AnyCancellable?

    private struct SavedCharacter: Codable {
        let characterName: String
        let avatarBase: String
        let selectedHair: String
        let selectedEyes: String
        let selectedEyebrows: String
        let selectedFace: String
        let selectedLips: String
        let selectedTop: String
        let selectedCropTop: String
        let selectedBottom: String
        let selectedDress: String
        let selectedShoes: String
        let selectedHat: String
        let selectedBag: String
        let selectedAccessory: String
        let selectedPet: String
        let selectedSwimwear: String
        let wearingDress: Bool
        let wearingCropTop: Bool
        let wearingSwimwear: Bool
    }
    @Published var onboardingComplete = false
    @Published var onboardingStep = 0
    @Published var selectedTab: MainTab = .world

    @Published var characterName = ""
    @Published var showUnsafeNameMessage = false

    @Published var avatarBase: AvatarBase = .girl
    @Published var selectedHair = "Chocolate Waves"
    @Published var selectedEyes = "Brown Sparkle"
    @Published var selectedEyebrows = "Soft Arch"
    @Published var selectedFace = "Warm"
    @Published var selectedLips = "Rose"
    @Published var selectedTop = "Heart Tee"
    @Published var selectedCropTop = "Pink Heart Crop"
    @Published var selectedBottom = "White Jeans"
    @Published var selectedDress = "Rainbow Dress"
    @Published var selectedShoes = "Pink Trainers"
    @Published var selectedHat = "No Hat"
    @Published var selectedBag = "Heart Bag"
    @Published var selectedAccessory = "Pink Bow"
    @Published var selectedPet = "Kitten"
    @Published var selectedSwimwear = "Pink Flower One-Piece"
    @Published var wearingDress = false
    @Published var wearingCropTop = false
    @Published var wearingSwimwear = false

    init() {
        restoreSavedCharacter()

        // Save the current character automatically whenever the store changes.
        // The guard inside saveCharacterIfNeeded() means first-time onboarding
        // is not persisted until the player actually finishes setup.
        persistenceCancellable = objectWillChange
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveCharacterIfNeeded()
            }
    }

    @Published var selectedHouse = "Modern House"
    @Published var selectedRoom = "Living Room"
    @Published var roomDecor: [String: [String]] = [:]

    @Published var friendSearch = ""
    @Published var invitedFriend: FriendProfile?
    @Published var livingTogether = false

    @Published var selectedCountry = "Italy"
    @Published var selectedFood = "Pizza"
    @Published var latestDelivery: FoodItem?

    let hair: [AvatarOption] = [
        .init(name: "Chocolate Waves", emoji: "〰️", hex: "6B3A2A"),
        .init(name: "Black Buns", emoji: "🎀", hex: "251C29"),
        .init(name: "Golden Ponytail", emoji: "✨", hex: "D9A24B"),
        .init(name: "Pink Bob", emoji: "🌸", hex: "F277B5"),
        .init(name: "Blue Curls", emoji: "💙", hex: "4C7BD9"),
        .init(name: "Dark Curls", emoji: "⭐️", hex: "3C2A2E")
    ]

    let eyes: [AvatarOption] = [
        .init(name: "Brown Sparkle", emoji: "🤎", hex: "5D3A2D"),
        .init(name: "Ocean Blue", emoji: "💙", hex: "3A7BD5"),
        .init(name: "Green Glow", emoji: "💚", hex: "4A9B68"),
        .init(name: "Hazel", emoji: "✨", hex: "8B6B3E"),
        .init(name: "Violet", emoji: "💜", hex: "7A55B8")
    ]

    let eyebrows: [AvatarOption] = [
        .init(name: "Soft Arch", emoji: "⌒", hex: "6C4432"),
        .init(name: "Straight", emoji: "—", hex: "4A352D"),
        .init(name: "Bold", emoji: "➖", hex: "2B2020"),
        .init(name: "Curved", emoji: "◡", hex: "7B4B39")
    ]

    let faces: [AvatarOption] = [
        .init(name: "Fair", emoji: "☺︎", hex: "F6D1B5"),
        .init(name: "Warm", emoji: "☺︎", hex: "EAB58E"),
        .init(name: "Golden", emoji: "☺︎", hex: "C98E62"),
        .init(name: "Deep", emoji: "☺︎", hex: "7E503B"),
        .init(name: "Rich", emoji: "☺︎", hex: "57382F")
    ]

    let lips: [AvatarOption] = [
        .init(name: "Rose", emoji: "💗", hex: "C65570"),
        .init(name: "Peach", emoji: "🍑", hex: "DD7C75"),
        .init(name: "Berry", emoji: "🍓", hex: "A73C63"),
        .init(name: "Natural", emoji: "✨", hex: "A96057")
    ]

    let tops: [AvatarOption] = [
        .init(name: "Heart Tee", emoji: "💗", hex: "FF82B8"),
        .init(name: "Sky Hoodie", emoji: "☁️", hex: "68B7FF"),
        .init(name: "Lavender Jacket", emoji: "💜", hex: "A68BFF"),
        .init(name: "Mint Top", emoji: "🌿", hex: "72D7BA"),
        .init(name: "Star Sweater", emoji: "⭐️", hex: "FFB7DB"),
        .init(name: "Blue Varsity", emoji: "💙", hex: "467FDB")
    ]

    let cropTops: [AvatarOption] = [
        .init(name: "Pink Heart Crop", emoji: "💗", hex: "FF82B8"),
        .init(name: "Lavender Crop", emoji: "💜", hex: "A880EE"),
        .init(name: "Blue Star Crop", emoji: "⭐️", hex: "5CA9FF"),
        .init(name: "Black Sparkle Crop", emoji: "✨", hex: "352E43"),
        .init(name: "Mint Crop", emoji: "🌿", hex: "72D7BA"),
        .init(name: "Peach Crop", emoji: "🍑", hex: "FF9C9C")
    ]

    let bottoms: [AvatarOption] = [
        .init(name: "White Jeans", emoji: "🤍", hex: "F6F4FA"),
        .init(name: "Blue Jeans", emoji: "👖", hex: "4A82C8"),
        .init(name: "Pink Shorts", emoji: "🌸", hex: "F48AB7"),
        .init(name: "Black Shorts", emoji: "🖤", hex: "2D2D3B"),
        .init(name: "Lavender Skirt", emoji: "💜", hex: "B596F2"),
        .init(name: "Denim Skirt", emoji: "💙", hex: "5E91C7")
    ]

    let dresses: [AvatarOption] = [
        .init(name: "Rainbow Dress", emoji: "🌈", hex: "F88FBF"),
        .init(name: "Lavender Dress", emoji: "💜", hex: "B692E8"),
        .init(name: "Blue Party Dress", emoji: "💙", hex: "65A8FF"),
        .init(name: "Star Dress", emoji: "⭐️", hex: "FFB0D4")
    ]

    let shoes: [AvatarOption] = [
        .init(name: "Pink Trainers", emoji: "👟", hex: "FF8DBD"),
        .init(name: "Blue Trainers", emoji: "👟", hex: "5D9FEB"),
        .init(name: "White Boots", emoji: "🥾", hex: "F8F5FC"),
        .init(name: "Purple Shoes", emoji: "👟", hex: "9A73E2")
    ]

    let hats: [AvatarOption] = [
        .init(name: "No Hat", emoji: "✨", hex: "FFFFFF"),
        .init(name: "Pink Cap", emoji: "🧢", hex: "FF91C1"),
        .init(name: "Blue Cap", emoji: "🧢", hex: "5EABFF"),
        .init(name: "Crown", emoji: "👑", hex: "FFD35A")
    ]

    let bags: [AvatarOption] = [
        .init(name: "Heart Bag", emoji: "👜", hex: "FF83B4"),
        .init(name: "Purple Backpack", emoji: "🎒", hex: "9C78EA"),
        .init(name: "Blue Backpack", emoji: "🎒", hex: "5DA5F4"),
        .init(name: "Star Bag", emoji: "⭐️", hex: "FFC75B")
    ]

    let accessories: [AvatarOption] = [
        .init(name: "Pink Bow", emoji: "🎀", hex: "FF7DB4"),
        .init(name: "Heart Glasses", emoji: "💗", hex: "FF6FAC"),
        .init(name: "Headphones", emoji: "🎧", hex: "8B70F3"),
        .init(name: "Flower", emoji: "🌸", hex: "FF9FCB")
    ]

    let pets: [AvatarOption] = [
        .init(name: "Kitten", emoji: "🐱", hex: "FFFFFF"),
        .init(name: "Puppy", emoji: "🐶", hex: "D49A6A"),
        .init(name: "Bunny", emoji: "🐰", hex: "FFF6FB"),
        .init(name: "Penguin", emoji: "🐧", hex: "2C3342"),
        .init(name: "Unicorn", emoji: "🦄", hex: "F0C8FF")
    ]

    // Simple, child-friendly swimwear for the Water Park wardrobe.
    // Everything is free and selecting an item changes the avatar immediately.
    let girlSwimwear: [AvatarOption] = [
        .init(name: "Pink Flower One-Piece", emoji: "🌺", hex: "FF6FB2"),
        .init(name: "Purple Heart One-Piece", emoji: "💜", hex: "9A7AF2"),
        .init(name: "Pink Ruffle Set", emoji: "🎀", hex: "FF8BC4"),
        .init(name: "Blue Check Set", emoji: "💙", hex: "63B6F6")
    ]

    let boySwimwear: [AvatarOption] = [
        .init(name: "Navy Swim Shorts", emoji: "🌊", hex: "3156A6"),
        .init(name: "Aqua Palm Shorts", emoji: "🌴", hex: "31C5C2"),
        .init(name: "Blue Rashguard Set", emoji: "🌊", hex: "4BA7E8"),
        .init(name: "Green Shark Set", emoji: "🦈", hex: "7FD653")
    ]

    let places: [WorldPlace] = [
        .init(name: "Mall", emoji: "🛍️", subtitle: "Lots of colourful shops", colors: ["FF82B8", "A980F4"]),
        .init(name: "Supermarket", emoji: "🛒", subtitle: "Pick pretend food for home", colors: ["64BEFF", "7FE3D1"]),
        .init(name: "Clothes Store", emoji: "👗", subtitle: "Try every style for free", colors: ["FF86BE", "FFB2D5"]),
        .init(name: "Shoe Store", emoji: "👟", subtitle: "Trainers, boots and more", colors: ["6AA9FF", "A78AFF"]),
        .init(name: "Hat Store", emoji: "👒", subtitle: "Caps, crowns and hats", colors: ["FFB46A", "FF8AB9"]),
        .init(name: "Bag Store", emoji: "👜", subtitle: "Bags and backpacks", colors: ["A982F4", "6BB2FF"]),
        .init(name: "Toy Store", emoji: "🧸", subtitle: "Pretend toys and dolls", colors: ["FF9EA2", "FFD56A"]),
        .init(name: "Baby Store", emoji: "🍼", subtitle: "Cute pretend baby things", colors: ["FFB8D7", "A8D8FF"]),
        .init(name: "Phone Store", emoji: "📱", subtitle: "Pretend phones and gadgets", colors: ["64B5FF", "9A84F5"]),
        .init(name: "Hairdresser", emoji: "💇", subtitle: "Try colourful hairstyles", colors: ["FF7EB9", "C08AF5"]),
        .init(name: "Nail Salon", emoji: "💅", subtitle: "Make colourful nail art", colors: ["D379F0", "FF84B7"]),
        .init(name: "Cafe & Restaurant", emoji: "🍝", subtitle: "Pretend meals with friends", colors: ["FFAA6E", "FF7FAE"]),
        .init(name: "Aquarium", emoji: "🐠", subtitle: "Explore colourful sea life", colors: ["55B9FF", "60DBE9"]),
        .init(name: "Zoo", emoji: "🦒", subtitle: "Meet friendly animals", colors: ["72D49A", "FFD15F"]),
        .init(name: "Beach", emoji: "🏖️", subtitle: "Sandcastles and seaside fun", colors: ["65C9FF", "FFD96C"]),
        .init(name: "Swimming Pool", emoji: "🏊", subtitle: "Splash and play together", colors: ["5CB8FF", "73E1E3"]),
        .init(name: "Game Room", emoji: "🎮", subtitle: "Find even more games", colors: ["A069F2", "FF6FB0"]),
        .init(name: "School", emoji: "🏫", subtitle: "Optional pretend school role-play", colors: ["FFB86F", "68B6FF"])
    ]

    let destinations: [TravelDestination] = [
        .init(name: "Spain", flag: "🇪🇸", emoji: "🏰", food: "Paella & churros", fashion: "Sunny colourful styles", colors: ["FFB45C", "FF6B91"]),
        .init(name: "China", flag: "🇨🇳", emoji: "🏯", food: "Dumplings & noodles", fashion: "Modern and traditional-inspired looks", colors: ["EF5561", "FFD25C"]),
        .init(name: "Japan", flag: "🇯🇵", emoji: "⛩️", food: "Sushi & ramen", fashion: "Cute street styles", colors: ["FF8EB9", "A98BF5"]),
        .init(name: "Korea", flag: "🇰🇷", emoji: "🌸", food: "Bibimbap & rice dishes", fashion: "Colourful city looks", colors: ["72B7FF", "FF94C5"]),
        .init(name: "Italy", flag: "🇮🇹", emoji: "🏛️", food: "Pizza & spaghetti", fashion: "Bright city outfits", colors: ["6BCB8E", "FF8A8A"]),
        .init(name: "Germany", flag: "🇩🇪", emoji: "🏰", food: "Pretzels & bakery treats", fashion: "Cosy city styles", colors: ["FFC85C", "EB6A7D"]),
        .init(name: "France", flag: "🇫🇷", emoji: "🗼", food: "Croissants & crepes", fashion: "Pretty city outfits", colors: ["6BA8FF", "FF85B6"]),
        .init(name: "United Kingdom", flag: "🇬🇧", emoji: "🎡", food: "Picnic & cafe treats", fashion: "Raincoats and colourful layers", colors: ["6A84F5", "FF668F"]),
        .init(name: "USA", flag: "🇺🇸", emoji: "🗽", food: "Burgers & pancakes", fashion: "Casual colourful looks", colors: ["5DA9FF", "FF6E8F"])
    ]

    let houses: [HouseStyle] = [
        .init(name: "Pool Villa", emoji: "🏡", description: "A bright house with a big swimming pool"),
        .init(name: "Pink Townhouse", emoji: "🏘️", description: "A cosy pink house near the shops"),
        .init(name: "Modern House", emoji: "🏠", description: "A bright modern home with a pretty inside layout"),
        .init(name: "Beach House", emoji: "🏖️", description: "A sunny house beside the beach")
    ]

    let rooms = ["Living Room", "Bedroom", "Kitchen", "Bathroom", "Game Room", "Pool Garden"]

    let decorItems: [DecorItem] = [
        .init(name: "Pink Sofa", emoji: "🛋️", room: "Living Room"), .init(name: "TV", emoji: "📺", room: "Living Room"),
        .init(name: "Lamp", emoji: "💡", room: "Living Room"), .init(name: "Plant", emoji: "🪴", room: "Living Room"),
        .init(name: "Bed", emoji: "🛏️", room: "Bedroom"), .init(name: "Teddy", emoji: "🧸", room: "Bedroom"),
        .init(name: "Wardrobe", emoji: "🚪", room: "Bedroom"), .init(name: "Mirror", emoji: "🪞", room: "Bedroom"),
        .init(name: "Dining Table", emoji: "🍽️", room: "Kitchen"), .init(name: "Fridge", emoji: "🧊", room: "Kitchen"),
        .init(name: "Cupcakes", emoji: "🧁", room: "Kitchen"), .init(name: "Fruit", emoji: "🍓", room: "Kitchen"),
        .init(name: "Bath", emoji: "🛁", room: "Bathroom"), .init(name: "Towels", emoji: "🧺", room: "Bathroom"),
        .init(name: "Arcade", emoji: "🕹️", room: "Game Room"), .init(name: "Game Console", emoji: "🎮", room: "Game Room"),
        .init(name: "Pool Float", emoji: "🛟", room: "Pool Garden"), .init(name: "Palm Tree", emoji: "🌴", room: "Pool Garden"),
        .init(name: "Flowers", emoji: "🌸", room: "Pool Garden"), .init(name: "Picnic", emoji: "🧺", room: "Pool Garden")
    ]

    let foods: [FoodItem] = [
        .init(name: "Pizza", emoji: "🍕"), .init(name: "Burger", emoji: "🍔"), .init(name: "Sushi", emoji: "🍣"),
        .init(name: "Noodles", emoji: "🍜"), .init(name: "Tacos", emoji: "🌮"), .init(name: "Fruit", emoji: "🍓"),
        .init(name: "Cupcake", emoji: "🧁"), .init(name: "Ice Cream", emoji: "🍦"), .init(name: "Pancakes", emoji: "🥞")
    ]

    let demoFriends: [FriendProfile] = [
        .init(allianName: "SunnyGirl", emoji: "👧🏽", homeName: "Pool Villa"),
        .init(allianName: "PinkBunny", emoji: "👧🏻", homeName: "Pink Townhouse"),
        .init(allianName: "BestieStar", emoji: "👦🏾", homeName: "Modern House"),
        .init(allianName: "HappyPlay", emoji: "👦🏻", homeName: "Beach House")
    ]

    lazy var miniGames: [MiniGame] = Self.makeMiniGames()

    /// Called once the player finishes the first-time setup.
    /// From then on, the saved character is restored automatically on launch.
    func finishOnboarding() {
        guard safeName(characterName) else {
            showUnsafeNameMessage = true
            onboardingStep = 1
            return
        }

        showUnsafeNameMessage = false
        onboardingComplete = true
        onboardingStep = 0
        selectedTab = .world
        persistCharacter()
    }

    /// Explicit save used by the Dress Up screen. Avatar changes also autosave.
    func saveCharacter() {
        guard onboardingComplete else { return }
        persistCharacter()
    }

    /// Lets the player intentionally rename/remake the character. The previous
    /// saved character stays safe until the new setup is completed.
    func beginCharacterChange() {
        onboardingComplete = false
        onboardingStep = 1
        showUnsafeNameMessage = false
        characterName = ""
    }

    private func saveCharacterIfNeeded() {
        guard onboardingComplete else { return }
        persistCharacter()
    }

    private func persistCharacter() {
        let snapshot = SavedCharacter(
            characterName: characterName,
            avatarBase: avatarBase.rawValue,
            selectedHair: selectedHair,
            selectedEyes: selectedEyes,
            selectedEyebrows: selectedEyebrows,
            selectedFace: selectedFace,
            selectedLips: selectedLips,
            selectedTop: selectedTop,
            selectedCropTop: selectedCropTop,
            selectedBottom: selectedBottom,
            selectedDress: selectedDress,
            selectedShoes: selectedShoes,
            selectedHat: selectedHat,
            selectedBag: selectedBag,
            selectedAccessory: selectedAccessory,
            selectedPet: selectedPet,
            selectedSwimwear: selectedSwimwear,
            wearingDress: wearingDress,
            wearingCropTop: wearingCropTop,
            wearingSwimwear: wearingSwimwear
        )

        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.characterSaveKey)
    }

    private func restoreSavedCharacter() {
        guard
            let data = UserDefaults.standard.data(forKey: Self.characterSaveKey),
            let saved = try? JSONDecoder().decode(SavedCharacter.self, from: data),
            !saved.characterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }

        characterName = saved.characterName
        avatarBase = AvatarBase(rawValue: saved.avatarBase) ?? .girl
        selectedHair = saved.selectedHair
        selectedEyes = saved.selectedEyes
        selectedEyebrows = saved.selectedEyebrows
        selectedFace = saved.selectedFace
        selectedLips = saved.selectedLips
        selectedTop = saved.selectedTop
        selectedCropTop = saved.selectedCropTop
        selectedBottom = saved.selectedBottom
        selectedDress = saved.selectedDress
        selectedShoes = saved.selectedShoes
        selectedHat = saved.selectedHat
        selectedBag = saved.selectedBag
        selectedAccessory = saved.selectedAccessory
        selectedPet = saved.selectedPet
        selectedSwimwear = saved.selectedSwimwear
        wearingDress = saved.wearingDress
        wearingCropTop = saved.wearingCropTop
        wearingSwimwear = saved.wearingSwimwear

        onboardingComplete = true
        onboardingStep = 0
    }

    func safeName(_ input: String) -> Bool {
        let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard (2...18).contains(value.count) else { return false }
        let lower = value.lowercased()
        let blocked = ["poop", "poo", "wee", "pee", "shit", "fuck", "bitch", "dick", "cock", "asshole", "sex", "kill", "hate"]
        guard blocked.allSatisfy({ !lower.contains($0) }) else { return false }
        guard !lower.contains("@"), value.range(of: #"\d{6,}"#, options: .regularExpression) == nil else { return false }
        return true
    }

    func continueFromName() {
        if safeName(characterName) {
            showUnsafeNameMessage = false
            onboardingStep = 2
        } else {
            showUnsafeNameMessage = true
        }
    }

    func roomKey() -> String { "\(selectedHouse)|\(selectedRoom)" }
    func addDecor(_ item: DecorItem) { roomDecor[roomKey(), default: []].append(item.emoji) }
    func clearRoom() { roomDecor[roomKey()] = [] }
    func currentDecor() -> [String] { roomDecor[roomKey()] ?? [] }

    func order(_ food: FoodItem) {
        selectedFood = food.name
        latestDelivery = food
    }

    func findFriend() -> FriendProfile? {
        let query = friendSearch.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return nil }
        return demoFriends.first { $0.allianName.lowercased() == query }
    }

    private static func makeMiniGames() -> [MiniGame] {
        let categories: [(String, String, [String])] = [
            ("Cooking", "🍳", ["FF9F7F", "FFCA71"]), ("Swimming", "🏊", ["58B8FF", "61E1E7"]),
            ("Fashion", "👗", ["FF79B2", "B27AF1"]), ("Pet Care", "🐶", ["FFB47E", "FF88B7"]),
            ("Building", "🧱", ["9D7BF3", "62B8FF"]), ("Art", "🎨", ["FF7DB5", "FFCE67"]),
            ("Dance", "💃", ["BD75F5", "FF72B1"]), ("Music", "🎵", ["687DF7", "B474F3"]),
            ("Sports", "⚽️", ["62CC9A", "5EB7FF"]), ("Adventure", "🗺️", ["5BB9FF", "A779F4"]),
            ("Beach", "🏖️", ["65C9FF", "FFD466"]), ("Zoo", "🦒", ["75D79D", "FFC960"]),
            ("Aquarium", "🐠", ["55C3FF", "5DE5DC"]), ("Garden", "🌷", ["72D79E", "FF86B8"]),
            ("Salon", "💇", ["FF73B0", "C57EF2"]), ("Nail Art", "💅", ["C476EE", "FF85B6"]),
            ("Hide & Seek", "🙈", ["FFB86E", "7EB6FF"]), ("Toy Play", "🧸", ["FFC460", "FF89B6"]),
            ("House", "🏠", ["FF86B8", "8A8CF4"]), ("Kindness", "💗", ["FF76AD", "B88AF5"])
        ]
        let endings = ["Party", "Adventure", "Club", "Studio", "Day", "World"]
        var result: [MiniGame] = []
        for (category, emoji, colors) in categories {
            for ending in endings {
                result.append(.init(name: "\(category) \(ending)", emoji: emoji, category: category, cooperativeTip: "Play together, help each other and finish as a team.", colors: colors))
            }
        }
        return result
    }
}

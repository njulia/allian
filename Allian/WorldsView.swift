import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct PlaceDirectoryView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ApprovedArt(name: "TravelWorldArt", height: 230)
                    SectionTitle(title: "Explore Allian", subtitle: "Tap anywhere you want to visit")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(store.places) { place in
                            NavigationLink {
                                PlaceDetailView(place: place)
                            } label: {
                                PlaceCard(place: place)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Explore the World")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaceDetailView: View {
    let place: WorldPlace
    @EnvironmentObject private var store: GameStore
    @State private var message = ""

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 34)
                            .fill(LinearGradient(colors: place.colors.map(Color.init(hex:)), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 300)
                        VStack(spacing: 10) {
                            Text(place.emoji).font(.system(size: 100))
                            Text(place.name)
                                .font(.system(.largeTitle, design: .rounded).weight(.black))
                                .foregroundStyle(.white)
                            Text(place.subtitle)
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundStyle(.white.opacity(0.92))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }

                    AllianCard {
                        VStack(spacing: 12) {
                            Text("What do you want to do?")
                                .font(.system(.title3, design: .rounded).weight(.black))
                                .foregroundStyle(AllianTheme.ink)

                            actionButton("Explore", emoji: "✨") { message = "You are exploring \(place.name)!" }
                            actionButton("Invite a friend", emoji: "🫶") { message = "Open Friends and invite an Allian character name." }
                            actionButton("Play together", emoji: "🎮") { message = "Choose a mini-game and help each other." }
                        }
                    }

                    if !message.isEmpty {
                        Text("💗 \(message)")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundStyle(Color(hex: "694892"))
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 22))
                    }
                }
                .padding(14)
            }
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func actionButton(_ title: String, emoji: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(emoji).font(.title2)
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.black))
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(AllianTheme.ink)
            .padding(14)
            .background(LinearGradient(colors: [AllianTheme.softPink, AllianTheme.softPurple, AllianTheme.softBlue], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

struct TravelView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ApprovedArt(name: "TravelWorldArt", height: 270)

                    HStack(spacing: 10) {
                        travelMode(title: "Airport", emoji: "✈️", color: AllianTheme.pink)
                        travelMode(title: "Train Station", emoji: "🚆", color: AllianTheme.blue)
                    }

                    SectionTitle(title: "Travel to different countries", subtitle: "Explore food, clothes and beautiful places")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(store.destinations) { destination in
                            NavigationLink {
                                CountryView(destination: destination)
                            } label: {
                                VStack(spacing: 7) {
                                    Text(destination.flag).font(.system(size: 42))
                                    Text(destination.name)
                                        .font(.system(.headline, design: .rounded).weight(.black))
                                        .foregroundStyle(.white)
                                    Text(destination.food)
                                        .font(.system(.caption2, design: .rounded).weight(.bold))
                                        .foregroundStyle(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, minHeight: 125)
                                .padding(10)
                                .background(LinearGradient(colors: destination.colors.map(Color.init(hex:)), startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 22))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Travel")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func travelMode(title: String, emoji: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Text(emoji).font(.title2)
            Text(title).font(.system(.subheadline, design: .rounded).weight(.black))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.gradient, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct CountryView: View {
    let destination: TravelDestination
    @State private var selected = "Explore"

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 34)
                            .fill(LinearGradient(colors: destination.colors.map(Color.init(hex:)), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 280)
                        VStack(spacing: 10) {
                            Text(destination.flag).font(.system(size: 86))
                            Text(destination.emoji).font(.system(size: 66))
                            Text(destination.name)
                                .font(.system(.largeTitle, design: .rounded).weight(.black))
                                .foregroundStyle(.white)
                        }
                    }

                    AllianCard {
                        VStack(alignment: .leading, spacing: 12) {
                            infoRow("🍴", "Food", destination.food)
                            infoRow("👕", "Clothes", destination.fashion)
                            infoRow("💗", "All free", "Explore without coins or points")
                        }
                    }

                    Text("This is a playful, respectful introduction to a place — not a complete description of its people or culture.")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(Color(hex: "715787"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(14)
            }
        }
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoRow(_ emoji: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(emoji).font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(.headline, design: .rounded).weight(.black)).foregroundStyle(AllianTheme.ink)
                Text(detail).font(.system(.subheadline, design: .rounded).weight(.bold)).foregroundStyle(Color(hex: "715787"))
            }
        }
    }
}

struct FriendsView: View {
    @EnvironmentObject private var store: GameStore
    @State private var result: FriendProfile?
    @State private var searched = false

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ApprovedArt(name: "FriendsArt", height: 230)

                    AllianCard {
                        VStack(spacing: 12) {
                            Text("Find a Friend")
                                .font(.system(.title2, design: .rounded).weight(.black))
                                .foregroundStyle(AllianTheme.ink)
                            Text("Use their Allian character name — not their real name.")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(Color(hex: "715787"))
                                .multilineTextAlignment(.center)

                            HStack {
                                TextField("Character name...", text: $store.friendSearch)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                    .padding(13)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                                Button {
                                    result = store.findFriend()
                                    searched = true
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title3.weight(.black))
                                        .foregroundStyle(.white)
                                        .frame(width: 48, height: 48)
                                        .background(AllianTheme.blue.gradient, in: RoundedRectangle(cornerRadius: 15))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    if let result {
                        FriendResultCard(friend: result)
                    } else if searched {
                        Text("We couldn't find that demo Allian name. Try SunnyGirl, PinkBunny, BestieStar or HappyPlay.")
                            .font(.system(.subheadline, design: .rounded).weight(.bold))
                            .foregroundStyle(Color(hex: "714E8D"))
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 22))
                    }

                    if let friend = store.invitedFriend {
                        ApprovedArt(name: "FriendsHouseArt", height: 220)
                        AllianCard {
                            VStack(spacing: 10) {
                                Text("💗 Live Together")
                                    .font(.system(.title2, design: .rounded).weight(.black))
                                    .foregroundStyle(AllianTheme.ink)
                                Text("You invited \(friend.allianName). You can choose a shared house and play together.")
                                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                                    .foregroundStyle(Color(hex: "705787"))
                                    .multilineTextAlignment(.center)
                                Toggle("Share a house in this demo", isOn: $store.livingTogether)
                                    .font(.system(.headline, design: .rounded).weight(.bold))
                                    .tint(AllianTheme.pink)
                            }
                        }
                    }

                    SectionTitle(title: "Kind words", subtitle: "Friendly phrase buttons for playing together")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(["Hi! 👋", "Want to play?", "Let's decorate!", "Want to visit the zoo?", "Great job! 💗", "Thank you!", "Let's help each other.", "Let's go home!"], id: \.self) { phrase in
                            Text(phrase)
                                .font(.system(.caption, design: .rounded).weight(.black))
                                .foregroundStyle(AllianTheme.ink)
                                .frame(maxWidth: .infinity, minHeight: 54)
                                .padding(7)
                                .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FriendResultCard: View {
    @EnvironmentObject private var store: GameStore
    let friend: FriendProfile

    var body: some View {
        HStack(spacing: 12) {
            Text(friend.emoji)
                .font(.system(size: 52))
                .frame(width: 72, height: 72)
                .background(AllianTheme.softPink, in: RoundedRectangle(cornerRadius: 20))
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.allianName)
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .foregroundStyle(AllianTheme.ink)
                Text(friend.homeName)
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: "735B88"))
            }
            Spacer()
            Button("Invite") {
                store.invitedFriend = friend
            }
            .font(.system(.subheadline, design: .rounded).weight(.black))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(AllianTheme.purple.gradient, in: Capsule())
        }
        .padding(14)
        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 24))
    }
}

struct MiniGamesView: View {
    @EnvironmentObject private var store: GameStore
    @State private var search = ""

    private var games: [MiniGame] {
        if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return store.miniGames }
        return store.miniGames.filter { $0.name.localizedCaseInsensitiveContains(search) || $0.category.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AllianSwirlBackground().ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        AllianLogo(subtitle: "More than 100 mini-games — just for fun")
                        ApprovedArt(name: "MiniGamesArt", height: 210)

                        NavigationLink {
                            CookPartyView()
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .fill(Color.white.opacity(0.28))
                                        .frame(width: 78, height: 78)
                                    Text("🍳").font(.system(size: 52))
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Cook Party")
                                        .font(.system(.title2, design: .rounded).weight(.black))
                                    Text("Pick a recipe, drag ingredients, prepare, cook, decorate and serve.")
                                        .font(.system(.caption, design: .rounded).weight(.bold))
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Image(systemName: "play.fill")
                                    .font(.title2.weight(.black))
                            }
                            .foregroundStyle(.white)
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "FF6FB4"), Color(hex: "A875F4"), Color(hex: "67B8FF")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: RoundedRectangle(cornerRadius: 26, style: .continuous)
                            )
                            .shadow(color: AllianTheme.purple.opacity(0.22), radius: 12, y: 6)
                        }
                        .buttonStyle(.plain)

                        HStack {
                            Image(systemName: "magnifyingglass").foregroundStyle(AllianTheme.purple)
                            TextField("Find a mini-game", text: $search)
                        }
                        .padding(13)
                        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 18))

                        Text("\(games.count) games • no points • no winners • help each other")
                            .font(.system(.caption, design: .rounded).weight(.black))
                            .foregroundStyle(Color(hex: "6C4F91"))

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(games) { game in
                                NavigationLink {
                                    MiniGamePlayView(game: game)
                                } label: {
                                    VStack(spacing: 7) {
                                        Text(game.emoji).font(.system(size: 40))
                                        Text(game.name)
                                            .font(.system(.subheadline, design: .rounded).weight(.black))
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 118)
                                    .padding(9)
                                    .background(LinearGradient(colors: game.colors.map(Color.init(hex:)), startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 22))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(12)
                    .padding(.bottom, 22)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct MiniGamePlayView: View {
    let game: MiniGame
    @State private var actionCount = 0

    var body: some View {
        Group {
            if game.category == "Cooking" {
                CookPartyView()
            } else {
                ZStack {
                    AllianSwirlBackground().ignoresSafeArea()
                    VStack(spacing: 18) {
                        Text(game.emoji).font(.system(size: 100))
                        Text(game.name)
                            .font(.system(.largeTitle, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.ink)
                            .multilineTextAlignment(.center)
                        Text(game.cooperativeTip)
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundStyle(Color(hex: "6D5388"))
                            .multilineTextAlignment(.center)

                        AllianCard {
                            VStack(spacing: 12) {
                                Text(actionCount == 0 ? "Tap to start playing" : "Keep creating and playing together. 💗")
                                    .font(.system(.headline, design: .rounded).weight(.black))
                                    .foregroundStyle(AllianTheme.ink)
                                    .multilineTextAlignment(.center)
                                Button {
                                    actionCount += 1
                                } label: {
                                    Text(actionCount == 0 ? "Play" : "Do another fun action")
                                        .font(.system(.headline, design: .rounded).weight(.black))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            LinearGradient(
                                                colors: game.colors.map(Color.init(hex:)),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            in: RoundedRectangle(cornerRadius: 18)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Text("No score. No coins. No one loses.")
                            .font(.system(.caption, design: .rounded).weight(.black))
                            .foregroundStyle(Color(hex: "6B4E8C"))
                    }
                    .padding(18)
                }
            }
        }
        .navigationTitle(game.category == "Cooking" ? "Cook Party" : game.category)
        .navigationBarTitleDisplayMode(.inline)
    }
}


private enum CookPartyStage: Int, CaseIterable {
    case ingredients
    case prepare
    case cook
    case decorate
    case serve

    var title: String {
        switch self {
        case .ingredients: return "Ingredients"
        case .prepare: return "Prepare"
        case .cook: return "Cook"
        case .decorate: return "Decorate"
        case .serve: return "Serve"
        }
    }

    var emoji: String {
        switch self {
        case .ingredients: return "🧺"
        case .prepare: return "🥣"
        case .cook: return "🔥"
        case .decorate: return "✨"
        case .serve: return "🍽️"
        }
    }
}

private struct CookPartyFoodItem: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String

    init(_ name: String, _ emoji: String) {
        self.id = name
        self.name = name
        self.emoji = emoji
    }
}

private struct CookPartyRecipe: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let ingredients: [CookPartyFoodItem]
    let decorations: [CookPartyFoodItem]
    let prepareText: String
    let prepareEmoji: String
    let cookText: String
    let cookEmoji: String
    let finishedEmoji: String
    let colors: [String]

    init(
        name: String,
        emoji: String,
        ingredients: [CookPartyFoodItem],
        decorations: [CookPartyFoodItem],
        prepareText: String,
        prepareEmoji: String,
        cookText: String,
        cookEmoji: String,
        finishedEmoji: String,
        colors: [String]
    ) {
        self.id = name
        self.name = name
        self.emoji = emoji
        self.ingredients = ingredients
        self.decorations = decorations
        self.prepareText = prepareText
        self.prepareEmoji = prepareEmoji
        self.cookText = cookText
        self.cookEmoji = cookEmoji
        self.finishedEmoji = finishedEmoji
        self.colors = colors
    }
}

struct CookPartyView: View {
    @EnvironmentObject private var store: GameStore

    @State private var selectedRecipe: CookPartyRecipe?
    @State private var stage: CookPartyStage = .ingredients
    @State private var collectedIngredients: Set<String> = []
    @State private var selectedDecorations: Set<String> = []
    @State private var prepareMoves = 0
    @State private var cookProgress = 0.0
    @State private var isIngredientDropTarget = false
    @State private var plateOffset: CGSize = .zero
    @State private var served = false

    private let requiredPrepareMoves = 5

    private let recipes: [CookPartyRecipe] = [
        CookPartyRecipe(
            name: "Pizza",
            emoji: "🍕",
            ingredients: [
                CookPartyFoodItem("Dough", "🫓"),
                CookPartyFoodItem("Tomato Sauce", "🍅"),
                CookPartyFoodItem("Cheese", "🧀")
            ],
            decorations: [
                CookPartyFoodItem("Pepper", "🫑"),
                CookPartyFoodItem("Mushroom", "🍄"),
                CookPartyFoodItem("Basil", "🌿")
            ],
            prepareText: "Roll the dough. Swipe across the board five times.",
            prepareEmoji: "🫓",
            cookText: "Bake the pizza. Slide the oven control all the way to READY.",
            cookEmoji: "🔥",
            finishedEmoji: "🍕",
            colors: ["FF7DAF", "FFB45F"]
        ),
        CookPartyRecipe(
            name: "Cupcakes",
            emoji: "🧁",
            ingredients: [
                CookPartyFoodItem("Flour", "🌾"),
                CookPartyFoodItem("Egg", "🥚"),
                CookPartyFoodItem("Milk", "🥛")
            ],
            decorations: [
                CookPartyFoodItem("Icing", "🍥"),
                CookPartyFoodItem("Sprinkles", "✨"),
                CookPartyFoodItem("Strawberry", "🍓")
            ],
            prepareText: "Mix the cupcake batter. Swipe around the bowl five times.",
            prepareEmoji: "🥣",
            cookText: "Bake the cupcakes. Slide the oven control all the way to READY.",
            cookEmoji: "♨️",
            finishedEmoji: "🧁",
            colors: ["FF82C2", "AE82F5"]
        ),
        CookPartyRecipe(
            name: "Burgers",
            emoji: "🍔",
            ingredients: [
                CookPartyFoodItem("Bun", "🥯"),
                CookPartyFoodItem("Patty", "🥩"),
                CookPartyFoodItem("Lettuce", "🥬")
            ],
            decorations: [
                CookPartyFoodItem("Cheese", "🧀"),
                CookPartyFoodItem("Tomato", "🍅"),
                CookPartyFoodItem("Pickles", "🥒")
            ],
            prepareText: "Shape the burger patty. Swipe across it five times.",
            prepareEmoji: "🥩",
            cookText: "Cook the burger. Slide the pan control all the way to READY.",
            cookEmoji: "🍳",
            finishedEmoji: "🍔",
            colors: ["FF9C67", "FF6F91"]
        ),
        CookPartyRecipe(
            name: "Noodles",
            emoji: "🍜",
            ingredients: [
                CookPartyFoodItem("Noodles", "🍜"),
                CookPartyFoodItem("Carrot", "🥕"),
                CookPartyFoodItem("Pepper", "🫑")
            ],
            decorations: [
                CookPartyFoodItem("Egg", "🍳"),
                CookPartyFoodItem("Spring Onion", "🌿"),
                CookPartyFoodItem("Sesame", "✨")
            ],
            prepareText: "Prepare the vegetables. Swipe across the chopping board five times.",
            prepareEmoji: "🔪",
            cookText: "Stir the noodles. Slide the pan control all the way to READY.",
            cookEmoji: "🥘",
            finishedEmoji: "🍜",
            colors: ["72B7FF", "A77CF4"]
        ),
        CookPartyRecipe(
            name: "Fruit Salad",
            emoji: "🍓",
            ingredients: [
                CookPartyFoodItem("Strawberry", "🍓"),
                CookPartyFoodItem("Banana", "🍌"),
                CookPartyFoodItem("Grapes", "🍇")
            ],
            decorations: [
                CookPartyFoodItem("Blueberries", "🫐"),
                CookPartyFoodItem("Kiwi", "🥝"),
                CookPartyFoodItem("Orange", "🍊")
            ],
            prepareText: "Chop the fruit. Swipe across the chopping board five times.",
            prepareEmoji: "🔪",
            cookText: "Toss the fruit together. Slide the bowl control all the way to READY.",
            cookEmoji: "🥣",
            finishedEmoji: "🥗",
            colors: ["74D79D", "FF86B8"]
        )
    ]

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()

            if let recipe = selectedRecipe {
                recipeGame(recipe)
            } else {
                recipePicker
            }
        }
        .navigationTitle("Cook Party")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var recipePicker: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("🍳 Cook Party")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                    Text("Choose what you want to make. Then really prepare it.")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(Color(hex: "6D5388"))
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 10) {
                    Text(store.avatarBase.emoji).font(.system(size: 54))
                    if store.livingTogether {
                        Text(store.invitedFriend?.emoji ?? "🧑").font(.system(size: 54))
                        Text("Cook together 💗")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.purple)
                    } else {
                        Text("You can cook by yourself or with a friend.")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.purple)
                    }
                }
                .padding(12)
                .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 22))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(recipes) { recipe in
                        Button {
                            start(recipe)
                        } label: {
                            VStack(spacing: 9) {
                                Text(recipe.emoji).font(.system(size: 58))
                                Text(recipe.name)
                                    .font(.system(.headline, design: .rounded).weight(.black))
                                    .foregroundStyle(.white)
                                Text("Make it")
                                    .font(.system(.caption, design: .rounded).weight(.black))
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity, minHeight: 145)
                            .padding(10)
                            .background(
                                LinearGradient(
                                    colors: recipe.colors.map(Color.init(hex:)),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: RoundedRectangle(cornerRadius: 24)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("No scores • no coins • no winners • just cooking and playing")
                    .font(.system(.caption, design: .rounded).weight(.black))
                    .foregroundStyle(Color(hex: "6B4E8C"))
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .padding(.bottom, 26)
        }
    }

    private func recipeGame(_ recipe: CookPartyRecipe) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                HStack {
                    Button {
                        selectedRecipe = nil
                        resetGame()
                    } label: {
                        Label("Recipes", systemImage: "chevron.left")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.purple)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 9)
                            .background(.white.opacity(0.9), in: Capsule())
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text("\(recipe.emoji) \(recipe.name)")
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                }

                stageStrip

                Group {
                    switch stage {
                    case .ingredients:
                        ingredientStage(recipe)
                    case .prepare:
                        prepareStage(recipe)
                    case .cook:
                        cookStage(recipe)
                    case .decorate:
                        decorateStage(recipe)
                    case .serve:
                        serveStage(recipe)
                    }
                }
                .animation(.spring(response: 0.32, dampingFraction: 0.85), value: stage.rawValue)
            }
            .padding(16)
            .padding(.bottom, 30)
        }
    }

    private var stageStrip: some View {
        HStack(spacing: 5) {
            ForEach(CookPartyStage.allCases, id: \.rawValue) { item in
                VStack(spacing: 3) {
                    Text(item.emoji).font(.system(size: 20))
                    Text(item.title)
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .lineLimit(1)
                }
                .foregroundStyle(item.rawValue <= stage.rawValue ? Color.white : Color(hex: "735B88"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    item.rawValue <= stage.rawValue
                    ? AnyShapeStyle(
                        LinearGradient(
                            colors: [AllianTheme.pink, AllianTheme.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    : AnyShapeStyle(Color.white.opacity(0.82)),
                    in: RoundedRectangle(cornerRadius: 14)
                )
            }
        }
    }

    private func ingredientStage(_ recipe: CookPartyRecipe) -> some View {
        VStack(spacing: 16) {
            Text("1. Put the ingredients in the bowl")
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Text("Drag each ingredient into the bowl. You can also tap an ingredient.")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "6D5388"))
                .multilineTextAlignment(.center)

            HStack(spacing: 10) {
                ForEach(recipe.ingredients) { item in
                    Button {
                        collectedIngredients.insert(item.id)
                    } label: {
                        VStack(spacing: 6) {
                            Text(item.emoji).font(.system(size: 44))
                            Text(item.name)
                                .font(.system(.caption2, design: .rounded).weight(.black))
                                .foregroundStyle(AllianTheme.ink)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, minHeight: 98)
                        .background(
                            collectedIngredients.contains(item.id)
                            ? AllianTheme.softPink
                            : Color.white.opacity(0.92),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    collectedIngredients.contains(item.id) ? AllianTheme.pink : Color.white,
                                    lineWidth: 3
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .onDrag {
                        NSItemProvider(object: item.id as NSString)
                    }
                }
            }

            VStack(spacing: 8) {
                Text(collectedIngredients.isEmpty ? "🥣" : bowlContents(recipe))
                    .font(.system(size: collectedIngredients.isEmpty ? 82 : 56))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(
                    collectedIngredients.count == recipe.ingredients.count
                    ? "Everything is in the bowl!"
                    : "Drop ingredients here"
                )
                .font(.system(.headline, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.purple)
            }
            .frame(maxWidth: .infinity, minHeight: 155)
            .background(
                isIngredientDropTarget ? AllianTheme.softPink : Color.white.opacity(0.88),
                in: RoundedRectangle(cornerRadius: 28)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(isIngredientDropTarget ? AllianTheme.pink : AllianTheme.purple.opacity(0.22), lineWidth: 4)
            )
            .onDrop(of: [UTType.text], isTargeted: $isIngredientDropTarget) { providers in
                receiveIngredientDrop(providers: providers, recipe: recipe)
            }

            if collectedIngredients.count == recipe.ingredients.count {
                nextButton("Prepare \(recipe.name)", icon: "arrow.right") {
                    stage = .prepare
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 28))
    }

    private func prepareStage(_ recipe: CookPartyRecipe) -> some View {
        VStack(spacing: 16) {
            Text("2. Prepare")
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Text(recipe.prepareText)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "6D5388"))
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                Text(recipe.prepareEmoji)
                    .font(.system(size: 96))
                    .offset(x: CGFloat((prepareMoves % 3) - 1) * 9)
                Text(prepareMoves >= requiredPrepareMoves ? "Ready!" : "Swipe here")
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(AllianTheme.purple)

                ProgressView(value: Double(prepareMoves), total: Double(requiredPrepareMoves))
                    .tint(AllianTheme.pink)
            }
            .frame(maxWidth: .infinity, minHeight: 210)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.94), AllianTheme.softPink.opacity(0.82)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                in: RoundedRectangle(cornerRadius: 28)
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 18)
                    .onEnded { _ in
                        prepareMoves = min(requiredPrepareMoves, prepareMoves + 1)
                    }
            )

            if prepareMoves >= requiredPrepareMoves {
                nextButton("Go to Cooking", icon: "flame.fill") {
                    stage = .cook
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 28))
    }

    private func cookStage(_ recipe: CookPartyRecipe) -> some View {
        VStack(spacing: 16) {
            Text("3. Cook")
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Text(recipe.cookText)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "6D5388"))
                .multilineTextAlignment(.center)

            VStack(spacing: 14) {
                Text(recipe.cookEmoji).font(.system(size: 92))
                HStack {
                    Text("RAW")
                    Spacer()
                    Text("READY")
                }
                .font(.system(.caption, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.purple)

                Slider(value: $cookProgress, in: 0...1)
                    .tint(AllianTheme.pink)

                Text(cookProgress >= 0.98 ? "Ready to decorate!" : "Move the control with your finger")
                    .font(.system(.subheadline, design: .rounded).weight(.black))
                    .foregroundStyle(cookProgress >= 0.98 ? AllianTheme.pink : Color(hex: "6D5388"))
            }
            .padding(18)
            .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 26))

            if cookProgress >= 0.98 {
                nextButton("Decorate It", icon: "sparkles") {
                    stage = .decorate
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 28))
    }

    private func decorateStage(_ recipe: CookPartyRecipe) -> some View {
        VStack(spacing: 16) {
            Text("4. Decorate")
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Text("Tap anything you want to add. There is no wrong way to make it.")
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "6D5388"))
                .multilineTextAlignment(.center)

            Text(decoratedDish(recipe))
                .font(.system(size: 64))
                .minimumScaleFactor(0.45)
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 24))

            HStack(spacing: 9) {
                ForEach(recipe.decorations) { item in
                    Button {
                        if selectedDecorations.contains(item.id) {
                            selectedDecorations.remove(item.id)
                        } else {
                            selectedDecorations.insert(item.id)
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Text(item.emoji).font(.system(size: 40))
                            Text(item.name)
                                .font(.system(.caption2, design: .rounded).weight(.black))
                                .foregroundStyle(AllianTheme.ink)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, minHeight: 96)
                        .background(
                            selectedDecorations.contains(item.id)
                            ? AllianTheme.softPink
                            : Color.white.opacity(0.92),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    selectedDecorations.contains(item.id) ? AllianTheme.pink : Color.clear,
                                    lineWidth: 3
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            nextButton("Take It to the Table", icon: "fork.knife") {
                stage = .serve
            }
        }
        .padding(16)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 28))
    }

    private func serveStage(_ recipe: CookPartyRecipe) -> some View {
        VStack(spacing: 16) {
            Text("5. Serve")
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Text(served ? "Dinner is on the table. Sit down and enjoy it together. 💗" : "Drag the plate to the table.")
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "6D5388"))
                .multilineTextAlignment(.center)

            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FFF2FB"), Color(hex: "EAF6FF")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                HStack {
                    VStack(spacing: 5) {
                        Text("Kitchen")
                            .font(.system(.caption, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.purple)
                        Text(decoratedDish(recipe))
                            .font(.system(size: 48))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .offset(plateOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        guard !served else { return }
                                        plateOffset = value.translation
                                    }
                                    .onEnded { value in
                                        if value.translation.width > 85 {
                                            served = true
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                plateOffset = CGSize(width: 115, height: 0)
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                plateOffset = .zero
                                            }
                                        }
                                    }
                            )
                    }
                    Spacer()
                    VStack(spacing: 5) {
                        Text("Table")
                            .font(.system(.caption, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.purple)
                        Text("🍽️").font(.system(size: 62))
                    }
                }
                .padding(24)
            }
            .frame(height: 190)

            if served {
                HStack(spacing: 16) {
                    Text(store.avatarBase.emoji).font(.system(size: 58))
                    if store.livingTogether {
                        Text(store.invitedFriend?.emoji ?? "🧑").font(.system(size: 58))
                    }
                    Text(recipe.finishedEmoji).font(.system(size: 58))
                }
                .padding(14)
                .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 24))

                HStack(spacing: 10) {
                    Button {
                        selectedDecorations.removeAll()
                        served = false
                        plateOffset = .zero
                        stage = .decorate
                    } label: {
                        Label("Decorate Again", systemImage: "sparkles")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.purple)
                            .padding(.vertical, 13)
                            .frame(maxWidth: .infinity)
                            .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    Button {
                        selectedRecipe = nil
                        resetGame()
                    } label: {
                        Label("Another Recipe", systemImage: "arrow.counterclockwise")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(.white)
                            .padding(.vertical, 13)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [AllianTheme.pink, AllianTheme.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                in: RoundedRectangle(cornerRadius: 18)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 28))
    }

    private func nextButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(.headline, design: .rounded).weight(.black))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [AllianTheme.pink, AllianTheme.purple, AllianTheme.blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 20)
                )
        }
        .buttonStyle(.plain)
    }

    private func start(_ recipe: CookPartyRecipe) {
        selectedRecipe = recipe
        resetGame()
    }

    private func resetGame() {
        stage = .ingredients
        collectedIngredients.removeAll()
        selectedDecorations.removeAll()
        prepareMoves = 0
        cookProgress = 0
        isIngredientDropTarget = false
        plateOffset = .zero
        served = false
    }

    private func bowlContents(_ recipe: CookPartyRecipe) -> String {
        recipe.ingredients
            .filter { collectedIngredients.contains($0.id) }
            .map(\.emoji)
            .joined(separator: " ")
    }

    private func decoratedDish(_ recipe: CookPartyRecipe) -> String {
        let extras = recipe.decorations
            .filter { selectedDecorations.contains($0.id) }
            .map(\.emoji)
            .joined(separator: "")
        return recipe.finishedEmoji + extras
    }

    private func receiveIngredientDrop(providers: [NSItemProvider], recipe: CookPartyRecipe) -> Bool {
        guard let provider = providers.first else { return false }

        provider.loadObject(ofClass: NSString.self) { object, _ in
            guard let value = object as? NSString else { return }
            let ingredientID = value as String
            guard recipe.ingredients.contains(where: { $0.id == ingredientID }) else { return }

            DispatchQueue.main.async {
                collectedIngredients.insert(ingredientID)
            }
        }
        return true
    }
}


struct PlaceCard: View {
    let place: WorldPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.emoji)
                .font(.system(size: 44))
            Text(place.name)
                .font(.system(.headline, design: .rounded).weight(.black))
                .foregroundStyle(.white)
            Text(place.subtitle)
                .font(.system(.caption, design: .rounded).weight(.bold))
                .foregroundStyle(.white.opacity(0.94))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 142, alignment: .leading)
        .padding(14)
        .background(
            LinearGradient(
                colors: place.colors.map(Color.init(hex:)),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.85), lineWidth: 2))
    }
}

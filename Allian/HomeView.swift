import SwiftUI

struct HomeView: View {
    private let places: [AllianPlace] = [
        AllianPlace(title: "Beach", emoji: "🏖️", subtitle: "Swim, build sandcastles and relax", colors: [Color.cyan.opacity(0.75), Color.blue.opacity(0.55)]),
        AllianPlace(title: "Mall", emoji: "🛍️", subtitle: "Visit lots of free shops", colors: [AllianPalette.pink.opacity(0.8), AllianPalette.purple.opacity(0.65)]),
        AllianPlace(title: "Zoo", emoji: "🦒", subtitle: "Meet animals with your friends", colors: [Color.green.opacity(0.70), Color.yellow.opacity(0.55)]),
        AllianPlace(title: "Aquarium", emoji: "🐬", subtitle: "Explore an underwater world", colors: [AllianPalette.blue.opacity(0.8), Color.cyan.opacity(0.65)]),
        AllianPlace(title: "Game Room", emoji: "🕹️", subtitle: "Open fun games you can really play", colors: [AllianPalette.purple.opacity(0.8), AllianPalette.pink.opacity(0.7)]),
        AllianPlace(title: "City", emoji: "🏙️", subtitle: "Explore shops, cafés and parks", colors: [AllianPalette.blue.opacity(0.7), AllianPalette.softPurple])
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AllianPalette.mainGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 18) {
                        header
                        quickActions
                        worldMap
                        featuredPlaces
                        kindnessCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 28)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            NavigationLink(destination: AvatarView()) {
                ZStack {
                    Circle().fill(Color.white).frame(width: 62, height: 62)
                    Text("👧").font(.system(size: 42))
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text("Allian")
                    .font(.system(size: 46, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [AllianPalette.pink, AllianPalette.purple, AllianPalette.blue], startPoint: .leading, endPoint: .trailing)
                    )
                Text("Explore • Create • Live • Travel • Play")
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .foregroundStyle(AllianPalette.purple)
            }
            Spacer()
        }
        .padding(.top, 8)
    }

    private var quickActions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                NavigationLink(destination: AvatarView()) { actionTile("My Avatar", "👚", AllianPalette.pink) }
                NavigationLink(destination: HouseView()) { actionTile("House", "🏡", AllianPalette.pink) }
                NavigationLink(destination: TodayPlaceDetailView(place: AllianPlace(title: "City", emoji: "🏙️", subtitle: "Explore the whole town", colors: [AllianPalette.blue, AllianPalette.softBlue]))) { actionTile("City", "🏙️", AllianPalette.blue) }
                NavigationLink(destination: MallView()) { actionTile("Mall", "🛍️", AllianPalette.pink) }
                NavigationLink(destination: TodayTravelView()) { actionTile("Travel", "✈️", AllianPalette.blue) }
                NavigationLink(destination: MiniGamesLibraryView()) { actionTile("Mini Games", "🎮", AllianPalette.purple) }
                NavigationLink(destination: TodayFriendsView()) { actionTile("Friends", "👭", AllianPalette.pink) }
                NavigationLink(destination: TodayFoodDeliveryView()) { actionTile("Food", "🍔", Color.orange) }
            }
            .padding(.horizontal, 2)
        }
    }

    private func actionTile(_ title: String, _ emoji: String, _ color: Color) -> some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 31))
            Text(title)
                .font(.system(.caption, design: .rounded).weight(.black))
                .foregroundStyle(Color(red: 0.20, green: 0.18, blue: 0.48))
        }
        .frame(width: 92, height: 82)
        .background(Color.white.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.7), lineWidth: 3))
    }

    private var worldMap: some View {
        ZStack {
            LinearGradient(colors: [Color.cyan.opacity(0.45), Color.green.opacity(0.36), AllianPalette.softPink], startPoint: .top, endPoint: .bottom)
            VStack(spacing: 10) {
                HStack {
                    mapLabel("🏖️ Beach")
                    Spacer()
                    mapLabel("🦒 Zoo")
                }
                HStack {
                    mapLabel("🏙️ City")
                    Spacer()
                    mapLabel("🛍️ Mall")
                    Spacer()
                    mapLabel("🐬 Aquarium")
                }
                HStack {
                    Spacer()
                    NavigationLink(destination: HouseView()) {
                        VStack(spacing: 4) {
                            Text("🏡").font(.system(size: 70))
                            Text("My House + Pool")
                                .font(.system(.headline, design: .rounded).weight(.black))
                                .foregroundStyle(AllianPalette.purple)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color.white.opacity(0.95))
                                .clipShape(Capsule())
                        }
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                HStack {
                    mapLabel("🕹️ Game Room")
                    Spacer()
                    mapLabel("✈️ Airport")
                    mapLabel("🚆 Train")
                }
            }
            .padding(18)
        }
        .frame(height: 310)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.9), lineWidth: 3))
        .shadow(color: AllianPalette.blue.opacity(0.18), radius: 14, x: 0, y: 8)
    }

    private func mapLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(.caption, design: .rounded).weight(.black))
            .foregroundStyle(AllianPalette.purple)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color.white.opacity(0.94))
            .clipShape(Capsule())
    }

    private var featuredPlaces: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Explore Together")
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianPalette.purple)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(places) { place in
                    NavigationLink(destination: TodayPlaceDetailView(place: place)) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text(place.emoji).font(.system(size: 42))
                            Text(place.title)
                                .font(.system(.headline, design: .rounded).weight(.black))
                                .foregroundStyle(.white)
                            Text(place.subtitle)
                                .font(.system(.caption2, design: .rounded).weight(.bold))
                                .foregroundStyle(.white.opacity(0.95))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, minHeight: 138, alignment: .leading)
                        .padding(14)
                        .background(AllianPalette.cardGradient(place.colors))
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var kindnessCard: some View {
        NavigationLink(destination: TodayFriendsView()) {
            HStack(spacing: 12) {
                Text("💗").font(.system(size: 40))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live & Play With Friends")
                        .font(.system(.headline, design: .rounded).weight(.black))
                    Text("Use Allian names, choose a house together, and both friends can decorate.")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(AllianPalette.purple)
            .padding(16)
            .allianCard()
        }
        .buttonStyle(.plain)
    }
}

struct TodayPlaceDetailView: View {
    let place: AllianPlace
    @State private var activityText = "Choose something fun to do."

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    Text(place.emoji).font(.system(size: 100))
                    Text(place.title)
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.purple)
                    Text(place.subtitle)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .multilineTextAlignment(.center)

                    Text(activityText)
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(AllianPalette.pink)
                        .padding()
                        .allianCard()

                    VStack(spacing: 12) {
                        activityButton("Explore", "🗺️") { activityText = "You are exploring \(place.title)! 🌈" }
                        activityButton("Play Together", "👭") { activityText = "You and your friend are playing together! 💗" }
                        activityButton("Take a Photo", "📸") { activityText = "Smile! Your in-game photo is ready. 📸" }
                        if place.title == "Game Room" {
                            NavigationLink(destination: MiniGamesLibraryView()) {
                                activityButtonLabel("Open Mini Games", "🎮")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(place.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func activityButton(_ title: String, _ emoji: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { activityButtonLabel(title, emoji) }
        .buttonStyle(.plain)
    }

    private func activityButtonLabel(_ title: String, _ emoji: String) -> some View {
        HStack {
            Text(emoji).font(.system(size: 30))
            Text(title).font(.system(.headline, design: .rounded).weight(.black))
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(AllianPalette.purple)
        .padding(16)
        .allianCard()
    }
}

struct MallView: View {
    private let shops = [
        ("Clothes Store", "👚"), ("Shoe Store", "👟"), ("Hat Store", "👑"), ("Bag Store", "👜"),
        ("Toy Store", "🧸"), ("Baby Store", "🍼"), ("Phone Store", "📱"), ("Hairdresser", "💇‍♀️"),
        ("Nail Salon", "💅"), ("Supermarket", "🛒"), ("Café", "☕️"), ("Restaurant", "🍝")
    ]

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Allian Mall")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.pink)
                    Text("Everything is free and open from the start.")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(AllianPalette.purple)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(shops, id: \.0) { shop in
                            NavigationLink(destination: ShopView(name: shop.0, emoji: shop.1)) {
                                VStack(spacing: 8) {
                                    Text(shop.1).font(.system(size: 44))
                                    Text(shop.0)
                                        .font(.system(.headline, design: .rounded).weight(.black))
                                }
                                .foregroundStyle(AllianPalette.purple)
                                .frame(maxWidth: .infinity, minHeight: 120)
                                .allianCard()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Mall")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShopView: View {
    let name: String
    let emoji: String
    @State private var picked = ""

    private let sampleItems = ["Pink", "Blue", "Purple", "Rainbow", "Sparkly", "Cute"]

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            VStack(spacing: 18) {
                Text(emoji).font(.system(size: 92))
                Text(name)
                    .font(.system(.largeTitle, design: .rounded).weight(.black))
                    .foregroundStyle(AllianPalette.purple)
                Text("Pick anything you like — it is all free.")
                    .font(.system(.headline, design: .rounded).weight(.bold))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(sampleItems, id: \.self) { item in
                        Button {
                            picked = item
                        } label: {
                            VStack {
                                Text(emoji).font(.system(size: 34))
                                Text(item).font(.system(.caption, design: .rounded).weight(.black))
                            }
                            .frame(maxWidth: .infinity, minHeight: 92)
                            .background(picked == item ? AllianPalette.softPink : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(picked == item ? AllianPalette.pink : Color.clear, lineWidth: 3))
                        }
                        .buttonStyle(.plain)
                    }
                }
                if !picked.isEmpty {
                    Text("You chose the \(picked.lowercased()) one! 💗")
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.pink)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct TodayTravelView: View {
    private let countries = [
        AllianCountry(name: "Spain", flag: "🇪🇸", food: "Paella & churros", fashion: "Colourful summer clothes", landmark: "Sunny plazas"),
        AllianCountry(name: "China", flag: "🇨🇳", food: "Dumplings & noodles", fashion: "Festival-inspired outfits", landmark: "Beautiful city streets"),
        AllianCountry(name: "Japan", flag: "🇯🇵", food: "Sushi & ramen", fashion: "Cute street fashion", landmark: "Temples & bright cities"),
        AllianCountry(name: "Korea", flag: "🇰🇷", food: "Bibimbap & snacks", fashion: "Modern colourful outfits", landmark: "City & palace areas"),
        AllianCountry(name: "Italy", flag: "🇮🇹", food: "Pizza & spaghetti", fashion: "Stylish clothes", landmark: "Old streets & fountains"),
        AllianCountry(name: "Germany", flag: "🇩🇪", food: "Pretzels & bakery treats", fashion: "City and festival clothes", landmark: "Castles & towns"),
        AllianCountry(name: "France", flag: "🇫🇷", food: "Croissants & crêpes", fashion: "Paris-inspired outfits", landmark: "Paris streets"),
        AllianCountry(name: "United Kingdom", flag: "🇬🇧", food: "Afternoon tea", fashion: "City outfits", landmark: "London landmarks")
    ]

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    HStack(spacing: 24) {
                        Text("✈️").font(.system(size: 76))
                        Text("🚆").font(.system(size: 70))
                    }
                    Text("Travel the World")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.purple)
                    Text("Choose a country and actually go inside its Allian world.")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .multilineTextAlignment(.center)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(countries) { country in
                            NavigationLink(destination: TodayCountryView(country: country)) {
                                VStack(spacing: 8) {
                                    Text(country.flag).font(.system(size: 52))
                                    Text(country.name).font(.system(.headline, design: .rounded).weight(.black))
                                }
                                .foregroundStyle(AllianPalette.purple)
                                .frame(maxWidth: .infinity, minHeight: 115)
                                .allianCard()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Travel")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TodayCountryView: View {
    let country: AllianCountry
    @State private var message = "Welcome!"

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            VStack(spacing: 16) {
                Text(country.flag).font(.system(size: 100))
                Text(country.name)
                    .font(.system(.largeTitle, design: .rounded).weight(.black))
                    .foregroundStyle(AllianPalette.purple)
                countryCard("Food", "🍽️", country.food)
                countryCard("Clothes", "👚", country.fashion)
                countryCard("Explore", "🗺️", country.landmark)
                Button {
                    message = "You are exploring \(country.name)! 🌈"
                } label: {
                    Text("Explore \(country.name)")
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [AllianPalette.pink, AllianPalette.purple], startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                }
                Text(message).font(.system(.headline, design: .rounded).weight(.bold)).foregroundStyle(AllianPalette.pink)
                Spacer()
            }
            .padding()
        }
    }

    private func countryCard(_ title: String, _ emoji: String, _ detail: String) -> some View {
        HStack {
            Text(emoji).font(.system(size: 34))
            VStack(alignment: .leading) {
                Text(title).font(.system(.headline, design: .rounded).weight(.black))
                Text(detail).font(.system(.subheadline, design: .rounded).weight(.bold))
            }
            Spacer()
        }
        .foregroundStyle(AllianPalette.purple)
        .padding()
        .allianCard()
    }
}

struct HouseView: View {
    @State private var layout: HouseLayout = .two
    @State private var roomChoice: RoomChoice = .separate
    @State private var selectedFurniture = "Pink Sofa"
    @State private var friendDecorating = true

    private let furniture = ["Pink Sofa", "Blue Bed", "Game Table", "Plant", "Mirror", "Toy Box", "Pool Float", "Lamp"]

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    Text("🏡 My House")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.pink)
                    Text("🏊‍♀️ Pool • 🌴 Garden • 🎮 Game Room")
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.purple)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose House Layout").font(.system(.title3, design: .rounded).weight(.black))
                        Picker("House Layout", selection: $layout) {
                            ForEach(HouseLayout.allCases) { item in Text(item.rawValue).tag(item) }
                        }
                        .pickerStyle(.segmented)

                        Text("Room Options").font(.system(.title3, design: .rounded).weight(.black))
                        Picker("Room Choice", selection: $roomChoice) {
                            ForEach(RoomChoice.allCases) { item in Text(item.rawValue).tag(item) }
                        }
                        .pickerStyle(.menu)

                        Toggle("Both friends can decorate", isOn: $friendDecorating)
                            .font(.system(.headline, design: .rounded).weight(.black))
                            .tint(AllianPalette.pink)
                            .disabled(true)
                    }
                    .padding()
                    .allianCard()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Decorate Together")
                            .font(.system(.title3, design: .rounded).weight(.black))
                        Text("Tap furniture to place it in your shared home.")
                            .font(.system(.subheadline, design: .rounded).weight(.bold))

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(furniture, id: \.self) { item in
                                Button {
                                    selectedFurniture = item
                                } label: {
                                    Text(item)
                                        .font(.system(.subheadline, design: .rounded).weight(.black))
                                        .foregroundStyle(AllianPalette.purple)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .background(selectedFurniture == item ? AllianPalette.softPink : Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        Text("Placed: \(selectedFurniture) 💗")
                            .font(.system(.headline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianPalette.pink)
                    }
                    .padding()
                    .allianCard()
                }
                .padding()
            }
        }
        .navigationTitle("House")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TodayFriendsView: View {
    @State private var friendName = ""
    @State private var status = "Search using your friend's Allian name — not their real name."
    @State private var isLivingTogether = false
    @State private var layout: HouseLayout = .two

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("👭 Friends")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.pink)
                    Text(status)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .multilineTextAlignment(.center)

                    HStack {
                        TextField("Enter Allian character name", text: $friendName)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        Button("Invite") {
                            if friendName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                status = "Type your friend's Allian character name first. 💗"
                            } else {
                                status = "Invite sent to \(friendName)! They can choose whether to join. 💗"
                            }
                        }
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(AllianPalette.pink)
                        .clipShape(Capsule())
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Live together in the same world", isOn: $isLivingTogether)
                            .font(.system(.headline, design: .rounded).weight(.black))
                            .tint(AllianPalette.pink)

                        if isLivingTogether {
                            Text("Choose your shared house")
                                .font(.system(.headline, design: .rounded).weight(.black))
                            Picker("Shared House", selection: $layout) {
                                ForEach(HouseLayout.allCases) { item in Text(item.rawValue).tag(item) }
                            }
                            .pickerStyle(.segmented)

                            NavigationLink(destination: HouseView()) {
                                HStack {
                                    Text("🏡")
                                    Text("Go to Shared House")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .font(.system(.headline, design: .rounded).weight(.black))
                                .foregroundStyle(AllianPalette.purple)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                    }
                    .padding()
                    .allianCard()

                    Text("Both friends can decorate the house. Each person can only change their own avatar and clothes.")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(AllianPalette.purple)
                        .padding()
                        .allianCard()
                }
                .padding()
            }
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MiniGamesLibraryView: View {
    @State private var selectedKind: MiniGameKind = .cooking
    @State private var gameNumber = 1

    private let kinds = MiniGameKind.allCases

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    Text("🎮 Mini Games")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.purple)
                    Text("100,000 playful variations — no points, no leaderboards.")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .multilineTextAlignment(.center)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(kinds, id: \.self) { kind in
                            Button {
                                selectedKind = kind
                            } label: {
                                VStack(spacing: 8) {
                                    Text(kind.emoji).font(.system(size: 44))
                                    Text(kind.rawValue).font(.system(.headline, design: .rounded).weight(.black))
                                }
                                .foregroundStyle(AllianPalette.purple)
                                .frame(maxWidth: .infinity, minHeight: 112)
                                .background(selectedKind == kind ? AllianPalette.softPink : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(selectedKind == kind ? AllianPalette.pink : Color.clear, lineWidth: 3))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Stepper("Game variation #\(gameNumber)", value: $gameNumber, in: 1...100_000)
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .padding()
                        .allianCard()

                    NavigationLink(destination: PlayableMiniGameView(game: AllianMiniGame(id: gameNumber, title: "\(selectedKind.rawValue) #\(gameNumber)", emoji: selectedKind.emoji, kind: selectedKind))) {
                        Text("Play This Game")
                            .font(.system(.title3, design: .rounded).weight(.black))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [AllianPalette.pink, AllianPalette.purple, AllianPalette.blue], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
        .navigationTitle("Mini Games")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlayableMiniGameView: View {
    let game: AllianMiniGame
    @State private var state = 0
    @State private var selectedItems: Set<String> = []

    var body: some View {
        Group {
            if game.kind == .cooking {
                CookPartyView()
            } else {
                ZStack {
                    AllianPalette.mainGradient.ignoresSafeArea()
                    VStack(spacing: 18) {
                        Text(game.emoji).font(.system(size: 90))
                        Text(game.title)
                            .font(.system(.largeTitle, design: .rounded).weight(.black))
                            .foregroundStyle(AllianPalette.purple)

                        switch game.kind {
                        case .cooking: EmptyView()
                        case .swimming: swimmingGame
                        case .fashion: fashionGame
                        case .petCare: petGame
                        case .building: buildingGame
                        case .art: artGame
                        case .adventure: adventureGame
                        case .sports: sportsGame
                        case .dancing: danceGame
                        case .music: musicGame
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(game.kind == .cooking ? "Cook Party" : game.kind.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var cookingGame: some View {
        VStack(spacing: 14) {
            Text("Make dinner together. Tap ingredients to add them.")
                .font(.system(.headline, design: .rounded).weight(.bold))
                .multilineTextAlignment(.center)
            HStack {
                gameChoice("🍅", "Tomato")
                gameChoice("🧀", "Cheese")
                gameChoice("🥦", "Veg")
            }
            Text(selectedItems.isEmpty ? "Your bowl is ready!" : "In the bowl: \(selectedItems.sorted().joined(separator: ", "))")
                .font(.system(.headline, design: .rounded).weight(.black))
        }
        .padding().allianCard()
    }

    private var swimmingGame: some View {
        VStack(spacing: 14) {
            Text("Help your swimmer move across the pool.")
                .font(.system(.headline, design: .rounded).weight(.bold))
            GeometryReader { proxy in
                Text("🏊‍♀️")
                    .font(.system(size: 64))
                    .offset(x: CGFloat(state % 5) * max(0, (proxy.size.width - 80) / 5))
                    .animation(.easeInOut, value: state)
            }
            .frame(height: 90)
            Button("Swim ➜") { state += 1 }
                .allianPlayButton()
        }
        .padding().allianCard()
    }

    private var fashionGame: some View {
        VStack(spacing: 14) {
            Text("Create a look. Tap to change it.")
                .font(.system(.headline, design: .rounded).weight(.bold))
            Text(["👗", "👚", "🧥", "🩱"][state % 4]).font(.system(size: 90))
            Button("Change Outfit") { state += 1 }.allianPlayButton()
        }
        .padding().allianCard()
    }

    private var petGame: some View {
        VStack(spacing: 14) {
            Text(state % 3 == 0 ? "🐶" : state % 3 == 1 ? "🐕" : "🐩").font(.system(size: 90))
            HStack {
                Button("Feed") { state += 1 }.allianPlayButton()
                Button("Brush") { state += 1 }.allianPlayButton()
                Button("Hug") { state += 1 }.allianPlayButton()
            }
        }
        .padding().allianCard()
    }

    private var buildingGame: some View {
        VStack(spacing: 12) {
            Text("Tap blocks to build together.")
                .font(.system(.headline, design: .rounded).weight(.bold))
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    Button {
                        if selectedItems.contains("Block \(index)") { selectedItems.remove("Block \(index)") }
                        else { selectedItems.insert("Block \(index)") }
                    } label: {
                        Text(selectedItems.contains("Block \(index)") ? "🏠" : "🟦").font(.system(size: 42))
                    }
                }
            }
        }
        .padding().allianCard()
    }

    private var artGame: some View { simpleCycle(title: "Make colourful art together.", items: ["🎨", "🌈", "🦋", "🌸"]) }
    private var adventureGame: some View { simpleCycle(title: "Explore a silly adventure path.", items: ["🌳", "🏰", "🌉", "🎡"]) }
    private var sportsGame: some View { simpleCycle(title: "Pass the ball and play together.", items: ["⚽️", "🏀", "🏐", "🥎"]) }
    private var danceGame: some View { simpleCycle(title: "Choose the next dance move.", items: ["💃", "🕺", "🤸‍♀️", "✨"]) }
    private var musicGame: some View { simpleCycle(title: "Make a little tune together.", items: ["🎵", "🎹", "🥁", "🎸"]) }

    private func simpleCycle(title: String, items: [String]) -> some View {
        VStack(spacing: 14) {
            Text(title).font(.system(.headline, design: .rounded).weight(.bold)).multilineTextAlignment(.center)
            Text(items[state % items.count]).font(.system(size: 90))
            Button("Next") { state += 1 }.allianPlayButton()
        }
        .padding().allianCard()
    }

    private func gameChoice(_ emoji: String, _ name: String) -> some View {
        Button {
            if selectedItems.contains(name) { selectedItems.remove(name) } else { selectedItems.insert(name) }
        } label: {
            VStack {
                Text(emoji).font(.system(size: 40))
                Text(name).font(.system(.caption, design: .rounded).weight(.black))
            }
            .padding(10)
            .background(selectedItems.contains(name) ? AllianPalette.softPink : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

private extension View {
    func allianPlayButton() -> some View {
        self
            .font(.system(.headline, design: .rounded).weight(.black))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AllianPalette.purple)
            .clipShape(Capsule())
    }
}

struct TodayFoodDeliveryView: View {
    private let foods = ["🍕 Pizza", "🍔 Burger", "🍣 Sushi", "🍝 Pasta", "🧁 Cupcake", "🥤 Drink"]
    @State private var selected = "🍕 Pizza"
    @State private var delivered = false

    var body: some View {
        ZStack {
            AllianPalette.mainGradient.ignoresSafeArea()
            VStack(spacing: 18) {
                Text("🛵 Food Delivery")
                    .font(.system(.largeTitle, design: .rounded).weight(.black))
                    .foregroundStyle(AllianPalette.pink)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(foods, id: \.self) { food in
                        Button {
                            selected = food
                            delivered = false
                        } label: {
                            Text(food)
                                .font(.system(.headline, design: .rounded).weight(.black))
                                .foregroundStyle(AllianPalette.purple)
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(selected == food ? AllianPalette.softPink : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                    }
                }
                Button("Order to My House") { delivered = true }
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AllianPalette.pink)
                    .clipShape(Capsule())
                if delivered {
                    Text("🛵 Ding dong! Your \(selected) has arrived at your house! 💗")
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(AllianPalette.purple)
                        .multilineTextAlignment(.center)
                        .padding()
                        .allianCard()
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Food Delivery")
        .navigationBarTitleDisplayMode(.inline)
    }
}

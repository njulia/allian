import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        NavigationStack {
            ZStack {
                AllianSwirlBackground().ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        AllianLogo(subtitle: "Your mini phone")
                        ApprovedArt(name: "PhoneTravelArt", height: 230)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            NavigationLink { FoodDeliveryView() } label: { PhoneAppTile(title: "Food", emoji: "🍔", colors: ["FF9B75", "FFCC72"]) }
                            NavigationLink { FriendsView() } label: { PhoneAppTile(title: "Friends", emoji: "🫶", colors: ["FF79B4", "A67BF3"]) }
                            NavigationLink { PlaceDirectoryView() } label: { PhoneAppTile(title: "Map", emoji: "🗺️", colors: ["62C9A0", "5FB7FF"]) }

                            Button { store.selectedTab = .house } label: { PhoneAppTile(title: "Homes", emoji: "🏠", colors: ["FFAD6F", "FF7DB0"]) }
                            NavigationLink { TravelView() } label: { PhoneAppTile(title: "Travel", emoji: "✈️", colors: ["61B8FF", "8F79F3"]) }
                            Button { store.selectedTab = .games } label: { PhoneAppTile(title: "Games", emoji: "🎮", colors: ["9C72F3", "FF79AF"]) }

                            Button { store.selectedTab = .avatar } label: { PhoneAppTile(title: "Avatar", emoji: "👕", colors: ["FF78AD", "68B8FF"]) }
                            NavigationLink { PlaceDirectoryView() } label: { PhoneAppTile(title: "Shops", emoji: "🛍️", colors: ["FF83B7", "B079F3"]) }
                            NavigationLink { CameraPlayView() } label: { PhoneAppTile(title: "Camera", emoji: "📸", colors: ["5EA8FF", "7CD5E5"]) }
                        }

                        if let delivery = store.latestDelivery {
                            AllianCard {
                                HStack(spacing: 12) {
                                    Text("🛵").font(.system(size: 42))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Delivery is on the way!")
                                            .font(.system(.headline, design: .rounded).weight(.black))
                                            .foregroundStyle(AllianTheme.ink)
                                        Text("\(delivery.emoji) \(delivery.name) is coming to your house.")
                                            .font(.system(.caption, design: .rounded).weight(.bold))
                                            .foregroundStyle(Color(hex: "715787"))
                                    }
                                }
                            }
                        }

                        AllianCard {
                            VStack(alignment: .leading, spacing: 9) {
                                Text("💗 Allian promises")
                                    .font(.system(.headline, design: .rounded).weight(.black))
                                    .foregroundStyle(AllianTheme.ink)
                                Text("• Everything is free and unlocked")
                                Text("• No points or leaderboards")
                                Text("• Friend search uses Allian character names")
                                Text("• Kind phrase buttons instead of open chat in this prototype")
                            }
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundStyle(Color(hex: "705585"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(12)
                    .padding(.bottom, 20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct PhoneAppTile: View {
    let title: String
    let emoji: String
    let colors: [String]

    var body: some View {
        VStack(spacing: 7) {
            Text(emoji).font(.system(size: 34))
            Text(title)
                .font(.system(.caption, design: .rounded).weight(.black))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 92)
        .padding(8)
        .background(LinearGradient(colors: colors.map(Color.init(hex:)), startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 21))
        .shadow(color: Color(hex: colors.first ?? "8A64F2").opacity(0.18), radius: 7, y: 4)
    }
}

struct FoodDeliveryView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ApprovedArt(name: "FoodDeliveryArt", height: 230)
                    Text("Food Delivery")
                        .font(.system(.largeTitle, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                    Text("Pick a pretend meal. It's all free.")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(Color(hex: "715787"))

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(store.foods) { food in
                            Button {
                                store.order(food)
                            } label: {
                                VStack(spacing: 6) {
                                    Text(food.emoji).font(.system(size: 40))
                                    Text(food.name)
                                        .font(.system(.caption, design: .rounded).weight(.black))
                                        .foregroundStyle(AllianTheme.ink)
                                    Text("FREE")
                                        .font(.system(size: 9, weight: .black, design: .rounded))
                                        .foregroundStyle(AllianTheme.pink)
                                }
                                .frame(maxWidth: .infinity, minHeight: 98)
                                .padding(8)
                                .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 20))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if let delivery = store.latestDelivery {
                        AllianCard {
                            VStack(spacing: 10) {
                                Text("🛵💨").font(.system(size: 50))
                                Text("Your \(delivery.name) is coming!")
                                    .font(.system(.title3, design: .rounded).weight(.black))
                                    .foregroundStyle(AllianTheme.ink)
                                Text("The delivery will arrive at \(store.selectedHouse).")
                                    .font(.system(.caption, design: .rounded).weight(.bold))
                                    .foregroundStyle(Color(hex: "715787"))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(14)
            }
        }
        .navigationTitle("Food Delivery")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CameraPlayView: View {
    @State private var sticker = "💗"

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(LinearGradient(colors: [Color(hex: "9BDFFF"), Color(hex: "F9C9EA"), Color(hex: "D9C4FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 360)
                    VStack(spacing: 12) {
                        Text("🏡  🌈  🏖️").font(.system(size: 48))
                        Text(sticker).font(.system(size: 90))
                        Text("Allian Camera")
                            .font(.system(.title, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.ink)
                    }
                }

                Text("Pick a sticker")
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(AllianTheme.ink)
                HStack(spacing: 12) {
                    ForEach(["💗", "🌈", "✨", "🐱", "🌸"], id: \.self) { item in
                        Button(item) { sticker = item }
                            .font(.title2)
                            .frame(width: 52, height: 52)
                            .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
                    }
                }
                Text("This prototype does not access the real camera or photo library.")
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: "705585"))
                    .multilineTextAlignment(.center)
            }
            .padding(16)
        }
        .navigationTitle("Camera")
        .navigationBarTitleDisplayMode(.inline)
    }
}

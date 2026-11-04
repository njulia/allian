import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        Group {
            if store.onboardingComplete {
                MainShellView()
            } else {
                OnboardingView()
            }
        }
        .preferredColorScheme(.light)
        .tint(AllianTheme.purple)
    }
}

struct MainShellView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack(alignment: .bottom) {
            AllianSwirlBackground().ignoresSafeArea()

            Group {
                switch store.selectedTab {
                case .world: HomeView()
                case .house: CreateView()
                case .avatar: AvatarView()
                case .games: MiniGamesView()
                case .phone: SettingsView()
                }
            }
            .padding(.bottom, 88)

            AllianTabBar()
        }
    }
}

struct AllianTabBar: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        HStack(spacing: 4) {
            ForEach(MainTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                        store.selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .bold))
                        Text(tab.title)
                            .font(.system(size: 10, weight: .black, design: .rounded))
                    }
                    .foregroundStyle(store.selectedTab == tab ? Color.white : Color(hex: "63429F"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(
                        store.selectedTab == tab
                        ? AnyShapeStyle(LinearGradient(colors: [AllianTheme.pink, AllianTheme.purple, AllianTheme.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        : AnyShapeStyle(Color.clear),
                        in: RoundedRectangle(cornerRadius: 17)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 25))
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 2))
        .shadow(color: AllianTheme.purple.opacity(0.24), radius: 18, y: 7)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
}

struct OnboardingView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            AllianSwirlBackground().ignoresSafeArea()
            switch store.onboardingStep {
            case 0: WelcomeScreen()
            case 1: NameScreen()
            case 2: AvatarOnboardingScreen()
            default: ReadyScreen()
            }
        }
        .animation(.spring(response: 0.34, dampingFraction: 0.83), value: store.onboardingStep)
    }
}

private struct WelcomeScreen: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ApprovedArt(name: "WelcomeArt", height: 410)
                    .overlay(alignment: .bottom) {
                        LinearGradient(colors: [.clear, Color.white.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                    }

                HStack(spacing: 8) {
                    FeaturePill(emoji: "👕", title: "Create")
                    FeaturePill(emoji: "🏠", title: "Decorate")
                    FeaturePill(emoji: "🎮", title: "Play")
                    FeaturePill(emoji: "🫶", title: "Friends")
                }

                AllianPrimaryButton(title: "Let's Play!", icon: "play.fill") {
                    store.onboardingStep = 1
                }

                Text("Everything is free and unlocked. No points, no rankings, no pressure. 💗")
                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: "5A3E89"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                Text("For everyone ages 3+")
                    .font(.system(.caption, design: .rounded).weight(.black))
                    .foregroundStyle(Color(hex: "6B4AA2"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(.white.opacity(0.82), in: Capsule())
            }
            .padding(14)
            .padding(.bottom, 24)
        }
    }
}

private struct NameScreen: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                OnboardingHeader(step: 2, title: "Name Your Character", subtitle: "Choose a fun Allian name — not your real name.")

                ApprovedArt(name: "NameArt", height: 205)

                VStack(spacing: 12) {
                    TextField("Type a character name...", text: $store.characterName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .font(.system(.title2, design: .rounded).weight(.black))
                        .padding(17)
                        .background(.white, in: RoundedRectangle(cornerRadius: 22))
                        .overlay(RoundedRectangle(cornerRadius: 22).stroke(AllianTheme.purple.opacity(0.28), lineWidth: 3))

                    Text("You can choose almost any name you like. Please don't use rude words or private information.")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(Color(hex: "67517D"))
                        .multilineTextAlignment(.center)
                }
                .padding(18)
                .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 28))

                if store.showUnsafeNameMessage {
                    HStack(spacing: 10) {
                        Text("💗").font(.title2)
                        Text("Oops! Sorry, please change your name. 💗")
                            .font(.system(.headline, design: .rounded).weight(.black))
                            .foregroundStyle(Color(hex: "9A3A73"))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "FFE7F2"), in: RoundedRectangle(cornerRadius: 22))
                    .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color(hex: "FF8BC0"), lineWidth: 2))
                }

                AllianPrimaryButton(title: "Next", icon: "chevron.right") {
                    store.continueFromName()
                }

                BackButton { store.onboardingStep = 0 }
            }
            .padding(16)
            .padding(.bottom, 30)
        }
    }
}

private struct AvatarOnboardingScreen: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                OnboardingHeader(step: 3, title: "Create Your Avatar", subtitle: "Boys and girls can use every style. Everything is free.")
                AvatarEditorView(compact: true)
                AllianPrimaryButton(title: "I Love It!", icon: "heart.fill") {
                    store.onboardingStep = 3
                }
                BackButton { store.onboardingStep = 1 }
            }
            .padding(12)
            .padding(.bottom, 28)
        }
    }
}

private struct ReadyScreen: View {
    @EnvironmentObject private var store: GameStore

    private let features: [(String, String)] = [
        ("🏠", "Decorate houses"), ("🎮", "100+ mini-games"), ("🌍", "Explore the world"),
        ("👕", "Change your avatar"), ("🫶", "Play with friends"), ("✈️", "Travel to countries"),
        ("🐠", "Visit the aquarium"), ("🦒", "Visit the zoo")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                OnboardingHeader(step: 4, title: "Your World Is Ready!", subtitle: "Hi \(store.characterName.isEmpty ? "friend" : store.characterName)! Here's what you can do.")

                ApprovedArt(name: "WorldMapArt", height: 260)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                        HStack(spacing: 10) {
                            Text(feature.0).font(.title2)
                            Text(feature.1)
                                .font(.system(.subheadline, design: .rounded).weight(.black))
                                .foregroundStyle(Color(hex: "54378C"))
                        }
                        .frame(maxWidth: .infinity, minHeight: 72)
                        .padding(8)
                        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 20))
                    }
                }

                AllianPrimaryButton(title: "Enter My World", icon: "sparkles") {
                    store.finishOnboarding()
                }

                BackButton { store.onboardingStep = 2 }
            }
            .padding(14)
            .padding(.bottom, 28)
        }
    }
}

struct OnboardingHeader: View {
    let step: Int
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Text("\(step)")
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(AllianTheme.purple.gradient, in: Circle())
                Text(title)
                    .font(.system(.title2, design: .rounded).weight(.black))
                    .foregroundStyle(Color(hex: "4F2A94"))
            }
            Text(subtitle)
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "6A527F"))
                .multilineTextAlignment(.center)
        }
    }
}

struct AllianTheme {
    static let pink = Color(hex: "FF6FB1")
    static let purple = Color(hex: "8A64F2")
    static let blue = Color(hex: "59B6FF")
    static let ink = Color(hex: "4D2B91")
    static let softPink = Color(hex: "FFE2F0")
    static let softPurple = Color(hex: "EADFFF")
    static let softBlue = Color(hex: "DFF2FF")
}

struct AllianSwirlBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(colors: [AllianTheme.softPink, AllianTheme.softPurple, AllianTheme.softBlue, Color(hex: "FFF0F7")], startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(AllianTheme.pink.opacity(0.24))
                    .frame(width: proxy.size.width * 1.15)
                    .blur(radius: 70)
                    .offset(x: -proxy.size.width * 0.35, y: -proxy.size.height * 0.28)
                Circle()
                    .fill(AllianTheme.blue.opacity(0.22))
                    .frame(width: proxy.size.width * 1.2)
                    .blur(radius: 80)
                    .offset(x: proxy.size.width * 0.32, y: proxy.size.height * 0.12)
                Circle()
                    .fill(AllianTheme.purple.opacity(0.20))
                    .frame(width: proxy.size.width)
                    .blur(radius: 70)
                    .offset(x: -proxy.size.width * 0.18, y: proxy.size.height * 0.48)
                VStack {
                    HStack {
                        Text("☁️").font(.system(size: 44)).opacity(0.42)
                        Spacer()
                        Text("💗").font(.system(size: 30)).opacity(0.44)
                    }
                    Spacer()
                    HStack {
                        Text("✨").font(.system(size: 32)).opacity(0.44)
                        Spacer()
                        Text("🌈").font(.system(size: 42)).opacity(0.30)
                    }
                }
                .padding(20)
            }
        }
    }
}

struct AllianLogo: View {
    var subtitle: String = "Create • Explore • Live • Travel • Play"

    var body: some View {
        VStack(spacing: 2) {
            Text("Allian")
                .font(.system(size: 58, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [AllianTheme.pink, AllianTheme.purple, AllianTheme.blue], startPoint: .leading, endPoint: .trailing))
                .shadow(color: .white, radius: 1, x: 0, y: 3)
                .shadow(color: AllianTheme.purple.opacity(0.22), radius: 8, y: 5)
                .overlay(alignment: .topTrailing) { Text("💗").font(.system(size: 25)).offset(x: 14, y: -2) }
            Text(subtitle)
                .font(.system(.subheadline, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
                .multilineTextAlignment(.center)
        }
    }
}

struct ApprovedArt: View {
    let name: String
    let height: CGFloat

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.9), lineWidth: 3))
            .shadow(color: AllianTheme.purple.opacity(0.18), radius: 18, y: 9)
    }
}

struct AllianCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding(16)
            .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 26))
            .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white, lineWidth: 2))
            .shadow(color: AllianTheme.purple.opacity(0.12), radius: 12, y: 6)
    }
}

struct AllianPrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                Image(systemName: icon)
            }
            .font(.system(.title3, design: .rounded).weight(.black))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(LinearGradient(colors: [AllianTheme.pink, Color(hex: "F04FA6"), AllianTheme.purple], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 22))
            .shadow(color: AllianTheme.pink.opacity(0.28), radius: 12, y: 7)
        }
        .buttonStyle(.plain)
    }
}

struct FeaturePill: View {
    let emoji: String
    let title: String
    var body: some View {
        VStack(spacing: 3) {
            Text(emoji).font(.title3)
            Text(title).font(.system(size: 10, weight: .black, design: .rounded))
        }
        .foregroundStyle(AllianTheme.ink)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct BackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label("Back", systemImage: "chevron.left")
                .font(.system(.subheadline, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
                .padding(.horizontal, 15)
                .padding(.vertical, 9)
                .background(.white.opacity(0.82), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r, g, b, a: UInt64
        switch cleaned.count {
        case 8: (r, g, b, a) = (value >> 24, value >> 16 & 0xff, value >> 8 & 0xff, value & 0xff)
        default: (r, g, b, a) = (value >> 16, value >> 8 & 0xff, value & 0xff, 255)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

import SwiftUI

private enum WardrobeTab: String, CaseIterable, Identifiable {
    case all = "All"
    case swimwear = "Swimwear"
    case hair = "Hair"
    case face = "Face"
    case accessories = "Accs"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .all: return "tshirt.fill"
        case .swimwear: return "water.waves"
        case .hair: return "scissors"
        case .face: return "face.smiling"
        case .accessories: return "sunglasses"
        }
    }
}

struct AvatarView: View {
    @EnvironmentObject private var store: GameStore
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var selectedTab: WardrobeTab = .swimwear
    @State private var showSavedMessage = false

    private var isWide: Bool { horizontalSizeClass == .regular }

    var body: some View {
        ZStack {
            swimwearBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    header

                    if isWide {
                        HStack(alignment: .top, spacing: 16) {
                            avatarPanel
                                .frame(maxWidth: .infinity)
                            wardrobePanel
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        avatarPanel
                        wardrobePanel
                    }

                    actionButtons

                    Button {
                        store.beginCharacterChange()
                    } label: {
                        Label("Change Character", systemImage: "person.crop.circle.badge.arrow.trianglehead.counterclockwise")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianPalette.purple)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.9), in: Capsule())
                            .overlay(Capsule().stroke(AllianPalette.purple.opacity(0.28), lineWidth: 2))
                    }
                    .buttonStyle(.plain)
                }
                .padding(14)
                .padding(.bottom, 28)
            }

            if showSavedMessage {
                VStack {
                    Spacer()
                    Text("Look saved! 💗")
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 13)
                        .background(AllianPalette.purple.opacity(0.94), in: Capsule())
                        .shadow(color: AllianPalette.purple.opacity(0.25), radius: 12, y: 5)
                        .padding(.bottom, 24)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle("Dress Up")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // The approved design opens directly to the Water Park wardrobe.
            // Existing outfit choices remain available under All.
            selectedTab = .swimwear
        }
    }

    private var swimwearBackground: some View {
        ZStack {
            AllianPalette.mainGradient
            Circle()
                .fill(Color.white.opacity(0.28))
                .frame(width: 260, height: 260)
                .offset(x: -155, y: -290)
            Circle()
                .fill(AllianPalette.blue.opacity(0.12))
                .frame(width: 320, height: 320)
                .offset(x: 180, y: 330)
            VStack {
                Spacer()
                HStack(spacing: 28) {
                    Text("🛟")
                    Text("🏖️")
                    Text("💦")
                }
                .font(.system(size: 46))
                .opacity(0.22)
                .padding(.bottom, 34)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            HStack(spacing: 9) {
                Image(systemName: "hanger")
                    .font(.system(size: 28, weight: .black))
                Text("Dress Up")
                    .font(.system(.largeTitle, design: .rounded).weight(.black))
            }
            .foregroundStyle(AllianPalette.pink)

            HStack(spacing: 7) {
                Text("💦")
                Text("Swimwear")
                    .font(.system(.title2, design: .rounded).weight(.black))
                Text("💦")
            }
            .foregroundStyle(AllianPalette.purple)

            Text("Simple swimwear for the Water Park. Everything is free.")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(AllianPalette.purple.opacity(0.72))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var avatarPanel: some View {
        VStack(spacing: 12) {
            AllianDressUpAvatarPreview(
                base: store.avatarBase,
                hair: store.selectedHair,
                eyes: store.selectedEyes,
                top: store.selectedTop,
                bottom: store.selectedBottom,
                hat: store.selectedHat,
                accessory: store.selectedAccessory,
                swimwear: store.selectedSwimwear,
                wearingSwimwear: store.wearingSwimwear,
                wearingCropTop: store.wearingCropTop,
                wearingDress: store.wearingDress,
                swimwearColor: selectedSwimwearColor
            )
            .frame(height: isWide ? 500 : 420)

            HStack(spacing: 10) {
                avatarBaseButton(.girl)
                avatarBaseButton(.boy)
            }

            Text(store.wearingSwimwear ? store.selectedSwimwear : "Everyday Outfit")
                .font(.system(.subheadline, design: .rounded).weight(.black))
                .foregroundStyle(AllianPalette.purple)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.88), in: Capsule())
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.93), AllianPalette.softPink.opacity(0.92), AllianPalette.softBlue.opacity(0.82)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.white.opacity(0.94), lineWidth: 3)
        )
        .shadow(color: AllianPalette.purple.opacity(0.18), radius: 18, y: 8)
    }

    private var wardrobePanel: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "tshirt.fill")
                    .foregroundStyle(.white)
                Text("Wardrobe")
                    .font(.system(.title2, design: .rounded).weight(.black))
                    .foregroundStyle(.white)
                Spacer()
                Text("✨")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [AllianPalette.purple, AllianPalette.pink], startPoint: .leading, endPoint: .trailing),
                in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )

            wardrobeTabs

            Group {
                switch selectedTab {
                case .all:
                    allWardrobe
                case .swimwear:
                    swimwearWardrobe
                case .hair:
                    optionSection(title: "Hair", icon: "✂️", options: store.hair, selected: store.selectedHair) { option in
                        store.selectedHair = option.name
                    }
                case .face:
                    VStack(spacing: 12) {
                        optionSection(title: "Eyes", icon: "👀", options: store.eyes, selected: store.selectedEyes) { option in
                            store.selectedEyes = option.name
                        }
                        optionSection(title: "Face", icon: "😊", options: store.faces, selected: store.selectedFace) { option in
                            store.selectedFace = option.name
                        }
                    }
                case .accessories:
                    VStack(spacing: 12) {
                        optionSection(title: "Hats", icon: "🧢", options: store.hats, selected: store.selectedHat) { option in
                            store.selectedHat = option.name
                        }
                        optionSection(title: "Accessories", icon: "✨", options: store.accessories, selected: store.selectedAccessory) { option in
                            store.selectedAccessory = option.name
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(AllianPalette.purple.opacity(0.18), lineWidth: 2)
        )
        .shadow(color: AllianPalette.purple.opacity(0.18), radius: 18, y: 8)
    }

    private var wardrobeTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(WardrobeTab.allCases) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 18, weight: .black))
                            Text(tab.rawValue)
                                .font(.system(.caption, design: .rounded).weight(.black))
                        }
                        .foregroundStyle(selectedTab == tab ? Color.white : AllianPalette.purple)
                        .frame(minWidth: 76, minHeight: 58)
                        .background(
                            selectedTab == tab
                            ? AnyShapeStyle(LinearGradient(colors: [AllianPalette.blue, AllianPalette.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(AllianPalette.softPurple),
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(selectedTab == tab ? Color.yellow.opacity(0.85) : Color.white, lineWidth: selectedTab == tab ? 3 : 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var swimwearWardrobe: some View {
        VStack(spacing: 14) {
            swimwearSection(title: "Girls", icon: "👧", base: .girl, options: store.girlSwimwear)
            swimwearSection(title: "Boys", icon: "👦", base: .boy, options: store.boySwimwear)
        }
    }

    private func swimwearSection(title: String, icon: String, base: AvatarBase, options: [AvatarOption]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(icon)
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(base == .girl ? AllianPalette.pink : AllianPalette.blue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background((base == .girl ? AllianPalette.softPink : AllianPalette.softBlue), in: Capsule())

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 118), spacing: 10)], spacing: 10) {
                ForEach(options) { option in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            store.avatarBase = base
                            store.selectedSwimwear = option.name
                            store.wearingSwimwear = true
                            store.wearingDress = false
                            store.wearingCropTop = false
                        }
                    } label: {
                        swimwearOptionCard(option, base: base)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func swimwearOptionCard(_ option: AvatarOption, base: AvatarBase) -> some View {
        let isSelected = store.wearingSwimwear && store.avatarBase == base && store.selectedSwimwear == option.name

        return VStack(spacing: 7) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: option.hex).opacity(0.18))
                    .frame(height: 86)

                SwimwearMiniIcon(base: base, name: option.name, color: Color(hex: option.hex))
                    .frame(width: 76, height: 76)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(Color.green)
                        .background(Circle().fill(.white))
                        .offset(x: 38, y: 31)
                }
            }

            Text(option.name)
                .font(.system(size: 11, weight: .black, design: .rounded))
                .foregroundStyle(AllianPalette.purple)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(8)
        .background(isSelected ? AllianPalette.softPink : Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(isSelected ? Color.yellow : AllianPalette.purple.opacity(0.12), lineWidth: isSelected ? 3 : 1)
        )
    }

    private var allWardrobe: some View {
        VStack(spacing: 12) {
            optionSection(title: "Tops", icon: "👕", options: store.tops, selected: store.selectedTop) { option in
                store.selectedTop = option.name
                store.wearingCropTop = false
                store.wearingDress = false
                store.wearingSwimwear = false
            }

            optionSection(title: "Crop Tops", icon: "💗", options: store.cropTops, selected: store.selectedCropTop) { option in
                store.selectedCropTop = option.name
                store.wearingCropTop = true
                store.wearingDress = false
                store.wearingSwimwear = false
            }

            optionSection(title: "Bottoms", icon: "🩳", options: store.bottoms, selected: store.selectedBottom) { option in
                store.selectedBottom = option.name
                store.wearingDress = false
                store.wearingSwimwear = false
            }

            optionSection(title: "Dresses", icon: "👗", options: store.dresses, selected: store.selectedDress) { option in
                store.selectedDress = option.name
                store.wearingDress = true
                store.wearingCropTop = false
                store.wearingSwimwear = false
            }
        }
    }

    private func optionSection(
        title: String,
        icon: String,
        options: [AvatarOption],
        selected: String,
        onSelect: @escaping (AvatarOption) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 7) {
                Text(icon)
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(AllianPalette.purple)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 9)], spacing: 9) {
                ForEach(options) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            onSelect(option)
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Text(option.emoji)
                                .font(.system(size: 31))
                            Text(option.name)
                                .font(.system(size: 10, weight: .black, design: .rounded))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .foregroundStyle(AllianPalette.purple)
                        .frame(maxWidth: .infinity, minHeight: 82)
                        .padding(6)
                        .background(selected == option.name ? AllianPalette.softPink : Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(selected == option.name ? AllianPalette.pink : AllianPalette.purple.opacity(0.1), lineWidth: selected == option.name ? 3 : 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(11)
        .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func avatarBaseButton(_ base: AvatarBase) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                store.avatarBase = base
                if store.wearingSwimwear {
                    let options = base == .girl ? store.girlSwimwear : store.boySwimwear
                    if let first = options.first {
                        store.selectedSwimwear = first.name
                    }
                }
            }
        } label: {
            HStack(spacing: 7) {
                Text(base.emoji)
                Text(base.rawValue)
                    .font(.system(.headline, design: .rounded).weight(.black))
            }
            .foregroundStyle(store.avatarBase == base ? Color.white : (base == .girl ? AllianPalette.pink : AllianPalette.blue))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(
                store.avatarBase == base
                ? AnyShapeStyle(base == .girl ? AllianPalette.pink : AllianPalette.blue)
                : AnyShapeStyle(Color.white.opacity(0.9)),
                in: Capsule()
            )
            .overlay(
                Capsule().stroke(base == .girl ? AllianPalette.pink.opacity(0.45) : AllianPalette.blue.opacity(0.45), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                randomizeLook()
            } label: {
                Label("Random", systemImage: "dice.fill")
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AllianPalette.purple, in: Capsule())
            }
            .buttonStyle(.plain)

            Button {
                store.saveCharacter()
                withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                    showSavedMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showSavedMessage = false
                    }
                }
            } label: {
                Label("Save Look", systemImage: "checkmark")
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(colors: [AllianPalette.pink, Color.orange.opacity(0.82)], startPoint: .leading, endPoint: .trailing),
                        in: Capsule()
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 4)
    }

    private func randomizeLook() {
        let base: AvatarBase = Bool.random() ? .girl : .boy
        store.avatarBase = base
        store.wearingSwimwear = true
        store.wearingCropTop = false
        store.wearingDress = false

        if let hair = store.hair.randomElement() { store.selectedHair = hair.name }
        if let eyes = store.eyes.randomElement() { store.selectedEyes = eyes.name }
        let swimwear = base == .girl ? store.girlSwimwear : store.boySwimwear
        if let suit = swimwear.randomElement() { store.selectedSwimwear = suit.name }
    }

    private var selectedSwimwearColor: Color {
        let options = store.girlSwimwear + store.boySwimwear
        let hex = options.first(where: { $0.name == store.selectedSwimwear })?.hex ?? "FF6FB2"
        return Color(hex: hex)
    }
}

/// Compact avatar editor used during first-time onboarding.
/// The full wardrobe remains available later from the Avatar tab.
struct AvatarEditorView: View {
    @EnvironmentObject private var store: GameStore
    let compact: Bool

    private var swimwearOptions: [AvatarOption] {
        store.avatarBase == .girl ? store.girlSwimwear : store.boySwimwear
    }

    private var swimwearColor: Color {
        let all = store.girlSwimwear + store.boySwimwear
        let hex = all.first(where: { $0.name == store.selectedSwimwear })?.hex ?? "FF6FB2"
        return Color(hex: hex)
    }

    var body: some View {
        VStack(spacing: 14) {
            AllianDressUpAvatarPreview(
                base: store.avatarBase,
                hair: store.selectedHair,
                eyes: store.selectedEyes,
                top: store.selectedTop,
                bottom: store.selectedBottom,
                hat: store.selectedHat,
                accessory: store.selectedAccessory,
                swimwear: store.selectedSwimwear,
                wearingSwimwear: store.wearingSwimwear,
                wearingCropTop: store.wearingCropTop,
                wearingDress: store.wearingDress,
                swimwearColor: swimwearColor
            )
            .frame(height: compact ? 300 : 400)

            HStack(spacing: 10) {
                baseButton(.girl)
                baseButton(.boy)
            }

            Text("Pick a simple Water Park outfit")
                .font(.system(.headline, design: .rounded).weight(.black))
                .foregroundStyle(AllianPalette.purple)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(swimwearOptions) { option in
                        Button {
                            store.selectedSwimwear = option.name
                            store.wearingSwimwear = true
                            store.wearingDress = false
                            store.wearingCropTop = false
                        } label: {
                            VStack(spacing: 7) {
                                SwimwearMiniIcon(base: store.avatarBase, name: option.name, color: Color(hex: option.hex))
                                    .frame(width: 72, height: 76)
                                Text(option.name)
                                    .font(.system(size: 10, weight: .black, design: .rounded))
                                    .foregroundStyle(AllianPalette.purple)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .padding(9)
                            .frame(width: 104, height: 126)
                            .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(store.selectedSwimwear == option.name && store.wearingSwimwear ? AllianPalette.pink : Color.white, lineWidth: 3)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }

            Text("You can change hair, hats and all other clothes later in Dress Up.")
                .font(.system(.caption, design: .rounded).weight(.bold))
                .foregroundStyle(AllianPalette.purple.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(14)
        .background(Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 28))
    }

    private func baseButton(_ base: AvatarBase) -> some View {
        Button {
            store.avatarBase = base
            let options = base == .girl ? store.girlSwimwear : store.boySwimwear
            if let first = options.first {
                store.selectedSwimwear = first.name
            }
            store.wearingSwimwear = true
            store.wearingDress = false
            store.wearingCropTop = false
        } label: {
            HStack(spacing: 7) {
                Text(base.emoji)
                Text(base.rawValue)
                    .font(.system(.headline, design: .rounded).weight(.black))
            }
            .foregroundStyle(store.avatarBase == base ? Color.white : AllianPalette.purple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(store.avatarBase == base ? AllianPalette.purple : Color.white, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct SwimwearMiniIcon: View {
    let base: AvatarBase
    let name: String
    let color: Color

    var body: some View {
        ZStack {
            if base == .girl {
                if name.contains("Set") {
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(width: 50, height: 30)
                        RoundedRectangle(cornerRadius: 9)
                            .fill(color.opacity(0.9))
                            .frame(width: 44, height: 22)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 17)
                        .fill(color)
                        .frame(width: 54, height: 67)
                        .overlay(Text(name.contains("Flower") ? "🌺" : "💗").font(.system(size: 20)))
                }
            } else {
                if name.contains("Set") {
                    VStack(spacing: 3) {
                        RoundedRectangle(cornerRadius: 9)
                            .fill(color.opacity(0.82))
                            .frame(width: 58, height: 35)
                            .overlay(Text(name.contains("Shark") ? "🦈" : "🌊").font(.system(size: 16)))
                        RoundedRectangle(cornerRadius: 7)
                            .fill(color)
                            .frame(width: 52, height: 27)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(color)
                        .frame(width: 59, height: 43)
                        .overlay(Text(name.contains("Palm") ? "🌴" : "🌊").font(.system(size: 17)))
                }
            }
        }
    }
}

private struct AllianDressUpAvatarPreview: View {
    let base: AvatarBase
    let hair: String
    let eyes: String
    let top: String
    let bottom: String
    let hat: String
    let accessory: String
    let swimwear: String
    let wearingSwimwear: Bool
    let wearingCropTop: Bool
    let wearingDress: Bool
    let swimwearColor: Color

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AllianPalette.softPink, Color.white.opacity(0.92), AllianPalette.softBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            poolDecor

            VStack(spacing: -4) {
                head
                torsoAndArms
                legs
                feet
            }
            .offset(y: 12)

            if accessory != "None" && !wearingSwimwear {
                Text(accessoryEmoji)
                    .font(.system(size: 46))
                    .offset(x: 98, y: 64)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.9), lineWidth: 2)
        )
    }

    private var poolDecor: some View {
        ZStack {
            VStack {
                Spacer()
                Rectangle()
                    .fill(AllianPalette.blue.opacity(0.18))
                    .frame(height: 78)
            }
            Text("🛟")
                .font(.system(size: 50))
                .opacity(0.48)
                .offset(x: -125, y: 135)
            Text("🏖️")
                .font(.system(size: 42))
                .opacity(0.42)
                .offset(x: 125, y: -130)
        }
    }

    private var head: some View {
        ZStack(alignment: .top) {
            Circle()
                .fill(skinColor)
                .frame(width: 126, height: 126)
                .overlay(face)
                .overlay(hairLayer)

            if hat != "No Hat" && hat != "None" && !wearingSwimwear {
                Text(hatEmoji)
                    .font(.system(size: hat == "Crown" ? 72 : 64))
                    .offset(y: hat == "Crown" ? -48 : -41)
                    .shadow(color: .white.opacity(0.6), radius: 2)
            }
        }
    }

    private var torsoAndArms: some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(skinColor)
                .frame(width: 24, height: 120)
                .rotationEffect(.degrees(7))

            clothingBody

            Capsule()
                .fill(skinColor)
                .frame(width: 24, height: 120)
                .rotationEffect(.degrees(-7))
        }
    }

    @ViewBuilder
    private var clothingBody: some View {
        if wearingSwimwear {
            if base == .girl {
                if swimwear.contains("Set") {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(swimwearColor)
                            .frame(width: 122, height: 64)
                            .overlay(Text(swimwear.contains("Ruffle") ? "🎀" : "💙").font(.system(size: 28)))
                        RoundedRectangle(cornerRadius: 15)
                            .fill(swimwearColor.opacity(0.92))
                            .frame(width: 100, height: 42)
                    }
                    .frame(width: 126, height: 116)
                } else {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(swimwearColor)
                        .frame(width: 124, height: 118)
                        .overlay(Text(swimwear.contains("Flower") ? "🌺" : "💗").font(.system(size: 32)))
                }
            } else {
                if swimwear.contains("Set") {
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(swimwearColor.opacity(0.8))
                            .frame(width: 126, height: 72)
                            .overlay(Text(swimwear.contains("Shark") ? "🦈" : "🌊").font(.system(size: 26)))
                        RoundedRectangle(cornerRadius: 15)
                            .fill(swimwearColor)
                            .frame(width: 112, height: 48)
                    }
                } else {
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.86))
                            .frame(width: 124, height: 62)
                            .overlay(Text("🌊").font(.system(size: 26)))
                        RoundedRectangle(cornerRadius: 15)
                            .fill(swimwearColor)
                            .frame(width: 112, height: 54)
                    }
                }
            }
        } else if wearingDress {
            RoundedRectangle(cornerRadius: 30)
                .fill(AllianPalette.pink.opacity(0.82))
                .frame(width: 136, height: 126)
                .overlay(Text("✨").font(.system(size: 34)))
        } else {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(topColor)
                    .frame(width: 125, height: wearingCropTop ? 78 : 104)
                    .overlay(Text(topSymbol).font(.system(size: 32)))
                RoundedRectangle(cornerRadius: 20)
                    .fill(bottomColor)
                    .frame(width: 126, height: wearingCropTop ? 65 : 54)
                    .overlay(Text(bottomSymbol).font(.system(size: 24)))
            }
        }
    }

    private var legs: some View {
        HStack(spacing: 42) {
            Capsule().fill(skinColor).frame(width: 31, height: wearingSwimwear ? 98 : 92)
            Capsule().fill(skinColor).frame(width: 31, height: wearingSwimwear ? 98 : 92)
        }
    }

    private var feet: some View {
        HStack(spacing: 34) {
            if wearingSwimwear {
                RoundedRectangle(cornerRadius: 8).fill(skinColor).frame(width: 43, height: 18)
                RoundedRectangle(cornerRadius: 8).fill(skinColor).frame(width: 43, height: 18)
            } else {
                Text("👟").font(.system(size: 39))
                Text("👟").font(.system(size: 39))
            }
        }
    }

    private var face: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 37)
            HStack(spacing: 27) {
                eye
                eye
            }
            Text("◡")
                .font(.system(size: 27, weight: .bold))
                .foregroundStyle(Color(red: 0.75, green: 0.25, blue: 0.35))
        }
    }

    private var eye: some View {
        Circle()
            .fill(eyeColor)
            .frame(width: 24, height: 24)
            .overlay(Circle().fill(Color.white).frame(width: 7, height: 7).offset(x: -5, y: -5))
    }

    private var hairLayer: some View {
        ZStack {
            Capsule()
                .fill(hairColor)
                .frame(width: 142, height: 62)
                .offset(y: -31)
            Circle()
                .trim(from: base == .boy ? 0.56 : 0.46, to: 1.0)
                .stroke(hairColor, style: StrokeStyle(lineWidth: base == .boy ? 20 : 24, lineCap: .round))
                .frame(width: 144, height: base == .boy ? 122 : 150)
                .offset(y: base == .boy ? 10 : 20)
        }
    }

    private var skinColor: Color { Color(red: 0.95, green: 0.73, blue: 0.61) }

    private var hairColor: Color {
        if hair.contains("Black") || hair.contains("Dark") { return .black.opacity(0.82) }
        if hair.contains("Golden") || hair.contains("Blonde") { return Color(red: 0.95, green: 0.78, blue: 0.45) }
        if hair.contains("Pink") { return AllianPalette.pink.opacity(0.85) }
        if hair.contains("Blue") { return AllianPalette.blue.opacity(0.85) }
        return Color(red: 0.35, green: 0.16, blue: 0.10)
    }

    private var eyeColor: Color {
        if eyes.contains("Blue") { return .blue }
        if eyes.contains("Green") { return .green }
        if eyes.contains("Hazel") { return Color(red: 0.55, green: 0.45, blue: 0.18) }
        if eyes.contains("Violet") || eyes.contains("Purple") { return .purple }
        return .brown
    }

    private var topColor: Color {
        if top.contains("Blue") || top.contains("Sky") { return AllianPalette.blue.opacity(0.78) }
        if top.contains("Lavender") { return AllianPalette.purple.opacity(0.74) }
        if top.contains("Mint") { return Color.green.opacity(0.56) }
        return AllianPalette.pink.opacity(0.72)
    }

    private var bottomColor: Color {
        if bottom.contains("Purple") || bottom.contains("Lavender") { return AllianPalette.purple.opacity(0.78) }
        if bottom.contains("Pink") { return AllianPalette.pink.opacity(0.78) }
        return Color(red: 0.40, green: 0.67, blue: 0.94)
    }

    private var topSymbol: String {
        if top.contains("Heart") { return "💗" }
        if top.contains("Rainbow") { return "🌈" }
        if top.contains("Mint") { return "🌿" }
        return "⭐️"
    }

    private var bottomSymbol: String { bottom.contains("Heart") ? "💗" : "✨" }

    private var hatEmoji: String {
        switch hat {
        case "Pink Cap", "Blue Cap": return "🧢"
        case "Crown": return "👑"
        default: return ""
        }
    }

    private var accessoryEmoji: String {
        switch accessory {
        case "Heart Glasses": return "💗"
        case "Headphones": return "🎧"
        case "Flower": return "🌸"
        case "Pink Bow": return "🎀"
        default: return ""
        }
    }
}

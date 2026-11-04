import SwiftUI

struct CreateView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        NavigationStack {
            ZStack {
                AllianSwirlBackground().ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        AllianLogo(subtitle: "Choose a house and decorate anything you like")

                        SectionTitle(title: "My Houses", subtitle: "Tap a house to see the inside layout and start decorating")
                        houseSelector

                        selectedHouseShowcase

                        SectionTitle(title: "Choose a Room", subtitle: "Pick a room to decorate inside your house")
                        roomSelector

                        SectionTitle(title: "Decorate", subtitle: "Everything is free and unlocked")
                        decorGrid

                        Button {
                            store.clearRoom()
                        } label: {
                            Label("Clear this room", systemImage: "arrow.counterclockwise")
                                .font(.system(.subheadline, design: .rounded).weight(.black))
                                .foregroundStyle(AllianTheme.ink)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 11)
                                .background(.white.opacity(0.88), in: Capsule())
                        }
                        .buttonStyle(.plain)

                        if let friend = store.invitedFriend {
                            AllianCard {
                                HStack(spacing: 12) {
                                    Text("🫶").font(.title)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Live with \(friend.allianName)")
                                            .font(.system(.headline, design: .rounded).weight(.black))
                                            .foregroundStyle(AllianTheme.ink)
                                        Text("You can choose to share this house in the friends demo.")
                                            .font(.system(.caption, design: .rounded).weight(.bold))
                                            .foregroundStyle(Color(hex: "715787"))
                                    }
                                    Spacer()
                                    Toggle("", isOn: $store.livingTogether)
                                        .labelsHidden()
                                        .tint(AllianTheme.pink)
                                }
                            }
                        }
                    }
                    .padding(12)
                    .padding(.bottom, 20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var houseSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(store.houses) { house in
                    Button {
                        store.selectedHouse = house.name
                        if store.selectedHouse == "Modern House" && !["Living Room", "Kitchen", "Bedroom", "Bathroom"].contains(store.selectedRoom) {
                            store.selectedRoom = "Living Room"
                        }
                    } label: {
                        VStack(spacing: 7) {
                            Text(house.emoji).font(.system(size: 42))
                            Text(house.name)
                                .font(.system(.subheadline, design: .rounded).weight(.black))
                                .multilineTextAlignment(.center)
                            Text(house.description)
                                .font(.system(.caption2, design: .rounded).weight(.bold))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .foregroundStyle(store.selectedHouse == house.name ? .white : AllianTheme.ink)
                        .frame(width: 150, height: 145)
                        .padding(8)
                        .background(
                            store.selectedHouse == house.name
                            ? AnyShapeStyle(LinearGradient(colors: [AllianTheme.pink, AllianTheme.purple, AllianTheme.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color.white.opacity(0.88)),
                            in: RoundedRectangle(cornerRadius: 22)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var selectedHouseShowcase: some View {
        if store.selectedHouse == "Modern House" {
            ModernHouseDesignShowcase()
                .environmentObject(store)
        } else {
            HouseRoomPreview()
                .environmentObject(store)
        }
    }

    private var roomSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(store.rooms, id: \.self) { room in
                    Button(room) {
                        store.selectedRoom = room
                    }
                    .font(.system(.caption, design: .rounded).weight(.black))
                    .foregroundStyle(store.selectedRoom == room ? .white : AllianTheme.ink)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 10)
                    .background(
                        store.selectedRoom == room
                        ? AnyShapeStyle(AllianTheme.purple.gradient)
                        : AnyShapeStyle(Color.white.opacity(0.9)),
                        in: Capsule()
                    )
                }
            }
        }
    }

    private var decorGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 9)], spacing: 9) {
            ForEach(store.decorItems.filter { $0.room == store.selectedRoom }) { item in
                Button {
                    store.addDecor(item)
                } label: {
                    VStack(spacing: 5) {
                        Text(item.emoji).font(.system(size: 32))
                        Text(item.name)
                            .font(.system(.caption2, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.ink)
                            .multilineTextAlignment(.center)
                        Text("FREE")
                            .font(.system(size: 9, weight: .black, design: .rounded))
                            .foregroundStyle(AllianTheme.pink)
                    }
                    .frame(maxWidth: .infinity, minHeight: 92)
                    .padding(7)
                    .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ModernHouseDesignShowcase: View {
    @EnvironmentObject private var store: GameStore
    @State private var viewMode: ModernHouseViewMode = .inside

    private let primaryRooms = ["Living Room", "Kitchen", "Bedroom", "Bathroom"]

    private var activeRoom: String {
        primaryRooms.contains(store.selectedRoom) ? store.selectedRoom : "Living Room"
    }

    var body: some View {
        AllianCard {
            VStack(spacing: 14) {
                HStack(alignment: .top, spacing: 12) {
                    ModernHousePosterCard()
                        .frame(width: 220)

                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            ForEach(ModernHouseViewMode.allCases, id: \.self) { mode in
                                Button {
                                    viewMode = mode
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: mode == .inside ? "house.fill" : "square.grid.2x2")
                                        Text(mode.title)
                                    }
                                    .font(.system(.subheadline, design: .rounded).weight(.black))
                                    .foregroundStyle(viewMode == mode ? .white : AllianTheme.ink)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        viewMode == mode
                                        ? AnyShapeStyle(LinearGradient(colors: [AllianTheme.pink, AllianTheme.purple], startPoint: .leading, endPoint: .trailing))
                                        : AnyShapeStyle(Color.white.opacity(0.86)),
                                        in: Capsule()
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Group {
                            if viewMode == .inside {
                                ModernHouseInsideCutaway(selectedRoom: activeRoom)
                            } else {
                                ModernHouseLayoutPlan(selectedRoom: activeRoom)
                            }
                        }
                        .frame(height: 365)
                    }
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(primaryRooms, id: \.self) { room in
                            Button {
                                store.selectedRoom = room
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: icon(for: room))
                                    Text(room)
                                }
                                .font(.system(.subheadline, design: .rounded).weight(.black))
                                .foregroundStyle(store.selectedRoom == room ? .white : AllianTheme.ink)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    store.selectedRoom == room
                                    ? AnyShapeStyle(AllianTheme.pink.gradient)
                                    : AnyShapeStyle(Color.white.opacity(0.9)),
                                    in: Capsule()
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                HStack(spacing: 10) {
                    ForEach([("Decorate", "paintbrush.fill"), ("Edit", "slider.horizontal.3"), ("Move", "arrow.up.and.down.and.arrow.left.and.right"), ("Change Style", "sparkles"), ("Save", "checkmark.circle.fill")], id: \.0) { item in
                        HStack(spacing: 6) {
                            Image(systemName: item.1)
                            Text(item.0)
                        }
                        .font(.system(.caption, design: .rounded).weight(.black))
                        .foregroundStyle(item.0 == "Save" ? .white : AllianTheme.ink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            item.0 == "Save"
                            ? AnyShapeStyle(AllianTheme.purple.gradient)
                            : AnyShapeStyle(Color.white.opacity(0.9)),
                            in: Capsule()
                        )
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Room Previews", systemImage: "camera.fill")
                            .font(.system(.headline, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.ink)
                        Spacer()
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(primaryRooms, id: \.self) { room in
                                Button {
                                    store.selectedRoom = room
                                } label: {
                                    RoomPreviewThumbnail(room: room, selected: room == activeRoom)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
    }

    private func icon(for room: String) -> String {
        switch room {
        case "Living Room": return "sofa.fill"
        case "Kitchen": return "fork.knife"
        case "Bedroom": return "bed.double.fill"
        case "Bathroom": return "bathtub.fill"
        default: return "house.fill"
        }
    }
}

private enum ModernHouseViewMode: CaseIterable {
    case inside
    case layout

    var title: String {
        switch self {
        case .inside: return "Inside View"
        case .layout: return "House Layout"
        }
    }
}

struct ModernHousePosterCard: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(hex: "BFE3FF"), Color(hex: "F5D7FF"), Color(hex: "FFE7F2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.95), lineWidth: 3))

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "house.fill")
                        .foregroundStyle(AllianTheme.purple)
                        .padding(12)
                        .background(.white.opacity(0.9), in: Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Modern House")
                            .font(.system(.title2, design: .rounded).weight(.black))
                            .foregroundStyle(AllianTheme.ink)
                        Text("House Design")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundStyle(AllianTheme.purple)
                    }
                }

                Spacer(minLength: 8)

                ModernHouseExteriorArt()
                    .frame(height: 220)

                HStack(alignment: .bottom, spacing: 8) {
                    Text("👧")
                        .font(.system(size: 60))
                        .padding(.bottom, 4)
                    Text("Design your Modern House in Allian! 💗")
                        .font(.system(.subheadline, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                        .padding(12)
                        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(14)
        }
        .frame(maxHeight: .infinity)
    }
}

struct ModernHouseExteriorArt: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: [Color(hex: "C6EBFF"), Color.white, Color(hex: "EDE2FF")], startPoint: .top, endPoint: .bottom))

            // garden
            Rectangle()
                .fill(LinearGradient(colors: [Color(hex: "8ADB9F"), Color(hex: "A8F0C2")], startPoint: .top, endPoint: .bottom))
                .frame(height: 70)

            // path
            Path { path in
                path.move(to: CGPoint(x: 85, y: 220))
                path.addLine(to: CGPoint(x: 112, y: 175))
                path.addLine(to: CGPoint(x: 138, y: 175))
                path.addLine(to: CGPoint(x: 165, y: 220))
            }
            .fill(Color.white.opacity(0.95))

            // tree left
            VStack(spacing: -6) {
                Circle().fill(Color(hex: "FFA8D4")).frame(width: 52, height: 52)
                Circle().fill(Color(hex: "FFBADC")).frame(width: 44, height: 44)
                Rectangle().fill(Color(hex: "A77959")).frame(width: 10, height: 42)
            }
            .offset(x: -85, y: -28)

            // house
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    modernWindow(width: 65, height: 72)
                    modernWindow(width: 65, height: 72)
                }
                .padding(.horizontal, 14)
                .padding(.top, 12)

                HStack(spacing: 8) {
                    modernWindow(width: 62, height: 58)
                    Rectangle()
                        .fill(Color(hex: "EBD3C4"))
                        .frame(width: 34)
                    modernWindow(width: 62, height: 58)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .background(
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.92))
                    Rectangle()
                        .fill(Color(hex: "E8D6C7"))
                        .frame(width: 40)
                }
            )
            .frame(width: 190, height: 158)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.white.opacity(0.95))
                    .frame(width: 215, height: 12)
                    .offset(y: -8)
                    .rotationEffect(.degrees(-3))
            }
            .offset(y: -14)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func modernWindow(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(colors: [Color(hex: "B5E3FF"), Color(hex: "FFE1F4")], startPoint: .top, endPoint: .bottom))
            .frame(width: width, height: height)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "3F4B66"), lineWidth: 2))
    }
}

struct ModernHouseInsideCutaway: View {
    let selectedRoom: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(hex: "FFF4FA"), Color(hex: "FFF7EC"), Color(hex: "F5EEFF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.95), lineWidth: 3))

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Spacer().frame(width: 140)
                    roomBox(room: "Bedroom")
                    roomBox(room: "Bathroom")
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)

                Rectangle()
                    .fill(Color(hex: "D4C6FF"))
                    .frame(height: 3)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 10)

                HStack(spacing: 12) {
                    roomBox(room: "Living Room")
                        .frame(maxWidth: .infinity)
                    roomBox(room: "Kitchen")
                        .frame(maxWidth: .infinity)
                    staircase
                        .frame(width: 108)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }
        }
    }

    @ViewBuilder
    private func roomBox(room: String) -> some View {
        let isSelected = selectedRoom == room
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.white.opacity(0.93))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isSelected ? AllianTheme.pink : Color.white, lineWidth: isSelected ? 4 : 2)
            )
            .overlay {
                roomContent(room: room)
                    .padding(12)
            }
            .shadow(color: isSelected ? AllianTheme.pink.opacity(0.20) : .clear, radius: 8, y: 3)
    }

    @ViewBuilder
    private func roomContent(room: String) -> some View {
        switch room {
        case "Living Room":
            VStack(alignment: .leading, spacing: 8) {
                roomTitle(room, icon: "sofa.fill")
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [Color(hex: "FFE7F1"), Color(hex: "F6F0FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 88)
                    .overlay(alignment: .bottomLeading) {
                        HStack(alignment: .bottom, spacing: 8) {
                            RoundedRectangle(cornerRadius: 16).fill(Color.white).frame(width: 70, height: 36)
                            Circle().fill(Color(hex: "D9B4FF")).frame(width: 28, height: 28)
                            Spacer()
                        }
                        .padding(10)
                    }
                HStack {
                    Circle().fill(Color(hex: "FFB8D7")).frame(width: 18, height: 18)
                    RoundedRectangle(cornerRadius: 8).fill(Color(hex: "EADFFF")).frame(width: 54, height: 12)
                    Spacer()
                    Text("🪴")
                }
            }
        case "Kitchen":
            VStack(alignment: .leading, spacing: 8) {
                roomTitle(room, icon: "fork.knife")
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [Color(hex: "FFF0F6"), Color(hex: "FFF6E8")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 88)
                    .overlay {
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 8).fill(Color(hex: "F5D8D0")).frame(height: 18)
                                RoundedRectangle(cornerRadius: 8).fill(Color(hex: "F5D8D0")).frame(height: 18)
                            }
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 14).fill(Color.white).frame(height: 34)
                                VStack(spacing: 4) {
                                    Circle().fill(Color(hex: "FFC3D9")).frame(width: 10, height: 10)
                                    Circle().fill(Color(hex: "CBAEFF")).frame(width: 10, height: 10)
                                }
                            }
                        }
                        .padding(10)
                    }
                Text("🍓   🧁   🥤")
            }
        case "Bedroom":
            VStack(alignment: .leading, spacing: 8) {
                roomTitle(room, icon: "bed.double.fill")
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [Color(hex: "FFF0F8"), Color(hex: "F6EEFF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 88)
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 12).fill(Color(hex: "FFC7DE")).frame(width: 92, height: 26)
                            RoundedRectangle(cornerRadius: 10).fill(Color.white).frame(width: 92, height: 16)
                        }
                        .padding(.bottom, 10)
                    }
                HStack {
                    Text("🪴")
                    Spacer()
                    Text("🖼️")
                }
            }
        default:
            VStack(alignment: .leading, spacing: 8) {
                roomTitle(room, icon: "bathtub.fill")
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [Color(hex: "FFF4FA"), Color(hex: "EEF7FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 88)
                    .overlay {
                        HStack(alignment: .bottom, spacing: 12) {
                            RoundedRectangle(cornerRadius: 10).fill(Color.white).frame(width: 44, height: 26)
                            Circle().stroke(Color(hex: "FFD3E3"), lineWidth: 6).frame(width: 34, height: 34)
                            Spacer()
                            RoundedRectangle(cornerRadius: 12).fill(Color(hex: "F3F4FA")).frame(width: 24, height: 44)
                        }
                        .padding(10)
                    }
                Text("🪞   🚿   🧴")
            }
        }
    }

    private func roomTitle(_ room: String, icon: String) -> some View {
        HStack {
            Label(room, systemImage: icon)
                .font(.system(.caption, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Spacer()
        }
    }

    private var staircase: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle().fill(Color(hex: "F9DAB6")).frame(width: 18, height: 9)
                }
            }
            .rotationEffect(.degrees(-32), anchor: .leading)
            .offset(y: 18)

            Spacer()

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.92))
                .overlay(alignment: .bottomTrailing) {
                    VStack(spacing: 4) {
                        ForEach(0..<4, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 4).fill(Color(hex: "F9DAB6")).frame(width: 60, height: 8)
                        }
                    }
                    .rotationEffect(.degrees(-32))
                    .padding(.trailing, 18)
                    .padding(.bottom, 18)
                }
        }
    }
}

struct ModernHouseLayoutPlan: View {
    let selectedRoom: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(hex: "FEF7FB"), Color(hex: "F2F7FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.95), lineWidth: 3))

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    planRoom("Bedroom", color: Color(hex: "FFD9EB"), icon: "bed.double.fill")
                    planRoom("Bathroom", color: Color(hex: "E7F3FF"), icon: "bathtub.fill")
                }
                HStack(spacing: 12) {
                    planRoom("Living Room", color: Color(hex: "FBE6F7"), icon: "sofa.fill")
                    VStack(spacing: 12) {
                        planRoom("Kitchen", color: Color(hex: "FFF0D8"), icon: "fork.knife")
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.92))
                            .frame(height: 70)
                            .overlay(
                                VStack(spacing: 6) {
                                    Text("Stairs")
                                        .font(.system(.caption, design: .rounded).weight(.black))
                                        .foregroundStyle(AllianTheme.ink)
                                    HStack(spacing: 4) {
                                        ForEach(0..<5, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 3).fill(Color(hex: "D8C3FF")).frame(width: 12, height: 8)
                                        }
                                    }
                                }
                            )
                    }
                }
            }
            .padding(18)
        }
    }

    private func planRoom(_ room: String, color: Color, icon: String) -> some View {
        let isSelected = selectedRoom == room
        return RoundedRectangle(cornerRadius: 24)
            .fill(color)
            .frame(maxWidth: .infinity, minHeight: room == "Living Room" ? 150 : 110)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? AllianTheme.pink : Color.white, lineWidth: isSelected ? 4 : 2)
            )
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(AllianTheme.purple)
                    Text(room)
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                    Text(isSelected ? "Selected" : "Tap room buttons below")
                        .font(.system(.caption2, design: .rounded).weight(.bold))
                        .foregroundStyle(Color(hex: "7A6794"))
                }
            }
    }
}

struct RoomPreviewThumbnail: View {
    let room: String
    let selected: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(thumbnailGradient)
                    .frame(width: 178, height: 118)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(selected ? AllianTheme.pink : Color.white.opacity(0.95), lineWidth: selected ? 4 : 2))
                VStack(spacing: 8) {
                    Text(emoji)
                        .font(.system(size: 38))
                    Text(room)
                        .font(.system(.caption, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.88), in: Capsule())
                }
            }
        }
    }

    private var emoji: String {
        switch room {
        case "Living Room": return "🛋️"
        case "Kitchen": return "🍽️"
        case "Bedroom": return "🛏️"
        case "Bathroom": return "🛁"
        default: return "🏠"
        }
    }

    private var thumbnailGradient: LinearGradient {
        switch room {
        case "Living Room":
            return LinearGradient(colors: [Color(hex: "FFF0F7"), Color(hex: "F2EBFF")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Kitchen":
            return LinearGradient(colors: [Color(hex: "FFF1DC"), Color(hex: "FFE8F3")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Bedroom":
            return LinearGradient(colors: [Color(hex: "FFEAF4"), Color(hex: "F3EDFF")], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color(hex: "F8F1FF"), Color(hex: "ECF7FF")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct HouseRoomPreview: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: roomColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 250)

            VStack(spacing: 8) {
                HStack {
                    Text(roomEmoji)
                        .font(.system(size: 76))
                    Spacer()
                    Text(store.selectedHouse)
                        .font(.system(.caption, design: .rounded).weight(.black))
                        .foregroundStyle(AllianTheme.ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.9), in: Capsule())
                }

                Spacer()

                HStack(spacing: 11) {
                    ForEach(Array(store.currentDecor().enumerated()), id: \.offset) { entry in
                        Text(entry.element).font(.system(size: 35))
                    }
                    if store.currentDecor().isEmpty {
                        Text("Tap furniture below to add it")
                            .font(.system(.subheadline, design: .rounded).weight(.black))
                            .foregroundStyle(Color(hex: "684C8B"))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 20))
            }
            .padding(16)
        }
        .overlay(alignment: .topLeading) {
            Text(store.selectedRoom)
                .font(.system(.headline, design: .rounded).weight(.black))
                .foregroundStyle(.white)
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(AllianTheme.purple.opacity(0.82), in: Capsule())
                .padding(12)
        }
    }

    private var roomEmoji: String {
        switch store.selectedRoom {
        case "Bedroom": return "🛏️"
        case "Kitchen": return "🍽️"
        case "Bathroom": return "🛁"
        case "Game Room": return "🎮"
        case "Pool Garden": return "🏊"
        default: return "🛋️"
        }
    }

    private var roomColors: [Color] {
        switch store.selectedRoom {
        case "Pool Garden": return [Color(hex: "9EEAFF"), Color(hex: "81D9FF"), Color(hex: "FFD6EA")]
        case "Game Room": return [Color(hex: "CAB4FF"), Color(hex: "86B8FF"), Color(hex: "FFC2E0")]
        case "Kitchen": return [Color(hex: "FFF0D8"), Color(hex: "FFD8EA"), Color(hex: "E8E0FF")]
        case "Bathroom": return [Color(hex: "E8F7FF"), Color(hex: "F0E6FF"), Color(hex: "FFDFF0")]
        case "Bedroom": return [Color(hex: "FFE0F0"), Color(hex: "EADFFF"), Color(hex: "DFF2FF")]
        default: return [Color(hex: "FFD6EA"), Color(hex: "EADFFF"), Color(hex: "DFF2FF")]
        }
    }
}

struct SectionTitle: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.title2, design: .rounded).weight(.black))
                .foregroundStyle(AllianTheme.ink)
            Text(subtitle)
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "715787"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

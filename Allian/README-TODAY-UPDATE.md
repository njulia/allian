# Allian — Today Update

This update implements the design agreed in today's chat.

## Changed / new files
- `HomeView.swift`
- `AvatarView.swift`
- `AllianTodayModels.swift`

## What now works
- Home buttons open real screens instead of doing nothing.
- Mall opens individual shops.
- Beach, zoo, aquarium, city and game room open interactive destination screens.
- Travel opens countries and lets the player enter/explore each destination.
- House screen lets players choose 1–4 bedrooms and shared/separate-room options.
- Friends screen uses an **Allian character name**, not a real name.
- Living together is optional.
- Both friends are allowed to decorate a shared house.
- Each player only changes their own avatar/clothes.
- Mini-games have 100,000 selectable procedural variations across 10 game categories.
- Mini-game screens contain real tap interactions rather than dead buttons.
- Food delivery lets the player choose food and shows it arriving at the house.
- Avatar hats and crowns appear immediately on the avatar.
- Crop tops remain included.
- No points, coins, XP or leaderboards.
- Uses only APIs compatible with iOS 16.0.

## Install
Add `AllianTodayModels.swift` to the Allian target. Replace the existing `HomeView.swift` and `AvatarView.swift` with the files in this update.

If your Xcode project already defines any of the same helper types (for example `AllianPlace`), remove or rename the duplicate older definition.

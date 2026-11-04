# Allian — Picture-Match SwiftUI Prototype

This is the complete iPhone/iPad Xcode source project for the Allian design approved in the chat.

## Important visual change

This version does **not** use a plain/default SwiftUI look. The approved Allian screenshots are used as the visual source of truth and are also included in `DesignReference/`. Cropped artwork from those approved screenshots is bundled in `Assets.xcassets` and displayed inside the actual interactive app so the running UI has the same bright pink/purple/blue world, shops, houses, travel, mini-phone, friends, avatar and mini-game look.

The app uses a new bundle identifier (`com.example.allian.picturematch`) so it installs separately from the older prototype and does not accidentally show the old cached UI.

## Included

- Bright pink, purple and blue swirly GUI
- Welcome / intro screen
- Safe character-name flow with: `Oops! Sorry, please change your name. 💗`
- Boys and girls avatar bases
- Hair, eyes, eyebrows, face/skin tones and lips
- Tops, crop tops, bottoms, dresses, shoes, hats, bags, accessories and pets
- Clothes visibly change the SwiftUI avatar preview
- Large explorable Allian world directory
- Mall, supermarket, clothes, shoe, hat, bag, toy, baby and phone shops
- Hairdresser and nail salon
- Cafe and restaurant
- Aquarium, zoo, beach, swimming pool, game room and optional school
- Multiple houses, rooms, furniture placement, game room and pool garden
- In-game mini phone
- Pretend food delivery to the chosen house
- Airport and train travel
- Spain, China, Japan, Korea, Italy, Germany, France, UK and USA destination cards
- Friend search by **Allian character name**, not real name
- Optional shared-house / live-together prototype flow
- Kind phrase buttons instead of unrestricted chat in this prototype
- **120 mini-games** generated from 20 categories × 6 variations
- No coins, XP, points, leaderboards, locked items or pay-to-win progression

## Open in Xcode

1. Unzip the project.
2. Open `Allian.xcodeproj`.
3. Select your Apple development team in Signing & Capabilities if Xcode asks.
4. Pick an iPhone or iPad simulator.
5. Run the `Allian` scheme.

The deployment target is iOS 16.0 and the project uses SwiftUI / Swift 5.

## Visual reference

The exact approved artwork used to guide this implementation is in:

- `DesignReference/approved-onboarding-and-world.png`
- `DesignReference/approved-travel-avatar-world.png`
- `DesignReference/approved-friends-mini-games.png`
- `DesignReference/Allian_Master_Game_Design_Document.docx`

If a future code change makes the app plain, dark, black-and-white or system-default-looking, treat that as a visual regression.

## Prototype limitations

The friend/live-together feature is currently a **local UI prototype** with demo Allian character names. Real device-to-device multiplayer needs a child-safe backend, authenticated parent/guardian controls, moderation and safeguarding work before production release. The Camera screen is a pretend in-game camera and does not access the real device camera or photo library.

This prototype also does not include ads, tracking, location collection, analytics SDKs or real-money purchases.

# iOS 16.0 Compatibility Check

- Deployment targets found: 16.0, 16.0
- Removed all custom `Font.rounded()` call sites.
- Removed `View.fontDesign`, which requires iOS 16.1+.
- Rounded typography now uses `Font.system(_:design:)`, compatible with iOS 16.0.
- NavigationStack remains in use; it is available from iOS 16.0.
- Remaining `.rounded()` calls: 0
- Known post-iOS-16.0 API hits from static scan: 0

This is a static source compatibility pass. Final verification should be done by building with Xcode using an iOS 16.0 deployment target.

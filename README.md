# ADManagerKit

*(Internal Use Only – Not Published to a Public Repository)*

A Swift package that provides an abstraction layer for multiple ad providers, simplifying:

* SDK configuration and initialization for Google Mobile Ads (AdMob)
* Integration of additional providers via a unified protocol
* Runtime switching between providers—you can use AdMob now and swap to another later
* A SwiftUI `BannerAdView` component with lifecycle callbacks and retry logic

---

## Why ADManagerKit

* **Provider abstraction**: implement `AdProvider` once and support any ad SDK
* **Plug-and-play**: AdMob is ready out of the box; add others without changing your UI code
* **Easy provider switching**: change providers by updating configuration only
* **SwiftUI-friendly**: built-in `BannerAdView` with predefined sizes and callbacks

---

## Requirements

* iOS 13.0+
* Swift 5.5+
* Xcode 13+
* Google Mobile Ads SDK (>= 9.0) for the default AdMob provider

---

## Installation

### Swift Package Manager

In Xcode, go to *File → Swift Packages → Add Package Dependency* and enter:

```text
https://github.com/GeorgeAGomes/ADManagerKit
```

1. Add your AdMob IDs to your app's Info.plist either by specifying the values directly:

```xml
<key>ADMOB_APP_ID</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
<key>BANNER_AD_UNIT_ID</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx</string>
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
```

or by creating a custom `.xcconfig` file and referencing it in your build settings:

```text
// Config.xcconfig
ADMOB_APP_ID         = ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx
BANNER_AD_UNIT_ID    = ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
```

and then using those variables in your Info.plist:

```xml
<key>ADMOB_APP_ID</key>
<string>$(ADMOB_APP_ID)</string>
<key>BANNER_AD_UNIT_ID</key>
<string>$(BANNER_AD_UNIT_ID)</string>
<key>GADApplicationIdentifier</key>
<string>$(ADMOB_APP_ID)</string>
```

2. Initialize the Google Mobile Ads SDK early in your app lifecycle (e.g., in your App initializer or AppDelegate):

```swift
import ADManagerKit

@main
struct MyApp: App {
    init() {
        ADManagerKit().start { status in
            // SDK initialization completed
            print("Ad SDK adapters: \(status.adapterStatusesByClassName)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## Usage

### SwiftUI Banner Ad

1. Use `BannerAdView` in your SwiftUI view:

```swift
import SwiftUI
import ADManagerKit

struct ContentView: View {
   @StateObject private var adState = BannerAdState()

   var body: some View {
       VStack {
           BannerAdView(
               state: adState,
               retryLimit: 3,
               didLoad: { print("Ad loaded") },
               didError: { error in print("Ad error: \(error.localizedDescription)") },
               didClick: { print("Ad clicked") },
               didRecordImpression: { print("Impression recorded") },
               willPresentScreen: { print("Will present full-screen") },
               willDismissScreen: { print("Will dismiss full-screen") },
               didDismissScreen: { print("Did dismiss full-screen") }
           )
           .sized(.medium)
       }
   }
}
```

Predefined sizes:

* `.small` – 320×50
* `.medium` – 320×100
* `.large` – 300×250

---

## Customization

* **Retry Logic**: Set `retryLimit` when initializing `BannerAdView` to control how many times a failed load retries (with exponential back-off).
* **Test Devices**: To customize test device IDs:

  ```swift
  MobileAds.shared.requestConfiguration.testDeviceIdentifiers = ["YOUR_TEST_DEVICE_ID_1", "YOUR_TEST_DEVICE_ID_2"]
  ```

---

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open a pull request.

---

## License

This project is released under the MIT License. See the `LICENSE` file for details.

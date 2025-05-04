//
//  BannerAdView.swift
//  ADManagerKit
//
//  Created by George on 04/05/25.
//
import SwiftUI
import GoogleMobileAds

/// A SwiftUI view that displays a Google Mobile Ads banner ad.
/// It binds banner view delegate events to a `BannerAdState` and allows optional callbacks.
public struct BannerAdView: UIViewRepresentable {
    @ObservedObject private var state: BannerAdState

    private let didLoad: (() -> Void)?
    private let didError: ((Error) -> Void)?
    private let didClick: (() -> Void)?
    private let didRecordImpression: (() -> Void)?
    private let willPresentScreen: (() -> Void)?
    private let willDismissScreen: (() -> Void)?
    private let didDismissScreen: (() -> Void)?
    private let retryLimit: Int

    /// Initializes a `BannerAdView`.
    /// - Parameters:
    ///   - state: The `BannerAdState` object to track ad lifecycle events.
    ///   - retryLimit: Number of retry attempts on ad load failure (default is 0).
    ///   - didLoad: Closure called when an ad loads successfully.
    ///   - didError: Closure called when an ad fails to load, providing an error.
    ///   - didClick: Closure called when the ad is clicked.
    ///   - didRecordImpression: Closure called when an impression is recorded.
    ///   - willPresentScreen: Closure called before presenting a full-screen view.
    ///   - willDismissScreen: Closure called before dismissing a full-screen view.
    ///   - didDismissScreen: Closure called after dismissing a full-screen view.
    public init(
        state: BannerAdState,
        retryLimit: Int = 0,
        didLoad: (() -> Void)? = nil,
        didError: ((Error) -> Void)? = nil,
        didClick: (() -> Void)? = nil,
        didRecordImpression: (() -> Void)? = nil,
        willPresentScreen: (() -> Void)? = nil,
        willDismissScreen: (() -> Void)? = nil,
        didDismissScreen: (() -> Void)? = nil
    ) {
        self.retryLimit = retryLimit
        self.state = state
        self.didLoad = didLoad
        self.didError = didError
        self.didClick = didClick
        self.didRecordImpression = didRecordImpression
        self.willPresentScreen = willPresentScreen
        self.willDismissScreen = willDismissScreen
        self.didDismissScreen = didDismissScreen
    }

    /// Coordinator acts as the delegate for `BannerView`, updating the SwiftUI state and callbacks.
    public class Coordinator: NSObject, BannerViewDelegate {
        /// Reference to the parent `BannerAdView` to update ad state and invoke callbacks.
        let parent: BannerAdView
        /// Maximum number of retry attempts for loading an ad when an error occurs.
        private let retryLimit: Int
        /// Tracks the current number of retry attempts performed.
        private var currentRetryCount = 0

        /// Creates a coordinator for the given `BannerAdView`.
        /// - Parameter parent: The view that owns this coordinator.
        init(parent: BannerAdView) {
            self.parent = parent
            self.retryLimit = parent.retryLimit
        }

        /// Called when an ad successfully loads.
        /// - Parameter bannerView: The banner view that loaded the ad.
        /// Updates `state.adSize`, resets retry count, and invokes the `didLoad` callback.
        public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            parent.state.adSize = CGSize(
                width: bannerView.frame.width,
                height: bannerView.frame.height
            )
            parent.state.didLoad = true
            currentRetryCount = 0
            parent.didLoad?()
        }

        /// Called when the banner view fails to receive an ad.
        /// - Parameters:
        ///   - bannerView: The banner view that failed to load.
        ///   - error: The error encountered during loading.
        /// Updates `state.error`, invokes `didError`, and retries loading based on `retryLimit`.
        public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            parent.state.error = error
            parent.didError?(error)

            guard currentRetryCount < retryLimit else { return }
            currentRetryCount += 1

            let delay = pow(2.0, Double(currentRetryCount))
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                bannerView.load(Request())
            }
        }

        /// Called when the user taps on the banner ad.
        /// - Parameter bannerView: The banner view that was clicked.
        /// Updates `state.didClick` and invokes the `didClick` callback.
        public func bannerViewDidRecordClick(_ bannerView: BannerView) {
            parent.state.didClick = true
            parent.didClick?()
        }

        /// Called when the ad registers an impression.
        /// - Parameter bannerView: The banner view that recorded the impression.
        /// Updates `state.didRecordImpression` and invokes the corresponding callback.
        public func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            parent.state.didRecordImpression = true
            parent.didRecordImpression?()
        }

        /// Called just before presenting a full-screen content (e.g., click-through).
        /// - Parameter bannerView: The banner view that will present the screen.
        /// Updates `state.willPresentScreen` and invokes the `willPresentScreen` callback.
        public func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            parent.state.willPresentScreen = true
            parent.willPresentScreen?()
        }

        /// Called just before dismissing full-screen content.
        /// - Parameter bannerView: The banner view that will dismiss the screen.
        /// Updates `state.willDismissScreen` and invokes the `willDismissScreen` callback.
        public func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            parent.state.willDismissScreen = true
            parent.willDismissScreen?()
        }

        /// Called after full-screen content has been dismissed.
        /// - Parameter bannerView: The banner view that dismissed the screen.
        /// Updates `state.didDismissScreen` and invokes the `didDismissScreen` callback.
        public func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            parent.state.didDismissScreen = true
            parent.didDismissScreen?()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /// Creates and configures the `BannerView` with ad unit ID, root view controller, delegate,
    /// and initiates loading an ad request.
    public func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = Bundle.main.infoDictionary?["BANNER_AD_UNIT_ID"] as? String
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.delegate = context.coordinator
        banner.load(Request())

        return banner
    }

    /// No-op. Updates to the SwiftUI view do not require additional changes to the underlying `BannerView`.
    public func updateUIView(_ uiView: BannerView, context: Context) { }
}

public extension BannerAdView {
    /// Adjusts the BannerAdView frame to the predefined size specified by `BannerAdViewSize`.
    func sized(_ size: BannerAdViewSize) -> some View {
        let adSize = size.adSize().size
        return self
            .frame(width: adSize.width,
                   height: adSize.height)
    }
}

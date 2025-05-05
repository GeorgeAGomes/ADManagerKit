import XCTest
import SwiftUI
import GoogleMobileAds
@testable import ADManagerKit

final class ADManagerKitTests: XCTestCase {
    // MARK: - BannerAdViewSize Tests
    func testBannerAdViewSizeSmall() {
        let adSize = BannerAdViewSize.small.adSize()
        XCTAssertEqual(adSize.size.width, AdSizeBanner.size.width)
        XCTAssertEqual(adSize.size.height, AdSizeBanner.size.height)
    }

    func testBannerAdViewSizeMedium() {
        let adSize = BannerAdViewSize.medium.adSize()
        XCTAssertEqual(adSize.size.width, AdSizeLargeBanner.size.width)
        XCTAssertEqual(adSize.size.height, AdSizeLargeBanner.size.height)
    }

    func testBannerAdViewSizeLarge() {
        let adSize = BannerAdViewSize.large.adSize()
        XCTAssertEqual(adSize.size.width, AdSizeMediumRectangle.size.width)
        XCTAssertEqual(adSize.size.height, AdSizeMediumRectangle.size.height)
    }

    // MARK: - BannerAdState Tests
    func testBannerAdStateInitialValues() {
        let state = BannerAdState()
        XCTAssertFalse(state.didLoad)
        XCTAssertNil(state.error)
        XCTAssertFalse(state.didClick)
        XCTAssertFalse(state.didRecordImpression)
        XCTAssertFalse(state.willPresentScreen)
        XCTAssertFalse(state.willDismissScreen)
        XCTAssertFalse(state.didDismissScreen)
        XCTAssertEqual(state.adSize, .zero)
    }

    // MARK: - Coordinator Tests
	@MainActor func testCoordinatorDidReceiveAd() {
        let state = BannerAdState()
        var didLoadCalled = false
        let view = BannerAdView(state: state, didLoad: { didLoadCalled = true })
        let coordinator = view.makeCoordinator()
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        coordinator.bannerViewDidReceiveAd(bannerView)
        XCTAssertTrue(state.didLoad)
        XCTAssertEqual(state.adSize, CGSize(width: 320, height: 50))
        XCTAssertTrue(didLoadCalled)
    }

	@MainActor func testCoordinatorDidFailToReceiveAdWithError() {
        let state = BannerAdState()
        var didErrorCalled = false
        let view = BannerAdView(state: state, didError: { _ in didErrorCalled = true })
        let coordinator = view.makeCoordinator()
        let bannerView = BannerView(adSize: AdSizeBanner)
        let testError = NSError(domain: "Test", code: 1, userInfo: nil)
        coordinator.bannerView(bannerView, didFailToReceiveAdWithError: testError)
        XCTAssertEqual(state.error as NSError?, testError)
        XCTAssertTrue(didErrorCalled)
    }

	@MainActor func testCoordinatorDidRecordClick() {
        let state = BannerAdState()
        var didClickCalled = false
        let view = BannerAdView(state: state, didClick: { didClickCalled = true })
        let coordinator = view.makeCoordinator()
        let bannerView = BannerView(adSize: AdSizeBanner)
        coordinator.bannerViewDidRecordClick(bannerView)
        XCTAssertTrue(state.didClick)
        XCTAssertTrue(didClickCalled)
    }

	@MainActor func testCoordinatorDidRecordImpression() {
        let state = BannerAdState()
        var didRecordImpressionCalled = false
        let view = BannerAdView(state: state, didRecordImpression: { didRecordImpressionCalled = true })
        let coordinator = view.makeCoordinator()
        let bannerView = BannerView(adSize: AdSizeBanner)
        coordinator.bannerViewDidRecordImpression(bannerView)
        XCTAssertTrue(state.didRecordImpression)
        XCTAssertTrue(didRecordImpressionCalled)
    }

	@MainActor func testCoordinatorScreenPresentationAndDismissal() {
        let state = BannerAdState()
        var willPresentCalled = false
        var willDismissCalled = false
        var didDismissCalled = false
        let view = BannerAdView(
            state: state,
            willPresentScreen: { willPresentCalled = true },
            willDismissScreen: { willDismissCalled = true },
            didDismissScreen: { didDismissCalled = true }
        )
        let coordinator = view.makeCoordinator()
        let bannerView = BannerView(adSize: AdSizeBanner)
        coordinator.bannerViewWillPresentScreen(bannerView)
        coordinator.bannerViewWillDismissScreen(bannerView)
        coordinator.bannerViewDidDismissScreen(bannerView)
        XCTAssertTrue(state.willPresentScreen)
        XCTAssertTrue(willPresentCalled)
        XCTAssertTrue(state.willDismissScreen)
        XCTAssertTrue(willDismissCalled)
        XCTAssertTrue(state.didDismissScreen)
        XCTAssertTrue(didDismissCalled)
    }
}

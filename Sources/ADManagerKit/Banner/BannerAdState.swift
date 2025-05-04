//
//  BannerAdState.swift
//  ADManagerKit
//
//  Created by George on 04/05/25.
//
import SwiftUI
import GoogleMobileAds

/// Observable object that tracks the lifecycle state of a banner ad.
/// Publishes events for ad load, errors, clicks, impressions,
/// and presentation/dismissal of full-screen content.
public class BannerAdState: ObservableObject {
    @Published public var didLoad: Bool = false
    @Published public var error: Error? = nil
    @Published public var didClick: Bool = false
    @Published public var didRecordImpression: Bool = false
    @Published public var willPresentScreen: Bool = false
    @Published public var willDismissScreen: Bool = false
    @Published public var didDismissScreen: Bool = false
    @Published public var adSize: CGSize = .zero

    public init() { }
}

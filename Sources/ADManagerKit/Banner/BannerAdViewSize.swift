//
//  BannerAdViewSize.swift
//  ADManagerKit
//
//  Created by George on 04/05/25.
//
import GoogleMobileAds
import Foundation

/// Predefined banner ad sizes mapping to Google Mobile Ads `AdSize` values.
public enum BannerAdViewSize {
    case small
    case medium
    case large
}

public extension BannerAdViewSize {
    /// Returns the Google Mobile Ads `AdSize` corresponding to the banner size.
    func adSize() -> AdSize {
        switch self {
        case .small:
            return AdSizeBanner
        case .medium:
            return AdSizeLargeBanner
        case .large:
            return AdSizeMediumRectangle
        }
    }
}

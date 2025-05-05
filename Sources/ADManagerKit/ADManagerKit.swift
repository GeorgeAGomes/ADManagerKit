//
//  ADManagerKit.swift
//  ADManagerKit
//
//  Created by George on 03/05/25.
//

import Foundation
import GoogleMobileAds

/// A wrapper to simplify configuration and initialization of the Google Mobile Ads SDK.
/// Use `start(completionHandler:)` to set up test device IDs and start the SDK.
public class ADManagerKit {

    public init() { }

    /// Configures test device identifiers and starts the Google Mobile Ads SDK.
    /// - Parameter completionHandler: Optional callback invoked when initialization completes.
    public func start(completionHandler: GADInitializationCompletionHandler?) {
		guard let _ = Bundle.main.infoDictionary?["ADMOB_APP_ID"] as? String else {
			fatalError("ADMOB_APP_ID is missing from Bundle")
		}

//        MobileAds.shared.start(completionHandler: completionHandler)
    }
}


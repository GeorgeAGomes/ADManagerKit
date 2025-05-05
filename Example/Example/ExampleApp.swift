//
//  ExampleApp.swift
//  Example
//
//  Created by George on 03/05/25.
//

import SwiftUI
import ADManagerKit

@main
struct ExampleApp: App {

	init() {
		ADManagerKit().start(completionHandler: nil)
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
		
}

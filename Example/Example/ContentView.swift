//
//  ContentView.swift
//  Example
//
//  Created by George on 03/05/25.
//

import SwiftUI
import ADManagerKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
		.onAppear {
			print(ADManagerKit().hello())
		}
	}
}

#Preview {
    ContentView()
}

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
		TabView {
			DemoAdLayoutView()
				.tabItem {
					Label("Layout", systemImage: "rectangle.grid.2x2")
				}

			BannerSizesView()
				.tabItem {
					Label("Sizes", systemImage: "rectangle.split.3x1")
				}

			BannerStateView()
				.tabItem {
					Label("State", systemImage: "waveform.path.ecg")
				}
		}
	}
}

// MARK: - Demo Ad Layout
struct DemoAdLayoutView: View {
	@Environment(\.scenePhase) private var scenePhase
	@StateObject private var adState = BannerAdState()
	private let margin: CGFloat = 16

	var body: some View {
		GeometryReader { geo in
			let isLandscape = geo.size.width > geo.size.height
			let side = min(geo.size.width, geo.size.height) - margin*2

			Group {
				if isLandscape {
					HStack(spacing: 10) {
						Color.blue
							.frame(width: side, height: side)
							.cornerRadius(8)
						banner
					}
				} else {
					VStack(spacing: 10) {
						Color.blue
							.frame(width: side, height: side)
							.cornerRadius(8)
						banner
					}
				}
			}
			.padding(margin)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		}

	}

	private var banner: some View {
		BannerAdView(state: adState, retryLimit: 3)
			.sized(.medium)
	}
}

// MARK: - Banner Sizes Demo
struct BannerSizesView: View {
	var body: some View {
		ScrollView {
			VStack(spacing: 40) {
				Text("Small Banner")
				BannerAdView(state: BannerAdState()).sized(.small)

				Text("Medium Banner")
				BannerAdView(state: BannerAdState()).sized(.medium)

				Text("Large Banner")
				BannerAdView(state: BannerAdState()).sized(.large)
			}
			.padding()
		}
	}
}

// MARK: - Banner State Demo
struct BannerStateView: View {
	@StateObject private var state = BannerAdState()

	var body: some View {
		VStack(spacing: 12) {
			BannerAdView(state: state, didError: { error in
				print(error)
			})
				.sized(.medium)

			VStack(alignment: .leading, spacing: 8) {
				Text("didLoad: " + (state.didLoad ? "Yes" : "No"))
				Text("error: " + (state.error?.localizedDescription ?? "None"))
				Text("didClick: " + (state.didClick ? "Yes" : "No"))
				Text("didRecordImpression: " + (state.didRecordImpression ? "Yes" : "No"))
				Text("willPresentScreen: " + (state.willPresentScreen ? "Yes" : "No"))
				Text("willDismissScreen: " + (state.willDismissScreen ? "Yes" : "No"))
				Text("didDismissScreen: " + (state.didDismissScreen ? "Yes" : "No"))
			}
			.padding()


			Spacer()
		}
		.padding(.top, 20)    
		.padding(.horizontal)
	}
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

struct DemoAdLayoutView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			DemoAdLayoutView()
				.previewInterfaceOrientation(.portrait)
			DemoAdLayoutView()
				.previewInterfaceOrientation(.landscapeLeft)
		}
	}
}

struct BannerSizesView_Previews: PreviewProvider {
	static var previews: some View {
		BannerSizesView()
	}
}

struct BannerStateView_Previews: PreviewProvider {
	static var previews: some View {
		BannerStateView()
	}
}

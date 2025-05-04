// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ADManagerKit",
	platforms: [
		.iOS(.v18)
	],
	products: [
		.library(
			name: "ADManagerKit",
			targets: ["ADManagerKit"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
			exact: "12.3.0"
		),
	],
	targets: [
		.target(
			name: "ADManagerKit",
			dependencies: [
				.product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
			]
		),
		.testTarget(
			name: "ADManagerKitTests",
			dependencies: ["ADManagerKit"]
		),
	]
)

# SwiftyHawk

![Swift Version](https://img.shields.io/badge/Swift-4.1.2-orange.svg)
![PackageManager](https://img.shields.io/badge/PackageManager-Carthage|SwiftPM-brightgreen.svg?style=flat)
![Platforms](https://img.shields.io/badge/Platforms-iOS|macOS|tvOS|Linux-yellow.svg?style=flat)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/thepeaklab/SwiftyHawk/blob/master/LICENSE)
[![Twitter: @cpageler93](https://img.shields.io/badge/contact-@thepeaklab-009fee.svg?style=flat)](https://twitter.com/thepeaklab)

`SwiftyHawk` is a Swift implementation of [Hawk HTTP authentication scheme](https://github.com/hueniverse/hawk).

## Install

### Carthage

To install `SwiftyHawk` with Carthage, setup Carthage for your project as described in the [Quick Start](https://github.com/Carthage/Carthage#quick-start).

Then add this line to your Cartfile:

```
github "cpageler93/SwiftyHawk" ~> 0.1.4
```

### Swift Package Manager

To install `SwiftyHawk` with [Swift Package Manager](https://swift.org/package-manager) add `SwiftyHawk` to your `Package.swift`

```swift
// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dependencies",
    products: [
        .library(name: "Dependencies", targets: ["Dependencies"]),
    ],
    dependencies: [
        .package(url: "https://github.com/cpageler93/SwiftyHawk", from: "0.1.4")
    ],
    targets: [
        .target(name: "Dependencies", dependencies: ["SwiftyHawk"])
    ]
)

```

## Usage

```swift
// init credentials
let hawkCredentials = Hawk.Credentials(id: "your hawk id", key: "your hawk key", algoritm: .sha256)

// modify each outgoing http request
let headerResult = try? Hawk.Client.header(uri: "baseurl + path",
                                           method: "GET", // POST, PATCH, ...
                                           credentials: hawkCredentials,
                                           nonce: "FOOBAR")
httpRequest.headers["Authorization"] = headerResult?.headerValue ?? ""
```

## Need Help?

Please [submit an issue](https://github.com/cpageler93/SwiftyHawk/issues) on GitHub.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.

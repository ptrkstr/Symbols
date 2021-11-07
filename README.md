<div align="center">
  <img src="Assets/logo/logo.svg" height=150pt/>
  <br>
  <br>
  <div>
      <a href="https://swiftpackageindex.com/ptrkstr/Symbols"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fptrkstr%2FSymbols%2Fbadge%3Ftype%3Dplatforms"/></a>
      <a href="https://swiftpackageindex.com/ptrkstr/Symbols"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fptrkstr%2FSymbols%2Fbadge%3Ftype%3Dswift-versions"/></a>
      <br>
      <a href="https://github.com/apple/swift-package-manager" alt="Symbols on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
      <a href="https://github.com/ptrkstr/Symbols/actions/workflows/swift.yml"><img src="https://github.com/ptrkstr/Symbols/actions/workflows/Update Code Coverage.yml/badge.svg"/></a>
      <a href="https://codecov.io/gh/ptrkstr/Symbols"><img src="https://codecov.io/gh/ptrkstr/Symbols/branch/develop/graph/badge.svg?token=wQR49d2DsA"/></a>
  </div>
    <br>
  <p>
    Swift package for accessing SF Symbols in a type safe manner.
  </p>
</div>


## Features

- 💫 Contains all SF Symbols - 1.0, 2.0, 2.1, 3.0.
- 🏠 Supports all platforms: 📱 iOS, 💻 macOS, 📺 tvOS, ⌚️ watchOS.
- 💯 100% Test Coverage, **every** SF Symbol String extension is tested.
- 👷 Easy to maintain for future SF Symbol releases (see **Maintenance** section).
- ✅ Availability checks i.e. `@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)`.
- 🧵 String extension which means you can use all the existing `UIImage`/`NSImage` initialisers.
- 🔤 Camelcased allowing better code completion

## Usage

```swift
import Symbols
// Swift >= 5.5 
UIImage(systemName: .Symbols.magazineFill) // magazine.fill
NSImage(systemSymbolName: .Symbols.magazineFill, accessibilityDescription: nil) // magazine.fill
// Swift < 5.5
UIImage(systemName: String.Symbols.magazine) // magazine.fill
NSImage(systemSymbolName: String.Symbols.magazine, accessibilityDescription: nil) // magazine.fill
// Leading numbers prefixed with underscore
UIImage(systemName: .Symbols._0CircleFill) // 0.circle.fill
NSImage(systemSymbolName: .Symbols._0CircleFill, accessibilityDescription: nil) // 0.circle.fill
```

## Installation

### SPM

Add the following to your project:

```
https://github.com/ptrkstr/Symbols
```

## Maintenance

All terminal commands must be ran from the directory of this repo.

### Update raw.txt

1. Enter the following into terminal but don't press enter yet
   
    ```
    pbpaste > ./Generator/Sources/Generator/Resources/raw.txt
    ```
    
2. Open SF Symbols

3. Select all, right click, select "Copy X Names"

4. Press enter in terminal

### Update name_availability.plist

```
yes | cp /Applications/SF\ Symbols.app/Contents/Resources/name_availability.plist ./Generator/Sources/Generator/Resources
```

### Generate

```
cd Generator; swift run; cd ..
```

## Aren't there already packages like this?

Yep! But for one reason or another, they didn't fulfil my needs (as of 2021/11/05).

- [lennet/Symbols](https://github.com/lennet/symbols) - No updates since June 2019
- [piknotech/SFSafeSymbols](https://github.com/piknotech/SFSafeSymbols) - Missing support for SF Symbols 3 ([issue since 8 June 2021](https://github.com/piknotech/SFSafeSymbols/issues/75))
- [abadikaka/SFSymbolsFinder](https://github.com/abadikaka/SFSymbolsFinder) - Feature rich package but I wanted something lean
- [jollyjinx/SFSymbolEnum](https://github.com/jollyjinx/SFSymbolEnum) - Swift package index shows build breaking with iOS
- [justMaku/Symbolic](https://github.com/justmaku/symbolic) - No updates since June 2019
- [omeasraf/SFIcons ](https://github.com/omeasraf/SFIcons) - Swift package index shows build breaking with iOS

## TODO

- [ ] Show symbol in code completion


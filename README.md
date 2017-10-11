# TypedUserDefaults

With a strictly typed language like Swift, you'd like to make everything as strictly typed as possible. Here, this is a simple hack for UserDefaults.

## Usage

```swift
import TypedUserDefaults

extension UserDefaults.Key {
    static let foo = UserDefaults.DefaultKey<Int>("foo", default: 1)
    static let bar = UserDefaults.OptionalKey<String>("bar")
}

print("foo == \(UserDefaults.standard[.foo])")
UserDefaults.standard[.foo] += 1

if let bar = UserDefaults.standard[.bar] {
    print("bar == \(bar)")
}

UserDefaults.standard[.bar] = "blah"
```

## Installation

## Carthage
You can install TypedUserDefaults via [Carthage](https://github.com/Carthage/Carthage) by adding the following line to your `Cartfile`:

```
github "nh7a/TypeUserDefaults"
```

## Swift Package Manager
Or maybe via [Swift Package Manager](https://swift.org/package-manager/) by adding the following line to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
  .Package(url: "https://github.com/nh7a/TypedUserDefaults.git", majorVersion: 1)
]
```

## Requirements

* Xcode 9.0
* Swift 4.0

## License

Attributed is free software, and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

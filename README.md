# ConnectionChecker
A network connaction checker on iOS.

## Notices
The current version is working with Xcode Version 7. If you are using different Xcode version, please check out the previous releases.

## Getting Started
### Installation
If you're using Xcode 7 and above, Swifter can be installed by simply dragging the Swifter Xcode project into your own project and adding either the ConnectionChecker as an embedded framework.

### How to use
#### Detect internet connection:
```sh
UIDevice().isConnectedNetwork()
```
#### Detect internet connection in your view controller on Real-Time:
```sh
self.isConnectedNetwork { (isConnectedNetwork) in
    // Do something
    self.logger?.info(isConnectedNetwork) // Show internet is connected or not.
}
```
## Requirements
  - iOS 8 or later
  - Swift 2.0

# SSMP
*Second Screen Mod Protocol* for iOS

**Pre-release**

<p>
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" style="max-height: 300px;" alt="Swift"/></a>
<a href="https://cocoapods.org/pods/SSMP"><img src="https://img.shields.io/cocoapods/v/SSMP.svg" style="max-height: 300px;" alt="PodVersion"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4bc51d.svg?style=flat" style="max-height: 300px;" alt="Carthage Compatible"/></a>
<img src="https://img.shields.io/badge/platform-iOS-lightgrey.svg" style="max-height: 300px;" alt="Platform: iOS">
<br>

## What is SSMP?
SSM or *Second Screen Mode Protocol* is an open source framework for iOS writen in Swift. It makes it easy for apps to take advantage of a second display (through a cable or AirPlay). It has two modes.

**Custom**: Two views on two displays

**Default**: Gives the app into a desktop experience

## Usage
In your AppDelegate, set the view controller the second display should have:
```swift
SSMPApp.default.secondaryViewController = MyAppMainViewController()
```

#### Add for the custom extension type
*Not yet added*
```swift
SSMPApp.default.extensionType = screenType.custom
SSMPApp.default.primaryViewController = MyViewController()
```


#### To Start
```swift
SSMPApp.default.start()
```

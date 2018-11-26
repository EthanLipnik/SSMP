# SSMP
*Second Screen Mode Protocol* for iOS

***This is a Pre-release***

<p>
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" style="max-height: 300px;" alt="Swift"/></a>
<a href="https://cocoapods.org/pods/SSMP"><img src="https://img.shields.io/cocoapods/v/SSMP.svg" style="max-height: 300px;" alt="PodVersion"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4bc51d.svg?style=flat" style="max-height: 300px;" alt="Carthage Compatible"/></a>
<img src="https://img.shields.io/badge/platform-iOS-lightgrey.svg" style="max-height: 300px;" alt="Platform: iOS">
<br>

<p align="center">
<img src="readmeResources/showcase.gif" style="max-height: 4480px;" alt="Example project">
</p>

## What is SSMP?
SSM or *Second Screen Mode Protocol* is an open source framework for iOS writen in Swift that makes it easy for apps to take advantage of a second display (through a cable or AirPlay).

## What does it do?
When your device is connected to a display, the device becomes a mouse and keyboard. The display has the main view. It adds a mouse pointer which does all the normal touch inputs.

## Usage

#### Setup
In your AppDelegate, set the view controller the second display should have:
```swift
SSMPApp.default.viewController = MyAppMainViewController()
```

If you want to set whats on the device's display *(You will lose the mouse pointer)*:
```swift
SSMPApp.default.deviceViewController = MyOtherViewController()
```

#### Options
For SSMPApp:
```swift
verboseLogging: Bool
```
```swift
allowedClickTypes: [clickType]
clickType = .tap, .hardpress
```
```swift
primaryBackgroundColor: UIColor
```

#### To Start
```swift
SSMPApp.default.start()
```

//
//  SSMPApp.swift
//  SSMP
//
//  Created by Ethan Lipnik on 11/21/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

import UIKit

public enum screenType {
	case `default`
	case custom
}

public class SSMPApp: NSObject {
	public static var `default` = SSMPApp()
	
	public var secondaryViewController: UIViewController?
	public var primaryViewController: UIViewController?
	public var extensionType: screenType = .default
	public var primaryBackgroundColor: UIColor = UIColor.gray
	public var isVerboseLogEnabled: Bool = false
	public var secondWindow: UIWindow?
	private var secondScreenView: UIView?
	public var secondScreen: UIScreen?
	
	public func start() {
		
		if isVerboseLogEnabled {
			print("SSMP: Starting SSMP")
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(setupScreen), name: UIScreen.didConnectNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(screenDisconnected), name: UIScreen.didDisconnectNotification, object: nil)
	}
	
	@objc private func setupScreen() {
		
		if isVerboseLogEnabled {
			print("SSMP: Getting app ready for screens")
		}
		if UIScreen.screens.count > 1 {
			
			if isVerboseLogEnabled {
				print("SSMP: A screen is connected")
			}
			
			if secondaryViewController == nil {
				fatalError("SSMP ERROR 1: \"You need to set the secondary view controller before starting the SSMP.\"")
			}
			
			if primaryViewController != nil && extensionType != screenType.custom {
				fatalError("SSMP ERROR 3: \"Primary view controller is set but the extension type is not custom.\"")
			}
			
			secondScreen = UIScreen.screens[1]
			
			secondWindow = UIWindow(frame: secondScreen!.bounds)
			
			if let VC = secondaryViewController {
				let pointer = SSMPMousePointer()
				VC.view.addSubview(pointer)
				pointer.center = secondWindow!.center
				secondWindow?.rootViewController = VC
			} else {
				if isVerboseLogEnabled {
					print("SSMP ERROR 5: secondaryViewController is nil")
				}
			}
			
			secondWindow?.screen = secondScreen!
			
			secondScreenView = UIView(frame: secondWindow!.frame)
			
			secondWindow?.addSubview(secondScreenView!)
			secondScreenView?.isHidden = true
			
			secondWindow?.isHidden = false
			
			let window = UIApplication.shared.windows[1]
			if extensionType == screenType.default {
				window.rootViewController = SSMPDefaultExtensionViewController()
			} else if let VC = primaryViewController {
				window.rootViewController = VC
			}
		}
	}
	
	@objc private func screenDisconnected() {
		
		let window = UIApplication.shared.windows[0]
		if let VC = secondaryViewController {
			window.rootViewController = VC
		} else {
			fatalError("SSMP ERROR 4: Failed to get secondaryViewController")
		}
	}
}

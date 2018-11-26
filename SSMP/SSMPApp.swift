//
//  SSMPApp.swift
//  SSMP
//
//  Created by Ethan Lipnik on 11/21/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

import UIKit

public enum clickType {
	case tap
	case hardpress
}

public class SSMPApp: NSObject {
	public static var `default` = SSMPApp()
	
	public var viewController: UIViewController?
	public var deviceViewContreoller: UIViewController?
	public var primaryBackgroundColor: UIColor = UIColor.gray
	public var verboseLogging: Bool = false
	public var secondWindow: UIWindow?
	private var secondScreenView: UIView?
	public var secondScreen: UIScreen?
	public var allowedClickTypes = [clickType.tap, clickType.hardpress]
	
	public func start() {
		
		if verboseLogging {
			print("SSMP: \"Starting\"")
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(setupScreen), name: UIScreen.didConnectNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(screenDisconnected), name: UIScreen.didDisconnectNotification, object: nil)
	}
	
	public func stop() {
		if verboseLogging {
			print("SSMP: \"Stopped\"")
			print("SSMP: \"No longer looking for displays\"")
		}
		NotificationCenter.default.removeObserver(self, name: UIScreen.didConnectNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIScreen.didDisconnectNotification, object: nil)
		
		if UIScreen.screens.count > 1 {
			screenDisconnected()
		}
	}
	
	@objc private func setupScreen() {
		
		if verboseLogging {
			print("SSMP: \"Started\"")
			print("SSMP: \"Getting app ready for screens\"")
		}
		if UIScreen.screens.count > 1 {
			
			if verboseLogging {
				print("SSMP: \"A screen is connected\"")
			}
			
			if viewController == nil {
				fatalError("SSMP ERROR 1: \"You need to set the view controller before starting the SSMP.\"")
			}
			
			secondScreen = UIScreen.screens[1]
			
			secondWindow = UIWindow(frame: secondScreen!.bounds)
			
			if let VC = viewController {
				
				if deviceViewContreoller == nil {
					let pointer = SSMPMousePointer()
					
					var hasPointer = false
					
					for subview in VC.view.subviews {
						if subview is SSMPMousePointer {
							hasPointer = true
						}
					}
					if hasPointer == false {
						VC.view.addSubview(pointer)
					}
					pointer.center = secondWindow!.center
				}
				secondWindow?.rootViewController = VC
			} else {
				if verboseLogging {
					print("SSMP ERROR 5: \"secondaryViewController is nil\"")
				}
			}
			
			secondWindow?.screen = secondScreen!
			
			secondScreenView = UIView(frame: secondWindow!.frame)
			
			secondWindow?.addSubview(secondScreenView!)
			secondScreenView?.isHidden = true
			
			secondWindow?.isHidden = false
			
			let window = UIApplication.shared.windows[1]
			if deviceViewContreoller == nil {
				window.rootViewController = SSMPDefaultExtensionViewController()
			} else if let VC = deviceViewContreoller {
				window.rootViewController = VC
			}
		}
	}
	
	@objc private func screenDisconnected() {
		
		if let window = UIApplication.shared.windows.first {
			if let VC = viewController {
				window.rootViewController = VC
			} else {
				fatalError("SSMP ERROR 4: \"Failed to get secondaryViewController\"")
			}
		}
	}
}

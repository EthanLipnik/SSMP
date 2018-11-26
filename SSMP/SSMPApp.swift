//
//  SSMPApp.swift
//  SSMP
//
//  Created by Ethan Lipnik on 11/21/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

// Frameworks
import UIKit

// Establish the click types
public enum clickType {
	case tap
	case hardpress
}

// SSMPApp class
public class SSMPApp: NSObject {
	public static var `default` = SSMPApp()
	
	// Variables
	public var viewController: UIViewController?
	public var deviceViewController: UIViewController?
	public var primaryBackgroundColor: UIColor = UIColor.gray
	public var verboseLogging: Bool = false
	public var secondWindow: UIWindow?
	private var secondScreenView: UIView?
	public var secondScreen: UIScreen?
	public var allowedClickTypes = [clickType.tap, clickType.hardpress]
	
	// Start function
	public func start() {
		
		// If verbose logging is enabled, log "starting"
		if verboseLogging {
			print("SSMP: \"Starting\"")
		}
		
		// Start listening for screen updates
		NotificationCenter.default.addObserver(self, selector: #selector(setupScreen), name: UIScreen.didConnectNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(screenDisconnected), name: UIScreen.didDisconnectNotification, object: nil)
	}
	
	// Stop function
	public func stop() {
		
		// If verbose logging is enabled, log "stopped"
		if verboseLogging {
			print("SSMP: \"Stopped\"")
			print("SSMP: \"No longer looking for displays\"")
		}
		
		// Stop listening for screen updates
		NotificationCenter.default.removeObserver(self, name: UIScreen.didConnectNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIScreen.didDisconnectNotification, object: nil)
		
		// Disconnect any connected screens
		if UIScreen.screens.count > 1 {
			screenDisconnected()
		}
	}
	
	// Setup screen function
	@objc private func setupScreen() {
		
		// If verbose logging is enabled, log "started"
		if verboseLogging {
			print("SSMP: \"Started\"")
			print("SSMP: \"Getting app ready for screens\"")
		}
		
		// If there are more screens, setup screens
		if UIScreen.screens.count > 1 {
			
			// If verbose logging is enabled, log "a screen is connected"
			if verboseLogging {
				print("SSMP: \"A screen is connected\"")
			}
			
			// If view controller is nil, show error
			guard let VC = viewController else { fatalError("SSMP ERROR 1: \"You need to set the view controller before starting the SSMP.\"") }
			
			// Set the second screen
			secondScreen = UIScreen.screens[1]
			
			// Set the second window
			secondWindow = UIWindow(frame: secondScreen!.bounds)
			
			// If the device's view isn't overrided, then initialize the pointer
			if deviceViewController == nil {
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
			
			// Set second window's root view controller
			secondWindow?.rootViewController = VC
			
			// Set second window's screen
			secondWindow?.screen = secondScreen!
			
			// Initalize second screen view
			secondScreenView = UIView(frame: secondWindow!.frame)
			
			// Add second screen view to second window
			secondWindow?.addSubview(secondScreenView!)
			secondScreenView?.isHidden = true
			
			// Make sure second window is not hidden
			secondWindow?.isHidden = false
			
			// If device's view controller is nil, initialize the default view controller. Else, set it to the device's view controller
			let window = UIApplication.shared.windows[1]
			if deviceViewController == nil {
				window.rootViewController = SSMPDefaultExtensionViewController()
			} else if let VC = deviceViewController {
				window.rootViewController = VC
			}
		}
	}
	
	// Screen Disconnected
	@objc private func screenDisconnected() {
		
		// If device's window is not nil, reset the device's view
		if let window = UIApplication.shared.windows.first {
			if let VC = viewController {
				window.rootViewController = VC
			} else {
				fatalError("SSMP ERROR 4: \"Failed to get secondaryViewController\"")
			}
		}
	}
}

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

// MARK: SSMP Class
public class SSMPApp: NSObject {
	public static var `default` = SSMPApp()
	
	
	// MARK: Variables
	public var viewController: UIViewController?
	public var deviceViewController: UIViewController?
	public var primaryBackgroundColor: UIColor = UIColor.gray
	public var verboseLogging: Bool = false
	public var secondWindow: UIWindow?
	private var secondScreenView: UIView?
	public var secondScreen: UIScreen?
	public var allowedClickTypes = [clickType.tap, clickType.hardpress]
	private var fallbackViewController: UIViewController?
}

// MARK: Functions
extension SSMPApp {
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
}

// MARK: Selectors
extension SSMPApp {
	
	// Setup screen function
	@objc private func setupScreen() {
		
		// Set fallback view controller
		fallbackViewController = UIApplication.topViewController()
		
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
				UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
					window.rootViewController = SSMPDefaultExtensionViewController()
				}, completion: { completed in
				})
			} else if let VC = deviceViewController {
				window.rootViewController = VC
			}
		}
	}
	
	// Screen Disconnected
	@objc private func screenDisconnected() {
		
		// If device's window is not nil, reset the device's view
		if let window = UIApplication.shared.keyWindow {
			if let VC = fallbackViewController {
				UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
					window.rootViewController = VC
				}, completion: { completed in
				})
			} else {
				fatalError("SSMP ERROR 4: \"Failed to get fallback view controller\"")
			}
		}
	}
}

extension UIApplication {
	class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		if let navigationController = controller as? UINavigationController {
			return topViewController(controller: navigationController.visibleViewController)
		}
		if let tabController = controller as? UITabBarController {
			if let selected = tabController.selectedViewController {
				return topViewController(controller: selected)
			}
		}
		if let presented = controller?.presentedViewController {
			return topViewController(controller: presented)
		}
		return controller
	}
}

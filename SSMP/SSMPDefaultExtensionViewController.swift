//
//  SSMPDefaultExtensionViewController.swift
//  SSMP
//
//  Created by Ethan Lipnik on 11/22/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

// Frameworks
import UIKit
import AVFoundation
import WebKit

// MARK: SSMPDefaultExtensionViewController Class
public class SSMPDefaultExtensionViewController: UIViewController {
	
	// MARK: Variables
	public var textView: SSMPTextView?
}

// MARK: Default Functions
extension SSMPDefaultExtensionViewController {
	
	// View loaded
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		// Set background color
		self.view.backgroundColor = SSMPApp.default.primaryBackgroundColor
		
		// Gestures
		/// Move mouse gesture
		let mouseMoveGesture = SSMPPanGestureRecognizer(target: self, action: #selector(self.moveMousePan(_:)))
		mouseMoveGesture.maximumNumberOfTouches = 1
		self.view.addGestureRecognizer(mouseMoveGesture)
		
		/// Scroll view gesture
		let scrollMouseGesture = SSMPPanGestureRecognizer(target: self, action: #selector(self.scrollMousePan(_:)))
		scrollMouseGesture.maximumNumberOfTouches = 2
		scrollMouseGesture.minimumNumberOfTouches = 2
		self.view.addGestureRecognizer(scrollMouseGesture)
		
		/// If allowed clicks contains "tap", then add primary mouse click tap
		if SSMPApp.default.allowedClickTypes.contains(.tap) {
			let primaryMouseClickGesture = SSMPTapGestureRecognizer(target: self, action: #selector(self.primaryMouseClickedTap(_:)))
			primaryMouseClickGesture.numberOfTapsRequired = 1
			self.view.addGestureRecognizer(primaryMouseClickGesture)
		}
		
		/// If allowed clicks contains "hardpress", then add primary mouse click hardpress
		if SSMPApp.default.allowedClickTypes.contains(.hardpress) {
			let primaryMouseClick3DGesture = SSMPDeepPressGestureRecognizer(target: self, action: #selector(self.primaryMouseClickedPressed(_:)), threshold: 0.225)
			primaryMouseClick3DGesture.vibrateOnDeepPress = true
			self.view.addGestureRecognizer(primaryMouseClick3DGesture)
		}
	}
}

// MARK: Functions
extension SSMPDefaultExtensionViewController {
	
	// Click function
	func click() {
		
		// Play click sound
		let systemSoundID: SystemSoundID = 1104
		AudioServicesPlaySystemSound(systemSoundID)
		
		var subviews = [UIView]()
		var webView: WKWebView?
		var mousePointer: SSMPMousePointer!
		
		// Get mouse pointer and remove all non-interactable subviews
		for subview in SSMPApp.default.viewController!.view.subviews {
			if subview is SSMPMousePointer {
				mousePointer = subview as? SSMPMousePointer
			}
			if subview is SSMPMousePointer || subview.isUserInteractionEnabled == false {
				
				subviews.append(subview)
				subview.removeFromSuperview()
			} else if subview is WKWebView {
				
				webView = subview as? WKWebView
			}
		}
		
		// Get view user clicked
		var newView: UIView?
		if webView == nil {
			newView = SSMPApp.default.viewController!.view.hitTest(mousePointer!.center, with: nil)
		} else {
			newView = webView
		}
		
		if let button = newView as? UIButton { // If subview is button
			button.sendActions(for: .touchUpInside)
		} else if let tableView = newView as? UITableView { // If subview is tableview
			let index = tableView.indexPathForRow(at: mousePointer!.center)
			tableView.selectRow(at: index, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
		} else if let collectionView = newView as? UICollectionView { // If subview is collectionview
			let index = collectionView.indexPathForItem(at: mousePointer!.center)
			collectionView.selectItem(at: index, animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
		} else if let textview = newView as? UITextView { // If subview is text view
			
			if textView == nil {
				textView = SSMPTextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
				textView?.alpha = 0
				textView?.isUserInteractionEnabled = false
				textView?.delegate = self
				textView?.autocapitalizationType = .none
				textView?.autocorrectionType = .no
				self.view.addSubview(textView!)
			}
			
			textView?.tiedTextView = textview
			
			textView?.text = " "
			textView?.becomeFirstResponder()
			
			
			textview.becomeFirstResponder()
			
			textView?.inputAccessoryView = textview.inputAccessoryView
		} else if let collectionview = newView as? UICollectionView {
			let index = collectionview.indexPathForItem(at: mousePointer!.center)
			collectionview.selectItem(at: index, animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
		} else if newView is WKWebView {
			
		} else {
			if let gestureRecognizers = newView?.gestureRecognizers { // Get gestures from view
				for gesture in gestureRecognizers {
					if let gesture = gesture as? SSMPTapGestureRecognizer {
						if gesture.numberOfTapsRequired == 1 {
							gesture.perform(gesture.function)
						}
					}
				}
			}
		}
		
		// Add back the subviews
		for subview in subviews {
			SSMPApp.default.viewController!.view.addSubview(subview)
		}
	}
}

// MARK: Selectors
extension SSMPDefaultExtensionViewController {
	
	// Move mouse gesture
	@objc func moveMousePan(_ gesture: UIPanGestureRecognizer) {
		
		// Get all the subviews in the external display
		for subview in SSMPApp.default.viewController!.view.subviews {
			
			// Get the pointer
			if let pointer = subview as? SSMPMousePointer {
				
				// If only one finger is used, move pointer
				if gesture.numberOfTouches == 1 {
					if pointer.frame.origin.x < SSMPApp.default.secondScreen!.bounds.width - (gesture.velocity(in: self.view).x / 10) && pointer.frame.origin.x > SSMPApp.default.secondScreen!.bounds.origin.x - (gesture.velocity(in: self.view).x / 10) {
						pointer.frame.origin.x += gesture.velocity(in: self.view).x / 10
					}
					if pointer.frame.origin.y < SSMPApp.default.secondScreen!.bounds.height - (gesture.velocity(in: self.view).y / 10) && pointer.frame.origin.y > SSMPApp.default.secondScreen!.bounds.origin.y - (gesture.velocity(in: self.view).y / 10) {
						pointer.frame.origin.y += gesture.velocity(in: self.view).y / 10
					}
				}
			}
		}
	}
	
	// Scroll view gesture
	@objc func scrollMousePan(_ gesture: UIPanGestureRecognizer) {
		
		// Get mouse pointer
		var mousePointer: SSMPMousePointer?
		for subview in SSMPApp.default.viewController!.view.subviews {
			if let pointer = subview as? SSMPMousePointer {
				mousePointer = pointer
			}
		}
		
		// If pointer is not nil
		if let pointer = mousePointer {
			
			// If only two fingers are used, scroll
			if gesture.numberOfTouches == 2 {
				
				// Get all subviews in external display
				for subview in SSMPApp.default.viewController!.view.subviews {
					
					// Get subview that mouse pointer in front of
					if subview.frame.contains(pointer.center) {
						
						// Scroll
						UIView.animate(withDuration: 0.2) {
							if let scrollView = subview as? UIScrollView {
								let width: CGFloat = scrollView.frame.size.width
								let height: CGFloat = scrollView.frame.size.height
								let newPosition: CGFloat = scrollView.contentOffset.y + gesture.velocity(in: self.view).y * 2
								let toVisible: CGRect = CGRect(x: 0, y: newPosition, width: width, height: height)
								
								scrollView.scrollRectToVisible(toVisible, animated: true)
							} else if let tableView = subview as? UITableView {
								tableView.contentOffset.y += gesture.velocity(in: self.view).y / 20
							} else if let collectionView = subview as? UICollectionView {
								collectionView.contentOffset.y += gesture.velocity(in: self.view).y / 20
							} else if let webView = subview as? UIWebView {
								let width: CGFloat = webView.frame.size.width
								let height: CGFloat = webView.frame.size.height
								let newPosition: CGFloat = webView.scrollView.contentOffset.y + gesture.velocity(in: self.view).y * 2
								let toVisible: CGRect = CGRect(x: 0, y: newPosition, width: width, height: height)
								
								webView.scrollView.scrollRectToVisible(toVisible, animated: true)
							} else if let webView = subview as? WKWebView {
								
								let width: CGFloat = webView.frame.size.width
								let height: CGFloat = webView.frame.size.height
								let newPosition: CGFloat = webView.scrollView.contentOffset.y + gesture.velocity(in: self.view).y * 2
								let toVisible: CGRect = CGRect(x: 0, y: newPosition, width: width, height: height)
								
								webView.scrollView.scrollRectToVisible(toVisible, animated: true)
							}
						}
					}
				}
			}
		}
	}
	
	// Primary mouse tap
	@objc func primaryMouseClickedTap(_ gesture: UITapGestureRecognizer) {
		click()
	}
	
	// Primary mouse 3D touch
	@objc func primaryMouseClickedPressed(_ gesture: SSMPDeepPressGestureRecognizer) {
		
		if gesture.state == .began {
			click()
		}
	}
}

// MARK: Text View Delegate
extension SSMPDefaultExtensionViewController: UITextViewDelegate {
	
	// Text view should change text
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		self.textView?.tiedTextView?.replace(self.textView!.tiedTextView!.selectedTextRange!, withText: text)
		self.textView?.text = " "
		return true
	}
	
	// Text view did change text
	public func textViewDidChange(_ textView: UITextView) {
		if self.textView?.text == "" {
			self.textView?.tiedTextView?.deleteBackward()
			self.textView?.text = " "
		}
	}
	
	// Text view did end editing
	public func textViewDidEndEditing(_ textView: UITextView) {
		self.textView?.inputAccessoryView = nil
		SSMPApp.default.viewController!.view.endEditing(true)
	}
}

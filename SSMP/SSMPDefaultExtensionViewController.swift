//
//  SSMPDefaultExtensionViewController.swift
//  SSMP
//
//  Created by Ethan Lipnik on 11/22/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

import UIKit

public class SSMPDefaultExtensionViewController: UIViewController {
	
	public var textView: SSMPTextView?
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = SSMPApp.default.primaryBackgroundColor
		
		let mouseMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveMousePan(_:)))
		mouseMoveGesture.maximumNumberOfTouches = 1
		self.view.addGestureRecognizer(mouseMoveGesture)
		
		let scrollMouseGesture = UIPanGestureRecognizer(target: self, action: #selector(self.scrollMousePan(_:)))
		scrollMouseGesture.maximumNumberOfTouches = 2
		scrollMouseGesture.minimumNumberOfTouches = 2
		self.view.addGestureRecognizer(scrollMouseGesture)
		
		let primaryMouseClickGesture = UITapGestureRecognizer(target: self, action: #selector(self.primaryMouseClickedTap(_:)))
		primaryMouseClickGesture.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(primaryMouseClickGesture)
	}
	
	@objc func moveMousePan(_ gesture: UIPanGestureRecognizer) {
		for subview in SSMPApp.default.secondaryViewController!.view.subviews {
			if let pointer = subview as? SSMPMousePointer {
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
	
	@objc func scrollMousePan(_ gesture: UIPanGestureRecognizer) {
		var mousePointer: SSMPMousePointer?
		for subview in SSMPApp.default.secondaryViewController!.view.subviews {
			if let pointer = subview as? SSMPMousePointer {
				mousePointer = pointer
			}
		}
		
		if let pointer = mousePointer {
			if gesture.numberOfTouches == 2 {
				for subview in SSMPApp.default.secondaryViewController!.view.subviews {
					if subview.frame.contains(pointer.center) {
						UIView.animate(withDuration: 0.2) {
							if let scrollView = subview as? UIScrollView {
								let width: CGFloat = scrollView.frame.size.width
								let height: CGFloat = scrollView.frame.size.height
								let newPosition: CGFloat = scrollView.contentOffset.y + gesture.velocity(in: self.view).y * 2
								let toVisible: CGRect = CGRect(x: 0, y: newPosition, width: width, height: height)
								
								scrollView.scrollRectToVisible(toVisible, animated: true)
							} else if let tableView = subview as? UITableView {
								tableView.contentOffset.y += gesture.velocity(in: self.view).y / 20
							}
						}
					}
				}
			}
		}
	}
	
	@objc func primaryMouseClickedTap(_ gesture: UITapGestureRecognizer) {
		
		var subviews = [UIView]()
		var mousePointer: SSMPMousePointer!
		
		for subview in SSMPApp.default.secondaryViewController!.view.subviews {
			if subview is SSMPMousePointer {
				mousePointer = subview as? SSMPMousePointer
			}
			if subview is SSMPMousePointer || subview.isUserInteractionEnabled == false {
				subviews.append(subview)
				subview.removeFromSuperview()
			}
		}
		
		let newView = SSMPApp.default.secondaryViewController!.view.hitTest(mousePointer!.center, with: nil)
		if let button = newView as? UIButton {
			button.sendActions(for: .touchUpInside)
		} else if let tableView = newView as? UITableView {
			let index = tableView.indexPathForRow(at: mousePointer!.center)
			tableView.selectRow(at: index, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
		} else if let textview = newView as? UITextView {
			
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
		} else {
			if let gestureRecognizers = newView?.gestureRecognizers {
				for gesture in gestureRecognizers {
					if let gesture = gesture as? UITapGestureRecognizer {
						if gesture.numberOfTapsRequired == 1 {
							gesture.touchesBegan(Set<UITouch>(), with: UIEvent())
						}
					}
				}
			}
		}
		
		for subview in subviews {
			SSMPApp.default.secondaryViewController!.view.addSubview(subview)
		}
		
	}
}

extension SSMPDefaultExtensionViewController: UITextViewDelegate {
	
	public func textViewDidChange(_ textView: UITextView) {
		func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			self.textView?.tiedTextView?.replace(self.textView!.tiedTextView!.selectedTextRange!, withText: text)
			self.textView?.text = " "
			return true
		}
		
		func textViewDidChange(_ textView: UITextView) {
			if self.textView?.text == "" {
				self.textView?.tiedTextView?.deleteBackward()
				self.textView?.text = " "
			}
		}
		
		func textViewDidEndEditing(_ textView: UITextView) {
			self.textView?.inputAccessoryView = nil
			SSMPApp.default.secondaryViewController!.view.endEditing(true)
		}
	}
}

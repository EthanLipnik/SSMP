//
//  ViewController.swift
//  SSMP Example
//
//  Created by Ethan Lipnik on 11/23/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

import UIKit
// import SSMP not required in this file

class ViewController: UIViewController {
	
	// Elements
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Add gesture to hide the keyboard
		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
		self.view.addGestureRecognizer(gesture)
	}
	
	// When button clicked, change its title
	@IBAction func clickMeBtn_Click(_ sender: UIButton) {
		
		sender.setTitle("Clicked!", for: .normal)
	}
	
	// Hide keyboard selector
	@objc func hideKeyboard() {
		self.view.endEditing(true)
	}
}

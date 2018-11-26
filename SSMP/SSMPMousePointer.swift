//
//  UIMousePointer.swift
//  SSMP
//
//  Created by Ethan Lipnik on 11/22/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

// Frameworks
import UIKit

// MARK: SSMPMousePointer Class
public class SSMPMousePointer: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.frame = frame
		
		setUp()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setUp()
	}
}

// MARK: Functions
extension SSMPMousePointer {
	
	// Setup function
	private func setUp() {
		self.backgroundColor = UIColor.black
		self.layer.borderColor = UIColor.white.cgColor
		self.layer.borderWidth = 1
		self.layer.cornerRadius = 5
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowRadius = 6
		self.layer.shadowOpacity = 1
		
		self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
	}
}

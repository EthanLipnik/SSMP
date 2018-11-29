//
//  webViewController.swift
//  SSMP Example
//
//  Created by Ethan Lipnik on 11/29/18.
//  Copyright © 2018 Fetch. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController {
	@IBOutlet weak var webView: WKWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		webView.load(URLRequest(url: URL(string: "https://apple.com/")!))
		webView.isUserInteractionEnabled = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

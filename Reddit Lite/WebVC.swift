//
//  WebVC.swift
//  Reddit Lite
//
//  Created by Joseph Pereniguez on 24/11/2018.
//  Copyright © 2018 Joseph Pereniguez. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebVC: UIViewController {
    
    //MARK: Outlets

    @IBOutlet weak var postView: WKWebView!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post, let url = URL(string: post.url) {
            postView.load(URLRequest(url: url))
            self.title = post.title
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

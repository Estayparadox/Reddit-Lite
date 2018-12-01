//
//  MainViewController.swift
//  Reddit Lite
//
//  Created by Joseph Pereniguez on 23/11/2018.
//  Copyright © 2018 Joseph Pereniguez. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
        }
    }

}


//
//  LoginViewController.swift
//  Reddit Lite
//
//  Created by Joseph Pereniguez on 23/11/2018.
//  Copyright © 2018 Joseph Pereniguez. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions

    @IBAction func handleLogin(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("User has logged in successfully.")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}

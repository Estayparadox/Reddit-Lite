//
//  SignupViewController.swift
//  Reddit Lite
//
//  Created by Joseph Pereniguez on 23/11/2018.
//  Copyright © 2018 Joseph Pereniguez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }
    
    // MARK: Actions
    
    @IBAction func handleSignup(_ sender: UIButton) {
        
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
     
        // define the database
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        Auth.auth().createUserAndRetrieveData(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                guard let uid = result?.user.uid else { return }
                self.ref.child("users/\(uid)").setValue(userData) // send the data to the Firebase database
                print("User has been correctly created.")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        /* Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                
                print("User has been correctly created.")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed successfully.")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                print("Error: \(String(describing: error?.localizedDescription)).")
            }
        } */
    }
    
}

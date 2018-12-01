//
//  ProfileViewController.swift
//  Reddit Lite
//
//  Created by Joseph Pereniguez on 25/11/2018.
//  Copyright © 2018 Joseph Pereniguez. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let storageRef = FirebaseStorage.Storage().reference()
    
    // MARK: Outlets
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var appUser: AppUser? {
        didSet {
            guard let userName = appUser?.name else { return }
            guard let userEmail = appUser?.email else { return }
            
            navigationItem.title = "Profile"
            viewTitle.text = "Hello " + userName + " !"
            nameLabel.text = userName
            emailLabel.text = userEmail
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        fetchUserInfo()
    }
    
    // MARK: Actions
    
    @IBAction func uploadImageButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func handleLogout(_ sender: UIButton) {
        
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
        print("User has correctly logged out.")
        
    }
    
    @IBAction func handleSave(_ sender: UIButton) {
        
        print("Saving changes.")
        saveChanges()
        
    }
    
    // MARK: Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImageFromPicker
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveChanges() {
        let imageName = NSUUID().uuidString
        let storedImage = storageRef.child("profileImage").child(imageName)
        
        if let uploadData = self.profileImage.image!.pngData() {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["pic": urlText], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                return
                            }
                        })
                    }
                })
            })
        }
        
    }
    
    func fetchUserInfo() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? NSDictionary else { return }
            guard let userName = data["name"] as? String else { return }
            guard let userEmail = data["email"] as? String else { return }
            
            // self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            self.profileImage.clipsToBounds = true
            
            self.appUser = AppUser(name: userName, uid: userId, email: userEmail)
            
            if let dict = snapshot.value as? [String: AnyObject] {
                if let profileImageUrl = dict["pic"] as? String {
                    let url = URL(string: profileImageUrl)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            self.profileImage.image = UIImage(data: data!)
                        }
                    }).resume()
                }
            }
        }
    }
    
}

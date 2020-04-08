//
//  LoginViewController.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 4/6/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController{
    @IBOutlet weak var username: UITextView!
    
    @IBOutlet weak var password: UITextView!
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }
    
    @IBAction func ValidateLogin(_ sender: UIButton) {
        
        print(self.username.text, self.password.text)
        
        // Check if valid username and password
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == self.username.text {
                        let password = document.data()["password"] as? String
                        print(password)
                        if  password == self.password.text {
                            print("\(document.data())")
                        }
                    }
                }
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cur_user = self.username.text
        print(appDelegate.cur_user)
        
    }
    
}

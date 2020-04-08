//
//  SignupViewController.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 4/6/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class SignupViewController: UIViewController{
    @IBOutlet weak var username: UITextView!
    @IBOutlet weak var password: UITextView!
    @IBOutlet weak var retryPassword: UITextView!
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }
    
    @IBAction func signUp(_ sender: Any) {
        // check that username doesn't already exist
        self.validateUsername(username: self.username.text) { (isValid) in
            if !isValid {
                print("not valid")
                // clear username field
                self.username.text = ""
                // alert that they need to pick a new username
                let alert = UIAlertController(title: "Username is taken", message: "Try new username", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("valid")
                // check that passwords match too
                if self.password.text == self.retryPassword.text {
                    print("password match")
                    // set cur_user for this session
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.cur_user = self.username.text
                    // add data to database
                    self.addUser(username: self.username.text, password: self.password.text)
                    // go to mapView
                    let mapView =  self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                    self.present(mapView, animated: true, completion: nil)
                } else {
                    // clear password fields
                    self.password.text = ""
                    self.retryPassword.text = ""
                    // send alert message for not matching passwords
                    print("printing alert")
                    let alert = UIAlertController(title: "Retried password doesn't match password", message: "Re-type passwords", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func validateUsername(username: String, completion: @escaping (Bool) -> Void) {
        print("validating username")
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("ID \(document.documentID)")
                    if document.documentID == username {
                        completion(false)
                        return
                    }
                }
            }
        }
        completion(true)
    };
    
    func addUser(username: String, password: String) {
        let db = Firestore.firestore();
        let data = ["password": password, "collection": ["planted": [], "plants": []]] as [String: Any]
        db.collection("users").document(username).setData(data);
        let collection = db.collection("users").document(username).collection("collection");
        collection.document("planted");
        collection.document("plants");
    }
}

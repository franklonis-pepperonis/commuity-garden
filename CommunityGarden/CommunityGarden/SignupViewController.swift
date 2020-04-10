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

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypedPassword: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }
    
    @IBAction func signUp(_ sender: Any) {
        // check that username doesn't already exist
        let username = self.username.text as! String
        self.validateUsername(username: username) { (isValid) in
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
                if self.password.text == self.retypedPassword.text {
                    print("password match")
                    // set cur_user for this session
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.cur_user = self.username.text
                    // add data to database
                    let password = self.password.text as! String
                    let firstName = self.firstName.text as! String
                    let lastName = self.lastName.text as! String
                    self.addUser(username: username, password: password, firstName: firstName, lastName: lastName)
                    // go to mapView
                    let mapView =  self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                    self.present(mapView, animated: true, completion: nil)
                } else {
                    // clear password fields
                    self.password.text = ""
                    self.retypedPassword.text = ""
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
            completion(true)
            return
        }
    };
    
    func addUser(username: String, password: String, firstName: String, lastName: String) {
        let db = Firestore.firestore();
        let data = ["first_name": firstName, "last_name": lastName, "password": password, "coins": 50, "water_available": 100] as [String: Any]
        db.collection("users").document(username).setData(data);
    }

}

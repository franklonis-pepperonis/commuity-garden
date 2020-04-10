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
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }
    
    @IBAction func ValidateLogin(_ sender: UIButton) {
        // Check if valid username and password
        let username = self.username.text as! String
        let password = self.password.text as! String
        self.validateUser(username: username, password: password) { (isValid) in
            if isValid {
                // set cur_user efor this session
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.cur_user = self.username.text
                // it exists, continue to map view
                let mapView =  self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.present(mapView, animated: true, completion: nil)
            }
            if !isValid {
                // clear username and password fiels
                self.username.text = ""
                self.password.text = ""
                // user does not exist, send alert
                let alert = UIAlertController(title: "Incorrect Username or Password", message: "Retry log in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: self.signUpHandler))
                self.present(alert, animated: true, completion: nil)
            }
        }
    };
    
    func signUpHandler(action: UIAlertAction) {
        let signUpView =  self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(signUpView, animated: true, completion: nil)
    };
    
    
    func validateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                    // check for valid username
                    if document.documentID == self.username.text {
                        let password = document.data()["password"] as? String
                        // check for correct password
                        if  password == self.password.text {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                }
                completion(false)
                return
            }
        }
    };
    
}

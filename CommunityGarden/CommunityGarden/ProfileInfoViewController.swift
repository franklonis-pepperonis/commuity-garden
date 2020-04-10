//
//  ProfileInfoViewController.swift
//  CommunityGarden
//
//  Created by Nikhil Bhansali on 3/21/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//
import Foundation
import UIKit
import FirebaseFirestore

class ProfileInfoViewController: UIViewController{
    
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var water: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var collection: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cur_user = appDelegate.cur_user as! String
        
        // pull user data from database
        let db = Firestore.firestore()
        db.collection("users").document(cur_user).getDocument() { (document, err) in
            // get data
            let data = document!.data() as! [String: Any]
            // get and set name on profile info page
            let first_name = data["first_name"] as! String
            let last_name = data["last_name"] as! String
            let fullname = first_name + " " + last_name
            self.fullName.text = fullname
            // get and set username
            let username = document!.documentID as! String
            self.username.text = "@" + username
            // get and set collection #
            // get and set planted plants #
            
            // set header bar
            let coins = data["coins"] as! Int
            self.coins.text = String(coins)
            let water = data["water_available"] as! Int
            self.water.text = String(water) + "%"
        }
        
        print(db.collection("users").document(cur_user).collection("plants"))
               
        
    }
}

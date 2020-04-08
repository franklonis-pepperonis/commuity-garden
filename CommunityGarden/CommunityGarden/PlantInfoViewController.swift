//
//  PlantInfoViewController.swift
//  CommunityGarden
//
//  Created by Jordan De Jesus on 3/20/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PlantInfoViewController: UIViewController {

    @IBOutlet weak var PlantImage: UIImageView!
    
    @IBOutlet weak var PlantName: UITextView!
    
    @IBOutlet weak var PlantDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlantImage.layer.cornerRadius = 20
        self.PlantName.layer.cornerRadius = 20
        self.PlantDescription.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        
        // Set up firebase
        let db = Firestore.firestore()
        db.collection("Plant Info").document("Cactus").getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()
                print("\(data!["Description"])")
                self.PlantDescription.text = "\(data!["Description"])"
            }
        }

    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

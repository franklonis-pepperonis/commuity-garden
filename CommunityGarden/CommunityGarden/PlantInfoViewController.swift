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
    
    
    var plantInfo: PlantInfo = PlantInfo(amt: 0, name: "")
    
    /* override func viewWillAppear(_ animated: Bool) {
        print(plantInfo)
        if let image = UIImage(named: self.plantInfo.img!){
            self.PlantImage.image = image
        }
        self.PlantName.text = self.plantInfo.name
        self.PlantDescription.text = self.plantInfo.description
        super.viewWillAppear(animated)
    } */
    
    override func viewDidLoad() {
        self.PlantImage.layer.cornerRadius = 20
        self.PlantName.layer.cornerRadius = 20
        self.PlantDescription.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        
        // Set up firebase
        if let image = UIImage(named: self.plantInfo.img!){
            self.PlantImage.image = image
        }
        self.PlantName.text = self.plantInfo.name
        self.PlantDescription.text = self.plantInfo.description
        super.viewDidLoad()
    
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

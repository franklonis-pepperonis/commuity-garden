//
//  PlantPlotView.swift
//  CommunityGarden
//
//  Created by Nikhil Bhansali on 4/9/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import AVFoundation
import CoreLocation
import Firebase
import FirebaseFirestore

class PlantPlotViewController: UIViewController
{

    var scene = SCNScene()
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var PlantName: UILabel!
    @IBOutlet weak var PlantOwner: UILabel!
    @IBOutlet weak var PlantHealth: UILabel!
    
    @IBOutlet weak var WaterButton: UIButton!
    @IBOutlet weak var ShovelButton: UIButton!
    
    // To setup nav bar
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var water: UILabel!
    
    
    // should eventually hold plant info to display
    var plant_id : String?
    var plant_ar : String?
    var garden_id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To setup nav bar
        setupNavBar()
        
        let db = Firestore.firestore()
    
        // eventually change "garden1" to whatever garden we're in
        db.collection("plant IDs").document(plant_id!).getDocument() { (Plant, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.PlantName.text = Plant!.data()!["name"] as? String
                self.PlantOwner.text = Plant!.data()!["owner"] as? String
                let health = Plant!.data()!["health"]
                self.PlantHealth.text = "\(health!)"
                print(Plant!.data()!)
                
                
                self.plant_ar = "art.scnassets/" + "\(self.PlantName.text!)" + ".dae"
               
               
                // change to image pulled from database from plant.image
                let scene = SCNScene(named: self.plant_ar!)
               
                // Add camera node
                let cameraNode = SCNNode()
                cameraNode.camera = SCNCamera()
                cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
                scene?.rootNode.addChildNode(cameraNode)
               
               
                // Add custom lighting
                /*
                 let lightNode = SCNNode()
                 lightNode.light = SCNLight()
                 lightNode.light?.type = .omni
                 lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
                 scene?.rootNode.addChildNode(lightNode)
               
                 let ambientLightNode = SCNNode()
                 ambientLightNode.light = SCNLight()
                 ambientLightNode.light?.type = .ambient
                 ambientLightNode.light?.color = UIColor.darkGray
                 scene?.rootNode.addChildNode(ambientLightNode)
                 */
        
                // If you don't want to fix manually the lights
                self.sceneView.autoenablesDefaultLighting = true
               
                // Allow user to manipulate camera
                self.sceneView.allowsCameraControl = true
               
                // Show FPS logs and timming
                // sceneView.showsStatistics = true
               
                // Set background color
                self.sceneView.backgroundColor = UIColor.white
               
                // Allow user translate image
                self.sceneView.cameraControlConfiguration.allowsTranslation = false
               
                // Set scene settings
                self.sceneView.scene = scene
                
            }
        }
    }
    @IBAction func waterButton(button: UIButton)
    {
        //need user, plant user, plant id, plant health
        let db = Firestore.firestore();
        //update health of plant, if its not 100 already
        if Int(self.PlantHealth.text!)! >= 100 {
            let alert = UIAlertController(title: "Plant not watered!", message: "This plant is already at full health!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var successful_planting = false
        
        db.collection("plant IDs").getDocuments() { (allPlants, err) in
            if let err = err {
                print("Error getting plants: \(err)")
            } else {
                // find plant that matches the current plant
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let userId = delegate.cur_user!
                for plant in allPlants!.documents {
                    if plant.documentID as String == self.plant_id! {
                        //find owner of plant
                        let owner = plant.data()["owner"] as! String
                        if owner == userId {
                            return
                        }
                        //query user db to find the correct owner
                        db.collection("users").getDocuments() { (users, err) in
                            if let err = err {
                                print("Error updating user leaves: \(err)")
                            } else {
                                for user in users!.documents {
                                    if user.documentID as String == owner {
                                        //add 10 coins to owner of plants coins
                                        var userCoins = user.data()["coins"] as! Int
                                        userCoins += 10
                                        //update plant onwer coins in the database
                                        db.collection("users").document(owner).setData(["coins": userCoins], merge: true)
                                        break
                                    }
                                }
                            }
                        }
                        break
                    }
                }
            }
        }
        
        db.collection("users").getDocuments() { (users, err) in
            if let err = err {
                print("Error updating user leaves: \(err)")
            } else {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let userId = delegate.cur_user!
                for user in users!.documents {
                    if user.documentID as String == userId {
                        //add 10 coins to owner of plants coins
                        //var userCoins = user.data()["coins"] as! Int
                        //update plant onwer coins in the database
                        //db.collection("users").document(userId).setData(["coins": userCoins], merge: true)
                        var userWater = user.data()["water_available"] as! Int
                        if(userWater <= 9){
                            let alert = UIAlertController(title: "Plant not watered", message: "You don't have enough water", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        userWater -= 10
                        db.collection("users").document(userId).setData(["water_available": userWater], merge: true)
                        successful_planting = true
                        
                        var newHealth = (Int(self.PlantHealth.text!)! + 10)
                        if (newHealth >= 100){
                            newHealth = 100
                        }
                        
                        db.collection("plant IDs").document(self.plant_id!).setData(["health": newHealth], merge:true);
                        self.PlantHealth.text = String(newHealth)
                        //update user water and coins
                        //query plant id DB
                        
                        let alert = UIAlertController(title: "Plant watered!", message: "-10 water available. +10 plant health!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        break
                    }
                }
            }
        }
    
        
        
        while (successful_planting == true){
            
        
            var newHealth = (Int(self.PlantHealth.text!)! + 10)
            if (newHealth >= 100){
                newHealth = 100
            }
            db.collection("plant IDs").document(plant_id!).setData(["health": newHealth], merge:true);
            self.PlantHealth.text = String(newHealth)
            //update user water and coins
            //query plant id DB
            
            let alert = UIAlertController(title: "Plant watered!", message: "-10 water available. +10 plant health!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
        setupNavBar()
        
        
    }
    
    @IBAction func shovelButton(button: UIButton)
    {
        
        // remove plant from living plants of user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cur_user = appDelegate.cur_user as! String
        let db = Firestore.firestore()
        db.collection("users").document(cur_user).collection("planted").document(self.plant_id!).delete()
                        
        // remove plant from plants database
        db.collection("plant IDs").document(self.plant_id!).delete()
        
        // remove plant_id from garden database
        db.collection("gardens").document(self.garden_id!).collection("plants").document(self.plant_id!).delete()
        
        let alert = UIAlertController(title: "You just removed a plant!", message: "It is now gone from the garden.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        appDelegate.ar_view?.deleteGarden()
        appDelegate.ar_view?.renderGarden()
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    // To setup nav bar
    func setupNavBar(){
        let db = Firestore.firestore()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        db.collection("users").getDocuments() { (users, err) in
            if let err = err {
                print("Error loading users: \(err)")
            } else {
                let userId = delegate.cur_user!
                for user in users!.documents {
                    if user.documentID as String == userId {
                        self.coins.text = String(user.data()["coins"] as! Int)
                        self.water.text = String(user.data()["water_available"] as! Int)  + "%"
                    }
                }
            }
        }
        db.collection("plant IDs").document(plant_id!).getDocument() { (Plant, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let health = Plant!.data()!["health"]
                self.PlantHealth.text = "\(health!)"
            }
        }
    }
}


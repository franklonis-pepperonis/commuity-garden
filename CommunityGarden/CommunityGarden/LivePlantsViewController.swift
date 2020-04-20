//
//  LivePlantsViewController.swift
//  CommunityGarden
//
//  Created by Grae Abbott on 3/20/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "LiveCell"

class LivePlantsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // no ordered maps in swift, using keys array to order keys
    var keys: [String] = []
    
    var plant2Info: [String: PlantInfo] = [:]
    
    let imageSize = CGSize(width: 160.0, height: 160.0)
    
    struct PlantInfo{
        var img: String? // name of image
        var name: String? // name of plant
        var garden: String?
        var health: Double?
    }
    
    
    @IBOutlet weak var LiveCollectionView: UICollectionView!
    
    // To setup nav bar
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var water: UILabel!
    
    
    
    override func viewDidLoad(){
        getUserPlantedData(self.LiveCollectionView)
        super.viewDidLoad();
        // To setup nav bar
        setupNavBar()
        self.LiveCollectionView.backgroundColor = UIColor(red: 216/255.0, green: 248/255.0, blue: 149/255.0, alpha: 1)
    }
    
    func getPlantInfo(_ collectionView: UICollectionView){
        let db = Firestore.firestore()
        _ = db.collection("plant IDs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("********\n")
                print("Error getting documents: \(err)")
                print("********\n")
            } else{
                for document in querySnapshot!.documents{
                    let plantName = document.documentID
                    if self.plant2Info[plantName] != nil {
                        let name = document.data()["name"] as! String
                        var img = name
                        var c = String(img.remove(at: img.startIndex))
                        c = c.lowercased()
                        img = "shop_" + c + img
                        let health = document.data()["health"] as! Double
                        let garden = document.data()["garden"] as! String
                        self.plant2Info[plantName]?.img = img
                        self.plant2Info[plantName]?.garden = garden
                        self.plant2Info[plantName]?.health = health
                        self.plant2Info[plantName]?.name = name
                    }
                }
                collectionView.reloadData()
            }
        }
    }
    
    func getUserPlantedData(_ collectionView: UICollectionView){
        var plant: String = ""
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let userId = delegate.cur_user!
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("planted").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\n")
                print("Error getting documents: \(err)")
                print("\n")
            } else {
                for document in querySnapshot!.documents{
                    // print(document.data())
                    // amt = document.data()["quantity"] as! Int
                    plant = document.documentID
                    self.plant2Info[plant] = PlantInfo()
                    self.keys.append(plant)
                }
                self.getPlantInfo(collectionView)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LiveCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        // get image file from db
        let plantId = self.keys[indexPath.item]
        let plantInfo = self.plant2Info[plantId]
        
        let image = UIImage(named: plantInfo?.img ?? "") ?? nil
        if(image != nil){
            let height = (cell.myButton.frame.size.height - imageSize.height) / 2
            let width = (cell.myButton.frame.size.width - imageSize.width) / 2
            cell.myButton.setImage(image, for: UIControl.State.normal)
            cell.myButton.frame = CGRect(x: 0, y: 0, width: self.imageSize.width * 0.85, height: self.imageSize.width * 0.85)
        }else{
            cell.myButton.setTitle("image error", for: UIControl.State.normal)
        }
        cell.myButton.tag = indexPath.item
        let action = #selector(self.buttonAction)
        cell.myButton.addTarget(self, action: action, for: .touchUpInside)
        // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func buttonAction(_ sender: UIButton!){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlantPlotViewController") as? PlantPlotViewController
        let key = self.keys[sender.tag]
        let plantInfo = self.plant2Info[key]
        viewController?.garden_id = plantInfo?.garden
        viewController?.plant_id = key
        self.present(viewController!, animated: true, completion: nil)
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
    }
    
    // Fuck around with this 2ma
    /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
    let viewController = storyboard.instantiateViewController(withIdentifier: "PlantPlotViewController") as? PlantPlotViewController
    
    viewController?.garden_id = self.gardenID
    viewController?.plant_id = plant.plant_id
    self.present(viewController!, animated: true, completion: nil) */
}

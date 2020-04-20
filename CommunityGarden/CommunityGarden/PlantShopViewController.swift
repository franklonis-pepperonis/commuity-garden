//
//  PlantShopViewController.swift
//  CommunityGarden
//
//  Created by Olivia Sun on 3/21/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


private let reuseIdentifier = "ShopCell"

class PlantShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var num_items = 0
    var images = [] as! [String]
    var costs = [] as! [String]
    var names = [] as! [String]
    var makeTransaction = true as! Bool
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // To setup nav bar
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var water: UILabel!
    
    override func viewDidLoad() {
        self.getNumImages(collectionView) { (numImages, Images, Costs, Names) in
            self.num_items = numImages
            self.images = Images
            self.costs = Costs
            self.names = Names
            self.collectionView.reloadData()
        }
        
        // To setup nav bar
        setupNavBar()
        self.collectionView.backgroundColor = UIColor(red: 179/255.0, green: 218/255.0, blue: 237/255.0, alpha: 1)
        super.viewDidLoad();
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.num_items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
   {
//        let height = view.frame.size.height
//        let width = view.frame.size.width
    return CGSize(width: self.collectionView.frame.width * 0.42, height: self.collectionView.frame.height * 0.46)
   }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PlantShopViewCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell

        let image = UIImage(named: self.images[indexPath.item]) as UIImage?
//        let image : UIImage = UIImage(named:img_str)!
        cell.shopImage.setBackgroundImage(image, for: [])
        cell.shopImage.tag = indexPath.item
        cell.shopImage.addTarget(self, action: #selector(buyPlant), for: .touchUpInside)
        cell.cost.text = self.costs[indexPath.item]
        cell.cost.textColor = UIColor.black
        cell.backgroundColor = UIColor.clear // make cell more visible in our example project
        return cell
        
    }
    
    @objc func buyPlant(_ sender: UIButton) {
        // get the current user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cur_user = appDelegate.cur_user as! String
        // check the cost
        self.checkCost(cur_user: cur_user, index: sender.tag) { (canBuy) in
            if canBuy {
                // add plant to collection
                self.addPlant(cur_user: cur_user, index: sender.tag)
                // send an alert
                let alert = UIAlertController(title: "You just bought a plant!", message: "It is now in your collection.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.map_view?.setupNavBar()
                delegate.live_plants_view?.setupNavBar()
                delegate.your_collection_view?.setupNavBar()
                self.setupNavBar()
                
            }
        }
    }
    
    func addPlant(cur_user: String, index: Int) {
        //go through all the plants to see if you just need to increment quantity
        let db = Firestore.firestore()
        let ref_plants = db.collection("users").document(cur_user).collection("plants")
        ref_plants.getDocuments() { (querySnapshot, err) in
            let plant_name = self.names[index]
            var done = false
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == plant_name {
                        var quantity = document.data()["quantity"] as! Int
                        quantity = quantity + 1
                        // incrememnt quantity of plant
                        db.collection("users").document(cur_user).collection("plants").document(document.documentID).updateData(["quantity": quantity])
                        done = true
                    }
                }
            }
            // add plant because it doesn't exists in plants
            if done == false {
               db.collection("users").document(cur_user).collection("plants").document(plant_name).setData(["quantity": 1])
            }
        }
    }
    
    func checkCost(cur_user: String, index: Int, completion: @escaping (Bool) -> Void ) {
        let db = Firestore.firestore()
           // check if cost works
           let ref_cur = db.collection("users").document(cur_user)
           ref_cur.getDocument() { (querySnapshot, err) in
               let data = querySnapshot!.data() as! [String: Any]
               let currency = data["coins"] as! Int
               let cost = Int(self.costs[index]) as! Int
               print(currency,cost)
               if currency >= cost {
                   let coins = currency - cost
                   db.collection("users").document(cur_user).updateData(["coins": coins])
                   completion(true)
               } else {
                   let alert = UIAlertController(title: "You don't have enough money to buy that plant!", message: "Try to buy a different plant.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                   completion(false)
               }
           }
    }
    
    func getNumImages(_ collectionView: UICollectionView, completion: @escaping (Int, [String], [String], [String]) -> Void) {
        let db = Firestore.firestore()
        db.collection("plant info").getDocuments() { (querySnapshot, err) in
            var num = 0
            var images = [] as! [String]
            var costs = [] as! [String]
            var names = [] as! [String]
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    num = num + 1
                    let img = document.data()["img"] as! String
                    images.append(img)
                    let cost = document.data()["cost"] as! Int
                    costs.append(String(cost))
                    let name = document.documentID
                    names.append(name)
                }
                completion(num, images, costs, names)
            }
        }
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
}


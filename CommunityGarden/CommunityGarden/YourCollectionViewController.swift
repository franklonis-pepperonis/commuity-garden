//
//  YourCollectionViewController.swift
//  CommunityGarden
//
//  Created by Grae Abbott on 3/20/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "ColCell"

class YourCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // no ordered maps in swift, using keys array to order keys
    var keys: [String] = []
    var plant2Info: [String: PlantInfo] = [:]
    var i: Int = 0
    let imageSize = CGSize(width: 160.0, height: 160.0)
    
    
    @IBOutlet weak var YourCollectionView: UICollectionView!
    
    // To setup nav bar
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var water: UILabel!
    
    
    
    override func viewDidLoad(){
        getUserCollectionData(self.YourCollectionView)
        super.viewDidLoad();
        
        // To setup nav bar
        self.setupNavBar()
        self.YourCollectionView.backgroundColor = UIColor(red: 216/255.0, green: 248/255.0, blue: 149/255.0, alpha: 1)
    }
    
    func getPlantImages(_ collectionView: UICollectionView){
        let db = Firestore.firestore()
        let docRef = db.collection("plant info").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\n")
                print("Error getting documents: \(err)")
                print("\n")
            } else{
                for document in querySnapshot!.documents{
                    let plantName = document.documentID
                    if self.plant2Info[plantName] != nil {
                        self.plant2Info[plantName]?.img = document.data()["img"] as! String
                        self.plant2Info[plantName]?.description = document.data()["description"] as! String
                    }
                }
                collectionView.reloadData()
            }
        }
    }
    
    func getUserCollectionData(_ collectionView: UICollectionView){
        var plant: String = ""
        var amt: Int = 0
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let userId = delegate.cur_user!
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("plants").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\n")
                print("Error getting documents: \(err)")
                print("\n")
            } else {
                for document in querySnapshot!.documents{
                    // print(document.data())
                    amt = document.data()["quantity"] as! Int
                    plant = document.documentID
                    self.plant2Info[plant] = PlantInfo(amt: amt, name: plant)
                    self.keys.append(plant)
                }
                self.getPlantImages(collectionView)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        // get image file from db
        let plantName = self.keys[indexPath.item]
        let plantInfo = self.plant2Info[plantName]
        
        let image = UIImage(named: plantInfo?.img ?? "") ?? nil
        if(image != nil){
            let height = (cell.myButton.frame.size.height - imageSize.height) / 2
            let width = (cell.myButton.frame.size.width - imageSize.width) / 2
            cell.myButton.setImage(image, for: UIControl.State.normal)
            cell.myButton.frame = CGRect(x: 0, y: 0, width: self.imageSize.width * 0.85, height: self.imageSize.width * 0.85)
        }else{
            cell.myButton.setTitle("image error", for: UIControl.State.normal)
        }
        let amt = plantInfo?.amt ?? 0
        cell.amount.text = String(amt)
        cell.myButton.tag = indexPath.item
        let action = #selector(self.buttonAction)
        cell.myButton.addTarget(self, action: action, for: .touchUpInside)
        cell.backgroundColor = UIColor.clear // make cell more visible in our example project
        cell.amount.textColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PlantInfoViewController{
            let key = keys[self.i]
            let plantInfo = self.plant2Info[key]!
            dest.plantInfo = plantInfo
        }
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        self.i = sender.tag
        self.performSegue(withIdentifier: "yourCol2Info", sender: nil)
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

/* extension YourCollectionViewController: CollectionViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        // You have the cell where the touch event happend, you can get the indexPath like the below
        print("******HERE******")
        print(self.collectionView.indexPath(for: cell)!.item)
        self.i = self.collectionView.indexPath(for: cell)!.item
        // Call `performSegue`
        self.performSegue(withIdentifier: "yourCol2Info", sender: nil)
    }
} */

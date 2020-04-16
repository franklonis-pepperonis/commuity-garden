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
    
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    // no ordered maps in swift, using keys array to order keys
    var keys: [String] = []
    
    var plant2Info: [String: PlantInfo] = [:]
    
    let imageSize = CGSize(width: 160.0, height: 160.0)
    
    struct PlantInfo{
        var amt: Int
        var img: String?
        var name: String
    }
    
    
    @IBOutlet weak var YourCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad(){
        getUserCollectionData(self.YourCollectionView)
        super.viewDidLoad();
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
        
        let image = UIImage(named: "shop_cactus")// plantInfo?.img ?? "") ?? nil
        if(image != nil){
            let height = (cell.myButton.frame.size.height - imageSize.height) / 2
            let width = (cell.myButton.frame.size.width - imageSize.width) / 2
            cell.myButton.setImage(UIImage(named: "shop_cactus"), for: UIControl.State.normal)
            cell.myButton.frame = CGRect(x: 0, y: 0, width: self.imageSize.width * 0.85, height: self.imageSize.width * 0.85)
        }else{
            cell.myButton.setTitle("fuck", for: UIControl.State.normal)
        }
        let amt = plantInfo?.amt ?? 0
        cell.amount.text = String(amt)
        // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

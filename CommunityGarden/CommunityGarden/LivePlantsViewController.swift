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

class LivePlantsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let userId = delegate.cur_user!
        let db = Firestore.firestore()
        var num = 0
        db.collection("users").document(userId).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()
                let planted = data!["Planted"] as! [Any]
                num = planted.count
                print(planted) // FOR DEBUGGING
                print(num) // FOR DEBUGGING
            }
        }
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LiveCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.liveLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        return cell
    }
}

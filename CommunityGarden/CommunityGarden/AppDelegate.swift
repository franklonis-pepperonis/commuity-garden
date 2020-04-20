//
//  AppDelegate.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 2/10/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?;
    var cur_user: String?;
    var ar_view: ARViewController?;
    var map_view: MapViewController?;
    var live_plants_view: LivePlantsViewController?;
    var your_collection_view: YourCollectionViewController?;
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        self.updateDatabase()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func updateDatabase(){
        let db = Firestore.firestore()
        
        let docRef = db.collection("update").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\n")
                print("Error getting documents: \(err)")
                print("\n")
            } else{
                for document in querySnapshot!.documents{

                    let last_timestamp = document.data()["last_update"] as? Timestamp
                    let then = last_timestamp?.dateValue()
                    let now: NSDate! = NSDate()
                    
                    let calendar = Calendar.current

                    let date1 = calendar.startOfDay(for: then!)
                    let date2 = calendar.startOfDay(for: (now! as Date))

                    let components = calendar.dateComponents([.day], from: date1, to: date2)
                    
                    if(components.day! > 0){
                        // if days have passed, update needs update value to true
                        db.collection("update").document("needs_update").setData(["last_update" : now!], merge: true)
                        
                        
                    //}
                    //if ((document.data()["value"]) as? Bool == true){
                        //iterate through all plants and decrement by value
                        db.collection("plant IDs").getDocuments() { (allPlants, err) in
                            if let err = err {
                                print("Error getting plants: \(err)")
                            } else {
                                for plant in allPlants!.documents {
                                    var curHealth = plant.data()["health"] as! Int
                                    curHealth -= 10
                                    var plant_id = plant.documentID as String
                                    if (curHealth <= 0){
                                        let plant_owner = plant.data()["owner"] as! String
                                        let plant_garden = plant.data()["garden"] as! String
                                        //remove plant
                                        db.collection("users").document(plant_owner).collection("planted").document(plant_id).delete()
                                                        
                                        // remove plant from plants database
                                        db.collection("plant IDs").document(plant_id).delete()
                                        
                                        // remove plant_id from garden database
                                        db.collection("gardens").document(plant_garden).collection("plants").document(plant_id).delete()
                                    } else{
                                        db.collection("plant IDs").document(plant_id).setData(["health": curHealth], merge: true)
                                    }
                                }
                            }
                        }
                        
                        
                        //iterate through all users and set water level to 100
                        //iterate through all users and give them 5 coins
                        db.collection("users").getDocuments() { (users, err) in
                            if let err = err {
                                print("Error loading users: \(err)")
                            } else {
                                for user in users!.documents {
                                    let user_id = user.documentID
                                    let userWater = 100
                                    var curCoinCount = user.data()["coins"] as! Int
                                    curCoinCount += 5
                                    db.collection("users").document(user_id).setData(["water_available": userWater], merge: true)
                                    db.collection("users").document(user_id).setData(["coins": curCoinCount], merge: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



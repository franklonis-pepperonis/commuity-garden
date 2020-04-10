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
    
    
    // should eventually hold plant info to display
    var plant_id : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
    
        // eventually change "garden1" to whatever garden we're in
        db.collection("plant IDs").document(plant_id!).getDocument() { (Plant, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.PlantName.text = Plant!.data()!["name"] as? String
                self.PlantOwner.text = Plant!.data()!["owner"] as? String
                self.PlantHealth.text = Plant!.data()!["health"] as? String
            }
        }
        
        
        
        // change to image pulled from database from plant.image
        let scene = SCNScene(named: "art.scnassets/\(String(describing: self.PlantName.text)).dae")
        
        // Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
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
        sceneView.autoenablesDefaultLighting = true
        
        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true
        
        // Show FPS logs and timming
        // sceneView.showsStatistics = true
        
        // Set background color
        sceneView.backgroundColor = UIColor.white
        
        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false
        
        // Set scene settings
        sceneView.scene = scene
        
        
    }
    
}



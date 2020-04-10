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

class PlantPlotViewController: UIViewController
{

    var scene = SCNScene()
    
    @IBOutlet weak var sceneView: SCNView!
  
    // should eventually hold plant info to display
    var plant_id : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change to image pulled from database from plant.image
        let scene = SCNScene(named: "art.scnassets/ElmTree.dae")
        
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



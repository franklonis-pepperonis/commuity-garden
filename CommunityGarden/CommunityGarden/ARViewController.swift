//
//  ViewController.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 2/10/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation
import CoreLocation
import ARKit
import Firebase
import FirebaseFirestore


class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var sceneController = PlantScene()
    

    var didInitializeScene: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        if let scene = sceneController.scene {
            // Set the scene to the view
            sceneView.scene = scene
        }
        
        renderGarden()
    
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.didTapScreen))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func renderGarden(){
        
        // query database for list of plants, and XY coordinates
        
        
        let db = Firestore.firestore()

        db.collection("gardens").document("garden1").getDocument() { (AllPlants, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // iterate through and populate call add plant on each one
                // for now add 6 plants to tis garden
                var position = SCNVector3(2, -1, 2)
                self.sceneController.addPlant(position: position, ar_image: "art.scnassets/ElmTree.dae")
                position = SCNVector3(2, -1, 4)
                self.sceneController.addPlant(position: position, ar_image: "art.scnassets/Bamboo.dae")
                position = SCNVector3(3, -1, 2)
                self.sceneController.addPlant(position: position, ar_image: "art.scnassets/Saguaro.dae")
                position = SCNVector3(2, -1, 6)
                self.sceneController.addPlant(position: position, ar_image: "art.scnassets/PalmTree.dae")
                position = SCNVector3(-2, -1, 0)
                self.sceneController.addPlant(position: position, ar_image: "art.scnassets/Bamboo.dae")
                
            }
        }
        

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @objc func didTapScreen(recognizer: UITapGestureRecognizer) {
        if didInitializeScene {
            if (sceneView.session.currentFrame?.camera) != nil {
                //var translation = matrix_identity_float4x4
                //translation.columns.3.z = -1.0
                //let transform = camera.transform * translation
                let position = SCNVector3(2, 0, 2)
                sceneController.addPlant(position: position, ar_image: "art.scnassets/Bamboo.dae")
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if !didInitializeScene {
            if sceneView.session.currentFrame?.camera != nil {
                didInitializeScene = true
            }
       }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


struct PlantScene {
    
    var scene: SCNScene?
    
    init() {
        scene = self.initializeScene()
    }
    
    func initializeScene() -> SCNScene? {
        let scene = SCNScene()
        
        setDefaults(scene: scene)
        
        return scene
    }
    
    func setDefaults(scene: SCNScene) {
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLight.LightType.ambient
        ambientLightNode.light?.color = UIColor(white: 0.8, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Create a directional light with an angle to provide a more interesting look
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.color = UIColor(white: 0.8, alpha: 1.0)
        let directionalNode = SCNNode()
        directionalNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-40), GLKMathDegreesToRadians(0), GLKMathDegreesToRadians(0))
        directionalNode.light = directionalLight
        scene.rootNode.addChildNode(directionalNode)
    }
    
    func addPlant(position: SCNVector3, ar_image: String) {
        
        guard let scene = self.scene else { return }
        
        let containerNode = SCNNode()
        
        let nodesInFile = SCNNode.allNodes(from: ar_image)
        nodesInFile.forEach { (node) in
            containerNode.addChildNode(node)
        }
        containerNode.position = position
        scene.rootNode.addChildNode(containerNode)
    }
}

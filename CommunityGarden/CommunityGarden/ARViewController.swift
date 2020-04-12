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

        // eventually change "garden1" to whatever garden we're in
        db.collection("gardens").document("garden1").collection("plants").getDocuments() { (AllPlants, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for plant in AllPlants!.documents {
                    let ar_img = plant.data()["ar img"] as? String
                    let plant_id = plant.data()["plant id"] as? String
                    
                    let x = Double(plant.data()["x coord"] as! String)!
                    let z = Double(plant.data()["z coord"] as! String)!
                    
                    let position = SCNVector3(x, 0, z)
                    self.sceneController.addPlant(position: position, ar_image: ar_img!, id: plant_id!)
                }
                
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
                let tapLocation = recognizer.location(in: sceneView)
                let hitTestResults = sceneView.hitTest(tapLocation)
                if let node = hitTestResults.first?.node, let scene = sceneController.scene, let plant = node.topmost(until: scene.rootNode) as? PlantObject {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      
                    let viewController = storyboard.instantiateViewController(withIdentifier: "PlantPlotViewController") as? PlantPlotViewController
            
                    
                    viewController?.plant_id = plant.plant_id
                    self.present(viewController!, animated: true, completion: nil)
                
                }
            }
            else {
                
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
    
    func addPlant(position: SCNVector3, ar_image: String, id: String) {
        
        guard let scene = self.scene else { return }
        
        let plant = PlantObject(from: ar_image, id: id)
        plant.position = position
        scene.rootNode.addChildNode(plant)
    }
}


class PlantObject: SCNNode {
    
    var plant_id : String
    
    init(from file: String, id : String) {
        self.plant_id = id
        super.init()
        let nodesInFile = SCNNode.allNodes(from: file)
        nodesInFile.forEach { (node) in
            self.addChildNode(node)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

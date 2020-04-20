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
    @IBOutlet weak var PlantButton: UIButton!
    var sceneController = PlantScene()
    

    var didInitializeScene: Bool = false
    var gardenID: String?
    var PlantToPlant: String?
    
    
        
    
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

        db.collection("gardens").document(self.gardenID!).collection("plants").getDocuments() { (AllPlants, err) in
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
    
    func deleteGarden(){
        self.sceneController.removePlants()
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
        self.viewDidLoad()
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
            if let camera = (sceneView.session.currentFrame?.camera) {
                let tapLocation = recognizer.location(in: sceneView)
                let hitTestResults = sceneView.hitTest(tapLocation)
                
                
                   
                
                if let node = hitTestResults.first?.node, let scene = sceneController.scene, let plant = node.topmost(until: scene.rootNode) as? PlantObject {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      
                    let viewController = storyboard.instantiateViewController(withIdentifier: "PlantPlotViewController") as? PlantPlotViewController
                    
                    viewController?.garden_id = self.gardenID
                    viewController?.plant_id = plant.plant_id
                    self.present(viewController!, animated: true, completion: nil)
                }
                else {
                    if PlantToPlant != nil{
                          
                        var translation = matrix_identity_float4x4
                        translation.columns.3.z = -10.0
                        translation.columns.3.y = -1.0
                        let transform = camera.transform * translation
                        let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                   
                        let plant = PlantToPlant!
                        // assign plant id
                        let plant_id = String(Int.random(in: 0 ..< 100000))
                        let plant_ar = "art.scnassets/" + plant + ".dae"
                        // TODO
                        
                        // plant this plant where tapped
                        
                        
                        // get the current user
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let cur_user = appDelegate.cur_user as! String
                        let db = Firestore.firestore()
                        
                        //decrement the quantity of the plant to be planted from this users collection
                        let ref = db.collection("users").document(cur_user).collection("plants")
                        ref.getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    if document.documentID == plant {
                                        var quantity = document.data()["quantity"] as! Int
                                        
                                        // remove from user collection if only one left
                                        if (quantity == 1){
                                            db.collection("users").document(cur_user).collection("plants").document(document.documentID).delete()
                                        } else{
                                            quantity = quantity - 1
                                            // decrement quantity of plant
                                            db.collection("users").document(cur_user).collection("plants").document(document.documentID).updateData(["quantity": quantity])
                                        }
                                       
                                    }
                                }
                            }
                        }
                        
                        //add this new plant to the plant IDs table with full health
                        db.collection("plant IDs").document(plant_id).setData(
                            ["garden": self.gardenID!, "health": 100, "name":plant, "owner":cur_user],
                            merge:true
                        );
                        
                        //add this new planted plant to the users living plants collection view
                        db.collection("users").document(cur_user).collection("planted").document(plant_id).setData(["exists": true], merge:true);
                        
                        //add this planted plant to the garden database so it always renders in the same spot.
                        db.collection("gardens").document(self.gardenID!).collection("plants").document(plant_id).setData(
                            ["ar img": plant_ar, "plant id": plant_id, "x coord": String(Int(position.x)), "z coord": String(Int(position.z))]
                        );
                        
                        
                        self.sceneController.addPlant(position: position, ar_image: plant_ar, id: String(plant_id))
                        
                        PlantToPlant = nil
                    }
                    
                }
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
    func removePlants(){
        guard let scene = self.scene else { return }
        
        scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
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

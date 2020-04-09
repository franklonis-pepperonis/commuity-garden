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

class ARViewController: UIViewController {
    var scene = SCNScene()
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var leftIndicator: UILabel!
    @IBOutlet weak var rightIndicator: UILabel!
    
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    
    var locationManager = CLLocationManager()
    var heading: Double = 0
    var userLocation = CLLocation()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 3, height: 3, length: 3, chamferRadius: 0))
    
    //temporary just one plant for now
    var plant: ARItem!
    
    func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
      var error: NSError?
      var captureSession: AVCaptureSession?
        
      let backVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        
      if backVideoDevice != nil {
        var videoInput: AVCaptureDeviceInput!
        do {
          videoInput = try AVCaptureDeviceInput(device: backVideoDevice!)
        } catch let error1 as NSError {
          error = error1
          videoInput = nil
        }
          

        if error == nil {
          captureSession = AVCaptureSession()

          if captureSession!.canAddInput(videoInput) {
            captureSession!.addInput(videoInput)
          } else {
            error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
          }
        } else {
          error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
        }
      } else {
        error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
      }
        
      return (session: captureSession, error: error)
    }
    
    
    func loadCamera() {
        
      let captureSessionResult = createCaptureSession()
       
      guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
        print("Error creating capture session.")
        return
      }

      self.cameraSession = session
        
      let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession!)
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(cameraLayer, at: 0)
        self.cameraLayer = cameraLayer
      }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            loadCamera()
            self.cameraSession?.startRunning()
            
            self.locationManager.delegate = self
        
            self.locationManager.startUpdatingHeading()

            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
            scene.rootNode.addChildNode(cameraNode)
            setupTarget()
            self.sceneView.scene = self.scene
        }
    
    func repositionTarget() {
      let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: plant.location)
        
      let delta = heading - self.heading
    
      if delta < -15.0 {
        leftIndicator.isHidden = false
        rightIndicator.isHidden = true
      } else if delta > 15 {
        leftIndicator.isHidden = true
        rightIndicator.isHidden = false
      } else {
        leftIndicator.isHidden = true
        rightIndicator.isHidden = true
      }
        
      let distance = userLocation.distance(from: plant.location)
      if let node = plant.itemNode {
        if node.parent == nil {
          node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
          scene.rootNode.addChildNode(node)
        } else {

          node.removeAllActions()
          node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2))
        }
      }
    }
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return (radians) * (180.0 / Double.pi)
    }
      
    func degreesToRadians(_ degrees: Double) -> Double {
        return (degrees) * (Double.pi / 180.0)
    }
      
    func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
      //1
      let fLat = degreesToRadians(from.coordinate.latitude)
      let fLng = degreesToRadians(from.coordinate.longitude)
      let tLat = degreesToRadians(to.coordinate.latitude)
      let tLng = degreesToRadians(to.coordinate.longitude)
        
      //2
      let degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        
      //3
      if degree >= 0 {
        return degree
      } else {
        return degree + 360
      }
    }
    
    func setupTarget() {
        self.scene = SCNScene(named: "art.scnassets/ElmTree.dae")!
        let plant = scene.rootNode.childNode(withName: "default", recursively: true)
        plant?.position = SCNVector3(x: 0, y: 0, z: 0)
        let node = SCNNode()
        node.addChildNode(plant!)
        node.name = "enemy"
        self.plant.itemNode = node
    }
}

extension ARViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    //1
    self.heading = fmod(newHeading.trueHeading, 360.0)
    repositionTarget()
  }
}

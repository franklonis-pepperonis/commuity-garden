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
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var leftIndicator: UILabel!
    @IBOutlet weak var rightIndicator: UILabel!
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    
    var locationManager = CLLocationManager()
    var heading: Double = 0
    var userLocation = CLLocation()
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCamera()
        self.cameraSession?.startRunning()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


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

class ARViewController: UIViewController {

    
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    
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
    
    func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
        //1
        var error: NSError?
        var captureSession: AVCaptureSession?
        
        //2
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                let backVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
                //3
                if backVideoDevice != nil {
                    var videoInput: AVCaptureDeviceInput!
                    do {
                        videoInput = try AVCaptureDeviceInput(device: backVideoDevice!)
                    } catch let error1 as NSError {
                        error = error1
                        videoInput = nil
                    }
                    //4
                    if error == nil {
                        captureSession = AVCaptureSession()
                        
                        //5
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
            }
            else {
                //do nothing
            }
        }
        
        
        //6
        return (session: captureSession, error: error)
    }
    
    func loadCamera() {
        //1
        let captureSessionResult = createCaptureSession()
        //2
        guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
            print("Error creating capture session.")
            return
        }
        
        //3
        self.cameraSession = session
        
        //4
        let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession!)
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraLayer.frame = self.view.bounds
        //5
        self.view.layer.insertSublayer(cameraLayer, at: 0)
        self.cameraLayer = cameraLayer
    }

}



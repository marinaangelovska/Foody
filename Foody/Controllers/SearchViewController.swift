//
//  SearchViewController.swift
//  Foody
//
//  Created by Marina Angelovska on 5/2/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class SearchViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video: AVCaptureVideoPreviewLayer?
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        accelerometerSensor()
        gyroscopeSensor()
    }

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != nil {
                if(metadataObjects.count > 0) {
                if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                    if object.type == .qr {
                        let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                            UIPasteboard.general.string = object.stringValue
                        }))
                        print("QR code string \(object.stringValue)")
                        
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    func accelerometerSensor() {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                if myData.acceleration.x > 2 {
                    print("Movement detected")
                }
            }
        }
    }
    
    func gyroscopeSensor() {
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData2 = data {
                if myData2.rotationRate.x > 3 {
                    print("Phone tilted")
                }
                
            }
        }
    }
}

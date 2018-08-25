//
//  FoodDetailsViewController.swift
//  Foody
//
//  Created by Marina Angelovska on 5/1/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class FoodDetailsViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {

   
    @IBOutlet weak var urlLabel: UITextView!
    @IBOutlet weak var chefLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var imgLabel: UIImageView!
    var location = CLLocation()
    var count = 0
    
    var title1: String = ""
    var chef: String = ""
    var url: String  = ""
    var img: UIImage? = nil
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = title1
        chefLabel.text = chef
        imgLabel.image = img
        urlLabel.text = url
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }

    @IBAction func sharePressed(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [title1, img], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion =  MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        manager.delegate = nil
        generateAnnoLoc()
    }
   
    func generateAnnoLoc() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = generateRandomCoordinates(min: 70, max: 150)
        annotation.title = chef
        map.addAnnotation(annotation)

    }
    
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        let currentLong = location.coordinate.longitude
        let currentLat = location.coordinate.latitude
        
        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000
        
        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)
        
        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)
        
        //Then we convert the distance in meters to coordinates by Multiplying number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)
        
        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
        
    }

    


}

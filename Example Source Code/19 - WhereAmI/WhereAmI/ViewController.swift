//
//  ViewController.swift
//  WhereAmI
//
//  Created by Kim Topley on 11/18/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var previousPoint: CLLocation?
    private var totalMovementDistance = CLLocationDistance(0)
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var verticalAccuracyLabel: UILabel!
    @IBOutlet var distanceTraveledLabel: UILabel!
    @IBOutlet var mapView:MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(manager: CLLocationManager,
                    didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager,
                   didFailWithError error: NSError) {
        let errorType = error.code == CLError.Denied.rawValue
                        ? "Access Denied": "Error \(error.code)"
        let alertController = UIAlertController(title: "Location Manager Error",
                                message: errorType, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel,
                                handler: { action in })
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true,
                                completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations
                            locations: [CLLocation]) {
        if let newLocation = locations.last {
            let latitudeString = String(format: "%g\u{00B0}",
                            newLocation.coordinate.latitude)
            latitudeLabel.text = latitudeString
            
            let longitudeString = String(format: "%g\u{00B0}",
                            newLocation.coordinate.longitude)
            longitudeLabel.text = longitudeString
            
            let horizontalAccuracyString = String(format:"%gm",
                            newLocation.horizontalAccuracy)
            horizontalAccuracyLabel.text = horizontalAccuracyString
            
            let altitudeString = String(format:"%gm", newLocation.altitude)
            altitudeLabel.text = altitudeString
            
            let verticalAccuracyString = String(format:"%gm",
                            newLocation.verticalAccuracy)
            verticalAccuracyLabel.text = verticalAccuracyString
            
            if newLocation.horizontalAccuracy < 0 {
                // invalid accuracy
                return
            }
            
            if newLocation.horizontalAccuracy > 100 ||
                    newLocation.verticalAccuracy > 50 {
                // accuracy radius is so large, we don't want to use it
                return
            }
            
            if previousPoint == nil {
                totalMovementDistance = 0
                let start = Place(title:"Start Point",
                                        subtitle:"This is where we started",
                                        coordinate:newLocation.coordinate)
                mapView.addAnnotation(start)
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,
                                        100, 100)
                mapView.setRegion(region, animated: true)
            } else {
                print("movement distance: " +
                    "\(newLocation.distanceFromLocation(previousPoint!))")
                totalMovementDistance +=
                    newLocation.distanceFromLocation(previousPoint!)
            }
            previousPoint = newLocation
            
            let distanceString = String(format:"%gm", totalMovementDistance)
            distanceTraveledLabel.text = distanceString
        }
    }
}


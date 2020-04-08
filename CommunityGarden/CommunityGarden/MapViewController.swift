//
//  MapViewController.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 3/18/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var userLocation: CLLocation?
    
    @IBAction func backToMapView( _ segue: UIStoryboardSegue) {
        
    }
    
    var targets = [ARItem]()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        setupLocations()
    }

    func setupLocations() {
        
        let firstTarget = ARItem(itemDescription: "Garden", location: CLLocation(latitude:42.2808, longitude:-83.7430))
        targets.append(firstTarget)
        
        for item in targets {
            let annotation = MapAnnotation(location: item.location.coordinate, item: item)
            self.mapView.addAnnotation(annotation)
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.location
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "garden")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //1
        let coordinate = view.annotation!.coordinate
        //2
        if let userCoordinate = userLocation {
            //3
            if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 1000 {
                //4
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController {
                    // more code later
                    //5
                    if let mapAnnotation = view.annotation as? MapAnnotation {
                        //6
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

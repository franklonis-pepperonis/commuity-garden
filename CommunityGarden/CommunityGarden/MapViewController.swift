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
import Firebase
import FirebaseFirestore

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backToMapView( _ segue: UIStoryboardSegue) {
        
    }
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // make sure user tracking mode is on, request authorization if not.
        // extension at bottom of file will update user location whenever user refreshes location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        setupLocations()
    }

    func setupLocations() {
        
        let db = Firestore.firestore()
        db.collection("gardens").getDocuments() { (allGardens, err) in
            if let err = err {
                print("Error getting gardens: \(err)")
            } else {
                var gardens = [Garden]()
                for garden in allGardens!.documents {
                    let latGarden = garden.data()["latitude"] as! Double
                    let longGarden = garden.data()["longitude"] as! Double
                    let tempGarden = Garden(garden_id: garden.documentID, location: CLLocation(latitude: latGarden, longitude: longGarden))
                    gardens.append(tempGarden)
                }
                for item in gardens {
                    let annotation = MapAnnotation(location: item.location.coordinate, item: item)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    
    // whwnever user location updates, update userlocation
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.location
    }

    // make map annotations that arent user location display a garden
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
    
    // if they select a garden, check to make sure the distance between the user and the garden is < 500 meters
    // instantiate a viewController for AR view controller and pass in garden object
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let coordinate = view.annotation!.coordinate
    
        if let userCoordinate = userLocation {

            if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 500 {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                      let delegate = UIApplication.shared.delegate as! AppDelegate
                      
                      delegate.ar_view = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController
                      
                      let viewController = delegate.ar_view
                      
                      if let mapAnnotation = view.annotation as? MapAnnotation {

                          viewController?.gardenID = mapAnnotation.item.garden_id
                          //viewController?.garden = mapAnnotation.item
                          //viewController?.userLocation = mapView.userLocation.location!
                          self.present(viewController!, animated: true, completion: nil)
                      }
        
            }
        }
    }
}

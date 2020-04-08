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
    
    @IBAction func backToMapView( _ segue: UIStoryboardSegue) {
        
    }
    
    var plants = [ARItem]()
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        setupLocations()
    }

    func setupLocations() {
        
        
        // eventually we need to change these to gardens and each AR item should really be a dof
        let firstPlant = ARItem(itemDescription: "Plant", location: CLLocation(latitude:42.2716, longitude:-83.7464), itemNode: nil)
        let secondPlant = ARItem(itemDescription: "Plant 2", location: CLLocation(latitude: 42.271740, longitude: -83.740227), itemNode: nil)
        plants.append(firstPlant)
        plants.append(secondPlant)
        
        for item in plants {
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

    let coordinate = view.annotation!.coordinate
    
    if let userCoordinate = userLocation {

      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 500 {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          
        let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController
        
          if let mapAnnotation = view.annotation as? MapAnnotation {

            viewController?.plant = mapAnnotation.item
            
            self.present(viewController!, animated: true, completion: nil)
          }
        
      }
    }
  }
}

//
//  MapAnnotation.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 3/18/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    let item: Garden
    
    init(location: CLLocationCoordinate2D, item: Garden) {
        self.coordinate = location
        self.item = item
        self.title = item.garden_id
        
        super.init()
    }
}

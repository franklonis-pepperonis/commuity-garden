//
//  ARItem.swift
//  CommunityGarden
//
//  Created by Franklin Luo on 3/18/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit


struct ARItem {
    let itemDescription: String
    // change this to be coordinates?
    let location: CLLocation
    var itemNode: SCNNode?
}


struct Garden {
    let garden_id: String
    let location: CLLocation
}

struct PlantInfo {
   var amt: Int // amt user has in plant collection
    var img: String? // name of image
    var name: String // name of plant
    var description: String? // description for plant info view
}

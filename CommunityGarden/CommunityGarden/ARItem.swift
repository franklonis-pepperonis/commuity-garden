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
    let location: CLLocation
    var itemNode: SCNNode?
}

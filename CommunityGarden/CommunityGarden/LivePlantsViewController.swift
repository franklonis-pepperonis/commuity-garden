//
//  LivePlantsViewController.swift
//  CommunityGarden
//
//  Created by Grae Abbott on 3/20/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//

import Foundation
import UIKit


class LivePlantsViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    @IBAction func ExaminePlant(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlantPlotViewController") as? PlantPlotViewController
        
        //database pull to get plant Info
        //viewController.plant = PlantInfo(description: String, ar_image: String, cost: Int, image: String)
        
        self.present(viewController!, animated: true, completion: nil)
        
    }
}

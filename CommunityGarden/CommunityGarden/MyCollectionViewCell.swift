//
//  MyCollectionViewCell.swift
//  CommunityGarden
//
//  Created by Grae Abbott on 4/9/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//
import UIKit

class MyCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var amount: UILabel!
    
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews(){
        self.myButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.myButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }*/
}

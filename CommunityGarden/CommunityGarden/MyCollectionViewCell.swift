//
//  MyCollectionViewCell.swift
//  CommunityGarden
//
//  Created by Grae Abbott on 4/9/20.
//  Copyright © 2020 FrankPepps. All rights reserved.
//
import UIKit

protocol CollectionViewCellDelegate: class {
    // Declare a delegate function holding a reference to `UICollectionViewCell` instance
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}

class MyCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var amount: UILabel!
    
    weak var delegate: CollectionViewCellDelegate?
    
    @IBAction func buttonTapped(sender: UIButton) {
        // Add the resposibility of detecting the button touch to the cell, and call the delegate when it is tapped adding `self` as the `UICollectionViewCell`
        self.delegate?.collectionViewCell(self, buttonTapped: myButton)
    }
    
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


class MyCollectionPlantingViewCell: UICollectionViewCell {
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var amount: UILabel!
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        print("initiated")
    }
    
   
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupViews()
    }
    
    /*func setupViews(){
        self.myButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.myButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }*/
}

//
//  PlacemarkCell.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 01/10/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit

// MARK: - Sending Actions for Cell Buttons
protocol PlacemarkCellDelegate {
    func deletePlacemarkAtIndex(index: Int)
}

// MARK: - Main Class
class PlacemarkCell: UITableViewCell {
    
    // MARK: Variables
    var cellDelegate: PlacemarkCellDelegate?
    var deleteButton: UIButton!
    var index = -1

    // MARK: Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: placemarkCellIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.darkThemeColor().CGColor
        
        deleteButton = UIButton(frame: CGRect(x: screenWidth-50, y: 5, width: 30, height: 30))
        deleteButton.setImage(UIImage(assetIdentifier: .DeleteIcon), forState: .Normal)
        deleteButton.backgroundColor = UIColor.darkThemeColor()
        deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(deleteButton)
    }
    
    // MARK: Dynamic Frames for Buttons
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = bounds.height - 10
        
        deleteButton.frame = CGRect(x: screenWidth-buttonWidth-20, y: 5, width: buttonWidth, height: buttonWidth)
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        deleteButton.layer.cornerRadius = deleteButton.bounds.width/2
    }
    
    // MARK: Actions
    func deleteButtonTapped() {
        if let delegate = cellDelegate {
            delegate.deletePlacemarkAtIndex(index)
        }
    }
}

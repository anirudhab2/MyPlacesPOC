//
//  CustomButton.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 01/10/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var action:(()->Void)!
    
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        
        // Cusomizing appearance to use in edit place view
        setTitle(title, forState: .Normal)
        backgroundColor = UIColor.darkThemeColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Different colors for enabled and disabled state
    override var enabled: Bool {
        didSet {
            if (enabled == true) {
                backgroundColor = UIColor.darkThemeColor()
            } else {
                backgroundColor = UIColor.lightThemeColor()
            }
        }
    }
}

//
//  Utilities.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 29/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit

let screenHeight = UIScreen.mainScreen().bounds.height
let screenWidth = UIScreen.mainScreen().bounds.width

let placemarkCellIdentifier = "PlacemarkCell"
let annotationIdentifier = "placemarkAnnotation"


// Using enum to assign images to prevent typos
extension UIImage {
    enum AssetIdentifier: String {
        case UpIcon, DownIcon, AddIcon, DeleteIcon, EditIcon, RecenterIcon
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}

extension UIColor {
    class func lightThemeColor() -> UIColor {
        return UIColor(red: 255/255, green: 170/255, blue: 200/255, alpha: 1)
    }
    
    class func darkThemeColor() -> UIColor {
        return UIColor(red:250/255, green:15/255, blue:75/255, alpha:1)
    }
}
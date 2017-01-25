//
//  Placemark.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 30/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import Foundation
import RealmSwift

// Realm Model
class Placemark: Object {
    
    dynamic var id: Int = -1
    dynamic var title: String = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    
    // Primary Key
    override class func primaryKey() -> String {
        return "id"
    }
}

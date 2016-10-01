//
//  PlacemarkAnnotation.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 30/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit
import MapKit

class PlacemarkAnnotation: NSObject, MKAnnotation {

    var id: Int = -1
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    // Intitializing annotation with placemark's properties, 
    // not using actual placemark object anywhere
    init(placemark: Placemark) {
        self.id = placemark.id
        self.title = placemark.title
        self.coordinate = CLLocationCoordinate2D(latitude: placemark.latitude, longitude: placemark.longitude)
    }
    
    var setTitle: String = "" {
        didSet {
            title = setTitle
        }
    }
}

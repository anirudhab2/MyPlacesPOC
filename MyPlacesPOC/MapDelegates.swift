//
//  MapVCDelegates.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 01/10/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import RealmSwift
import MapKit
import UIKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKindOfClass(MKUserLocation)) {
            return nil
        }
        
        let annotationIdentifier: String = "placemarkAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MKPinAnnotationView
        
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        annotationView?.draggable = true
        annotationView?.animatesDrop = true
        annotationView?.canShowCallout = true
        
        let button = UIButton(type: .DetailDisclosure)
        button.tintColor = UIColor.darkThemeColor()
        button.setImage(UIImage(named: "EditIcon"), forState: .Normal)
        
        annotationView?.rightCalloutAccessoryView = button
        
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if (newState == .Ending) {
            if let annotation = view.annotation as? PlacemarkAnnotation {
                if let placemark = placemarkList.filter("id == \(annotation.id)").first {
                    do {
                        let realm = try Realm()
                        
                        try realm.write({
                            placemark.latitude = annotation.coordinate.latitude
                            placemark.longitude = annotation.coordinate.longitude
                            placemark.distanceToUser = distanceOfUserLocationFrom(annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                        })
                    } catch let error as NSError {
                        print("Error in dragging annotation: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Couldn't downcast dragged annotation")
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PlacemarkAnnotation {
            
            editPlaceView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            editPlaceView.setAnnotation(annotation)
            self.view.addSubview(editPlaceView)
            
        } else {
            print("Couldn't downcast annotation")
        }
    }
}


extension MapViewController: EditPlaceDelegate {
    
    func newPlaceWithTitle(title: String) {
        let annotationCoordinate = mapView.convertPoint(mapView.center, toCoordinateFromView: mapView)
        addNewAnnotationAtCoordinate(annotationCoordinate, withTitle: title)
    }
    
    func placeTitleChangedForAnnotation(annotation: PlacemarkAnnotation, newTitle: String) {
        do {
            let realm = try Realm()
            
            try realm.write({
                mapView.removeAnnotation(annotation)
                annotation.setTitle = newTitle
                if let placemark = placemarkList.filter("id == \(annotation.id)").first {
                    do {
                        let realm = try Realm()
                        
                        try realm.write({
                            placemark.title = newTitle
                        })
                    } catch let error as NSError {
                        print("Error in dragging annotation: \(error.localizedDescription)")
                    }
                }
                
                mapView.addAnnotation(annotation)
                placemarkTableView.reloadData()
            })
        } catch let error as NSError {
            print("Error in editing annotation name: \(error.localizedDescription)")
        }
    }
}



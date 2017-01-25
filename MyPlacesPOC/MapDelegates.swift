//
//  MapDelegates.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 01/10/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import RealmSwift
import MapKit
import UIKit

// MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {
    
    //MARK: Custom View for Annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKindOfClass(MKUserLocation)) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MKPinAnnotationView
        
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        annotationView?.draggable = true
        annotationView?.animatesDrop = true
        annotationView?.canShowCallout = true
        
        let button = UIButton(type: .DetailDisclosure)
        button.tintColor = UIColor.darkThemeColor()
        button.setImage(UIImage(assetIdentifier: .EditIcon), forState: .Normal)
        
        annotationView?.rightCalloutAccessoryView = button
        
        
        return annotationView
    }
    
    // MARK: Updating Annotation and Database When Dragged
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if (newState == .Ending) {
            if let annotation = view.annotation as? PlacemarkAnnotation {
                if let placemark = placemarkList.filter("id == \(annotation.id)").first {
                    do {
                        let realm = try Realm()
                        
                        try realm.write({
                            placemark.latitude = annotation.coordinate.latitude
                            placemark.longitude = annotation.coordinate.longitude
                            placemarkTableView.reloadData()
                        })
                    } catch let error as NSError {
                        let message = "Error in dragging annotation: \(error.localizedDescription)"
                        print(message)
                        showAlertWithMessage(message)
                    }
                }
            } else {
                print("Couldn't downcast dragged annotation")
            }
        }
    }
    
    // MARK: Editing an Annotation
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

// MARK: - Location Manager
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        checkForLocationPermission()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        centerMapAroundAnnotation(mapView.userLocation)
        manager.stopUpdatingLocation()
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        centerMapAroundAnnotation(mapView.userLocation)
    }
    
    func checkForLocationPermission() {
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            recenterButton.enabled = false
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .Denied, .Restricted:
            recenterButton.enabled = false
            showLocationRequestAlert()
            break
        
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            locationManager.startUpdatingLocation()
            recenterButton.enabled = true
            break
            
        }
    }
    
    func showLocationRequestAlert() {
        let message = "Please allow us to use location when in use, it's worth it, trust me!!"
        let alertView = CustomAlertView(message: message)
        
        alertView.addFirstButton("Settings") {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        alertView.addSecondButton("Cancel") { }
        alertView.showInView(view)
    }
}


// MARK: - Adding/ Editing a Place
extension MapViewController: EditPlaceDelegate {
    
    // MARK: Changing Title of a place in Map and Database
    func placeTitleChangedForAnnotation(annotation: PlacemarkAnnotation, newTitle: String) {
        
        if let placemark = placemarkList.filter("id == \(annotation.id)").first {
            do {
                let realm = try Realm()
                
                try realm.write({ 
                    mapView.removeAnnotation(annotation)
                    annotation.setTitle = newTitle
                    placemark.title = newTitle
                    mapView.addAnnotation(annotation)
                    placemarkTableView.reloadData()
                })
                
            } catch let error as NSError {
                let message = "Error in editing annotation name: \(error.localizedDescription)"
                print(message)
                showAlertWithMessage(message)
            }
        }
    }
    
    // MARK: Adding a new Place
    func newPlaceWithTitle(title: String) {
        let annotationCoordinate = mapView.convertPoint(mapView.center, toCoordinateFromView: mapView)
        addNewAnnotationAtCoordinate(annotationCoordinate, withTitle: title)
    }
    
    // MARK: Adding a new Place at a coordinate
    func addNewAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, withTitle title: String) {
        
        // Creating a new Database Object
        let newPlacemark = Placemark()
        newPlacemark.title = title
        newPlacemark.latitude = coordinate.latitude
        newPlacemark.longitude = coordinate.longitude
        
        // Assigning Id to annotation from respactive Database object
        // Id will be used to connect these two
        if (placemarkList.count > 0) {
            let tempList = placemarkList.sorted("id")
            newPlacemark.id = tempList.last!.id + 1
        } else {
            newPlacemark.id = 0
        }
        
        do {
            let realm = try Realm()
            
            try realm.write({
                realm.add(newPlacemark)
                
                // Adding a annotation in map corresponding the Database object
                let annotation = PlacemarkAnnotation(placemark: newPlacemark)
                mapView.addAnnotation(annotation)
                placemarkTableView.reloadData()
            })
        } catch let error as NSError {
            let message = "Error in adding new placemark in realm: \(error.localizedDescription)"
            print(message)
            showAlertWithMessage(message)
        }
    }
}



//
//  TableDelegates.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 30/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import RealmSwift
import MapKit
import UIKit


// MARK: - Table View Methods
extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = placemarkList.count
        
        if (count == 0) {
            // If there are no annotations, hiding the placemark list
            placemarkListContainerView.hidden = true
            hidePlacemarkList()
        } else {
            placemarkListContainerView.hidden = false
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(placemarkCellIdentifier, forIndexPath: indexPath) as! PlacemarkCell
        
        let placemark = placemarkList[indexPath.row]
        let newDistance = distanceOfUserLocationFrom(placemark.latitude, longitude: placemark.longitude)
        cell.textLabel?.text = placemark.title
        cell.detailTextLabel?.text = formattedDistanceStringfrom(newDistance) + " away"
        cell.index = indexPath.row
        cell.cellDelegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let placemark = placemarkList[indexPath.row]
        
        for annotation in mapView.annotations {
            if let placemarkAnnotaion = annotation as? PlacemarkAnnotation {
                if (placemarkAnnotaion.id == placemark.id) {
                    
                    // Selecting annotation and centering map arround it
                    mapView.selectAnnotation(placemarkAnnotaion, animated: true)
                    centerMapAroundAnnotation(placemarkAnnotaion)
                }
            } 
        }
    }
}

// MARK: - Cell Actions
extension MapViewController: PlacemarkCellDelegate {
    
    func deletePlacemarkAtIndex(index: Int) {
        var annotationToDelete: PlacemarkAnnotation!
        
        // Taking annotation to delete
        for annotation in mapView.annotations {
            if let placemarkAnnotation = annotation as? PlacemarkAnnotation {
                if (placemarkAnnotation.id == placemarkList[index].id) {
                    annotationToDelete = placemarkAnnotation
                }
            } else {
                print("user location annotation will not downcast")
            }
        }
        
        if (annotationToDelete != nil) {
            do {
                let realm = try Realm()
                
                try realm.write({
                    // Removing annotation from map and deleting from database
                    mapView.removeAnnotation(annotationToDelete)
                    realm.delete(placemarkList[index])
                    placemarkTableView.reloadData()
                })
            } catch let error as NSError {
                let message = "Error in deleting item: \(error.localizedDescription)"
                print(message)
                showAlertWithMessage(message)
            }
        }
    }    
}


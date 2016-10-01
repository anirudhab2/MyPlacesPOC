//
//  PlacemarkTableDelegates.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 30/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit
import UIKit
import AddressBook



extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = placemarkList.count
        
        if (count == 0) {
            placemarkListContainerView.hidden = true
            hidePlacemarkList()
        } else {
            placemarkListContainerView.hidden = false
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlacemarkCell", forIndexPath: indexPath) as! PlacemarkCell
        
        cell.index = indexPath.row
        cell.cellDelegate = self
        cell.textLabel?.text = placemarkList[indexPath.row].title
        cell.detailTextLabel?.text = formattedDistanceStringfrom(placemarkList[indexPath.row].distanceToUser) + " away"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let placemark = placemarkList[indexPath.row]
        
        for annotation in mapView.annotations {
            if let placemarkAnnotaion = annotation as? PlacemarkAnnotation {
                if (placemarkAnnotaion.id == placemark.id) {
                    mapView.selectAnnotation(placemarkAnnotaion, animated: true)
                    centerMapAroundAnnotation(placemarkAnnotaion)
                }
            } 
        }
    }
}

extension MapViewController: PlacemarkCellDelegate {
    
    func deletePlacemarkAtIndex(index: Int) {
        var annotationToDelete: PlacemarkAnnotation!
        
        for annotation in mapView.annotations {
            if let placemarkAnnotation = annotation as? PlacemarkAnnotation {
                if (placemarkAnnotation.id == placemarkList[index].id) {
                    annotationToDelete = placemarkAnnotation
                } else {
                    print("Couldn't find the id to delete in map")
                }
            } else {
                print("user location annotation will not downcast")
            }
        }
        
        if (annotationToDelete != nil) {
            do {
                let realm = try Realm()
                
                try realm.write({
                    mapView.removeAnnotation(annotationToDelete)
                    realm.delete(placemarkList[index])
                    placemarkTableView.reloadData()
                })
            } catch let error as NSError {
                print("Error in deleting item: \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToPlacemarkAtIndex(index: Int) {
        let coordinate = CLLocationCoordinate2D(latitude: placemarkList[index].latitude, longitude: placemarkList[index].longitude)
        let location = CLLocation(latitude: placemarkList[index].latitude, longitude: placemarkList[index].longitude)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let mapPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: mapPlacemark)
        
        print(mapPlacemark)
        print(mapPlacemark.coordinate)
        print(mapItem)
        
        
        
//        CLGeocoder().reverseGeocodeLocation(location) { (placemarkList, error) in
//            if (error != nil) {
//                print("Reverse geocoder failed with error: \(error?.localizedDescription)")
//            } else {
//                if let placemark = placemarkList?.first {
//                    
//                    print("thoroughfare: \(placemark.thoroughfare)")
//                    print("subthoro: \(placemark.subThoroughfare)")
//                    print("sublocality: \(placemark.subLocality)")
//                    print("locality: \(placemark.locality)")
//                    print("sub admin area: \(placemark.subAdministrativeArea)")
//                    print("admin area: \(placemark.administrativeArea)")
//                    
//                    if let streetAddress = placemark.thoroughfare {
//                        let addressDict: [String: AnyObject] = [String(kABPersonAddressStreetKey): streetAddress]
//                        let mapPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
//                        let mapItem = MKMapItem(placemark: mapPlacemark)
//                        mapItem.openInMapsWithLaunchOptions(launchOptions)
//                    }
//                }
//            }
//        }

        
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}


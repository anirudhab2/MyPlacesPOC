//
//  MapViewController.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 30/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

// MARK: - Main Class
class MapViewController: UIViewController {

    // MARK: - Subviews
    var mapView: MKMapView!
    var placemarkListContainerView: UIView!
    var placemarkTableView: UITableView!
    var recenterButton: UIButton!
    var addButton: UIButton!
    var toggleListButton: UIButton!
    var editPlaceView: EditPlaceView!
    
    // MARK: - Variables
    var isPlacemarkListHidden = true
    let toggleListButtonHeight: CGFloat = 50
    var locationManager: CLLocationManager!
    var placemarkList: Results<Placemark>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        
        initializeSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAndSortAnnotationList()
        populateMapWithAnnotations()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForLocationPermission()
        centerMapAroundAnnotation(mapView.userLocation)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    func addNewAnnotation() {
        editPlaceView.frame = view.bounds
        view.addSubview(editPlaceView)
    }
    
    func recenterButtonTapped() {
        centerMapAroundAnnotation(mapView.userLocation)
    }
    
    func toggleListButtonTapped() {
        if (isPlacemarkListHidden) {
            showPlacemarkList()
        } else {
            hidePlacemarkList()
        }
    }
    
    // MARK: - Show/Hide Place List
    func showPlacemarkList() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.mapView.frame.size.height = screenHeight/2
            self.placemarkListContainerView.frame.origin.y = screenHeight/2
            
            }) { (finished) in
                self.toggleListButton.setImage(UIImage(assetIdentifier: .DownIcon), forState: .Normal)
                self.isPlacemarkListHidden = false
                self.placemarkTableView.reloadData()
        }
    }
    
    func hidePlacemarkList() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.mapView.frame.size.height = screenHeight
            self.placemarkListContainerView.frame.origin.y = screenHeight - self.toggleListButtonHeight
            
            }) { (finished) in
            self.toggleListButton.setImage(UIImage(assetIdentifier: .UpIcon), forState: .Normal)
            self.isPlacemarkListHidden = true
        }
    }
    
    // MARK: - Refresh Map and Annotation List
    func updateAndSortAnnotationList() {
        do {
            let realm = try Realm()
            placemarkList = realm.objects(Placemark).sorted("id", ascending: false)
            placemarkTableView.reloadData()
        } catch let error as NSError {
            let message = "Error in reading annotation list: \(error.localizedDescription)"
            print(message)
            showAlertWithMessage(message)
        }
    }
    
    func populateMapWithAnnotations() {
        
        for placemark in placemarkList {
            let placemarkAnnotation = PlacemarkAnnotation(placemark: placemark)
            mapView.addAnnotation(placemarkAnnotation)
        }
        
        placemarkTableView.reloadData()
    }
    
    // MARK: - Supporting Methods
    func centerMapAroundAnnotation(annotation: MKAnnotation) {
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    
    func distanceOfUserLocationFrom(latitude: Double, longitude: Double) -> Double {
        if let userLocation = mapView.userLocation.location {
            return userLocation.distanceFromLocation(CLLocation(latitude: latitude, longitude: longitude))
        } else {
            return 0
        }
    }
    
    func formattedDistanceStringfrom(distance: Double) -> String {
        var distanceString = ""
        
        var distanceInMeters = Int(distance)
        let distanceInKilometers = Int(distance/1000)
        
        if (distanceInKilometers < 1) {
            distanceString = String(format: "%03d", distanceInMeters) + " m"
        } else {
            distanceInMeters = distanceInMeters - (1000*distanceInKilometers)
            distanceString = "\(distanceInKilometers)." + String(format: "%03d", distanceInMeters) + " km"
        }
        
        return distanceString
    }
    
    func showAlertWithMessage(message: String) {
        let alertView = CustomAlertView(message: message)
        alertView.addFirstButton("Okay") { }
        alertView.showInView(view)
    }
}

//MARK: - Initialize Subviews
extension MapViewController {
    
    func initializeSubviews() {
        
        mapView = MKMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        
        
        recenterButton = UIButton(frame: CGRect(x: screenWidth-15, y: 45, width: -40, height: 40))
        recenterButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        recenterButton.setImage(UIImage(assetIdentifier: .RecenterIcon), forState: .Normal)
        recenterButton.backgroundColor = UIColor.darkThemeColor()
        recenterButton.layer.cornerRadius = recenterButton.bounds.width/2
        recenterButton.layer.shadowOpacity = 1
        recenterButton.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        recenterButton.layer.shadowRadius = 5
        recenterButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        recenterButton.addTarget(self, action: #selector(self.recenterButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(recenterButton)
        
        
        addButton = UIButton(frame: CGRect(x: screenWidth-15, y: 95, width: -40, height: 40))
        addButton.setImage(UIImage(assetIdentifier: .AddIcon), forState: .Normal)
        addButton.backgroundColor = UIColor.whiteColor()
        addButton.layer.cornerRadius = addButton.bounds.width/2
        addButton.layer.shadowOpacity = 1
        addButton.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        addButton.addTarget(self, action: #selector(self.addNewAnnotation), forControlEvents: .TouchUpInside)
        view.addSubview(addButton)
        
        
        placemarkListContainerView = UIView(frame: CGRect(x: 0, y: screenHeight-toggleListButtonHeight, width: screenWidth, height: screenHeight/2))
        view.addSubview(placemarkListContainerView)
        
        
        toggleListButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: toggleListButtonHeight))
        toggleListButton.backgroundColor = UIColor.darkThemeColor()
        toggleListButton.setImage(UIImage(assetIdentifier: .UpIcon), forState: .Normal)
        toggleListButton.imageEdgeInsets.left = (screenWidth - toggleListButtonHeight)/2
        toggleListButton.imageEdgeInsets.right = (screenWidth - toggleListButtonHeight)/2
        toggleListButton.addTarget(self, action: #selector(self.toggleListButtonTapped), forControlEvents: .TouchUpInside)
        placemarkListContainerView.addSubview(toggleListButton)
        
        
        let tableFrame = CGRect(x: 0, y: toggleListButtonHeight, width: screenWidth, height: placemarkListContainerView.bounds.height-toggleListButtonHeight)
        placemarkTableView = UITableView(frame: tableFrame, style: .Plain)
        placemarkTableView.backgroundColor = UIColor.clearColor()
        placemarkTableView.separatorStyle = .None
        placemarkTableView.allowsMultipleSelection = false
        placemarkTableView.dataSource = self
        placemarkTableView.delegate = self
        placemarkTableView.registerClass(PlacemarkCell.self, forCellReuseIdentifier: placemarkCellIdentifier)
        placemarkTableView.rowHeight = 50
        placemarkListContainerView.addSubview(placemarkTableView)
        
        
        editPlaceView = EditPlaceView(frame: view.bounds)
        editPlaceView.delegate = self
    }
}
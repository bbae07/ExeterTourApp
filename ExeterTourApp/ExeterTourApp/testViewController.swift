//
//  testViewController.swift
//  ExeterTourApp
//
//  Created by 이경문 on 2017. 5. 11..
//  Copyright © 2017년 bbae07. All rights reserved.
//

import UIKit
import MapboxDirections
import MapboxNavigation


class testViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation:loc? = nil
    var selectedLocation:loc? = nil
    
    
    
    func setLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1500.0
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        let currentLatitude = latestLocation.coordinate.latitude
        let currentLongitude = latestLocation.coordinate.longitude
        
        self.currentLocation?.latitude = currentLatitude
        self.currentLocation?.longitude = currentLongitude
        self.route()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocationManager()
        let mapView = MGLMapView(frame: view.bounds)
        
        view.addSubview(mapView)
        /*
	        // Do any additional setup after loading the view.
	        let directions = Directions.shared
	        
	        let waypoints = [
         Waypoint(
         coordinate: CLLocationCoordinate2D(latitude: 38.9099711, longitude: -77.0361122),
         name: "Mapbox"),
         Waypoint(
         coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365),
         name: "White House"),
         ]
	        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .cycling)
	        options.includesSteps = true
	        
	        let task = directions.calculate(options) { (waypoints, routes, error) in
         guard error == nil else {
         print("Error calculating directions: \(error!)")
         return
         }
         
         if let route = routes?.first, let leg = route.legs.first {
         print("Route via \(leg):")
         
         let distanceFormatter = LengthFormatter()
         let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
         
         let travelTimeFormatter = DateComponentsFormatter()
         travelTimeFormatter.unitsStyle = .short
         let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
         
         print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
         
         for step in leg.steps {
         print("\(step.instructions)")
         let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
         print("— \(formattedDistance) —")
         }
         }
	        }*/
        self.route()
        
    }
    
    func route(){
        var lat:Double? = nil
        var log:Double? = nil
        
        if let _ = self.currentLocation{
            lat = (self.currentLocation?.latitude)!
            log = (self.currentLocation?.longitude)!
        }else{
            lat = selectedLocation?.latitude
            log = selectedLocation?.longitude
        }
        
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: log!), name: "Mapbox")
        
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: (selectedLocation?.latitude)!, longitude: (selectedLocation?.longitude)!), name: selectedLocation?.name)
        
        let options = RouteOptions(waypoints: [origin, destination], profileIdentifier: .walking)
        options.routeShapeResolution = .full
        options.includesSteps = true
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            
            let viewController = NavigationViewController(for: route)
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
	    // MARK: - Navigation
     
	    // In a storyboard-based application, you will often want to do a little preparation before navigation
	    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
	    }
	    */
    
    
}

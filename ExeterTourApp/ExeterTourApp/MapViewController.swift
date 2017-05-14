//
//  MapViewController.swift
//  ExeterTourApp
//
//  Created by 이경문 on 2017. 3. 20..
//  Copyright © 2017년 bbae07. All rights reserved.
//

import UIKit
//import GoogleMaps
//import Alamofire
//import SwiftyJSON

class MapViewController: UIViewController{//,CLLocationManagerDelegate {
    
    var selectedLocation:loc? = nil
    
    var currentLocation:loc? = nil
    /*
    var locationManager: CLLocationManager = CLLocationManager()
    var mapView:GMSMapView? = nil
    
    var current_route_count = 0
    var current_route_path:GMSPath? = nil
    var current_route_polylines:[GMSPolyline] = []
    */
    var current_tolerance = 30
    
    var distance_label:UILabel? = nil
    var duration_label:UILabel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.setLocationManager()
        /*
        distance_label = UILabel(frame:CGRect(x:0,y:self.mapView!.frame.size.height - 100,width:self.mapView!.frame.size.width,height:50.0))
        duration_label = UILabel(frame:CGRect(x:0,y:self.mapView!.frame.size.height - 50,width:self.mapView!.frame.size.width,height:50.0))
        distance_label?.textColor = UIColor.black
        distance_label?.textAlignment = NSTextAlignment.right
        duration_label?.textColor = UIColor.black
        duration_label?.textAlignment = NSTextAlignment.right
        self.view.addSubview(distance_label!)
        self.view.addSubview(duration_label!)
        self.view.backgroundColor = UIColor.white
        */
    }
    /*
    
    func setLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1500.0
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        var camera = GMSCameraPosition()
        if let _ = self.currentLocation{
            camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation?.latitude)!,longitude: (self.currentLocation?.longitude)!, zoom: 18)
        }else{
            camera = GMSCameraPosition.camera(withLatitude: UserDefaults.standard.double(forKey: "LATITUDE"), longitude: UserDefaults.standard.double(forKey: "LONGITUDE"), zoom: 18)
        }
        mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height)), camera: camera)
        mapView?.isMyLocationEnabled = true
        self.view.insertSubview(mapView!, belowSubview: self.view)
    }
    
    func setGoogleMap(){
        var camera = GMSCameraPosition()
        //var marker = GMSMarker()
        if let _ = self.currentLocation{
            camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation?.latitude)!,longitude: (self.currentLocation?.longitude)!, zoom: 18)
        }else{
            camera = GMSCameraPosition.camera(withLatitude: UserDefaults.standard.double(forKey: "LATITUDE"), longitude: UserDefaults.standard.double(forKey: "LONGITUDE"), zoom: 18)
        }
        self.mapView?.camera = camera
    }
    
    func checkPathTolerance(){
        if let _:GMSPath = self.current_route_path{
            if !GMSGeometryIsLocationOnPathTolerance(CLLocationCoordinate2DMake((self.currentLocation?.latitude)!,(self.currentLocation?.longitude)!),self.current_route_path!,true,CLLocationDistance(self.current_tolerance)){
            //if !GMSGeometryIsLocationOnPathTolerance(CLLocationCoordinate2DMake(37.5657882,126.9363833),self.current_route_path!,true,CLLocationDistance(self.current_tolerance)){
                let alertController = UIAlertController(title: "The path has been abandoned.", message: "Do you want to explore the new path?", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler:
                    {   UIAlertAction -> Void in
                        let origin = "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)"
                        let destination = "\(self.selectedLocation!.latitude),\(self.selectedLocation!.longitude)"
                        let url_walking = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyBJEdKCVE-S4iBvZ2BwBFN_QbmswENTDUU"
                        self.human_route(url: url_walking, status: "walking")
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                    UIAlertAction -> Void in
                    self.current_tolerance *= 2
                })
                alertController.addAction(defaultAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        let currentLatitude = latestLocation.coordinate.latitude
        let currentLongitude = latestLocation.coordinate.longitude
        if let _ = self.currentLocation{
            if currentLatitude != self.currentLocation?.latitude || currentLongitude != self.currentLocation?.longitude{
                UserDefaults.standard.set(currentLatitude, forKey: "LATITUDE")
                UserDefaults.standard.set(currentLongitude, forKey: "LONGITUDE")
                UserDefaults.standard.synchronize()
            }
        }
        currentLocation = loc(name:"CURRENT", latitude: currentLatitude,longitude: currentLongitude , photo: [], explain: "CURRENT_EXPLAIN")
        //self.setGoogleMap()
        // 마커가 다 보이게 카메라 업데이트
        var bounds = GMSCoordinateBounds()
        for loc in [self.currentLocation,self.selectedLocation]
        {
            bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake((loc?.latitude)!, (loc?.longitude)!))
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        self.mapView?.animate(with: update)
        self.checkPathTolerance()
    }
    
    
    func human_route(url:String, status:String){
        
        Alamofire.request(url).responseJSON { response in
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            var total_distance:String? = nil
            var total_duration:String? = nil
            
            
            if routes.count == 0{
                if status == "transmit"{
                    let alertController = UIAlertController(title: "Path not found", message: "Please try again", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }else{
                    let origin = "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)"
                    let destination = "\(self.selectedLocation!.latitude),\(self.selectedLocation!.longitude)"
                    
                    let url_transmit = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=transit&key=AIzaSyBJEdKCVE-S4iBvZ2BwBFN_QbmswENTDUU"
                    self.human_route(url: url_transmit, status: "transmit")
                    return
                }
            }
            for line in self.current_route_polylines{
                line.map = nil
            }
            self.current_route_polylines = []

            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.current_route_path = path
                let polyline = GMSPolyline.init(path: path)
                self.current_route_polylines.append(polyline)
                polyline.map = self.mapView
                
                if total_distance == nil{
                    total_distance = route["legs"].arrayValue[0]["distance"].dictionary!["text"]?.stringValue
                }
                if total_duration == nil{
                    total_duration = route["legs"].arrayValue[0]["duration"].dictionary!["text"]?.stringValue
                }
            }
            // 마커가 다 보이게 카메라 업데이트
            var bounds = GMSCoordinateBounds()
            for loc in [self.currentLocation,self.selectedLocation]
            {
                bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake((loc?.latitude)!, (loc?.longitude)!))
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
            self.mapView?.animate(with: update)
            
            self.distance_label?.text = "Total distance : \(total_distance!)"
            self.duration_label?.text = "Total time : \(total_duration!)"+", mode=\(status)"
            self.checkPathTolerance()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _:loc = self.selectedLocation{
            //mapView?.clear()
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake((selectedLocation?.latitude)!, (selectedLocation?.longitude)!)
            marker.title = selectedLocation?.name
            marker.map = mapView
            
            let origin = "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)"
            let destination = "\(self.selectedLocation!.latitude),\(self.selectedLocation!.longitude)"
            
            let url_walking = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyBJEdKCVE-S4iBvZ2BwBFN_QbmswENTDUU"
            
            self.human_route(url: url_walking, status: "walking")
            //self.checkPathTolerance()
        }
    }
    
    func linear_route(){
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake((self.currentLocation?.latitude)!, (self.currentLocation?.longitude)!))
        path.add(CLLocationCoordinate2DMake((self.selectedLocation?.latitude)!, (self.selectedLocation?.longitude)!))
        let rectangle = GMSPolyline(path:path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapView
    }
    */
    /*
    func locationSelector(){
        print("selector clicked")
        //self.navigationController?.pushViewController(ENLocationTableViewController(), animated: true)
    }
    */

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

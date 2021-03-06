//
//  FirstViewController.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 10/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class RestaurantViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var mapView:MKMapView?
    
    @IBOutlet var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView!.contentInset = insets
        tableView!.estimatedRowHeight = 65
        navigationItem.title = "NearBy Restaurants"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onVenuesUpdated:"), name: API.notifications.venuesUpdated, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let tableView = self.tableView
        {
            tableView.delegate = self
            tableView.dataSource = self
        }
        
    }
    
    // User location Attributes
    var locationManager:CLLocationManager?
    let distanceSpan:Double = 1000
    
    var lastLocation:CLLocation?
    var venues:[Venue]?
    var region: MKCoordinateRegion?
    var annotation: CoffeeAnnotation?
    
    // Instantiate Location Manger
    override func viewDidAppear(animated: Bool)
    {
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50 // Don't send location updates with a distance smaller than 50 meters between them
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
            
            refreshVenues(newLocation, getDataFromFoursquare: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return venues?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels() //sets the fonts of the labels
        
//        if cell == nil
//        {
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
//        }
        
        if let venue = venues?[indexPath.row]
        {
            cell.nameLabel?.text = venue.name
            cell.addressLabel?.text = venue.address
            //cell.distanceLabel?.text = "\(venue.distancetolocation)"
            cell.distanceLabel?.text = "0.1 mi"
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // pass item details to item controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == "ShowItem" {
         //tableView?.indexPathForSelectedRow?.row
            //segue  = ItemViewController
            let destinationVC = segue.destinationViewController as! ItemViewController
            
            
            if let indexPath = self.tableView!.indexPathForSelectedRow{
                
                let selectedRow =  venues![indexPath.row]
                print("Selected Row:")
                print(selectedRow)
                destinationVC.venue = selectedRow
                region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(selectedRow.latitude), longitude: Double(selectedRow.longitude)), distanceSpan, distanceSpan)
                destinationVC.itemregion = region
                destinationVC.itemannotation = annotation
                print("Region:")
                print(self.region)
                print("Annotation:")
                print(annotation)
        }
            
        //}
    }
    
    func refreshVenues(location: CLLocation?, getDataFromFoursquare:Bool = false)
    {
        if location != nil
        {
            lastLocation = location
        }
        
        if let location = lastLocation
        {
            if getDataFromFoursquare == true
            {
                FSAPI.sharedInstance.getCoffeeShopsWithLocation(location)
            }
            
            let (start, stop) = calculateCoordinatesWithRegion(location)
            
            let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude > %f AND longitude < %f", start.latitude, stop.latitude, start.longitude, stop.longitude)
            
            let realm = try! Realm()
            
            venues = realm.objects(Venue).filter(predicate).sort {
                location.distanceFromLocation($0.coordinate) < location.distanceFromLocation($1.coordinate)
            }
            
            for venue in venues!
            {
                annotation = CoffeeAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
                
//                mapView?.addAnnotation(annotation)
            }
            
            tableView?.reloadData()
        }
    }
    
    func calculateCoordinatesWithRegion(location:CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distanceSpan, distanceSpan)
        
        var start:CLLocationCoordinate2D = CLLocationCoordinate2D()
        var stop:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        start.latitude  = region.center.latitude  + (region.span.latitudeDelta  / 2.0)
        start.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0)
        stop.latitude   = region.center.latitude  - (region.span.latitudeDelta  / 2.0)
        stop.longitude  = region.center.longitude + (region.span.longitudeDelta / 2.0)
        
        return (start, stop)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        if let venue = venues?[indexPath.row]
//        {
//             let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)), distanceSpan, distanceSpan)
//            print("Self Region before")
//            print(self.region)
//            self.region = region
//            print("Venue Region:")
//            print(region)
//            print("Self Region After")
//            print(self.region)
//            //mapView?.setRegion(region, animated: true)
//        }
    }
    
    
    func onVenuesUpdated(notification:NSNotification)
    {
        refreshVenues(nil)
    }
    
}


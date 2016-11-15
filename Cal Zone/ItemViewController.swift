//
//  File.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 11/3/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import MapKit

class ItemViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var venue : Venue!
    
    var itemregion : MKCoordinateRegion?
    
    var itemannotation : CoffeeAnnotation?
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let mapView = self.mapView
                {
                    mapView.delegate = self
                }
        mapView.setRegion(itemregion!, animated: true)
        
        mapView.addAnnotation(itemannotation!)
        
        
        navigationItem.title = venue.name
        
        nameLabel.text = venue.name
        
        addressLabel.text = venue.address
        
        distanceLabel.text = "0.1 mi"
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
        {
            if annotation.isKindOfClass(MKUserLocation)
            {
                return nil
            }
    
            var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
    
            if view == nil
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
            }
    
            view?.canShowCallout = true
            
            return view
        }
    
}
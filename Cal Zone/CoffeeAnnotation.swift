//
//  CoffeeAnnotation.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 10/29/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import MapKit

class CoffeeAnnotation: NSObject, MKAnnotation
{
    let title:String?
    let subtitle:String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
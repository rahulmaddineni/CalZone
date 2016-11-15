//
//  Venue.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 10/29/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//


import RealmSwift
import MapKit

class Venue: Object
{

    dynamic var id:String = ""
    dynamic var name:String = ""
    
    dynamic var latitude:Float = 0
    dynamic var longitude:Float = 0
    //dynamic var distancetolocation:Float = 0
    
    dynamic var address:String = ""
    
    var coordinate:CLLocation {
        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
    }
    
    override static func primaryKey() -> String?
    {
        return "id";
    }
}
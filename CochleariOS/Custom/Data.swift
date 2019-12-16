//
//  Data.swift
//  CochleariOS
//
//  Created by Quadir on 12/16/19.
//  Copyright © 2019 Quadir. All rights reserved.
//
import UIKit
import GooglePlaces
import MapKit
import GoogleMaps

struct Data {
    let title: String
    let location: CLLocationCoordinate2D
    let info: String
    var distance: Double
    init(_ title: String, _ location: CLLocationCoordinate2D, _ info: String,_ distance: Double) {
        self.title = title
        self.location = location
        self.info = info
        self.distance = distance
    }
}

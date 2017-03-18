//
//  loc.swift
//  ExeterTourApp
//
//  Created by Brian Bae on 2017. 3. 18..
//  Copyright © 2017년 bbae07. All rights reserved.
//

import Foundation

class loc{
    var name:String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var photo:[String] = []
    var explain:String = ""
    
    init(name:String, latitude:Double, longitude:Double, photo:[String], explain:String ){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.photo = photo
        self.explain = explain
    }
}

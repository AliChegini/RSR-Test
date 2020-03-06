//
//  AppModels.swift
//  RSR
//
//  Created by Ehsan on 06/03/2020.
//  Copyright © 2020 Ali C. All rights reserved.
//

import UIKit
import MapKit


// Class to model custom annotation object

class CustomAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
}


enum NetworkStatus {
    case connected
    case notConnected
    case unknown
}


enum RSRErrors: Error {
    case disallowedByUser
}


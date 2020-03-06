//
//  PermissionWorker.swift
//  RSR
//
//  Created by Ehsan on 06/03/2020.
//  Copyright © 2020 Ali C. All rights reserved.
//

import CoreLocation

class PermissionWorker: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
    
    
    func requestPermission() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw RSRErrors.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
}

//
//  MapInteractor.swift
//  RSR
//
//  Created by Ehsan on 06/03/2020.
//  Copyright (c) 2020 Ali C. All rights reserved.
//
//  This file was generated by Ali Chegini.
//  This is a simplified version of the Clean Swift Xcode Templates so
//  one can apply clean architecture to iOS and Mac projects.
//  For more info visit: http://clean-swift.com
//

import UIKit
import CoreLocation

protocol MapBusinessLogic {
    func askPermission(request: MapModels.AskForPermission.Request)
    func locateUser(request: MapModels.LocateTheUser.Request)
}

protocol MapDataStore {
  //var name: String { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {
    private let permissionWorker = PermissionWorker()
    private let locationManager = CLLocationManager()
    
    private var presenter: MapPresentable?
    
    
    init(presenter: MapPresentable) {
        super.init()
        locationManager.delegate = self
        
        self.presenter = presenter
    }
    
    
    
    func askPermission(request: MapModels.AskForPermission.Request) {
        do {
            try permissionWorker.requestPermission()
        } catch {
            print("this is error from permission worker", error)
        }
    }
    
    
    func locateUser(request: MapModels.LocateTheUser.Request) {
        locationManager.requestLocation()
    }
}



extension MapInteractor: CLLocationManagerDelegate {
    // MARK: CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // determining the address using the obtained location(coordinates)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            if let placemark = placemark {
                var stringAddress = ""
                guard let info = placemark.first else {
                    return
                }
                
                // constructing string address to show user
                if let streetName = info.thoroughfare {
                    stringAddress += "\(streetName) "
                }
                
                if let streetNumber = info.subThoroughfare {
                    stringAddress += "\(streetNumber), "
                }
                
                if let postCode = info.postalCode {
                    stringAddress += "\(postCode), "
                }
            
                if let city = info.locality {
                    stringAddress +=  "\(city)"
                }
                
                // construct response object and call presenter's method
                let response = MapModels.LocateTheUser.Response(stringLocation: stringAddress, coordinate: location.coordinate)
                self.presenter?.presentAddress(response: response)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //self.locationDelegate?.failedToObtainLocation(error)
        print(error)
    }
}
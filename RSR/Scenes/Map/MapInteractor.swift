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
import Network

protocol MapBusinessLogic {
    func askPermission(request: MapModels.AskForPermission.Request)
    func locateUser(request: MapModels.LocateTheUser.Request)
    func checkDeviceType(request: MapModels.ShowElementsForDevice.Request)
    func checkInternetConnection(request: MapModels.CheckInternetConnection.Request)
    func openAppUrl(request: MapModels.OpenAppURL.Request)
    func callTheCenter(request: MapModels.CallTheCenter.Request)
}

protocol MapDataStore {
  //var name: String { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {
    private let locationManager = CLLocationManager()
    
    private var presenter: MapPresentable?
    
    // two vars for monitoring network status
    private var networkMonitor = NWPathMonitor()
    private var queue = DispatchQueue(label: "NetworkMonitor")
    

    init(presenter: MapPresentable) {
        super.init()
        locationManager.delegate = self
        
        self.presenter = presenter
    }
    
    
    func askPermission(request: MapModels.AskForPermission.Request) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            // if status is restricted or denied completes the VIP cycle to alert the user
            let response = MapModels.AskForPermission.Response()
            presenter?.presentPermissionAlert(response: response)
        } else if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    
    func locateUser(request: MapModels.LocateTheUser.Request) {
        locationManager.requestLocation()
    }
    
    
    func checkDeviceType(request: MapModels.ShowElementsForDevice.Request) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let response = MapModels.ShowElementsForDevice.Response.init(deviceType: .phone)
            presenter?.presentElementsForDeviceType(response: response)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            let response = MapModels.ShowElementsForDevice.Response.init(deviceType: .pad)
            presenter?.presentElementsForDeviceType(response: response)
        }
    }
    
    
    func checkInternetConnection(request: MapModels.CheckInternetConnection.Request) {
        // check for internet connection
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                let response = MapModels.CheckInternetConnection.Response()
                self.presenter?.presentNetworkAlert(response: response)
                return
            }
        }
        
        networkMonitor.start(queue: queue)
    }
    
    
    func openAppUrl(request: MapModels.OpenAppURL.Request) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // open the app permission in Settings app
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func callTheCenter(request: MapModels.CallTheCenter.Request) {
        let number = "+319007788990"
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
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
        locationManager.requestLocation()
    }
}

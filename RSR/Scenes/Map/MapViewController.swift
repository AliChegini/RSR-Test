//
//  MapViewController.swift
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
import MapKit

protocol MapDisplayable: class {
    func displayAddress(viewModel: MapModels.LocateTheUser.ViewModel)
    func displayElementsForDeviceType(viewModel: MapModels.ShowElementsForDevice.ViewModel)
    func displayPermissionAlert(viewModel: MapModels.AskForPermission.ViewModel)
    func displayNetworkAlert(viewModel: MapModels.CheckInternetConnection.ViewModel)
}

class MapViewController: UIViewController, MapDisplayable, MKMapViewDelegate {
    private lazy var interactor = MapInteractor(presenter: MapPresenter(viewController: self))
    private lazy var router = MapRouter(viewController: self)
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // ring button at the bottom of scene
    @IBOutlet private weak var ringButton: UIButton!
    
    // cancel button at the top left corner of middle box view
    @IBOutlet private weak var cancelButton: UIButton!
    
    // middle yellow box containing labels and button
    @IBOutlet private weak var middleBoxView: UIView!
    
    // footerbox for ipad at the bottomof the scene
    @IBOutlet private weak var iPadFooterBoxView: UIView!
    
    // ring button inside the middle box
    @IBOutlet private weak var finalRingButton: UIButton!
    
    // swiftlint:disable force_cast
    let callout = Bundle.main.loadNibNamed("CalloutView", owner: self, options: nil)?.first as! CalloutView
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        print("viewDidLoad is getting called ")
        super.viewDidLoad()
        mapView.delegate = self
        roundTheButtons()
        checkDeviceType()
        askPermission()
        checkInternetConnection()
        locateUser()
    }
    
    fileprivate func askPermission() {
        let request = MapModels.AskForPermission.Request()
        interactor.askPermissionFor(request: request)
    }
    
    fileprivate func locateUser() {
        let request = MapModels.LocateTheUser.Request()
        interactor.locateUserFor(request: request)
    }
    
    fileprivate func checkDeviceType() {
        let request = MapModels.ShowElementsForDevice.Request()
        interactor.checkDeviceTypeFor(request: request)
    }
    
    fileprivate func checkInternetConnection() {
        let request = MapModels.CheckInternetConnection.Request()
        interactor.checkInternetConnectionFor(request: request)
    }
    
    fileprivate func openAppUrl() {
        let request = MapModels.OpenAppURL.Request()
        interactor.openAppUrlFor(request: request)
    }
    
    fileprivate func callTheCenter() {
        let request = MapModels.CallTheCenter.Request()
        interactor.callTheCenterFor(request: request)
    }
    
    func displayAddress(viewModel: MapModels.LocateTheUser.ViewModel) {
        _ = CustomAnnotation(coordinate: viewModel.coordinate, title: viewModel.address)
        callout.addressLabel.text = viewModel.address
        
        // Zooming on annotation
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: viewModel.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func displayElementsForDeviceType(viewModel: MapModels.ShowElementsForDevice.ViewModel) {
        if viewModel.deviceType == .pad {
            ringButton.isHidden = true
            iPadFooterBoxView.isHidden = false
        }
    }
        
    func displayPermissionAlert(viewModel: MapModels.AskForPermission.ViewModel) {
        createAndShowPermissionAlert()
    }
    
    func displayNetworkAlert(viewModel: MapModels.CheckInternetConnection.ViewModel) {
        createAndShowNetworkAlert()
    }
    
    @IBAction private func ringButtonAction(_ sender: UIButton) {
        hideCalloutAndRingButton()
        showMiddleBoxAndCancelButton()
    }
        
    @IBAction private func cancelButtonAction(_ sender: UIButton) {
        showCalloutAndRingButton()
        hideMiddleBoxAndCancelButton()
    }
    
    @IBAction private func finalRingButtonAction(_ sender: UIButton) {
        callTheCenter()
    }
    
    @IBAction private func iPadRingButtonAction(_ sender: UIButton) {
        callTheCenter()
    }
    
    /// Hides callout and button at the bottom of the page
    fileprivate func hideCalloutAndRingButton() {
        callout.isHidden = true
        ringButton.isHidden = true
    }
    
    /// Hides middle box and cancel button
    fileprivate func hideMiddleBoxAndCancelButton() {
        middleBoxView.isHidden = true
        cancelButton.isHidden = true
    }
    
    /// Shows callout and button at the bottom of the page
    fileprivate func showCalloutAndRingButton() {
        UIView.transition(with: callout,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.callout.isHidden = false
        })
        UIView.transition(with: ringButton,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.ringButton.isHidden = false
        })
    }
    
    /// Shows middle box and cancel button
    fileprivate func showMiddleBoxAndCancelButton() {
        UIView.transition(with: middleBoxView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.middleBoxView.isHidden = false
        })
        UIView.transition(with: cancelButton,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.cancelButton.isHidden = false
        })
    }
    
    // Methods for Custom annotations
    //
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "UserLocation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "marker")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        callout.setup(view: view)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotation = views.first?.annotation {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
}

extension MapViewController {
    /**
    Creates  and present  alert to ask for location permission
    */
    fileprivate func createAndShowPermissionAlert() {
        let alert = UIAlertController(title: "Location Permission",
                                      message:
            "Please authorize RSR to find your location while using the app.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: false) {
                self.openAppUrl()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
    Creates  and present  alert to alert user about connection issue
    */
    func createAndShowNetworkAlert() {
        let alert = UIAlertController(title: "Internet Error",
                                      message:
            "You are not connected to internet. Please check your connection and try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    /**
    Creates  rounded corners for buttons
    */
    fileprivate func roundTheButtons() {
        ringButton.layer.cornerRadius = 10
        finalRingButton.layer.cornerRadius = 10
    }
}

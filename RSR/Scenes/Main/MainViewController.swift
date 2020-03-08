//
//  MainViewController.swift
//  RSR
//
//  Created by Ehsan on 05/03/2020.
//  Copyright (c) 2020 Ali C. All rights reserved.
//
//  This file was generated by Ali Chegini.
//  This is a simplified version of the Clean Swift Xcode Templates so
//  one can apply clean architecture to iOS and Mac projects.
//  For more info visit: http://clean-swift.com
//

import UIKit

protocol MainDisplayable: class {
    func displayPrivacyAlert(viewModel: MainModels.AskForUserConsent.ViewModel)
    func displayElementsForDeviceType(viewModel: MainModels.ShowElementsForDevice.ViewModel)
}

class MainViewController: UIViewController, MainDisplayable {
    lazy var interactor: MainBusinessLogic = MainInteractor(presenter: MainPresenter(viewController: self))
    lazy var router = MainRouter(viewController: self)

    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var iPadPrivacyButton: UIButton!
    
    // defaults to save user consent on privacy policy
    let defaults = UserDefaults.standard
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundTheButtons()
        
        checkDeviceType()
        checkUserConsent()
    }
    
    
    func displayPrivacyAlert(viewModel: MainModels.AskForUserConsent.ViewModel) {
        createAndShowAlert()
    }
    
    
    func displayElementsForDeviceType(viewModel: MainModels.ShowElementsForDevice.ViewModel) {
        if viewModel.deviceType == .pad {
            // hide the navigation bar button and show the ipad button
            navigationItem.rightBarButtonItem = nil
            iPadPrivacyButton.isHidden = false
        }
    }
    
    
    fileprivate func checkDeviceType() {
        let request = MainModels.ShowElementsForDevice.Request()
        interactor.checkDeviceType(request: request)
    }
    
    fileprivate func checkUserConsent() {
        let request = MainModels.AskForUserConsent.Request()
        interactor.checkUserConsent(request: request)
    }
    
    
    @IBAction func policyButtonAction(_ sender: UIBarButtonItem) {
        createAndShowAlert()
    }
    
    @IBAction func iPadPrivacyButtonAction(_ sender: UIButton) {
        createAndShowAlert()
    }
    
    
    
    fileprivate func roundTheButtons() {
        showMapButton.layer.cornerRadius = 10
        iPadPrivacyButton.layer.cornerRadius = 10
    }
    
    fileprivate func createAndShowAlert() {
        let alert = UIAlertController(title: nil, message: "Om gebruik te maken van deze app dient u het privacybeleid te accepteren", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Accepteren", style: .default, handler: { (action) in
            // save in user defaults
            self.defaults.set(true, forKey: "PrivacyConsent")
        }))
        
        alert.addAction(UIAlertAction(title: "Ga naar privacybeleid", style: .default, handler: { (action) in
            // open link in browser
            if let url = URL(string: "https://www.rsr.nl/index.php?page=privacy-wetgeving") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: Boiler plate code
    
//    func doSomething() {
//        let request = Main.Something.Request()
//        interactor?.doSomething(request: request)
//    }
//
//    func displaySomething(viewModel: MainModels.ViewModel) {
//        //nameTextField.text = viewModel.name
//    }
}

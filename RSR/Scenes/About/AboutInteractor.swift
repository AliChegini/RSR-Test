//
//  AboutInteractor.swift
//  RSR
//
//  Created by Ehsan on 11/03/2020.
//  Copyright (c) 2020 Ali C. All rights reserved.
//
//  This file was generated by Ali Chegini.
//  This is a simplified version of the Clean Swift Xcode Templates so
//  one can apply clean architecture to iOS and Mac projects.
//  For more info visit: http://clean-swift.com
//

import UIKit

protocol AboutBusinessLogic {
    func checkDeviceType(request: AboutModels.ShowElementsForDevice.Request)
//    func doSomething(request: About.Something.Request)
}

protocol AboutDataStore {
  //var name: String { get set }
}

class AboutInteractor: AboutBusinessLogic, AboutDataStore {
    var presenter: AboutPresentable?

    init(presenter: AboutPresentable) {
        self.presenter = presenter
    }
    func checkDeviceType(request: AboutModels.ShowElementsForDevice.Request) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let response = AboutModels.ShowElementsForDevice.Response(deviceType: .phone)
            presenter?.presentElementsForDeviceType(response: response)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            let response = AboutModels.ShowElementsForDevice.Response(deviceType: .pad)
            presenter?.presentElementsForDeviceType(response: response)
        }
    }
  // MARK: Boiler plate code 
//    func doSomething(request: AboutModels.Request) {
//        worker = AboutWorker()
//        worker?.doSomeWork()
//
//        let response = AboutModels.Response()
//        presenter?.presentSomething(response: response)
//    }
}

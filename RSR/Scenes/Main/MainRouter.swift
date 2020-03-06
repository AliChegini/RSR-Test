//
//  MainRouter.swift
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

protocol MainRoutable {
//    func doSomething()
}


class MainRouter: MainRoutable {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    
    // All the routing and data passing logic will be here
    func doSomething() {
        // routing to next viewContoller
        // let vc = destinationVC
        
        // passing data to other contoller
        //vc.router.dataStore = input
        
        //viewContoller.present(vc)
    }
    
}

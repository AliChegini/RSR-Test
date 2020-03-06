//
//  MainPresenter.swift
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

protocol MainPresentable {
//    func presentSomething(response: MainModels.Response)
}

class MainPresenter: MainPresentable {
    weak var viewController: MainDisplayable?
  
    init(viewController: MainDisplayable) {
        self.viewController = viewController
    }
    
  // MARK: Do something
  
//    func presentSomething(response: MainModels.Response) {
//        let viewModel = MainModels.ViewModel()
//
//        viewController?.displaySomething(viewModel: viewModel)
//    }
    
  // func to display error can be added here

}

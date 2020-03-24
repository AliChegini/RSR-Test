//
//  CalloutView.swift
//  RSR
//
//  Created by Ehsan on 21/03/2020.
//  Copyright © 2020 Ali C. All rights reserved.
//

import UIKit
import MapKit

class CalloutView: UIView {
    // swiftlint:disable private_outlet
    @IBOutlet weak var addressLabel: UILabel!
    
    func setup(view: MKAnnotationView) {
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            // auto layout constraints for callout
            self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            self.widthAnchor.constraint(equalToConstant: 250),
            self.heightAnchor.constraint(equalToConstant: 250),
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -9)
            ])
    }
}

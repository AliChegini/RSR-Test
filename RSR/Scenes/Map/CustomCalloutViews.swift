//
//  CustomCalloutViews.swift
//  RSR
//
//  Created by Ehsan on 06/03/2020.
//  Copyright © 2020 Ali C. All rights reserved.
//

import UIKit

class CustomCalloutViews: UIView {
    
    // label at the top
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Uw locatie:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        
        return label
    }()
    
    
    // label in the middle
    let addressLabel: UILabel = {
        
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 2
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.font = UIFont.systemFont(ofSize: 18)
        addressLabel.textColor = .white
        
        return addressLabel
    }()
    
    
    // label at the bottom
    let instructionLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Onthoud deze locatie voor het telefoongesprek."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        
        return label
    }()
    
    
   // calloutView contains all the labels
    let calloutView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.image = UIImage(named: "address_back")
        
        return view
    }()
    
    

    
    func setupViews(view: UIView) {
        calloutView.addSubview(titleLabel)
        calloutView.addSubview(addressLabel)
        calloutView.addSubview(instructionLabel)
        
        view.addSubview(calloutView)
        
        NSLayoutConstraint.activate([
            // auto layout constraints for titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: calloutView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: calloutView.topAnchor, constant: 20),
            
            // auto layout constraints for addressLabel
            addressLabel.centerXAnchor.constraint(equalTo: calloutView.centerXAnchor),
            addressLabel.centerYAnchor.constraint(equalTo: calloutView.centerYAnchor),
            addressLabel.widthAnchor.constraint(equalTo: calloutView.widthAnchor),
            
            // auto layout constraints for instructionLabel
            instructionLabel.centerXAnchor.constraint(equalTo: calloutView.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: calloutView.bottomAnchor, constant: -80),
            instructionLabel.widthAnchor.constraint(equalTo: calloutView.widthAnchor),
            
            // auto layout constraints for calloutView
            calloutView.bottomAnchor.constraint(equalTo: view.topAnchor),
            calloutView.widthAnchor.constraint(equalToConstant: 250),
            calloutView.heightAnchor.constraint(equalToConstant: 250),
            calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
            ])
    }
    
}


extension UIView {
    
    func round(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}

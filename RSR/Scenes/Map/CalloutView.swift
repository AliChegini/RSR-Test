//
//  CalloutView.swift
//  RSR
//
//  Created by Ehsan on 21/03/2020.
//  Copyright © 2020 Ali C. All rights reserved.
//

import UIKit


@IBDesignable
class CalloutView: UIView {
    @IBOutlet weak var calloutView: UIImageView!
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius     }
    }
    
}

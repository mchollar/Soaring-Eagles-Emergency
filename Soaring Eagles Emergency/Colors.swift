//
//  Colors.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/26/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    
    static func addGradient(to view: UIView, color1: UIColor, color2: UIColor, alpha: Float = 1.0){
        
        if let oldLayerIndex = view.layer.sublayers?.firstIndex(where: {$0.name == "gradientLayer"}) {
            view.layer.sublayers?.remove(at: oldLayerIndex)
        }
        
        let gradient:CAGradientLayer = CAGradientLayer()
        //let maxSide = view.frame.size.width > view.frame.size.height ? view.frame.size.width : view.frame.size.height
        //let maxSize = CGSize(width: maxSide, height: maxSide)
        gradient.frame.size = view.frame.size
        gradient.colors = [color1.cgColor, color2.cgColor, color1.cgColor]
        gradient.opacity = alpha
        gradient.name = "gradientLayer"
        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

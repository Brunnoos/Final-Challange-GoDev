//
//  UIButton+extensions.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 06/04/22.
//

import Foundation
import UIKit

extension UIButton {
    
    func shrink() {
        
        if state == .normal {
            let shrink = CABasicAnimation(keyPath: "transform.scale")
            
            shrink.fromValue = 1
            shrink.toValue = 0.9
            shrink.duration = 0.25
            shrink.autoreverses = false
            
            layer.add(shrink, forKey: nil)
        }
        
    }
    
    func expand() {
        
        if state == .highlighted {
            let expand = CABasicAnimation(keyPath: "transform.scale")
            
            expand.fromValue = 0.9
            expand.toValue = 1
            expand.duration = 0.25
            expand.autoreverses = false
            
            layer.add(expand, forKey: nil)
        }
        
    }
}

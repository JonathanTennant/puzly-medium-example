//
//  UIButton + setSoundButtonInitialState.swift
//  Puzly
//
//  Created by John on 16/12/2020.
//

import Foundation
import UIKit

extension UIButton {
    
    func setSoundButtonInitialState() {
        
        let key = "muted"
        let userDefaults = UserDefaults.standard
        let button = self
        let mute = UIImage(named: "mute")
        
        if userDefaults.bool(forKey: key) {
            
            button.setBackgroundImage(mute, for: .normal)
            
        }
    }
    
    
    
    
}

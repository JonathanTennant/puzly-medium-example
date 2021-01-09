//
//  UIView + FadeInOut.swift
//  Puzly
//
//  Created by James Tapping on 06/12/2020.
//

import Foundation
import UIKit

extension UIView {
    
    func animateFadeInOut() {
        DispatchQueue.main.async {
            
            UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                self.self.alpha = 1
            }).startAnimation()
            
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                self.self.alpha = 0
            }).startAnimation()
            
            }

    }
    
    func animateFadeIn() {
        
        DispatchQueue.main.async {
            
            UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                self.self.alpha = 1
            }).startAnimation()
            
        }
    }
    
}

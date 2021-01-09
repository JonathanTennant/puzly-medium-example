//
//  ShadowView.swift
//  Puzly
//
//  Created by James Tapping on 05/12/2020.
//

import Foundation
import UIKit

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func addBehavior() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.backgroundColor = .black
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.alpha = 0
    }
}

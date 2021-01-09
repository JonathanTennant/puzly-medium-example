//
//  CGPoint+Nearest.swift
//  Puzly
//
//  Created by John on 01/12/2020.
//

import Foundation
import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}


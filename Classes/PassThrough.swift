//
//  PassThrough.swift
//  Puzly
//
//  Created by James Tapping on 09/12/2020.
//

import Foundation
import UIKit

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

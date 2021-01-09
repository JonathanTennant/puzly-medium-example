//
//  imageTileState.swift
//  Puzly
//
//  Created by John on 27/11/2020.
//

import Foundation
import UIKit

struct imageTile {
    let tag:Int
    let image:UIImage
    var positionIsCorrect:Bool = false
    var successSoundPlayed:Bool = false
}


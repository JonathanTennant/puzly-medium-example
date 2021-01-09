//
//  SoundHelper.swift
//  Puzly
//
//  Created by John on 10/12/2020.
//

import Foundation
import AVFoundation
import UIKit

class SoundHelper {
    
    let muted = UserDefaults.standard.bool(forKey: "muted")
    var player: AVAudioPlayer?
    func playSound(name: String) {
        
        if let url = Bundle.main.url(forResource: name, withExtension: nil ) {
            player = try! AVAudioPlayer(contentsOf: url)
            
            if !muted {
            
                DispatchQueue.main.async {
                    self.player?.play()
                }

            }
        } else {
          print("No resource found")
        }
    }
    
    func stopSound() {
        
        player?.stop()
    }
}

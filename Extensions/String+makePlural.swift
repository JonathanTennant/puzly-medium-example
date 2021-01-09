//
//  String + makePlural.swift
//  Puzly
//
//  Created by James Tapping on 14/12/2020.
//

import Foundation

extension String {
    
    func makePlural(_ n : Int) -> String {
        
        if n != 1 {
            
            return self + "s "
            
        }
        
        return self + " "
    }
}

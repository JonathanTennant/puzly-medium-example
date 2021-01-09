//
//  TileMaker.swift
//  Puzly
//
//  Created by John on 27/11/2020.
//

import Foundation
import UIKit

struct TileMaker {
    
    func makeTiles(image: UIImage, row : Int , column : Int) -> [UIImage] {

        var imageArr:[UIImage] = []
        
        let userImage = image
        
        let oImg = userImage

        let height =  (userImage.size.height) /  CGFloat (row) //height of each image tile
        let width =  (userImage.size.width)  / CGFloat (column)  //width of each image tile

        let scale = (userImage.scale) //scale conversion factor is needed as UIImage make use of "points" whereas CGImage use pixels.

        for y in 0..<row{
            var yArr = [UIImage]()
            for x in 0..<column{

                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width:width, height:height),
                    false, 0)
                let i =  oImg.cgImage?.cropping(to:  CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale  , width: (width * scale) , height: (height * scale)) )

                let newImg = UIImage.init(cgImage: i!)
                
                yArr.append(newImg)

                
                UIGraphicsEndImageContext();
            }
            
            imageArr.append(contentsOf: yArr)
        }
        
        return imageArr
    }
    
}

//
//  PhotosLoader.swift
//  Puzly
//
//  Created by John on 09/12/2020.
//

import Foundation
import UIKit

struct PhotosLoader {
     
    var photo: UIImage?
    let fileManager = FileManager.default
    let bundleURL = Bundle.main.bundleURL
    var count:Int?
    
    mutating func loadPhoto(item: Int) -> UIImage {
        
        let assetURL = bundleURL.appendingPathComponent("PlayPhotos") // Bundle URL
        do {
          let contents = try fileManager.contentsOfDirectory(at: assetURL,
         includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey],
         options: .skipsHiddenFiles)
            
         photo = UIImage(contentsOfFile: contents[item].path)
            
        }
        catch let error as NSError {
          print(error)
        }
        
        return photo!
    }
    
    mutating func photosCount() -> Int {
        
        let assetURL = bundleURL.appendingPathComponent("PlayPhotos") // Bundle URL
        do {
            let contents = try fileManager.contentsOfDirectory(at: assetURL,
            includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey],
                                                               options: .skipsHiddenFiles)
            count = contents.count
        }
        catch let error as NSError {
            print(error)
        }
        
        return count!
    }
    
}




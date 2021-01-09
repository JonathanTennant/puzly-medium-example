//
//  PuzlyBrain.swift
//  Puzly
//
//  Created by James on 30/11/2020.
//

import Foundation
import UIKit

protocol PuzlyBrainDelegate {
    
    func didFinishGame()
    func tileAndEmptyViewDidIntersect(tile: UIView, view: UIView)
    func tileInCorrectPosition()
}

struct PuzlyBrain {
    
    var tileMaker = TileMaker()
    var numberOfTiles = 16
    var bottomCellIsEmpty:[Bool] = []
    var topCellIsEmpty:[Bool] = []
    var imageTiles:[imageTile] = []
    var delegate: PuzlyBrainDelegate?
    var splitImages:[UIImage] = []
    
    
    mutating func setup(imageToTile: UIImage) {
        
        // reset the cell state and the split images for play again
        
        bottomCellIsEmpty = []
        topCellIsEmpty = []
        splitImages = []
        imageTiles = []
        
        splitImages = tileMaker.makeTiles(image: imageToTile, row: 4, column: 4)
        
        // Tag the images
        
        for i in 0...numberOfTiles - 1 {
            
            imageTiles.append(imageTile(tag: i, image: splitImages[i]))
            
        }
        
        // Setup the cell state
        
        for _ in 0...numberOfTiles - 1 {
            bottomCellIsEmpty.append(true)
            topCellIsEmpty.append(false)
        }
        
    }
    
    mutating func updateBrain(viewCollection: [UIView], imageCollection: [UIImageView], backViews: [UIView], touchedImage: UIView) {
        
        // Find the closest empty view to the tile
        
        let vcMap = viewCollection.compactMap {$0} + backViews.compactMap{$0}
        let distances = vcMap.map { $0.frame.origin.distance(to: touchedImage.frame.origin)}
        let cellsAreEmpty = bottomCellIsEmpty + topCellIsEmpty
        let combined = zip(vcMap, zip(distances, cellsAreEmpty)).map { ( $0.0, $0.1.0, $0.1.1 ) }
        let trueCells = combined.filter { $0.2 == true}
        let closestView = trueCells.min { $0.1 < $1.1 }
        
        delegate?.tileAndEmptyViewDidIntersect(tile: touchedImage, view: closestView!.0)
        
        // MARK:- Top Cell position and empty/full checks
        
        
        // Set the top cell to empty
        
        for (viewIndex,backView) in backViews.enumerated() {
            
            for image in imageCollection{
                
                if image.frame != backView.frame {
                    
                    topCellIsEmpty[viewIndex] = true
                    
                }
            }
        }
        
        // Set the top cell to not empty
        
        for (backViewIndex,backView) in backViews.enumerated() {

            for image in imageCollection {

                if image.frame == backView.frame {

                    topCellIsEmpty[backViewIndex] = false
            
                }
            }
        }
        
        
        // MARK:- Bottom Cell position and empty/full checks
        
        // Loops through all views and images to check for non collisions
        
        for (viewIndex,view) in viewCollection.enumerated() {
            
            for (imageIndex, image) in imageCollection.enumerated() {
                
                if image.frame != view.frame {
                    
                    imageTiles[imageIndex].positionIsCorrect = false
                    // imageTiles[imageIndex].successSoundPlayed = false
                    bottomCellIsEmpty[viewIndex] = true
                    
                }
            }
        }
        
        // Check for empty cells and update if not empty
        
        for (viewIndex,view) in viewCollection.enumerated() {
            
            for image in imageCollection {
                
                if image.frame == view.frame {
                    
                    bottomCellIsEmpty[viewIndex] = false
                
                }
            }
        }
        
        // Loops through all views and images to check for collisions and update positionIsCorrect
        
        for view in viewCollection {
            
            for (imageIndex, image) in imageCollection.enumerated() {
                
                if image.frame == view.frame  {
                    
                    if view.tag == imageTiles[imageIndex].tag {
                        
                        imageTiles[imageIndex].positionIsCorrect = true
                        
                        if !imageTiles[imageIndex].successSoundPlayed {
                            delegate?.tileInCorrectPosition()
                            imageTiles[imageIndex].successSoundPlayed = true
                            
                        }
                    }
                }
            }
        }
        
        // Check for correct positioning of the tiles
        
        let correctCount = imageTiles.filter { $0.positionIsCorrect }
        if correctCount.count == viewCollection.count {
            
            delegate?.didFinishGame()
            
        }
    }
}

    
    


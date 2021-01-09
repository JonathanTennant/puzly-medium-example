//
//  CropViewController.swift
//  Puzly
//
//  Created by James Tapping on 08/12/2020.
//

import UIKit

class CropViewController: UIViewController {
    
    var palette = Palette()
    var recievedImage: UIImage?
    var imageToSend: UIImage?
    
    @IBOutlet weak var importedImage: UIImageView!
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        importedImage.image = recievedImage
        
        addPanGesture(view: importedImage)
        addPinchGesture(view: importedImage)
        addRotateGesture(view: importedImage)
        
        startButton.layer.cornerRadius = 5
        
        targetView.layer.borderWidth = 2
        targetView.layer.borderColor = palette.gridyPink.cgColor
        
    }
    
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cropImageButton(_ sender: Any) {
        
        targetView.layer.borderColor = .none
        
        imageToSend = makeImage(with: targetView)
        
        performSegue(withIdentifier: "playBoard", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "playBoard" {
            
            let destinationVC = segue.destination as! PlayBoardViewController
            destinationVC.recievedImage = imageToSend
        }
    }
    
    func makeImage(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    
    func addPanGesture(view: UIView) {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CropViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
        
    }
    
    func addPinchGesture(view: UIView) {
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(CropViewController.handlePinch(sender:)))
        view.addGestureRecognizer(pinch)
        
    }
    
    func addRotateGesture(view: UIView) {
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(CropViewController.handleRotate(sender:)))
        view.addGestureRecognizer(rotate)
        
    }
    
    
    @objc func handleRotate(sender: UIRotationGestureRecognizer) {
        
        guard sender.view != nil else { return }
        
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = sender.view!.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }}
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        }}
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let touchedImage = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        
        case .began, .changed:
            
            touchedImage.center = CGPoint(x: touchedImage.center.x + translation.x, y: touchedImage.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            
        case .ended:
            
            break
            
        default:
            
            break
        }
    }
}



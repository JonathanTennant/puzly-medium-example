//
//  IntroViewController.swift
//  Puzly
//
//  Created by John on 07/12/2020.
//

import UIKit


class IntroViewController: UIViewController {
    
    var photos:[UIImage] = []
    var palette = Palette()
    var photosLoader = PhotosLoader()
    
    var playImage: UIImage?
    var libraryImage: UIImage?
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        pickView.layer.cornerRadius = 10
        cameraView.layer.cornerRadius = 10
        libraryView.layer.cornerRadius = 10
        
        imagePickerController.allowsEditing = false
        
        soundButton.setSoundButtonInitialState()
        
        
        
        
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var soundButton: SoundOnOffButton!
    
    
    @IBAction func didTapPickButton(_ sender: Any) {
        
        collectionView.animateFadeIn()
        pickView.alpha = 0
        
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapLibraryButton(_ sender: Any) {
        
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        
    }
    
}

extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 128, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosLoader.photosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosCollectionViewCell
        
        DispatchQueue.main.async { [self] in
            
            cell.photoImage.image = self.photosLoader.loadPhoto(item: indexPath.row)
            cell.photoImage.layer.cornerRadius = 10
            
        }
        
        cell.photoImage.image = photosLoader.loadPhoto(item: indexPath.row)
        cell.photoImage.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
        playImage = selectedCell.photoImage.image        
        collectionView.alpha = 0
        pickView.alpha = 1
        
        performSegue(withIdentifier: "playBoard", sender: self)
        
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "playBoard" {
                
                let destinationVC = segue.destination as! PlayBoardViewController
                    destinationVC.recievedImage = playImage
        }
            
            if segue.identifier == "cropBoard" {
                
                let destinationVC = segue.destination as! CropViewController
                    destinationVC.recievedImage = playImage
        }
    }
}

extension IntroViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        playImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "cropBoard", sender: self)
        
    }
}


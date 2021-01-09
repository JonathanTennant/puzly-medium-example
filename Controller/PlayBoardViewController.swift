//
//  PlayBoardViewController.swift
//  Puzly
//
//  Created by James on 24/11/2020.
//

import UIKit
import AVFoundation
import SwiftMessages

class PlayBoardViewController: UIViewController {
    
    var recievedImage: UIImage?
    var moves = 0
    var gridyBrain = PuzlyBrain()
    var timerHelper = TimerHelper()
    var soundHelper = SoundHelper()
    var shadowView = ShadowView()
    var palette = Palette()
    let impactGenerator = UIImpactFeedbackGenerator()
    var counter = 0.0
    var timer = Timer()
    var timePassed: String = ""
    var timePassedText: String = ""
    let timerView = MessageView.viewFromNib(layout: .statusLine)
    var config = SwiftMessages.Config()
    var tileOrigin:[CGRect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }

        view.addSubview(shadowView)
        gridyBrain.setup(imageToTile: recievedImage!)
        gridyBrain.delegate = self
        timerHelper.delegate = self
        
        for i in imageCollection {
            addPanGesture(view: i)
        }
        
        // Put the shuffled images onto the board
        
        for i in 0...gridyBrain.numberOfTiles - 1 {

            imageCollection[i].image = gridyBrain.imageTiles[i].image
        }
            newGameButton.layer.cornerRadius = 5
            gridyTitleLabel.font = UIFont(name: "TimeBurner", size: 38)
            gridyTitleLabel.adjustsFontForContentSizeCategory = true
            gridyTitleLabel.textColor = palette.gridyLightGreen
            timerView.configureTheme(.info)
            timerView.configureDropShadow()
            timerView.configureTheme(backgroundColor: palette.gridyLightGreen, foregroundColor: palette.gridyPink)
            config.presentationStyle = .top
            config.duration = .forever
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        hintImageButton.removeAllConstraints()
        
        for i in backViews {
            i.layer.borderWidth = 1
            i.layer.borderColor = palette.gridyPink.cgColor
            i.removeAllConstraints()
        }
        
        for image in imageCollection {
            image.removeAllConstraints()
        }
        
        // Set up the board
        
        for (index,i) in viewCollection.enumerated() {
        
            i.addBorder(toEdges: [.left, .top], color: palette.gridyPink, thickness: 1)
            
            switch index {
            case 12...15:
                viewCollection[index].addBorder(toEdges: .bottom, color: palette.gridyPink, thickness: 1)
            case 3,7,11:
                viewCollection[index].addBorder(toEdges: .right, color: palette.gridyPink, thickness: 1)
            default:
                    break
            }
            viewCollection[15].addBorder(toEdges: [.bottom,.right], color: palette.gridyPink, thickness: 1)
        }
        
        visualShuffle()
        
        // Save the tile origins for replay option
        
        for image in imageCollection {
            tileOrigin.append(image.frame)
        }
    }

    @IBOutlet var viewCollection: [UIView]!
    @IBOutlet var imageCollection: [UIImageView]!
    @IBOutlet var backViews: [UIView]!
    @IBOutlet weak var gridyTitleLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton! 
    @IBOutlet weak var hintImageButton: UIButton!
    
    @IBAction func didTapNewGame(_ sender: Any) {
        
        timerHelper.stopTimer()
        SwiftMessages.hideAll()
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hintButtonPressed(_ sender: Any) {
        
            impactGenerator.impactOccurred(intensity: 50)
            hintImageView.image = recievedImage
            view.bringSubviewToFront(hintView)
            hintImageView.animateFadeInOut()
            hintView.animateFadeInOut()
    }
    
    func addPanGesture(view: UIView) {

      let pan = UIPanGestureRecognizer(target: self, action: #selector(PlayBoardViewController.handlePan(sender:)))
      view.addGestureRecognizer(pan)

    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let width = viewCollection[0].frame.width
        let touchedImage = sender.view!
        let translation = sender.translation(in: view)

        switch sender.state {

        case .began, .changed:

            shadowView.alpha = 1
            touchedImage.center = CGPoint(x: touchedImage.center.x + translation.x, y: touchedImage.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            touchedImage.frame = CGRect(x: touchedImage.frame.minX, y: touchedImage.frame.minY, width: width, height: width)
            shadowView.frame = touchedImage.frame
            view.bringSubviewToFront(touchedImage)

        case .ended:

            gridyBrain.updateBrain(viewCollection: viewCollection, imageCollection: imageCollection, backViews: backViews, touchedImage: touchedImage)
            shadowView.alpha = 0
            
        default:
            break
        }
    }
    
    func visualShuffle() {
        soundHelper.playSound(name: "shuffle.wav")
        var loop: ((Int) -> Void)!
        loop = { [weak self] count in
          guard count > 0 else { return }
            self!.gridyBrain.imageTiles.shuffle()
            self!.impactGenerator.impactOccurred(intensity: 50)
            for i in 0...self!.gridyBrain.numberOfTiles - 1 {
                self!.imageCollection[i].image = self!.gridyBrain.imageTiles[i].image
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            loop(count - 1)
          }
        }
        loop(9)
    }

    func playAgain() {
        
        gridyBrain.setup(imageToTile: recievedImage!)
        moves = 0
        score.text = String(moves)
        for (i,rect) in tileOrigin.enumerated() {
            imageCollection[i].frame = rect
        }
        visualShuffle()
    }
}

extension PlayBoardViewController: PuzlyBrainDelegate {

    func tileAndEmptyViewDidIntersect(tile: UIView, view: UIView) {
        tile.frame = view.frame
        moves += 1
        
        if moves == 1 {
            SwiftMessages.show(config:config, view: timerView)
            timerHelper.startTimer()
        }
        
        score.text = String(moves)
        impactGenerator.impactOccurred(intensity: 50)
        soundHelper.playSound(name: "move.wav")
    }

    func didFinishGame() {
        
        timerHelper.stopTimer()
        let confettiView = SAConfettiView(frame: self.view.bounds)
        view.addSubview(confettiView)
        soundHelper.playSound(name: "cheers.wav")
        confettiView.intensity = 1
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            confettiView.stopConfetti()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [self] in
            confettiView.removeFromSuperview()
            SwiftMessages.hide()
            
            self.openAlert(title: "Puzly",
                           message: "Well done, \(moves) moves in \(timePassedText)!",
                           alertStyle: .actionSheet,
                           actionTitles: ["Play Again","New Game","Share"],
                           actionStyles: [.default, .default, .default],
                           actions: [
                            {_ in
                                self.playAgain()
                            },
                            {_ in
                                self.dismiss(animated: true, completion: nil)
                            },
                            { [self]_ in
                                
                                let activityVC = UIActivityViewController(activityItems: [recievedImage!, "I completed this #Puzly puzzle in \(moves) moves, \(timePassedText). Can you do better? :)"], applicationActivities: nil)
                                activityVC.popoverPresentationController?.sourceView = self.view
                                self.present(activityVC, animated: true, completion: nil)
                            }
                           ])
        }
    }
    
    func tileInCorrectPosition() {
        soundHelper.playSound(name: "success.mp3")
    }
}

extension PlayBoardViewController: TimerHelperDelegate {
    
    func didUpdateTimer(counter: Double) {
        timePassed = timerHelper.getTimePassed(counter: counter, type: .normal)
        timePassedText = timerHelper.getTimePassed(counter: counter, type: .withText)
        timerView.bodyLabel!.text = timePassed
    }
}

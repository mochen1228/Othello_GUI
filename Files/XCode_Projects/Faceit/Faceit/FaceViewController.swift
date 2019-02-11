//
//  ViewController.swift
//  Faceit
//
//  Created by ChenMo on 4/30/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    var mouthCurvatureLevelIndex: Int = 1;
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let pinchAction = #selector(faceView.changeScale(byReactingTo:));
            let tapEyesAction = #selector(self.toggleEyes(byReactingTo:));
            let swipeAction = #selector(self.changeSmileLevel(byReactingTo:));
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: pinchAction);
            let tapEyesRecognizer = UITapGestureRecognizer(target: self, action: tapEyesAction);
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: swipeAction);
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: swipeAction);
            
            swipeDownRecognizer.direction = .down;
            swipeUpRecognizer.direction = .up;
            
            faceView.addGestureRecognizer(pinchRecognizer);
            faceView.addGestureRecognizer(tapEyesRecognizer);
            faceView.addGestureRecognizer(swipeUpRecognizer);
            faceView.addGestureRecognizer(swipeDownRecognizer);
            updateFace();
        }
    }
    
    var expression = FacialExpression(eyes: .Closed,
                                      eyeBrows: .Normal,
                                      mouth: .Frown) {
        didSet {
            updateFace();
        }
    }

    private func changeEyesInModel(using model: FacialExpression) {
        if (model.eyes == .Open) {
            expression = FacialExpression(eyes: .Closed, eyeBrows: model.eyeBrows, mouth: model.mouth);
        } else if (model.eyes == .Closed) {
            expression = FacialExpression(eyes: .Open, eyeBrows: model.eyeBrows, mouth: model.mouth);
        }
    }
    
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if (tapRecognizer.state == .ended) {
            changeEyesInModel(using: expression);
        }
    }
    
    
    func changeSmileLevel(byReactingTo swipeRecognizer: UISwipeGestureRecognizer) {
        if (swipeRecognizer.direction == .down) {
            if (mouthCurvatureLevelIndex < 4) {
                mouthCurvatureLevelIndex += 1;
            }
        }
        if (swipeRecognizer.direction == .up) {
            if (mouthCurvatureLevelIndex > 0) {
                mouthCurvatureLevelIndex -= 1;
            }
        }
        expression.mouth = mouthCurvatureLevels[mouthCurvatureLevelIndex];
    }
    
    private func updateFace() {
        switch expression.eyes {
        case .Closed:
            faceView?.eyesOpen = false;
        case .Open:
            faceView?.eyesOpen = true;
        case .Squinting:
            faceView?.eyesOpen = false;
        }
        
        faceView?.smileLevel = CGFloat(mouthCurvatures[expression.mouth] ?? 0.0)
    }
    
    
    var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0,
                           FacialExpression.Mouth.Smile: 1.0,
                           FacialExpression.Mouth.Neutral: 0,
                           FacialExpression.Mouth.Grin: 0.5,
                           FacialExpression.Mouth.Smirk: 0.25];
    
    let mouthCurvatureLevels: [FacialExpression.Mouth] = [.Frown, .Neutral, .Smirk, .Grin, .Smile];
}


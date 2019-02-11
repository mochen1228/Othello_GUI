//
//  FaceView.swift
//  Faceit
//
//  Created by ChenMo on 4/30/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable var scale: CGFloat = 0.9 { didSet { setNeedsDisplay()}};
    
    @IBInspectable var eyesOpen: Bool = false { didSet { setNeedsDisplay()}};
    
    @IBInspectable var smileLevel: CGFloat = 0.0 { didSet { setNeedsDisplay()}};
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed:
            scale *= pinchRecognizer.scale;
            pinchRecognizer.scale = 1.0;
        default:
            break;
        }
    }
    
    private struct Ratios {
        static let skullRadiusToEyesOffset:CGFloat = 3;
        static let skullRadiusToEyesRadius:CGFloat = 10;
        static let skullRadiusToMouthOffset:CGFloat = 3;
        static let skullRadiusToMouthWidth:CGFloat = 1.3;
        static let skullRadiusToMouthHeight:CGFloat = 3;

    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x:bounds.midX, y:bounds.midY);
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale;
    }
    
    private enum eyeSide {
        case left;
        case right;
    }

    
    private func createSkull() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCenter,
                                radius: skullRadius,
                                startAngle: 0,
                                endAngle: CGFloat(2 * Double.pi),
                                clockwise: true);
        path.lineWidth = 5.0
        return path;
    }
    
    
    private func createEyes(_ side: eyeSide) -> UIBezierPath {
        func createEyeCenter() -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyesOffset;
            var eyeCenter = skullCenter;
            
            eyeCenter.y -= eyeOffset;
            
            if (side == eyeSide.left) {
                eyeCenter.x -= eyeOffset;
            } else {
                eyeCenter.x += eyeOffset;
            }
            
            return eyeCenter;
        }
        let eyeCenter = createEyeCenter();
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyesRadius;
        let path: UIBezierPath;
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter,
                                radius: eyeRadius,
                                startAngle: 0,
                                endAngle: CGFloat(2 * Double.pi),
                                clockwise: true);
        } else {
            path = UIBezierPath();
            path.move(to: CGPoint(x:eyeCenter.x - eyeRadius,
                                  y:eyeCenter.y));
            path.addLine(to: CGPoint(x:eyeCenter.x + eyeRadius,
                                     y:eyeCenter.y));
        }
        path.lineWidth = 5.0
        return path;
    }
    
    
    private func createMouth() -> UIBezierPath {
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset;
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth;
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight;
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2,
                               y: skullCenter.y + mouthOffset,
                               width: mouthWidth,
                               height: mouthHeight);
        
        let smileOffset = mouthRect.height / 2 * smileLevel;

        let start = CGPoint(x: mouthRect.minX,
                            y:mouthRect.minY + mouthHeight / 2);
        let end = CGPoint(x: mouthRect.maxX,
                          y: mouthRect.minY + mouthHeight / 2);
        let ctrl1 = CGPoint(x: mouthRect.minX + mouthWidth / 3,
                            y: mouthRect.minY + mouthHeight / 2 + smileOffset);
        let ctrl2 = CGPoint(x: mouthRect.maxX - mouthWidth / 3,
                            y: mouthRect.minY + mouthHeight / 2 + smileOffset);

        
        
        let path = UIBezierPath();
        path.move(to: start);
        path.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2);
        path.lineWidth = 5.0;
        return path;
    }
    
    
    override func draw(_ rect: CGRect) {
        UIColor.blue.set();
        createSkull().stroke();
        createEyes(eyeSide.left).stroke();
        createEyes(eyeSide.right).stroke();
        createMouth().stroke();
    }

}

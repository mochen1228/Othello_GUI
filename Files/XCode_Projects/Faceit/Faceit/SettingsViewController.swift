//
//  SettingsViewController.swift
//  Faceit
//
//  Created by ChenMo on 5/10/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit

class SettingsViewController: VCLLoggingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationViewController = segue.destination
        if let face = destinationViewController as? FaceViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "openSegue":
                    face.expression = FacialExpression(eyes: .Open,
                                                       eyeBrows: face.expression.eyeBrows,
                                                       mouth: face.expression.mouth);
                case "closeSegue":
                    face.expression = FacialExpression(eyes: .Closed,
                                                       eyeBrows: face.expression.eyeBrows,
                                                       mouth: face.expression.mouth);
                default:
                    break;
                }
            }
        }
    }

}

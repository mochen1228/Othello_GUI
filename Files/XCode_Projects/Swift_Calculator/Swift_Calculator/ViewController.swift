//
//  ViewController.swift
//  Swift_Calculator
//
//  Created by ChenMo on 4/24/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberDisplay: UILabel!
    
    private var calculatorLogic = Calculator()
    
    var userIsEntering: Bool = false;
    
    var displayValue: Double {
        get {
            return Double(numberDisplay.text!)!;
        } set {
            numberDisplay.text! = String(newValue);
        }
    }
    
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!;
        
        if userIsEntering {
            numberDisplay.text! += digit;
        } else {
            numberDisplay.text! = digit;
            userIsEntering = true;
            
        }
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        if userIsEntering {
                calculatorLogic.setOperand(displayValue);
                userIsEntering = false;
        }
        if let symbol = sender.currentTitle {
            calculatorLogic.performOperation(symbol)

        }
        if let result = calculatorLogic.result {
            displayValue = result;
        }
    }
    
    
}


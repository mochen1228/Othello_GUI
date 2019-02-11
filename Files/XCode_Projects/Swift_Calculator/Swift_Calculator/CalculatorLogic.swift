//
//  CalculatorLogic.swift
//  Swift_Calculator
//
//  Created by ChenMo on 4/24/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import Foundation

struct Calculator {
    private var accumulator: Double?;
    private var pendingState: pendingOperation?;
    
    private struct pendingOperation {
        let firstOperand: Double;
        let currentOperation: (Double, Double) -> Double;
        
        func execute(_ secondOperand: Double) -> Double {
            return currentOperation(firstOperand, secondOperand);
        }
    }
    
    var result: Double? {
        get {
            return accumulator;
        }
    }
    
    mutating func performOperation(_ operation: String ){
        switch operation {
        case "C":
            accumulator = 0.0;
            pendingState = nil;
        case "+":
            if (accumulator != nil) {
                pendingState = pendingOperation(firstOperand: accumulator!,
                                                currentOperation: addition);
                accumulator = nil;
            }
        case "-":
            if (accumulator != nil) {
                pendingState = pendingOperation(firstOperand: accumulator!,
                                                currentOperation: substraction);
                accumulator = nil;
            }
        case "×":
            if (accumulator != nil) {
                pendingState = pendingOperation(firstOperand: accumulator!,
                                                currentOperation: multiplication);
                accumulator = nil;
            }
        case "÷":
            if (accumulator != nil) {
                pendingState = pendingOperation(firstOperand: accumulator!,
                                                currentOperation: division);
                accumulator = nil;
            }
        case "±":
            if (accumulator != 0) {
                accumulator = changeSign(accumulator!);
            }
        case "=":
            if (pendingState != nil && accumulator != nil) {
                accumulator = pendingState!.execute(accumulator!);
            }
        default:
            break;
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand;
    }
    
    
    // operator methods---------------------------------------------------
    
    func changeSign(_ operand: Double) -> Double {
        return -operand;
    }
    
    func addition(_ operand1: Double, _ operand2: Double) -> Double{
        return operand1 + operand2;
    }
    
    
    func substraction(_ operand1: Double, _ operand2: Double) -> Double{
        return operand1 - operand2;
    }

    
    func multiplication(_ operand1: Double, _ operand2: Double) -> Double{
        return operand1 * operand2;
    }

    
    func division(_ operand1: Double, _ operand2: Double) -> Double{
        return operand1 / operand2;
    }


    
}

//
//  ViewController.swift
//  Calculator
//
//  Created by orion on 2016-12-20.
//  Copyright (c) 2016 orion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    //private var userIsInTheMiddleOfTyping = false
    private var status = enteringStatus(userIsInTheMiddleOfTyping: false, isAFloatingPointNumber: false)
    
    @IBAction private func touchDigit(_ sender: UIButton){
        let digit = sender.currentTitle!
        if status.userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            status.userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction private func floatingPointDot(_ sender: UIButton) {
        //if it is not a floating point number do the followings
        if !status.isAFloatingPointNumber {
            if status.userIsInTheMiddleOfTyping {
                display.text! += "."
            } else {
                display.text! = "0."
                status.userIsInTheMiddleOfTyping = true
            }
            status.isAFloatingPointNumber = true
        }
    }
    
    private struct enteringStatus {
        var userIsInTheMiddleOfTyping: Bool
        var isAFloatingPointNumber: Bool
        
        mutating func resetAllStatusToTheBeginningStage() {
            userIsInTheMiddleOfTyping = false
            isAFloatingPointNumber = false
        }
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if status.userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            status.resetAllStatusToTheBeginningStage()
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
}


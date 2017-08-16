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
    private var userIsInTheMiddleOfTyping = false
    @IBOutlet weak var sequenceBoard: UILabel!
    private var isOperationButtonJustPressed = false
    
    @IBAction private func touchDigit(_ sender: UIButton){
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            if !(textCurrentlyInDisplay.contains(".") &&
                digit == ".") {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = (digit == ".") ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
        isOperationButtonJustPressed = false
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = newValue.nonFloatingNumberForm
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if !isOperationButtonJustPressed {
            if userIsInTheMiddleOfTyping {
                brain.setOperand(operand: displayValue)
                userIsInTheMiddleOfTyping = false
            }
            else {
                brain.setOperand(operand: 0)
            }
            if let mathematicalSymbol = sender.currentTitle {
                brain.performOperation(symbol: mathematicalSymbol)
            }
            displayValue = brain.result
            sequenceBoard.text = brain.operandsSequence
        }
        isOperationButtonJustPressed = true
    }
    
    @IBAction func clear(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        displayValue = 0.0
        sequenceBoard.text! = " "
        brain.backToWhereItBegins()
    }
}


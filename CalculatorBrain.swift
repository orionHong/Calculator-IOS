//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 向宏儒 on 2017-02-02.
//  Copyright © 2017 orion. All rights reserved.
//

import Foundation

func factorial(_ x: Int) -> Int {
    var num = x // x is a constant, so I assigned x to a var called num
    if (num > 1) {
        num = num * factorial(num - 1) // A recursion, Hope it will work
    }
    return num //return the var num
}

extension Double {
    //Help omit the floating point; 0.0 will be displayed as 0
    var nonFloatingNumberForm: String {
        if self == floor(self) {
            return String(Int(self))
        }
        return String(self)
    }
}

class CalculatorBrain {
    private var accumulator = (value: 0.0, description: " ")
    private var resultIsPending: Bool {
        get {
            return pending?.isSet ?? false
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = (operand, accumulator.description + operand.nonFloatingNumberForm)
    }
    
    private let operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi), //M_PI,
        "e" : Operation.Constant(M_E), //M_E
        "√" : Operation.UnaryOperation(sqrt),
        "x!" : Operation.UnaryOperation{Double(factorial(Int($0)))},
        "ln" : Operation.UnaryOperation(log),
        "log" : Operation.UnaryOperation(log10),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "x2" : Operation.UnaryOperation{ $0 * $0 },
        "×" : Operation.BinaryOperation{ $0 * $1 },
        "+" : Operation.BinaryOperation{ $0 + $1 },
        "−" : Operation.BinaryOperation{ $0 - $1 },
        "÷" : Operation.BinaryOperation{ $0 / $1 },
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = (associatedConstantValue,
                               accumulator.description + "\(symbol) " )
                executePendingOperation()
            case .UnaryOperation(let function):
                if pending == nil {
                    if accumulator.description == " " {
                        accumulator = (function(accumulator.value),
                                       "\(symbol)(\(accumulator.value.nonFloatingNumberForm)) ")
                    }
                    else {
                        accumulator = (function(accumulator.value),
                                       "\(symbol)(\(accumulator.description)) ")
                    }
                }
                else {
                    accumulator = (function(accumulator.value), accumulator.description + "\(symbol)(\(accumulator.value.nonFloatingNumberForm) ")
                }
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = pendingBinaryInfo(binaryFunction: function, firstOperand: accumulator.value, isSet: true)
                accumulator.description += " \(symbol) "
            case .Equals: executePendingOperation()
            }
        }
    }
    //For Clear Button
    func backToWhereItBegins() {
        accumulator = (value: 0.0, description: " ")
        pending = nil
    }
    
    private func executePendingOperation() {
        if pending != nil {
            accumulator.value = pending!.binaryFunction(pending!.firstOperand, accumulator.value)
            pending = nil
        }
    }
    
    private var pending: pendingBinaryInfo?
    
    private struct pendingBinaryInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var isSet: Bool
    }
    
    var result: Double {
        get {
            return accumulator.value
        }
    }
    
    var operandsSequence: String {
        get {
            if resultIsPending {
                return accumulator.description + " ..."
            }
            else {
                return accumulator.description + " ="
            }
        }
    }
}

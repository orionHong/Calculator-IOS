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

class CalculatorBrain {
    private var accumulator = 0.0
    private var description = ""
    private var resultIsPending: Bool {
        get {
            return pending?.isSet ?? false
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
        description += String(operand)
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
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
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
                accumulator = associatedConstantValue
                description += String(accumulator)
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                description += String(accumulator)
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = pendingBinaryInfo(binaryFunction: function, firstOperand: accumulator, isSet: true)
            case .Equals: executePendingOperation()
            }
        }
    }
    
    private func performBinaryOperation() {
        executePendingOperation()
        
    }
    
    private func executePendingOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
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
            return accumulator
        }
    }
}

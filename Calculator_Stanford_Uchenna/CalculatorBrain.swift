//
//  File.swift
//  Calculator_MIT
//
//  Created by Uchenna Ezeobi on 8/14/17.
//  Copyright © 2017 Uchenna Ezeobi. All rights reserved.
//

import Foundation

internal struct CalculatorBrain {
    
    var result: Double? {
        return accumulator
    }
    
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    mutating func performOperation(_ symbol: String) {
        guard let operation = operations[symbol] else { return }
        switch operation {
        case .clear:
            accumulator = 0
        case .constant(let value):
            accumulator = value
        case .unaryOperation(let function):
            if let operand = accumulator {
                accumulator = function(operand)
            }

        case .binaryOperation(let function):
            if accumulator != nil {
                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
            }
        case .operationNoArguments(let function):
            accumulator = function()
        case .equals:
            performBinaryOperation()
        }
        
    }
    


    weak var numberFormatter: NumberFormatter?
    
    fileprivate var formattedAccumulator: String? {
        if let number = accumulator {
            return numberFormatter?.string(from: number as NSNumber) ?? String(number)
        } else {
            return nil
        }
    }
    
    
    
    fileprivate var accumulator: Double?
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double)-> Double)
        case binaryOperation((Double, Double)-> Double)
        case operationNoArguments (()->Double)
        case equals
        case clear
    }
    
    fileprivate var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "%": Operation.unaryOperation({ $0/100 }),
        "sin": Operation.unaryOperation(sin),
        "cos": Operation.unaryOperation(cos),
        "tan": Operation.unaryOperation(tan),
        "Ran": Operation.operationNoArguments({ Double(drand48()) }),
        "±": Operation.unaryOperation { -$0 },
        "×": Operation.binaryOperation(*),
        "÷": Operation.binaryOperation(/),
        "+": Operation.binaryOperation(+),
        "-": Operation.binaryOperation(-),
        "=": Operation.equals,
        "C": Operation.clear,
    ]
    
    fileprivate mutating func performBinaryOperation() {
        guard pendingBinaryOperation != nil && accumulator != nil else { return }
        accumulator = pendingBinaryOperation!.perform(with: accumulator!)
        pendingBinaryOperation = nil
    }
    
    fileprivate var pendingBinaryOperation: PendingBinaryOperation?
    
    fileprivate struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

}

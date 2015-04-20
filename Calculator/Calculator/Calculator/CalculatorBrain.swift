//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ray Tran on 10/04/2015.
//  Copyright (c) 2015 Ray Tran. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Constant(String, Double)
        
        var description: String {
            get {
                switch (self) {
                case .BinaryOperation(let symbol, _): return symbol
                case .UnaryOperation(let symbol, _): return symbol
                case .Operand(let operand): return "\(operand)"
                case .Constant(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var history = [String]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("÷", /))
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("−", -))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("π", M_PI))
    }
    
    func evaluate () -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(remainingOps)
                    if let op2 = op2Evaluation.result {
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_, let value):
                return (value, remainingOps)
            }
        }
        return (nil, ops)
    }

    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        history.append("\(operand)")
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            history.append(symbol)
        }
        return evaluate()
    }
    
    func getHistory() -> [(String)] {
        return history
    }
}
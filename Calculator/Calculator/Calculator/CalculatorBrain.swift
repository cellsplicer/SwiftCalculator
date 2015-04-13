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
        
        var description: String {
            get {
                switch (self) {
                case .BinaryOperation(let symbol, _): return symbol
                case .UnaryOperation(let symbol, _): return symbol
                case .Operand(let operand): return "\(operand)"
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        // TODO: use learnOp
        // TODO: implement sqrt
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["×"] = Op.BinaryOperation("×") {$0 * $1}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["+"] = Op.BinaryOperation("+") {$0 + $1}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    func evaluate () -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
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
            }
        }
        return (nil, ops)
    }

    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
//
//  ViewController.swift
//  Calculator
//
//  Created by Ray Tran on 9/04/2015.
//  Copyright (c) 2015 Ray Tran. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, HistoryViewControllerDelegate
{
    @IBOutlet weak var display: UILabel!
    
    var userIsTyping : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var calculatorBrain = CalculatorBrain()
    
    var hvcDelegate : HistoryViewControllerDelegate! = nil
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(digit == ".") {
            // . entered, special cases
            if(display.text!.rangeOfString(".") != nil) {
                // Operand already contains .
                return
            }
            if(display.text! == "0") {
                // Append . to 0
                display.text = display.text! + digit
                userIsTyping = true
                return;
            }
        } else if (digit == "0") {
            // 0 entered, special cases
            if(display.text! == "0") {
                // Display is "0", do not add more 0s
                return
            }
        }
        // All other digits
        if(userIsTyping) {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!;
        if(userIsTyping) {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = calculatorBrain.performOperation(operation) {
                displayValue = result
            } else {
                // TODO display NIL
                displayValue = 0;
            }
        }
    }

    @IBAction func backspace() {
        var text = display.text as String!
        if(userIsTyping && count(text) > 2) {
            display.text! = text.substringToIndex(advance(text.startIndex, count(text) - 1))
        } else {
            display.text! = "0";
        }
    }
    
    @IBAction func clear() {
        // Clear display and use a new brain
        display.text! = "0"
        userIsTyping = false
        calculatorBrain = CalculatorBrain()
    }
    
    @IBAction func enter() {
        userIsTyping = false;
        if let result = calculatorBrain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // TODO display NIL
            displayValue = 0;
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsTyping = false;
        }
    }
    
    func giveStringForIndex(index: Int) -> String {
        return calculatorBrain.getHistory()[index]
    }
    
    func giveNumberOfRows() -> Int {
        return calculatorBrain.getHistory().count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let vc = segue.destinationViewController as! HistoryViewController
        vc.historyViewControllerDelegate = self
        vc.popoverPresentationController!.delegate = self
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}


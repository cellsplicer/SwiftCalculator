//
//  ViewController.swift
//  Calculator
//
//  Created by Ray Tran on 9/04/2015.
//  Copyright (c) 2015 Ray Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController
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
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
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
}


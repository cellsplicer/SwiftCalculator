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

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsTyping) {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
}


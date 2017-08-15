//
//  ViewController.swift
//  Calculator_Stanford_Uchenna
//
//  Created by Uchenna Ezeobi on 8/15/17.
//  Copyright © 2017 Uchenna Ezeobi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    private var brain: CalculatorBrain = CalculatorBrain()
    private var numberFormatter = NumberFormatter()
    
    var userIsInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
            
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    var displayValue: Double {
        set {
            display.text = numberFormatter.string(from: newValue as NSNumber)
        }
        get {
            return Double(display.text!)!
        }
    }
    
    @IBAction private func backSpace()
    {	guard userIsInTheMiddleOfTyping else { return }
        var removedLastDigit = String(display.text!.characters.dropLast())
        
        if removedLastDigit.characters.last == "." {
            display.text = String(removedLastDigit.characters.dropLast())
        } else {
            display.text = removedLastDigit
        }
        
        
        if display.text?.characters.count == 0
        {	displayValue = 0.0
            userIsInTheMiddleOfTyping = false
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumFractionDigits = 6
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.minimumIntegerDigits = 1
        brain.numberFormatter = numberFormatter
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


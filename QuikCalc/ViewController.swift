//
//  ViewController.swift
//  QuikCalc
//
//  Created by Robert O'Connor on 12/02/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import UIKit
import AudioToolbox

/*
    1. User presses digit - number appended to string (up to 10 digits)
    2. User presses operator:
        - number converted to int
        - operator logged
        - gets ready for next number
    3. User presses =
        - currentTotal displayed (including any calculated value)
    4. User presses AC
        - All clear
    5. User presses Del:
        - last digit of displayLabel deleted
        - if 0 or 1 digits, back to 0
*/


class ViewController: UIViewController {
    
    // does this require a limiter? So as to only display a certain number of characters?
    @IBOutlet weak var displayLabel: UILabel!
    //displayLabel = [displayLabel substringToIndex:8];
    // or should it be done in InterfaceBuilder?
    
    var firstNumber:Double = 0;
    var secondNumber:Double = 0;
    var answer:Double = 0;
    var currentTotal:Int = 0;
    var operation:String?
    var kickSound: SystemSoundID!
    var snareSound: SystemSoundID!
    var clapSound: SystemSoundID!
    var hihatSound: SystemSoundID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.text = "\(currentTotal)"
        createSounds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        If 0 display, start a new one, otherwise append
    
        If operator set, start new number
    
        Is this it?
    */
    func createSounds(){
        var soundID: SystemSoundID = 0
        var soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "kick", "wav", nil)
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        kickSound = soundID
        soundID++
        soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "snare", "wav", nil)
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        snareSound = soundID
        soundID++
        soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "clap", "wav", nil)
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        clapSound = soundID
        soundID++
        soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "hihat", "wav", nil)
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        hihatSound = soundID
        soundID++
    }
    
    @IBAction func pressNumber(sender: AnyObject) {
        
        if let digit = (sender as UIButton).titleLabel?.text {
            if((NSString(string: displayLabel.text!)).doubleValue == answer){
                displayLabel.text! = "0"
            }
            if(displayLabel.text! != "0"){
                displayLabel.text! += digit
           }
            else{
                displayLabel.text = digit
            }
        }
    }
    
    /*
        If no currentValue, copy in displayLabel. Set operator
        If currentValue, set operator and recalculate
        Is this it?
    */
    @IBAction func pressOperator(sender: AnyObject) {
        firstNumber = (NSString(string: displayLabel.text!)).doubleValue
        //NSLog("%d", firstNumber)
        
        let o:String! = (sender as UIButton).titleLabel?.text
        
        switch(o){
            case "+":
                // add operation
                operation = "+"
            displayLabel.text = "0"
            case "-":
                // subtract operation
                operation = "-"
            displayLabel.text = "0"
            case "x":
                // multiply operation
                operation = "x"
            displayLabel.text = "0"
            case "/":
                // divide operation
                operation = "/"
            displayLabel.text = "0"
        default:
            operation = nil
        }
    }

    /*
        Perform calculation and display result
    */
    @IBAction func equalsOp (sender: AnyObject) {
        secondNumber = (NSString(string: displayLabel.text!)).doubleValue
        //secondNumber = (displayLabel.text!).toInt()!
        //NSLog("%d", secondNumber)
        if operation == "+"
        {
            answer = firstNumber + secondNumber
        }
        if operation == "-"
        {
            answer = firstNumber - secondNumber
        }
        if operation == "x"
        {
            answer = firstNumber * secondNumber
        }
        else if operation == "/"
        {
            answer = firstNumber / secondNumber
        }
        displayLabel.text = "\(answer)"
        //NSLog("%d", currentTotal)
    }
    
    /*
        Reset all values
    */
    @IBAction func clearOp (sender: AnyObject) {
        currentTotal = 0
        operation = nil
        
        displayLabel.text = "\(currentTotal)"
    }
    
    /*
        if displayLabel has more than one digit, append
        else reset to 0
    */
    @IBAction func deleteOp (sender: AnyObject) {
        var display:String! = displayLabel.text
        
        if(countElements(display) > 1){
            display = dropLast(display)
        }
        else{
            display = "0"
        }
        
        displayLabel.text = "\(display)"
    }
    @IBAction func playKick(sender: AnyObject) {
        println("Playing Kick Sound")
        AudioServicesPlaySystemSound(kickSound)
    }
    @IBAction func playSnare(sender: AnyObject) {
        println("Playing Snare Sound")
        AudioServicesPlaySystemSound(snareSound)
    }
    @IBAction func playClap(sender: AnyObject) {
        println("Playing Clap Sound")
        AudioServicesPlaySystemSound(clapSound)
    }
    @IBAction func playHihat(sender: AnyObject) {
        println("Playing Hihat Sound")
        AudioServicesPlaySystemSound(hihatSound)
    }
    
}


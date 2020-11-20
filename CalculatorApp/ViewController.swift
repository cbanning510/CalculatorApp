//
//  ViewController.swift
//  CalculatorApp
//
//  Created by chris on 11/20/20.
//

import UIKit

class ViewController: UIViewController {
    var currentDisplay = "0"
    var currentNumber = Double()
    var doesFirstNumberExist = false
    var doesSecondNumberExist = false
    var firstNumber = "" // assigned when operator is selected
    var isACButtonShowing = true
    var isCalculating = false
    var secondNumber = ""
    var secondNumberStarted = false
    var selectedOperator = ""
    
    let operatorDic = [ 1: "/", 2: "*", 3: "-", 4: "+"]
    let orangeButtonImageNames = [1: "orangeDivide", 2: "orangeMultiply", 3: "orangeSubtract", 4: "orangePlus"]
    let whiteButtonImageNames = [1: "whiteDivide", 2: "whiteMultiply", 3: "whiteSubtract", 4: "whitePlus"]
    
    // outlet collections:
    @IBOutlet var allButtons: [UIButton]?
    @IBOutlet var collectionOfOperatorButtons: [UIButton]?
    @IBOutlet var operatorButtonsNoEquals: [UIButton]?
    
    @IBOutlet weak var ACButton: UIButton!
    @IBOutlet weak var decimalPointButton: UIButton!
    @IBOutlet weak var displayLbl: UITextField!
    @IBOutlet weak var equalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.displayLbl.frame.height))
        displayLbl.rightView = paddingView // adds padding to calculator display label
        displayLbl.rightViewMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        self.viewWillLayoutSubviews()
        addBorderRadius(buttons: allButtons!) // these didn't render correctly in ViewDidLoad()
        configureOperatorButtonImageInsets(buttons: collectionOfOperatorButtons!)
        view.layoutIfNeeded()
               view.setNeedsLayout()
    }
    
    func configureOperatorButtonImageInsets(buttons: [UIButton]) {
        for button in buttons {
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        }
    }
    
    func resetAllOperatorButtonImages(buttons: [UIButton]) {
        for button in buttons {
            let imageName = whiteButtonImageNames[button.tag]
            button.backgroundColor = #colorLiteral(red: 1, green: 0.625041306, blue: 0.04110216349, alpha: 1)
            button.setImage(UIImage(named: imageName!), for: .normal)
        }
    }
    
    func addBorderRadius(buttons: [UIButton]) {
        for button in buttons {
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    func validateAndDisplay(currentDisplay: String) {  // for every number button pressed:
        isCalculating = true
        guard Double(currentDisplay) != nil else { return }
        displayLbl.text = currentDisplay
    }
    
    func changeACButtonToC() {  // change text of AC button
        if isACButtonShowing == true {
            isACButtonShowing = false
            ACButton.setTitle("C", for: .normal)
        }
    }
    
    func formatNumber(num: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        let dblNum = Double(String(format: "%.6f", num))!
        
        if dblNum.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Double(String(format: "%.0f", num))!)
                .replacingOccurrences(of: ".0*$", with: "", options: .regularExpression)
        }
        
        return String(Double(String(format: "%.6f", num))!)
    }
    
    func resetAll() {  // AC button
        resetAllOperatorButtonImages(buttons: operatorButtonsNoEquals!)
        firstNumber = ""
        secondNumber = ""
        selectedOperator = ""
        currentDisplay = "0"
        currentNumber = 0
        doesFirstNumberExist = false
        doesSecondNumberExist = false
        secondNumberStarted = false
        isCalculating = false
        displayLbl.text = currentDisplay
    }
    
    func displayAndResetVars(currentNumber: Double) {   // called after performing math
        currentDisplay = formatNumber(num: currentNumber)
        firstNumber = ""
        secondNumber = ""
        selectedOperator = ""
        doesFirstNumberExist = false
        secondNumberStarted = false
        isCalculating = false
        displayLbl.text = currentDisplay
    }
    
    func selectOperator(tag: Int) {  // select +, -, * or /
        selectedOperator = operatorDic[tag]!
        
        if currentDisplay == "0" {
            return
        }
        
        firstNumber = currentDisplay
        doesFirstNumberExist = true
    }
    
    // MARK: - Button Actions
    
    @IBAction func pressACButton(_ sender: Any) {
        if ACButton.titleLabel?.text == "AC"{
            resetAll()
            
        } else if ACButton.titleLabel?.text == "C" {
            currentDisplay = "0"
            isCalculating = false
            displayLbl.text = currentDisplay
            ACButton.setTitle("AC", for: .normal)
            isACButtonShowing = true
        }
    }
    
    @IBAction func pressPercent(_ sender: Any) {
        if currentDisplay == "0" {
            return
        }
        
        currentNumber = Double(currentDisplay)! / 100
        currentDisplay = formatNumber(num: currentNumber)
        displayLbl.text = currentDisplay
    }
    
    @IBAction func pressPlusMinus(_ sender: Any) {
        if currentDisplay == "0" || currentDisplay == "0." {
            currentDisplay = "-" + currentDisplay
            displayLbl.text = currentDisplay
            isCalculating = true
            
        } else if isCalculating {
            currentNumber = Double(currentDisplay)! * -1
            currentDisplay = formatNumber(num: currentNumber)
            displayLbl.text = currentDisplay
            
        } else if !isCalculating {
            currentDisplay = "-"
            displayLbl.text = currentDisplay
            isCalculating = true
        }
    }
    
    @IBAction func pressEqualsButton(_ sender: Any) {
        resetAllOperatorButtonImages(buttons: operatorButtonsNoEquals!)
        secondNumber = currentDisplay
        
        switch (selectedOperator) {
        case "/":
            currentNumber = Double(firstNumber)! / Double(secondNumber)!
            displayAndResetVars(currentNumber: currentNumber)
        case "*":
            currentNumber = Double(firstNumber)! * Double(secondNumber)!
            displayAndResetVars(currentNumber: currentNumber)
        case "+":
            currentNumber = (Double(firstNumber)!) + (Double(secondNumber)!)
            displayAndResetVars(currentNumber: currentNumber)
        case "-":
            currentNumber = Double(firstNumber)! - Double(secondNumber)!
            displayAndResetVars(currentNumber: currentNumber)
        default:
            return
        }
        
        isCalculating = false
    }
    
    @IBAction func selectOperator(sender: Any) {
        guard let button = sender as? UIButton else { return }
        isCalculating = true
        
        if selectedOperator.count > 0 || currentDisplay == "0" {
            return
        }
        
        let imageName = orangeButtonImageNames[button.tag]
        resetAllOperatorButtonImages(buttons: operatorButtonsNoEquals!)
        
        button.backgroundColor = .white
        button.setImage(UIImage(named: imageName!), for: .normal)
        
        switch(button.tag) {
        case 1:
            selectOperator(tag: 1)
        case 2:
            selectOperator(tag: 2)
        case 3:
            selectOperator(tag: 3)
        case 4:
            selectOperator(tag: 4)
        default:
            return
        }
    }
    
    @IBAction func tapDecimalPoint(_ sender: UIButton) {
        changeACButtonToC()
        
        if currentDisplay == "0" {
            currentDisplay.append(".")
            displayLbl.text = currentDisplay
            isCalculating = true
            
        } else if !isCalculating {
            currentDisplay = "0."
            displayLbl.text = currentDisplay
            isCalculating = true
            
        } else if !doesFirstNumberExist {
            if currentDisplay.contains(".") && !isCalculating {
                currentDisplay = ".0"
                displayLbl.text = currentDisplay
                isCalculating = true
                
            } else if !currentDisplay.contains(".") {
                currentDisplay.append(".")
                displayLbl.text = currentDisplay
                isCalculating = true
                
            } else {
                return
            }
            
        } else {
            if !secondNumberStarted {
                currentDisplay = "0."
                secondNumberStarted = true
                displayLbl.text = currentDisplay
                
            } else if !currentDisplay.contains(".") {
                currentDisplay.append(".")
                displayLbl.text = currentDisplay
                
            } else {
                return
            }
        }
    }
    
    @IBAction func tapNumber(sender: AnyObject) {
        guard let button = sender as? UIButton else { return }
        
        changeACButtonToC()
        
        if button.tag == 10 {
            return
        }
        
        if currentDisplay == "0" || !isCalculating {
            currentDisplay = String(button.tag)
            validateAndDisplay(currentDisplay: currentDisplay)
            
        } else if currentDisplay == "-0" {
            currentDisplay = "-" + String(button.tag)
            validateAndDisplay(currentDisplay: currentDisplay)
            
        } else if currentDisplay == "0." || !doesFirstNumberExist {
            currentDisplay.append(String(button.tag))
            validateAndDisplay(currentDisplay: currentDisplay)
            
        } else if doesFirstNumberExist && !secondNumberStarted {
            currentDisplay = String(button.tag)
            validateAndDisplay(currentDisplay: currentDisplay)
            secondNumberStarted = true
            
        } else {
            currentDisplay.append(String(button.tag))
            validateAndDisplay(currentDisplay: currentDisplay)
            secondNumberStarted = true
        }
    }
}


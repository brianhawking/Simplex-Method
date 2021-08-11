//
//  SetupController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/6/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class SetupController: UIViewController {
    
    @IBOutlet var screenView: UIView!
    
    @IBOutlet weak var deleteButton: KeypadButton!
    var error: Bool = false
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    
    // labels
    @IBOutlet weak var centerLine: UILabel!
    @IBOutlet weak var swipeText: UILabel!
    @IBOutlet weak var testForPointSize: UILabel!
    @IBOutlet weak var subjectTo: UILabel!
    @IBOutlet weak var objective: UILabel!
    @IBOutlet var allText: [UILabel]!
    
    
    
    // pointSize for labels
    var pointSize: CGFloat = 24
    
    
    var currentRow: Int = 0
    var currentColumn: Int = 0
    var previousRow: Int = -1
    var previousColumn: Int = -1
    
    var numberOfInequalities: Int = 1
    var numberOfVariables: Int = 2
    
    let maxVariables: Int = 3
    let maxInequalities: Int = 4
    
    // matrix
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
    var equalsMatrix: [UILabel] = []
    
    
    // objective function labels
    @IBOutlet var objCoefficients: [UILabel]!
    @IBOutlet weak var maxMinLabel: UILabel!
    @IBOutlet var objVariables: [UILabel]!
    @IBOutlet var objSigns: [UILabel]!
    
    // Inequality 1 Information
    @IBOutlet var Inequality1Coefficients: [UILabel]!
    @IBOutlet var Inequality1Variables: [UILabel]!
    @IBOutlet var Inequality1Signs: [UILabel]!
    
    // Inequality 2 Information
    @IBOutlet var Inequality2Coefficients: [UILabel]!
    @IBOutlet var Inequality2Variables: [UILabel]!
    @IBOutlet var Inequality2Signs: [UILabel]!
    
    
    
    // Inequality 3 Information
    @IBOutlet var Inequality3Coefficients: [UILabel]!
    @IBOutlet var Inequality3Variables: [UILabel]!
    @IBOutlet var Inequality3Signs: [UILabel]!
    
    
    
    // Inequality 4 Information
    @IBOutlet var Inequality4Coefficients: [UILabel]!
    @IBOutlet var Inequality4Variables: [UILabel]!
    @IBOutlet var Inequality4Signs: [UILabel]!
    
    var errorMessage: String = ""
    
    
    // numberpad labels
    @IBOutlet var numberPadLabels: [KeypadButton]!
    
    fileprivate func setupGestures() {
        // add the swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        screenView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        screenView.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        screenView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        screenView.addGestureRecognizer(swipeUp)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up color scheme
//        UserDefaults.standard.set(0, forKey: "scheme")
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        screenView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        // set up pointSize
        pointSize = testForPointSize.font.pointSize
        
        
        for text in allText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        centerLine.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        
        centerLine.layer.backgroundColor = UIColor.black.cgColor
        
        setupNumberPad()
        
        setupGestures()
        
       
        
        
        // set up matrix with coefficients
        matrix.append(objCoefficients)
        matrix.append(Inequality1Coefficients)
        matrix.append(Inequality2Coefficients)
        matrix.append(Inequality3Coefficients)
        matrix.append(Inequality4Coefficients)
        
        // set up variableMatrix
        variableMatrix.append(objVariables)
        variableMatrix.append(Inequality1Variables)
        variableMatrix.append(Inequality2Variables)
        variableMatrix.append(Inequality3Variables)
        variableMatrix.append(Inequality4Variables)
        
        // set up signMatrix
        signMatrix.append(objSigns)
        signMatrix.append(Inequality1Signs)
        signMatrix.append(Inequality2Signs)
        signMatrix.append(Inequality3Signs)
        signMatrix.append(Inequality4Signs)
        
        updateMatrix()
        
        // place indicator box
        matrix[0][0].blink()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func hideEverything() {
        // make them initially invisible
        for row in matrix {
            for col in row {
                col.isHidden = true
                col.adjustsFontSizeToFitWidth = true
            }
        }
         
        for row in signMatrix {
            for col in row {
                col.isHidden = true
            }
        }
         
        for row in variableMatrix {
            for col in row {
                col.isHidden = true
            }
        }
         
        for equals in equalsMatrix {
            equals.isHidden = true
        }
    }
    
    func showEverything() {
        for i in 0...numberOfInequalities {
            for j in 0..<numberOfVariables {
                matrix[i][j].isHidden = false
                matrix[i][j].displayFraction(pointSize: pointSize)
                matrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            if(i != 0){
                matrix[i][3].isHidden = false
                matrix[i][3].displayFraction(pointSize: pointSize)
                matrix[i][3].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            
        }

        for i in 0...numberOfInequalities {
            for j in 0..<numberOfVariables-1 {
                signMatrix[i][j].isHidden = false
                signMatrix[i][j].font = UIFont.systemFont(ofSize: 0.8*pointSize)
                signMatrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            if(i != 0){
                signMatrix[i][2].isHidden = false
                signMatrix[i][2].font = UIFont.systemFont(ofSize: 0.8*pointSize)
                signMatrix[i][2].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            if(numberOfVariables == maxVariables){
                // show +z
                signMatrix[0][1].isHidden = false
                signMatrix[0][1].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
               
        }

        for i in 0...numberOfInequalities {
            for j in 0..<numberOfVariables {
                variableMatrix[i][j].isHidden = false
                variableMatrix[i][j].font = UIFont.systemFont(ofSize: 0.8*pointSize)
                variableMatrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
        }

    }
    
    func setupNumberPad() {
//        for button in numberPadLabels {
//            button.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2, alpha: 1)
//            button.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button2Text, alpha: 1), for: .normal)
//            button.tintColor = colors.UIColorFromHex(rgbValue: colors.button2Text, alpha: 1)
//        }
        
        swipeText.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        
        subjectTo.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        deleteButton.tintColor = colors.UIColorFromHex(rgbValue: colors.button1Text)
    }
    
    
    @IBAction func enterKeys(_ sender: UIButton) {
        
        if(previousRow != currentRow || previousColumn != currentColumn){
            matrix[currentRow][currentColumn].text = " "
            previousRow = currentRow
            previousColumn = currentColumn
        }
        
        switch sender.tag {
        case 1...10:
            if(matrix[currentRow][currentColumn].text! == " "){
                matrix[currentRow][currentColumn].text! = String(sender.tag-1)
            }
            else if(matrix[currentRow][currentColumn].text! != "-0"){
                matrix[currentRow][currentColumn].text! += String(sender.tag-1)
            }
            else {
                matrix[currentRow][currentColumn].text! = "-"+String(sender.tag-1)
            }
        case 11: // delete button
            switch matrix[currentRow][currentColumn].text!.count {
            case 0:
                matrix[currentRow][currentColumn].text! = " "
                return
            case 1:
                matrix[currentRow][currentColumn].text! = " "
                return
            default:
                matrix[currentRow][currentColumn].text!.removeLast()
            }
        case 12: // add/remove the negative
            if(matrix[currentRow][currentColumn].text! == "" || matrix[currentRow][currentColumn].text! == " ") {
                matrix[currentRow][currentColumn].text! = "-"
            }
            else if(!matrix[currentRow][currentColumn].text!.contains("-")){
                matrix[currentRow][currentColumn].text!.insert("-", at: matrix[currentRow][currentColumn].text!.startIndex)
            }
            else {
                matrix[currentRow][currentColumn].text!.remove(at: matrix[currentRow][currentColumn].text!.startIndex)
            }
        case 13: // selects the decimal
            if (matrix[currentRow][currentColumn].text!.contains("/")){
                return
            }
            if(matrix[currentRow][currentColumn].text! == " "){
                matrix[currentRow][currentColumn].text! = "0."
            }
            if (!matrix[currentRow][currentColumn].text!.contains(".")){
                matrix[currentRow][currentColumn].text! += "."
            }
            if(matrix[currentRow][currentColumn].text! == "."){
                matrix[currentRow][currentColumn].text! = "0."
            }
        case 14:
            if(matrix[currentRow][currentColumn].text!.contains("/") || matrix[currentRow][currentColumn].text!.contains(".")){
                return
            }
                       
            if(matrix[currentRow][currentColumn].text! != " "){
                matrix[currentRow][currentColumn].text! += "/"
            }
        default:
            return
        }
        
        matrix[currentRow][currentColumn].displayFraction(pointSize: pointSize)
        
    }
    
    
    @IBAction func maxMinButtons(_ sender: UIButton) {
        
        if(sender.tag == 20){
            // user pressed Max
            maxMinLabel.text! = "Maximize"
            objective.text! = "P"
        }
        else {
            // user pressed Min
            maxMinLabel.text! = "Minimize"
            objective.text! = "C"
        }
    }
    
    
    @IBAction func changeInequalityButton(_ sender: UIButton) {
        if(currentRow == 0){
            return
        }
        switch sender.tag {
        case 35:
            signMatrix[currentRow][2].text! = "≤"
        case 36:
            signMatrix[currentRow][2].text! = "≥"
        default:
            break
        }
    }
    
    
    func updateMatrix() {
        hideEverything()
        showEverything()
    }
    
    
    @IBAction func adjustSize(_ sender: UIButton) {
        // adjust the matrix if user adds or removes variables or equations
        switch sender.tag {
        case 32: // add variable
            if(numberOfVariables != maxVariables){
                numberOfVariables += 1
            }
        case 33: // remove variable
            if(numberOfVariables > 2){
                numberOfVariables -= 1
            }
            if(currentColumn == 2){
                currentColumn = 1
            }
                   
        case 30: // add equation
            if(numberOfInequalities != maxInequalities){
                numberOfInequalities += 1
            }
                   
        case 31: // remove equation
            if(numberOfInequalities > 1) {
                numberOfInequalities -= 1
            }
            if(currentRow > numberOfInequalities){
                currentRow -= 1
            }
        default:
            break
        }
        matrix[currentRow][currentColumn].blink()
        updateMatrix()
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        
        if error == true {
           // return
        }
        
        if(foundErrors() == true){
            
        }
        else {
            // check if it's a standard min
            var isStandardMin: Bool = false
            
            if(maxMinLabel.text! == "Minimize"){
                isStandardMin = true
            }
            
            for i in 1...numberOfInequalities {
                if(signMatrix[i][2].text! == "≤"){
                    isStandardMin = false
                }
            }
            
            if(isStandardMin == true){
               performSegue(withIdentifier: "setupDualSegue", sender: nil)
            }
            else {
              performSegue(withIdentifier: "SetupPart2Segue", sender: nil)
            }
        }
        
        
        
        
    }
    
    func foundErrors() -> Bool {
        
                // check if box is invalid
        if(matrix[currentRow][currentColumn].text! == "" || matrix[currentRow][currentColumn].text! == " " ){
            matrix[currentRow][currentColumn].text! = "1"
        }
        else if(matrix[currentRow][currentColumn].text! == "-"){
            matrix[currentRow][currentColumn].text! = "-1"
        }
        else if(matrix[currentRow][currentColumn].text! == "-."){
            openPopUpMessage(message: "I don't understand what '-.' is.  Please try entering the number again.")
           
            return true
        }
        else if(matrix[currentRow][currentColumn].text! == "."){
            openPopUpMessage(message: "You just have a decimal.  Please finish entering the number.")
           
            return true
        }
        
        // check if they're divinding by 0
        let ND = matrix[currentRow][currentColumn].text!.components(separatedBy: "/")
        if ND.count == 2 {
            if Int(ND[1]) == 0 {
                openPopUpMessage(message: "Ahhh!! You're diving by Zero")
                return true
                
            }
            
            if(ND[1] == ""){
                openPopUpMessage(message: "Ahhh!! You didn't finish writing the fraction.")
                return true
            }
        }
        return false
    }
    
}


extension SetupController {
    
    
    func checkInequalities() {
        
    }
    
    func openPopUpMessage(message: String) {
       
//        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpNotification") as! PopUpNotification
//        vc.messageText = message
//        self.present(vc, animated: true, completion: nil)
        errorMessage = message
        performSegue(withIdentifier: "PopupNotifierSegue", sender: nil)
        
       
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
    if(segue.identifier == "PopupNotifierSegue"){
        let vc = segue.destination as! PopUpNotification
        vc.messageText = errorMessage
    }
    
    if(segue.identifier == "SetupPart2Segue") {
            
            
            
            // prepare strings
            var matrixOfStrings: [[String]] = []
            for row in matrix {
                var tempRow: [String] = []
                for col in row {
                    tempRow.append(col.text!)
                }
                matrixOfStrings.append(tempRow)
            }
            
        for i in 1...numberOfInequalities {
            var countPositives: Int = 0
            for j in 0..<numberOfVariables {
                var constant: Double = 1.0
                var row: Double = 1.0
                if(matrixOfStrings[i][3].contains("/")){
                    let numeratorDenonimator = matrixOfStrings[i][3].components(separatedBy: "/")
                    let numerator = numeratorDenonimator[0]
                    let denominator = numeratorDenonimator[1]
                    constant = Double(numerator)!/Double(denominator)!
                    
                }
                else {
                    constant = Double(matrixOfStrings[i][3])!
                }
                if(matrixOfStrings[i][j].contains("/")){
                    let numeratorDenonimator = matrixOfStrings[i][j].components(separatedBy: "/")
                    let numerator = numeratorDenonimator[0]
                    let denominator = numeratorDenonimator[1]
                    row = Double(numerator)!/Double(denominator)!
                    
                }
                else {
                    row = Double(matrixOfStrings[i][j])!
                }
                
                if(constant/row > 0){
                    countPositives += 1
                }
            }
            
//            if(countPositives == 0){
//                error = true
//                switch i {
//                case 1:
//                    openPopUpMessage(message: "Your 1st inequality is invalid.")
//                case 2:
//                    openPopUpMessage(message: "Your 2nd inequality is invalid.")
//                case 3:
//                    openPopUpMessage(message: "Your 3rd inequality is invalid.")
//                default:
//                    openPopUpMessage(message: "Your 4th inequality is invalid.")
//                }
//
//            }
    
        }
        
            
            var matrixOfSigns: [[String]] = []
            for row in signMatrix {
                var tempRow: [String] = []
                for col in row {
                    tempRow.append(col.text!)
                }
                matrixOfSigns.append(tempRow)
            }
            
            var matrixOfVariables: [[String]] = []
            for row in variableMatrix {
                var tempRow: [String] = []
                for col in row {
                    tempRow.append(col.text!)
                }
                matrixOfVariables.append(tempRow)
            }
          
            let vc = segue.destination as! SetupPart2Controller
            vc.matrixOfStrings = matrixOfStrings
            vc.matrixOfSigns = matrixOfSigns
            vc.problemType = maxMinLabel.text!
            vc.numberOfInequalities = numberOfInequalities
            vc.numberOfVariables = numberOfVariables
            
            checkInequalities()
            
        }
    
    if(segue.identifier == "setupDualSegue"){
        // prepare strings
          var matrixOfStrings: [[String]] = []
          for row in matrix {
              var tempRow: [String] = []
              for col in row {
                  tempRow.append(col.text!)
              }
              matrixOfStrings.append(tempRow)
          }
        
            for i in 1...numberOfInequalities {
                var countPositives: Int = 0
                for j in 0..<numberOfVariables {
                    if(Double(matrixOfStrings[i][3])!/Double(matrixOfStrings[i][j])! > 0){
                        countPositives += 1
                    }
                }
                
//                if(countPositives == 0){
//                    error = true
//                    switch i {
//                    case 1:
//                        openPopUpMessage(message: "Your 1st inequality is invalid.")
//                    case 2:
//                        openPopUpMessage(message: "Your 2nd inequality is invalid.")
//                    case 3:
//                        openPopUpMessage(message: "Your 3rd inequality is invalid.")
//                    case 4:
//                        openPopUpMessage(message: "Your 4th inequality is invalid.")
//                    default:
//                        break
//                    }
//                    
//                    
//                }
        
            }
          
          
          var matrixOfSigns: [[String]] = []
          for row in signMatrix {
              var tempRow: [String] = []
              for col in row {
                  tempRow.append(col.text!)
              }
              matrixOfSigns.append(tempRow)
          }
          
          var matrixOfVariables: [[String]] = []
          for row in variableMatrix {
              var tempRow: [String] = []
              for col in row {
                  tempRow.append(col.text!)
              }
              matrixOfVariables.append(tempRow)
          }
        
          let vc = segue.destination as! setupDualController
          vc.matrixOfStrings = matrixOfStrings
          vc.matrixOfSigns = matrixOfSigns
          vc.problemType = maxMinLabel.text!
          vc.numberOfInequalities = numberOfInequalities
          vc.numberOfVariables = numberOfVariables
        
          checkInequalities()
    }
    
    }
}

extension SetupController {
    
    @objc func swipeGesture (sender: UISwipeGestureRecognizer?) {
    
        
        // check if box is invalid
        if(matrix[currentRow][currentColumn].text! == "" || matrix[currentRow][currentColumn].text! == " " ){
            matrix[currentRow][currentColumn].text! = "1"
        }
        else if(matrix[currentRow][currentColumn].text! == "-"){
            matrix[currentRow][currentColumn].text! = "-1"
        }
        else if(matrix[currentRow][currentColumn].text! == "-."){
            openPopUpMessage(message: "I don't understand what '-.' is.  Please try entering the number again.")
            
            return
        }
        
        else if(matrix[currentRow][currentColumn].text! == "."){
            openPopUpMessage(message: "You just have a decimal.  Please finish entering the number.")
           
            return
        }
        
        // check if they're divinding by 0
        let ND = matrix[currentRow][currentColumn].text!.components(separatedBy: "/")
        if ND.count == 2 {
            if Int(ND[1]) == 0 {
                openPopUpMessage(message: "Ahhh!! You're diving by Zero")
                return
                
            }
            
            if(ND[1] == ""){
                openPopUpMessage(message: "Ahhh!! You didn't finish writing the fraction.")
                return
            }
        }
        
        matrix[currentRow][currentColumn].stopBlink()
        
        if sender != nil {
            
            switch sender!.direction {
            case UISwipeGestureRecognizer.Direction.up: // up
                if(currentRow == 0) {
                    break
                }
                    
                    if(currentColumn == 3 && currentRow == 1){
                        currentRow -= 1
                        currentColumn = numberOfVariables-1
                    }
                    else {
                        currentRow -= 1
                    }
                case UISwipeGestureRecognizer.Direction.right: // right
                    if(currentRow == 0 && currentColumn == numberOfVariables-1) {
                        currentRow = 1
                        currentColumn = 0
                    }
                    else if(currentColumn < numberOfVariables-1){
                        currentColumn += 1
                    }
                    else if(currentColumn == numberOfVariables-1){
                        currentColumn = 3
                        
                    }
                    else if (currentColumn == 3 && currentRow != numberOfInequalities){
                        currentColumn = 0
                        currentRow += 1
                    }
                    
    
                case UISwipeGestureRecognizer.Direction.down: // down
                    if(currentRow < numberOfInequalities){
                        currentRow += 1
                    }
                case UISwipeGestureRecognizer.Direction.left: // left
                    if(currentColumn == 3){
                        currentColumn = numberOfVariables-1
                    }
                    else if(currentColumn > 0){
                        currentColumn -= 1
                    }
                    else if(currentColumn == 0 && currentRow > 1){
                        currentColumn = 3
                        currentRow -= 1
                    }
                    else if(currentColumn == 0 && currentRow == 1){
                        currentColumn = numberOfVariables-1
                        currentRow = 0
                    }
                    
                default:
                    break
                
            }
        }
        
        matrix[currentRow][currentColumn].blink()

    }
    
    
    
}

extension UILabel {
    
    func blink() {
        
        var colors = ColorScheme()
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        

        self.layer.borderColor = colors.UIColorFromHex(rgbValue: colors.backgroundText).cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = colors.UIColorFromHex(rgbValue: colors.labelBackground)
    }
}

extension UILabel {
    func stopBlink() {
        self.layer.borderWidth = 0
        self.alpha = 1;
        self.backgroundColor = .clear
        
    }
}

extension UILabel {
    func displayFraction(pointSize: CGFloat) {
        
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize, weight: UIFont.Weight.light).fontDescriptor
        let fractionFontDesc = systemFontDesc.addingAttributes(
                    [
                        UIFontDescriptor.AttributeName.featureSettings: [
                            [
                                UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                                UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                            ],
                        ]
                    ] )
                
        let ND = self.text!.components(separatedBy: "/")
            if(ND.count == 1){
                self.font = UIFont.systemFont(ofSize: pointSize)
             
            }
     
            else {
                self.font = UIFont(descriptor: fractionFontDesc, size:pointSize)
                
            }
           
    }
    
    func displayFractionV2(list: [String], pointSize: CGFloat) {


        let attribString = NSMutableAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize), NSAttributedString.Key.foregroundColor: UIColor.black])

            for fraction in list{
                attribString.addAttributes([NSAttributedString.Key.font: UIFont.fractionFont(ofSize: pointSize+4)], range: (self.text! as NSString).range(of: fraction))
            }
            

        self.attributedText = attribString

    }
       
}

extension UIFont
{
    static func fractionFont(ofSize pointSize: CGFloat) -> UIFont
    {
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize).fontDescriptor
        let fractionFontDesc = systemFontDesc.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                    ], ]
            ] )
        return UIFont(descriptor: fractionFontDesc, size:pointSize)
    }
}


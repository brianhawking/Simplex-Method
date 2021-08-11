//
//  SetupPart2Controller.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/15/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class SetupPart2Controller: UIViewController {

    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var backgroundText: [UILabel]!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    @IBOutlet weak var quadrantLabel: UILabel!
    
    // type of problem
    var problemType: String = ""
    
    // matrix of labels
    var matrixOfStrings: [[String]] = []
    var matrixOfVariables: [[String]] = []
    var matrixOfSigns: [[String]] = []
    
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
    
    @IBOutlet weak var pOrC: UILabel!
    
    // rows and columns
    var numberOfInequalities: Int = 0
    var numberOfVariables: Int = 0

    // row coeffiients
    @IBOutlet var row1Coefficients: [UILabel]!
    @IBOutlet var row2Coefficients: [UILabel]!
    @IBOutlet var row3Coefficients: [UILabel]!
    @IBOutlet var row4Coefficients: [UILabel]!
    
    // row signs
    @IBOutlet var row1Signs: [UILabel]!
    @IBOutlet var row2Signs: [UILabel]!
    @IBOutlet var row3Signs: [UILabel]!
    @IBOutlet var row4Signs: [UILabel]!
    
    // row variables
    @IBOutlet var row1Variables: [UILabel]!
    @IBOutlet var row2Variables: [UILabel]!
    @IBOutlet var row3Variables: [UILabel]!
    @IBOutlet var row4Variables: [UILabel]!
    
    // objective equation
    @IBOutlet var objectiveCoefficients: [UILabel]!
    @IBOutlet var objectiveVariables: [UILabel]!
    @IBOutlet var objectiveSigns: [UILabel]!
    
    
    
    @IBOutlet weak var row2StackView: UIStackView!
    @IBOutlet weak var row3StackView: UIStackView!
    @IBOutlet weak var row4StackView: UIStackView!
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var pointSize: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
         
         // set up size
        pointSize = descriptionLabel.font.pointSize
         
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }

        maxMinLabel.text! = problemType
        
        if(numberOfVariables == 2){
            quadrantLabel.text! = "x ≥ 0, y ≥ 0"
        }
        else if (numberOfVariables == 3){
            quadrantLabel.text! = "x ≥ 0, y ≥ 0, z ≥ 0"
        }
        quadrantLabel.displayFraction(pointSize: pointSize)
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
         
         
        matrix.append(row1Coefficients)
        matrix.append(row2Coefficients)
        matrix.append(row3Coefficients)
        matrix.append(row4Coefficients)
        
        variableMatrix.append(row1Variables)
        variableMatrix.append(row2Variables)
        variableMatrix.append(row3Variables)
        variableMatrix.append(row4Variables)
         
         
        signMatrix.append(row1Signs)
        signMatrix.append(row2Signs)
        signMatrix.append(row3Signs)
        signMatrix.append(row4Signs)
        
        switch numberOfInequalities {
        case 1:
            row2StackView.removeFromSuperview()
            row3StackView.removeFromSuperview()
            row4StackView.removeFromSuperview()
        case 2:
            row3StackView.removeFromSuperview()
            row4StackView.removeFromSuperview()
        case 3:
            row4StackView.removeFromSuperview()
        default:
            break
        }
       
        
        for j in 0..<numberOfVariables {
              objectiveCoefficients[j].text! = matrixOfStrings[0][j]
          }
          
          for i in 1...numberOfInequalities {
              for j in 0..<numberOfVariables {
                  matrix[i-1][j].text! = matrixOfStrings[i][j]
                  matrix[i-1][j].displayFraction(pointSize: pointSize)
                  
              }
              matrix[i-1][3].text! = matrixOfStrings[i][3]
              matrix[i-1][3].displayFraction(pointSize: pointSize)
              
          }
        
        for i in 1...numberOfInequalities {
           
            signMatrix[i-1][2].text! = matrixOfSigns[i][2]
        }
        
        // check if it's a standard minimization
        var numberOfGreaterThanSigns: Int = 0
        for i in 0..<numberOfInequalities {
            if(signMatrix[i][2].text! == "≥"){
                numberOfGreaterThanSigns += 1
            }
        }
        
        if(maxMinLabel.text == "Minimize" && numberOfGreaterThanSigns == numberOfInequalities){
            print("SET UP DUAL METHOD")
        }
        
        if(maxMinLabel.text == "Maximize"){
            descriptionLabel.text! = ""
        }
        if(maxMinLabel.text == "Minimize") {
            
            descriptionLabel.text = "We need to change the objective statement from \n'Minimize C ="
            
            descriptionLabel.text! += " \(objectiveCoefficients[0].text!)x + \(objectiveCoefficients[1].text!)y"
            
            if(numberOfVariables == 3){
                descriptionLabel.text! += " + \(objectiveCoefficients[2].text!)z"
            }
            
            descriptionLabel.text! += "'"
            
            
            descriptionLabel.text! += " to \n'Maximize P = -C = "
            
            
            
            maxMinLabel.text! = "Maximize"
            for coefficient in objectiveCoefficients {
                if(coefficient.text!.contains("-")){
                    coefficient.text!.removeFirst()
                }
                else {
                    coefficient.text!.insert("-", at: coefficient.text!.startIndex)
                }
                
                if(Int(coefficient.text!) == 0){
                    coefficient.text! = "0"
                }
            }
            
            descriptionLabel.text! += "\(objectiveCoefficients[0].text!)x + \(objectiveCoefficients[1].text!)y"
            if(numberOfVariables == 3){
                descriptionLabel.text! += " + \(objectiveCoefficients[2].text!)z"
            }
            descriptionLabel.text! += ". "
        }
        
        checkInequalities()
        
        reload()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    func checkInequalities() {
        
        print(numberOfInequalities)
        
        var changeSigns: Bool = false
        for i in 0..<numberOfInequalities {
           
            
            if( signMatrix[i][2].text! == "≥") {
               
                signMatrix[i][2].text! = "≤"
                changeSigns = true
                
                
                // negate the coefficients
             
                for coefficient in matrix[i] {
                    if(coefficient.text!.contains("-")){
                        coefficient.text!.removeFirst()
                    }
                    else {
                        coefficient.text!.insert("-", at: coefficient.text!.startIndex)
                    }
                    
                    if(Int(coefficient.text!) == 0){
                        coefficient.text! = "0"
                    }
                }
            }
            
        
            print("ROW ",i)
        }
        if(changeSigns == true){
            descriptionLabel.text! += "\nSome of your inequalities have ≥ signs.  Multiply both sides by -1 to make them ≤ signs."
        }
       
    }
    
    func reload() {
        hideEverything()
        showWhatsAllowed()
    }
    
    func hideEverything() {
        
        
        
        for row in matrix {
            for col in row {
                col.isHidden = true
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
        
        for col in objectiveCoefficients {
            col.isHidden = true
        }
        
        for col in objectiveVariables {
            col.isHidden = true
        }
        
        for col in objectiveSigns {
            col.isHidden = true
        }
                
    }
    
       func showWhatsAllowed(){
        
            
            
            // show the objective function
            for j in 0..<numberOfVariables {
                objectiveCoefficients[j].isHidden = false
            
            objectiveCoefficients[j].displayFraction(pointSize: pointSize)
                objectiveCoefficients[j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            
            // add the objective variables
            for j in 0..<numberOfVariables {
                objectiveVariables[j].isHidden = false
            objectiveVariables[j].displayFraction(pointSize: pointSize)
                objectiveVariables[j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            
            // add the objective signs
            for j in 0..<numberOfVariables-1 {
                objectiveSigns[j].isHidden = false
                objectiveSigns[j].displayFraction(pointSize: pointSize)
                objectiveSigns[j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
            
            
            
            // show the coefficients
            for i in 0..<numberOfInequalities {
                for j in 0..<numberOfVariables{
                    matrix[i][j].isHidden = false
                    matrix[i][j].displayFraction(pointSize: pointSize)
                    matrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                  
                }
                
                matrix[i][3].isHidden = false
                matrix[i][3].displayFraction(pointSize: pointSize)
                matrix[i][3].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
               // matrix[i][3].layer.borderWidth = 1
            }

            for i in 0..<numberOfInequalities {
                for j in 0..<numberOfVariables-1 {
                    signMatrix[i][j].isHidden = false
                    signMatrix[i][j].displayFraction(pointSize: pointSize)
                    signMatrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                    //signMatrix[i][j].layer.borderWidth = 1
                }
                signMatrix[i][2].isHidden = false
                signMatrix[i][2].displayFraction(pointSize: pointSize)
                
                signMatrix[i][2].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
               
            }

            for i in 0..<numberOfInequalities {
                for j in 0..<numberOfVariables {
                    variableMatrix[i][j].isHidden = false
                    variableMatrix[i][j].displayFraction(pointSize: pointSize)
                    variableMatrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                   
                }
                 
            }
        }
     
    


}

extension SetupPart2Controller {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if(segue.identifier == "SimplexTableSegue") {
            
            // prepare strings
            var matrixOfStrings: [[String]] = []
            
            var tempRow: [String] = []
            for coefficient in objectiveCoefficients {
                tempRow.append(coefficient.text!)
            }
            matrixOfStrings.append(tempRow)
            
            for row in matrix {
                var tempRow: [String] = []
                for col in row {
                    tempRow.append(col.text!)
                }
                matrixOfStrings.append(tempRow)
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
            
            
          
            let vc = segue.destination as! SlackVariablesController
            vc.matrixOfStrings = matrixOfStrings
            vc.matrixOfSigns = matrixOfSigns
            vc.problemType = problemType
            vc.numberOfInequalities = numberOfInequalities
            vc.numberOfVariables = numberOfVariables
            
            
        }
    }
}

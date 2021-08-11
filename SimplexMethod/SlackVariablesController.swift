//
//  SlackVariablesController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/9/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class SlackVariablesController: UIViewController {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet var backgroundText: [UILabel]!
    
    
    // type of problem
    var problemType: String = ""
    
    // matrix of labels
    var matrixOfStrings: [[String]] = []
    var matrixOfVariables: [[String]] = []
    var matrixOfSigns: [[String]] = []
    
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
    
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
    
    
    
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
    
    @IBOutlet weak var textForPointSize: UILabel!
    var pointSize: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
        
        // set up size
        pointSize = textForPointSize.font.pointSize
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
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
        
        
        
        reload()
    
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
            if(objectiveCoefficients[j].text!.contains("-")) {
                // remove negative
                objectiveCoefficients[j].text!.removeFirst()
            }
            else {
                objectiveCoefficients[j].text!.insert("-", at: objectiveCoefficients[j].text!.startIndex)
            }
            if(objectiveCoefficients[j].text! == "-0"){
                objectiveCoefficients[j].text! = "0"
            }
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
        
        objectiveSigns[2].isHidden = false
        objectiveSigns[2].displayFraction(pointSize: pointSize)
        objectiveSigns[2].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        objectiveSigns[3].isHidden = false
        objectiveSigns[3].displayFraction(pointSize: pointSize)
        objectiveSigns[3].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        
        
        // show the coefficients
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables{
                matrix[i][j].isHidden = false
                matrix[i][j].displayFraction(pointSize: pointSize)
                matrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
              //  matrix[i][j].layer.borderWidth = 1
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
            signMatrix[i][3].isHidden = false
            signMatrix[i][2].displayFraction(pointSize: pointSize)
            signMatrix[i][3].displayFraction(pointSize: pointSize)
            signMatrix[i][2].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            signMatrix[i][3].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//signMatrix[i][2].layer.borderWidth = 1
           // signMatrix[i][3].layer.borderWidth = 1
        }

        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables {
                variableMatrix[i][j].isHidden = false
                variableMatrix[i][j].displayFraction(pointSize: pointSize)
                variableMatrix[i][j].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                //variableMatrix[i][j].layer.borderWidth = 1
            }
            variableMatrix[i][3].isHidden = false
            variableMatrix[i][3].displayFraction(pointSize: pointSize)
            variableMatrix[i][3].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            //variableMatrix[i][3].layer.borderWidth = 1
        }
    }


}


extension SlackVariablesController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if(segue.identifier == "SimplexTableSegue") {
           
            // prepare matrix
            var tempMatrix: [[String]] = []
            
            for i in 0..<4 {
                var rowMatrix: [String] = []
                for j in 0..<3 {
                    rowMatrix.append(matrix[i][j].text!)
                }
                for k in 3...7 {
                    if i == (k-3) {
                        rowMatrix.append("1")
                    }
                    else {
                        rowMatrix.append("0")
                    }
                }
                rowMatrix.append(matrix[i][3].text!)
                tempMatrix.append(rowMatrix)
            }
        
            // prepare objective
            var rowMatrix: [String] = []
            for j in 0..<3 {
                rowMatrix.append(objectiveCoefficients[j].text!)
            }
            for j in 3...7 {
                if j == 7 {
                    rowMatrix.append("1")
                }
                else {
                    rowMatrix.append("0")
                }
            }
            rowMatrix.append("0")
            
            tempMatrix.append(rowMatrix)
            
            
            
            let vc = segue.destination as! simplexTableController
            vc.matrixOfStrings = tempMatrix
            vc.problemType = problemType
            vc.numberOfInequalities = numberOfInequalities
            vc.numberOfVariables = numberOfVariables
            
            
            
        }
    }
}


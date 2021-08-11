//
//  setupDualControllerV3.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/20/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class setupDualControllerV3: UIViewController {

    // info sent from user input
    var matrixOfStrings: [[String]] = []
    var problemType: String = ""
    var numberOfInequalities: Int = 0
    var numberOfVariables: Int = 0
    
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
    
    @IBOutlet var row1Coefficients: [UILabel]!
    @IBOutlet var row1Variables: [UILabel]!
    @IBOutlet var row1Signs: [UILabel]!
    
    
    @IBOutlet var row2Coefficients: [UILabel]!
    @IBOutlet var row2Variables: [UILabel]!
    @IBOutlet var row2Signs: [UILabel]!
    
    
    @IBOutlet var row3Coefficients: [UILabel]!
    @IBOutlet var row3Variables: [UILabel]!
    @IBOutlet var row3Signs: [UILabel]!
    
    
    @IBOutlet var objectiveCoefficients: [UILabel]!
    @IBOutlet var objectiveVariables: [UILabel]!
    @IBOutlet var objectiveSigns: [UILabel]!
    
    @IBOutlet weak var row2StackView: UIStackView!
    @IBOutlet weak var row3StackView: UIStackView!
    
    
    @IBOutlet var quadrant: [UILabel]!
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var pointSize: CGFloat = 24
    var offset: CGFloat = 0
    
    @IBOutlet weak var textForPointSize: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var dualSystemText: UILabel!
    
    @IBOutlet var backgroundText: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
        
        // set up size
        pointSize = textForPointSize.font.pointSize
                 
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        dualSystemText.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        switch numberOfInequalities {
        case 1:
            row2StackView.removeFromSuperview()
            row3StackView.removeFromSuperview()
        case 2:
            row3StackView.removeFromSuperview()
        default:
            break
        }
        
        matrix.append(row1Coefficients)
        matrix.append(row2Coefficients)
        matrix.append(row3Coefficients)
        matrix.append(objectiveCoefficients)
        
        signMatrix.append(row1Signs)
        signMatrix.append(row2Signs)
        signMatrix.append(row3Signs)
        signMatrix.append(objectiveSigns)
        
        variableMatrix.append(row1Variables)
        variableMatrix.append(row2Variables)
        variableMatrix.append(row3Variables)
        variableMatrix.append(objectiveVariables)
        
        updateMatrix()
   
    }
    
    func updateMatrix() {
        hideEverything()
        showWhatsAllowed()
    }
    
    func hideEverything() {
        // hide coefficients
        for row in matrix {
            for col in row {
                col.isHidden = true
                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                col.displayFraction(pointSize: pointSize)
            }
        }
        
        // hide signs
        for row in signMatrix {
            for col in row {
                col.isHidden = true
                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                col.displayFraction(pointSize: pointSize)
            }
        }
        
        // hide variables
        for row in variableMatrix {
            for col in row {
                col.isHidden = true
                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                col.displayFraction(pointSize: pointSize)
            }
        }
        
        for col in quadrant {
            col.isHidden = true
            col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            col.displayFraction(pointSize: pointSize)
        }
    }
    
    func showWhatsAllowed() {
        
        //show coefficients
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables {
                matrix[i][j].text! = matrixOfStrings[i][j]
                matrix[i][j].isHidden = false
                matrix[i][j].displayFraction(pointSize: pointSize)
                
            }
            matrix[i][4].text! = matrixOfStrings[i][4]
            matrix[i][4].isHidden = false
            matrix[i][4].displayFraction(pointSize: pointSize)
        }
        
        // show objective coeffivcients
        for j in 0..<numberOfVariables {
            objectiveCoefficients[j].isHidden = false
            objectiveCoefficients[j].text! = matrixOfStrings[3][j]
            
            objectiveCoefficients[j].displayFraction(pointSize: pointSize)
            objectiveVariables[j].isHidden = false
            
            objectiveVariables[j].displayFraction(pointSize: pointSize)
        }
        for j in 0..<numberOfVariables-1 {
            objectiveSigns[j].isHidden = false
            objectiveSigns[j].displayFraction(pointSize: pointSize)
        }
        
        // show variables
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables {
                variableMatrix[i][j].isHidden = false
                variableMatrix[i][j].displayFraction(pointSize: pointSize)
            }
        }
        
        // show signs
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables-1 {
                signMatrix[i][j].isHidden = false
                signMatrix[i][j].displayFraction(pointSize: pointSize)
            }
            signMatrix[i][3].isHidden = false
            signMatrix[i][3].displayFraction(pointSize: pointSize)
        }
        
        for j in 0..<numberOfVariables {
            quadrant[j].isHidden = false
            quadrant[j].displayFraction(pointSize: pointSize)
        }
    }
    

}

extension setupDualControllerV3 {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
      
    if(segue.identifier == "setupDualSegueV4"){
        // prepare strings
         
        
          let vc = segue.destination as! setupDualControllerV4
          vc.matrixOfStrings = matrixOfStrings
          vc.problemType = problemType
          vc.numberOfInequalities = numberOfInequalities
          vc.numberOfVariables = numberOfVariables
    }
    
    }
}

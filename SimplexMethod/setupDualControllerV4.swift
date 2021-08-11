//
//  setupDualControllerV4.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/20/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class setupDualControllerV4: UIViewController {

    // info sent from user input
    var matrixOfStrings: [[String]] = []
    var problemType: String = ""
    var numberOfInequalities: Int = 0
    var numberOfVariables: Int = 0
    
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
    
    var tempMatrix: [[String]] = []
    

    
    @IBOutlet var row1Coefficients: [UILabel]! {
        didSet {
            row1Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row1Variables: [UILabel]! {
        didSet {
            row1Variables.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row1Signs: [UILabel]! {
        didSet {
            row1Signs.sort { $0.tag < $1.tag }
        }
    }
    
    
    @IBOutlet var row2Coefficients: [UILabel]! {
        didSet {
            row2Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row2Variables: [UILabel]! {
        didSet {
            row2Variables.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row2Signs: [UILabel]! {
        didSet {
            row2Signs.sort { $0.tag < $1.tag }
        }
    }
    
    
    @IBOutlet var row3Coefficients: [UILabel]! {
        didSet {
            row3Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row3Variables: [UILabel]! {
        didSet {
            row3Variables.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row3Signs: [UILabel]! {
        didSet {
            row3Signs.sort { $0.tag < $1.tag }
        }
    }
    
    
    @IBOutlet var objectiveCoefficients: [UILabel]!
    @IBOutlet var objectiveVariables: [UILabel]!
    @IBOutlet var objectiveSigns: [UILabel]!
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var pointSize: CGFloat = 24
    var offset: CGFloat = 0
    
    @IBOutlet weak var testForPointSize: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var allText: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
                 
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        pointSize = testForPointSize.font.pointSize
        
        for text in allText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        
        for _ in 0..<5 {
            var tempRow: [String] = []
            for _ in 0..<9 {
                tempRow.append("0")
            }
            tempMatrix.append(tempRow)
        }
        
        row1Coefficients = row1Coefficients.sorted { $0.tag < $1.tag }
        row2Coefficients = row2Coefficients.sorted { $0.tag < $1.tag }
        row3Coefficients = row3Coefficients.sorted { $0.tag < $1.tag }
        
        row1Variables = row1Variables.sorted { $0.tag < $1.tag }
        row2Variables = row2Variables.sorted { $0.tag < $1.tag }
        row3Variables = row3Variables.sorted { $0.tag < $1.tag }
        
        row1Signs = row1Signs.sorted { $0.tag < $1.tag }
        row2Signs = row2Signs.sorted { $0.tag < $1.tag }
        row3Signs = row3Signs.sorted { $0.tag < $1.tag }


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
            objectiveCoefficients[j].text! = String(-1*Int(matrixOfStrings[3][j])!)
            objectiveVariables[j].isHidden = false
            objectiveCoefficients[j].displayFraction(pointSize: pointSize)
            objectiveVariables[j].displayFraction(pointSize: pointSize)
        }
        
        for j in 0..<numberOfVariables-1 {
            objectiveSigns[j].isHidden = false
        }
        objectiveSigns[3].isHidden = false
               
        // show variables
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables {
                variableMatrix[i][j].isHidden = false
            }
            variableMatrix[i][4].isHidden = false
        }
               
        // show signs
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables-1 {
                signMatrix[i][j].isHidden = false
            }
            signMatrix[i][3].isHidden = false
            signMatrix[i][4].isHidden = false
        }
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        
        
        
    }
    

}

extension setupDualControllerV4 {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if(segue.identifier == "DualToSimplexTableSegue") {
           
         
            for i in 0..<numberOfInequalities {
                for j in 0..<numberOfVariables {
                    tempMatrix[i][j] = matrixOfStrings[i][j]
                }
                tempMatrix[i][i+4] = "1"
                tempMatrix[i][8] = matrixOfStrings[i][4]
                
            }
            
            // objective
            for j in 0..<numberOfVariables {
                tempMatrix[4][j] = String(-1*Int(matrixOfStrings[3][j])!)
                
//                if(matrixOfStrings[3][j].contains("-") || matrixOfStrings[3][j].contains("–") ){
//                        // remove negative
//                    tempMatrix[4][j].removeFirst()
//                    }
//                else if(matrixOfStrings[3][j] != "0"){
//                    tempMatrix[4][j].insert("-", at: tempMatrix[4][j].startIndex)
//                }
            }
            tempMatrix[4][7] = "1"
            
           
           
            let vc = segue.destination as! simplexTableController
            vc.matrixOfStrings = tempMatrix
            vc.problemType = "Standard Min"
            vc.numberOfInequalities = numberOfInequalities
            vc.numberOfVariables = numberOfVariables
        }
    }
}


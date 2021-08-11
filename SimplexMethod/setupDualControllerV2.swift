//
//  setupDualControllerV2.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/19/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class setupDualControllerV2: UIViewController {

    // info sent from user input
    var matrixOfStrings: [[String]] = []
    var matrixOfSigns: [[String]] = []
    var problemType: String = ""
    var numberOfInequalities: Int = 0
    var numberOfVariables: Int = 0
    
    // dual
    var dualMatrixOfStrings: [[String]] = []
               
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
    
    // lines
    var verticalLine = UIView()
    var headerLine = UIView()
    var objectiveLine = UIView()
    
    // backroundtText
    
    @IBOutlet var backgroundText: [UILabel]!
    
    @IBOutlet var variables: [UILabel]! {
        didSet {
            variables.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row1Coefficients: [UILabel]! {
        didSet {
            row1Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row2Coefficients: [UILabel]! {
        didSet {
            row2Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row3Coefficients: [UILabel]! {
        didSet {
            row3Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var objectiveCoefficients: [UILabel]! {
        didSet {
            objectiveCoefficients.sort { $0.tag < $1.tag }
        }
    }
    
    var transposedMatrixOfStrings: [[String]] = []
    
    
    @IBOutlet weak var primalTableView: UIView!
    @IBOutlet weak var primalTableStack: UIStackView!
    
    @IBOutlet weak var row3StackView: UIStackView!
    @IBOutlet weak var row2StackView: UIStackView!
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    
    var pointSize: CGFloat = 24
    var offset: CGFloat = 0
    @IBOutlet weak var testForPointSize: UILabel!
    
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up color scheme
         colors.changeColorScheme(scheme: scheme)
                 
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        primalTableView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        // set up size
        pointSize = testForPointSize.font.pointSize

        let tempVariales = numberOfVariables
        let tempInequalities = numberOfInequalities
        numberOfInequalities = tempVariales
        numberOfVariables = tempInequalities
        
      //  print(matrixOfStrings)
        
        var tempArray: [[String]] = []
        
    
        for j in 0..<matrixOfStrings[0].count  {
            var rowTemp: [String] = []
            for i in 0..<matrixOfStrings.count {
                rowTemp.append(matrixOfStrings[i][j])
            }
            tempArray.append(rowTemp)
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
        
      
        // transfer matrisOfStrigs into matrix
     
        matrix.append(row1Coefficients)
        matrix.append(row2Coefficients)
        matrix.append(row3Coefficients)
        matrix.append(objectiveCoefficients)
      
        for i in 0..<tempArray.count {
            var newRow: [String] = []
            for j in 0..<tempArray[i].count {
                matrix[i][j].text! = tempArray[i][j]
                newRow.append(tempArray[i][j])
            }
            dualMatrixOfStrings.append(newRow)
        }
        
        updateMatrix()
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        offset = primalTableView.frame.size.width / CGFloat((numberOfVariables+1))
        
        
        verticalLine.removeFromSuperview()
        verticalLine = addVerticalLine(with: .black, andWidth: 2)
        primalTableView.addSubview(verticalLine)
        
        headerLine.removeFromSuperview()
        headerLine = addHorizontalLine(with: .black, andWidth: 2, line: 1)
        primalTableView.addSubview(headerLine)
        
        objectiveLine.removeFromSuperview()
        objectiveLine = addHorizontalLine(with: .black, andWidth: 2, line: numberOfInequalities+1)
        primalTableView.addSubview(objectiveLine)
        
    }
    
    func updateMatrix() {
        hideEverything()
        showWhatsAllowed()
    }
    
    func hideEverything() {
        for variable in variables {
            variable.isHidden = true
            variable.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        for row in matrix {
            for col in row {
                col.isHidden = true
                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
        }
    }
    
    func showWhatsAllowed() {
        for j in 0..<numberOfVariables {
            variables[j].isHidden = false
            variables[j].displayFraction(pointSize: pointSize)
            matrix[3][j].isHidden = false
            matrix[3][j].displayFraction(pointSize: pointSize)
            
        }
        variables[4].isHidden = false
        variables[4].displayFraction(pointSize: pointSize)
        matrix[3][4].isHidden = false
        matrix[3][4].displayFraction(pointSize: pointSize)
        
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables {
                matrix[i][j].isHidden = false
                matrix[i][j].displayFraction(pointSize: pointSize)
            }
            matrix[i][4].isHidden = false
            matrix[i][4].displayFraction(pointSize: pointSize)
        }
    }
    
    
    func addVerticalLine(with color: UIColor?, andWidth borderWidth: CGFloat) -> UIView {
            let lineHeight =  primalTableView.frame.size.height
           
       
            
            let border = UIView()
        border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            border.frame = CGRect(x: primalTableView.frame.size.width - offset, y: 0, width: borderWidth, height: lineHeight)
           // SimplexTable.addSubview(border)
           return border
        }
       
       func addHorizontalLine(with color: UIColor?, andWidth borderWidth: CGFloat, line: Int) -> UIView {
           var lineHeight =  primalTableView.frame.size.height
           lineHeight = CGFloat(Float(lineHeight) * Float(line)/Float(numberOfInequalities+2) )
           
       
            
            let border = UIView()
            border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
           border.frame = CGRect(x: 0, y: lineHeight, width: primalTableView.frame.size.width, height: borderWidth)
            //primalTableView.addSubview(border)
           return border
          
        }


}

extension setupDualControllerV2 {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
      
    if(segue.identifier == "setupDualSegueV3"){
        // prepare strings
         
        
          let vc = segue.destination as! setupDualControllerV3
          vc.matrixOfStrings = dualMatrixOfStrings
          vc.problemType = problemType
          vc.numberOfInequalities = numberOfInequalities
          vc.numberOfVariables = numberOfVariables
    }
    
    }
}

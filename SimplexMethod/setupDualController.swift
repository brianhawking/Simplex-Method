//
//  setupDualController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/18/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class setupDualController: UIViewController {

    // info sent from user input
    var matrixOfStrings: [[String]] = []
    var matrixOfSigns: [[String]] = []
    var problemType: String = ""
    var numberOfInequalities: Int = 0
    var numberOfVariables: Int = 0
               
    var matrix: [[UILabel]] = []
    var variableMatrix: [[UILabel]] = []
    var signMatrix: [[UILabel]] = []
      
    var counter: Int = 0
   
    
    @IBOutlet var backgroundText: [UILabel]!
    
    
    // row coeffiients
    @IBOutlet var row1Coefficients: [UILabel]!{
        didSet {
            row1Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row2Coefficients: [UILabel]!{
        didSet {
            row2Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row3Coefficients: [UILabel]!{
        didSet {
            row3Coefficients.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var row4Coefficients: [UILabel]!{
        didSet {
            row4Coefficients.sort { $0.tag < $1.tag }
        }
    }
       
    @IBOutlet weak var textForPointSize: UILabel!
    
    // objective equation
    @IBOutlet var objectiveCoefficients: [UILabel]! {
        didSet {
            objectiveCoefficients.sort { $0.tag < $1.tag }
        }
    }
 
    @IBOutlet var variables: [UILabel]! {
        didSet {
            variables.sort { $0.tag < $1.tag }
        }
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var primalTableView: UIView!
    @IBOutlet weak var primalTableStack: UIStackView!
    
    // stackview rows
    @IBOutlet var rowStackViews: [UIStackView]!
    @IBOutlet weak var row2StackView: UIStackView!
    @IBOutlet weak var row3StackView: UIStackView!
    @IBOutlet weak var row4StackView: UIStackView!
    
       
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var pointSize: CGFloat = 24
    var offset: CGFloat = 0
    
    // lines
    var verticalLine = UIView()
    var headerLine = UIView()
    var objectiveLine = UIView()
    
    @IBOutlet var screenView: UIView!
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
    
    var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // order the collection labels
        row1Coefficients = row1Coefficients.sorted { $0.tag < $1.tag }
        row2Coefficients = row2Coefficients.sorted { $0.tag < $1.tag }
        row3Coefficients = row3Coefficients.sorted { $0.tag < $1.tag }
        row4Coefficients = row4Coefficients.sorted { $0.tag < $1.tag }
        objectiveCoefficients = objectiveCoefficients.sorted { $0.tag < $1.tag }
        variables = variables.sorted { $0.tag < $1.tag }
        
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

        print("stack at load is ", primalTableStack.frame.size.height)
        print("view at load is", primalTableView.frame.size.height)
        height = primalTableStack.frame.size.height
        
               // set up color scheme
        colors.changeColorScheme(scheme: scheme)
                
                // set up size
        pointSize = textForPointSize.font.pointSize
                
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        primalTableView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
            
        
        
        matrix.append(row1Coefficients)
        matrix.append(row2Coefficients)
        matrix.append(row3Coefficients)
        matrix.append(row4Coefficients)
        matrix.append(objectiveCoefficients)
        
        for i in 1...numberOfInequalities {
            for j in 0..<numberOfVariables {
                matrix[i-1][j].text! = matrixOfStrings[i][j]
                matrix[i-1][j].isHidden = false
                matrix[i-1][j].displayFraction(pointSize: pointSize)
            }
            matrix[i-1][3].text! = matrixOfStrings[i][3]
            matrix[i-1][3].displayFraction(pointSize: pointSize)
            
        }
        
        for j in 0..<numberOfVariables {
            matrix[4][j].text! = matrixOfStrings[0][j]
            matrix[4][j].displayFraction(pointSize: pointSize)
        }
               
        update()
        setupGestures()
        
    }
    

    
    override func viewDidLayoutSubviews() {
   
        super.viewDidLayoutSubviews()
        
        print("stack at layout is ", primalTableStack.frame.size.height)
        print("view at layout is", primalTableView.frame.size.height)
        
        
        offset = primalTableView.frame.size.width / CGFloat((numberOfVariables+1))
        
        height = primalTableView.frame.size.height
        
        verticalLine.removeFromSuperview()
        verticalLine = addVerticalLine(with: .black, andWidth: 2)
        primalTableView.addSubview(verticalLine)
        
        headerLine.removeFromSuperview()
        headerLine = addHorizontalLine(with: .black, andWidth: 2, line: 1)
        primalTableView.addSubview(headerLine)
        
        objectiveLine.removeFromSuperview()
        objectiveLine = addHorizontalLine(with: .black, andWidth: 2, line: numberOfInequalities+1)
        primalTableView.addSubview(objectiveLine)
        
        updateLabels()
        
      //  primalTableView.backgroundColor = .blue
        
        print("stack at end of layout is ", primalTableStack.frame.size.height)
        print("view at end of layout is", primalTableView.frame.size.height)
        
        
    }
    
    func updateLabels() {
        //matrix[0][0].backgroundColor = .black
    }
    
    func update() {
        print(matrixOfStrings)
        hideEverything()
        showWhatsAllowed()
        
    }
    
    func hideEverything() {
        
        for variable in variables {
            variable.isHidden = true
            variable.displayFraction(pointSize: pointSize)
            variable.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        for row in matrix {
            for col in row {
                col.isHidden = true
                col.displayFraction(pointSize: pointSize)
                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
        }
    }
    
    func showWhatsAllowed() {
        
        // show the variables
        for i in 0..<numberOfVariables {
            variables[i].isHidden = false
        }
        variables[3].isHidden = false
        
        // show the coefficients
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables{
                matrix[i][j].isHidden = false
                matrix[i][j].displayFraction(pointSize: pointSize)
                
                
                     
            }
                   
            matrix[i][3].isHidden = false
                   matrix[i][3].displayFraction(pointSize: pointSize)
            matrix[i][3].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                  // matrix[i][3].layer.borderWidth = 1
               }
 
        
        for j in 0..<numberOfVariables {
            matrix[4][j].isHidden = false
            matrix[4][j].displayFraction(pointSize: pointSize)
            
        }
        matrix[4][3].isHidden = false
        matrix[4][3].text! = ""
        
      
        
    }
    
    func addVerticalLine(with color: UIColor?, andWidth borderWidth: CGFloat) -> UIView {
         var lineHeight =  primalTableView.frame.size.height
        lineHeight = height
        //lineHeight = CGFloat(Float(lineHeight) * Float((numberOfInequalities+2))/6)
       // lineHeight = CGFloat(Float(lineHeight) * 4/5)
    
         
         let border = UIView()
        border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
         border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
         border.frame = CGRect(x: primalTableView.frame.size.width - offset, y: 0, width: borderWidth, height: lineHeight)
        // SimplexTable.addSubview(border)
        return border
     }
    
    func addHorizontalLine(with color: UIColor?, andWidth borderWidth: CGFloat, line: Int) -> UIView {
        var lineHeight =  primalTableView.frame.size.height
        lineHeight = height
        lineHeight = CGFloat(Float(lineHeight) * Float(line)/Float(numberOfInequalities+2) )
        
    
         
         let border = UIView()
         border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
         border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: 0, y: lineHeight, width: primalTableView.frame.size.width, height: borderWidth)
         //primalTableView.addSubview(border)
        return border
       
     }


}

extension setupDualController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
      
    if(segue.identifier == "setupDualSegueV2"){
        // prepare strings
          var matrixOfStrings: [[String]] = []
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
        
          let vc = segue.destination as! setupDualControllerV2
          vc.matrixOfStrings = matrixOfStrings
          vc.matrixOfSigns = matrixOfSigns
          vc.problemType = problemType
          vc.numberOfInequalities = numberOfInequalities
          vc.numberOfVariables = numberOfVariables
    }
    
    }
}

extension setupDualController {

    @objc func swipeGesture (sender: UISwipeGestureRecognizer?) {
     
    }
}

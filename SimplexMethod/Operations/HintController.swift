//
//  HintController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/13/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class HintController: UIViewController {

    var delegate: hintDelegate?
    
    let ZERO = Fraction(num: 0, den: 1)
    let ONE = Fraction(num: 1, den: 1)
    
    var problemType: String = ""
    var objective: String = "Maximize"
    
    var numberOfInequalities: Int = 1
    var numberOfVariables: Int = 1
    
    // define an emapty matrix to hold coefficients to be sent
    var matrixOfNumbers: Matrix = Matrix(rows: 5, columns: 9)
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var hintText: UILabel!
    
    // hint images
    @IBOutlet weak var changedRow: UIImageView!
    @IBOutlet weak var sign: UILabel!
    @IBOutlet weak var constant: UILabel!
    @IBOutlet weak var pivotRow: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var newRow: UIImageView!
    
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
    

    
    var hintsType: [String] = ["Is Pivot Set", "Pivot Column", "Pivot Row", "Ratios", "Scale", "RowPlusRow"]
    var hints: [Bool] = [false, false, false, false, false, false]
    var hintsIndex: Int = 0
    
    var isRowPlusRowActive: Bool = false
    var isScaleActive: Bool = false
    
    var pivotRowLocation: Int = -1
    var pivotColumnLocation: Int = -1
    
    var tableComplete: Bool = true
    var error: Bool = false
    var errorMessage: String = ""
    
    var pointSize: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
        
        
        hintText.textColor = colors.UIColorFromHex(rgbValue: colors.popupText)
        
        pointSize = constant.font.pointSize
        
        changedRow.isHidden = true
        sign.isHidden = true
        constant.isHidden = true
        pivotRow.isHidden = true
        arrow.isHidden = true
        newRow.isHidden = true
        
        if(problemType == "Maximize"){
            objective = "maximum"
        }
        else {
            objective = "minimum"
        }
        
        if(error == true){
            hintText.text! = "An error occured during the method indicating there is no optimal solution for this problem."
        }
        else if(isTableComplete() && isRowPlusRowActive == false){
            hintText.text! = "The table is complete."
            readAnswer()
        }
        else {
            // is there a one in the pivot
            if(pivotRowLocation != -1 && pivotColumnLocation != -1){
               
                if(matrixOfNumbers.grid[pivotRowLocation][pivotColumnLocation] == ONE) {
                    hints = [true, true, true, true, true, false]
                }
            }
            
            for i in 0..<hints.count {
                if(hints[i] == false){
                    hintsIndex = i
                    break
                }
            }
        }
        if(tableComplete == false){
            
            
            switch hintsType[hintsIndex] {
            case "Is Scale Active":
                break
            case "Is Pivot Set":
                    hintText.text! = "Find the pivot column by first looking for a negative in the constant column.  If one doesn't exist, look for the smallest negative in the objective row."
                    hints[hintsIndex] = true
                    
            case "Pivot Column":
                    findPivotColumn()
                    hints[hintsIndex] = true
            case "Pivot Row":
                    var location: Int = pivotColumnLocation
                    if(numberOfVariables == 2 && pivotColumnLocation > 2){
                        location -= 1
                    }
                    hintText.text! = "Now that you know the pivot column is column \(location+1) you must find the pivot row.  Evaluate the ratios of the constant column value divided by the pivot column value. The row with the smallest positive ratio is the pivot row."
                    hints[hintsIndex] = true
                    
                case "Ratios":
                    findRatios()
                    hints[hintsIndex] = true
                case "Scale":
                    findScale()
                    
                case "RowPlusRow":
                    findRowPlusRow()

                default:
                    break
                }
        }
    }

    
    func readAnswer() {
        hintText.text! = ""
        // go column by column
        // determine if it's a unit column
        var variable: [String] = ["0", "0", "0"]
        
        for j in 0..<numberOfVariables {
            var zeros = 0
            var ones = 0
            var row = 0
             for i in 0...4 {
                if(matrixOfNumbers.grid[i][j] == ZERO){
                    zeros += 1
                }
                if(matrixOfNumbers.grid[i][j] == ONE){
                    ones += 1
                    row = i
                }
            }
            if(ones == 1 && zeros == 4) {
                // you have a unint column in row i
                variable[j] = matrixOfNumbers.grid[row][8].fraction()
            }
            else {
                variable[j] = "0"
            }
        
        }
        if(problemType == "Standard Min"){
            for i in 0..<numberOfInequalities {
                variable[i] = matrixOfNumbers.grid[4][i+4].fraction()
            }
        
        }
        
        //
        //
        //
        //
        //
        
        if(problemType == "Maximize"){
            hintText.text! += "A \(objective) of P = \(matrixOfNumbers.grid[4][8].fraction()) at the point ("
            
        }
        else if problemType == "Standard Min" {
            hintText.text! += "A \(objective) of C = \(matrixOfNumbers.grid[4][8].fraction()) at the point ("
        }
        
        else {
            
            hintText.text! += "A \(objective) of C = \(matrixOfNumbers.grid[4][8].negateForText()) at the point ("
        }
        
        if(problemType == "Standard Min"){
            for i in 0..<numberOfInequalities {
                hintText.text! += "\(variable[i]), "
            }
        }
        else {
            for i in 0..<numberOfVariables {
                hintText.text! += "\(variable[i]), "
            }
        }
        
       
        hintText.text!.removeLast()
        hintText.text!.removeLast()
        hintText.text! += ")"
    }
    
    func isTableComplete() -> Bool{
        // check constants
        for i in 0..<4 {
            if(matrixOfNumbers.grid[i][8].num < 0 ){
                tableComplete = false
                return false
            }
        }
        
        // check bottom row
        for j in 0..<8 {
            if(matrixOfNumbers.grid[4][j].num < 0){
                tableComplete = false
                return false
            }
        }
        
        tableComplete = true
        return true
    }
    
    func findPivotColumn () {
        
        var tempArray: [Double] = []
        var negativeInConstant: Bool = false
        var row: Int = 0
        
        // negative in constant column?
        for i in 0..<numberOfInequalities {
            if(matrixOfNumbers.grid[i][8].num < 0){
                negativeInConstant = true
                row = i
                hintText.text! = "There is a negative in the constant column.  It is \(matrixOfNumbers.grid[i][8].fraction()). Scan across that row until you find another negative. This will be your pivot column.\n"
            }
        }
        
        if(negativeInConstant == true){
            
            for j in 0..<(numberOfVariables+numberOfInequalities) {
                if(matrixOfNumbers.grid[row][j].num < 0){
                    hintText.text! += "A negative was found in Column \(j+1).  This will be your pivot column."
                    pivotColumnLocation = j
                    error = false
                    break
                }
                else {
                    error = true
                }
            }
            if(error == true){
                hintText.text! = "You have a negative in the constant column.  You must scan across the row for another negative.  Since no other negative was found this indicates there is no optimal solution."
                tableComplete = true
               
            }
        }
        else {
            for i in 0..<7 {
                tempArray.append(matrixOfNumbers.grid[4][i].asDouble())
            }
                
            let smallest = tempArray.min()
            pivotColumnLocation = tempArray.firstIndex(of: smallest!)!
            var location = pivotColumnLocation
            if(numberOfVariables == 2 && location > 2) {
                location -= 1
            }
            hintText.text = "\(matrixOfNumbers.grid[4][pivotColumnLocation].fraction()) is the smallest number in the objective row.  Use Column \(location+1) as your pivot column."
        }
        
        
        
    }
    
    func findRatios() {
        hintText.text! = ""
        var ratios: [Double] = []
        var ratiosAsFractions: [Fraction] = []
        var eligibleRows: Int = 0
       
        
        for i in 0..<numberOfInequalities {
           
            hintText.text! += "Row \(i+1)s ratio is (\(matrixOfNumbers.grid[i][8].fraction())) / (\(matrixOfNumbers.grid[i][pivotColumnLocation].fraction())) = "
            
            var fractionString: String = ""
            
            if(matrixOfNumbers.grid[i][pivotColumnLocation] == ZERO){
                fractionString = "Undefined.\n"
                ratios.append(0)
                ratiosAsFractions.append(ZERO)
            }
            else if(matrixOfNumbers.grid[i][8] == ZERO && matrixOfNumbers.grid[i][pivotColumnLocation] != ZERO){
                fractionString = "0\n"
                ratios.append(0)
                ratiosAsFractions.append(ZERO)
            }
            else {
                
                let ratio = matrixOfNumbers.grid[i][8].asDouble() / matrixOfNumbers.grid[i][pivotColumnLocation].asDouble()
                 let ratioAsFraction = matrixOfNumbers.grid[i][8] / matrixOfNumbers.grid[i][pivotColumnLocation]
                
                fractionString = "\(ratioAsFraction.fraction())\n"
                
                if(ratio > 0) {
                    eligibleRows += 1
                }
                     ratios.append(ratio)
                     ratiosAsFractions.append(ratioAsFraction)
                
                
            }
            hintText.text! += fractionString
        }
        print("ratios count is \(ratios.count)")
        if(eligibleRows == 0){
            hintText.text! += "\nYou do not have any positive ratios. No optimal solution exists for this problem."
            error = true
            print(hintText.text!)
            return
        }
        
        var max: Double = 1000000
        var minLocation: Int = -1
        
        for i in 0..<ratios.count {
            if (ratios[i] < max && ratios[i] > 0){
                minLocation = i
                max = ratios[i]
            }
        }
        
        if(minLocation == -1){
            // no ratio was found
            hintText.text! = "\nYou do not have any positive ratios. No optimal solution exists for this problem."
            return
        }
        
//        let smallest = ratios.min()!
//        let smallestIndex = ratios.firstIndex(of: smallest)!
        //let smallest = ratios[minLocation]
        let smallestIndex = minLocation
        
        pivotRowLocation = smallestIndex
        
        var pivotColumnLocationAdjustment = pivotColumnLocation
        // adjust pivot column if z is not there
        if(numberOfVariables == 2 && pivotColumnLocation > 2) {
            pivotColumnLocationAdjustment -= 1
        }
        
        hintText.text! += "The smallest positive ratio is \(ratiosAsFractions[smallestIndex].fraction()).  Row \(smallestIndex+1) is the pivot row.  Your pivot element is Row \(smallestIndex+1) Column \(pivotColumnLocationAdjustment+1)."
       
    }
    
    func findPivotRow() {

        
    }
    
    func findScale() {
         let pivotElement = matrixOfNumbers.grid[pivotRowLocation][pivotColumnLocation]
          
        constant.isHidden = false
         constant.text! = pivotElement.reciprocal()
        print("THE RECIPROCAL IS ", constant.text!)
        constant.displayFraction(pointSize: pointSize)
        
         
         
         pivotRow.image = UIImage(named: "R\(pivotRowLocation+1)")
         pivotRow.isHidden = false
        
         arrow.isHidden = false
         
         newRow.isHidden = false
         newRow.image = UIImage(named: "R\(pivotRowLocation+1)")
         
             
             
         hintText.text! = "Multiply Row \(pivotRowLocation+1) by \(pivotElement.reciprocal())"
        
        isRowPlusRowActive = true
    }

    func findRowPlusRow() {
        
        var row = 0
        for i in 0...4 {
            if i != pivotRowLocation && matrixOfNumbers.grid[i][pivotColumnLocation] != ZERO {
                hintText.text! = "Evaluate the following operation..."
                isRowPlusRowActive = true
                if(i == 4){
                   row = numberOfInequalities+1
                }
                else {
                    row = i+1
                }
                changedRow.isHidden = false
                changedRow.image = UIImage(named: "R\(row)")
                
                sign.isHidden = false
                
                constant.isHidden = false
                constant.text! = matrixOfNumbers.grid[i][pivotColumnLocation].negateForText()
                
                pivotRow.isHidden = false
                pivotRow.image = UIImage(named: "R\(pivotRowLocation+1)")
                
                arrow.isHidden = false
                
                newRow.isHidden = false
                newRow.image = UIImage(named: "R\(row)")
                return
            }
        }
        hintText.text! = "Awesome! You completed the column."
        isRowPlusRowActive = false
        // you have a unit column
        hints = [false, false, false, false, false, false]
        pivotRowLocation = -1
        pivotColumnLocation = -1
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.getHint(hints: self.hints, pivotRow: self.pivotRowLocation, pivotColumn: self.pivotColumnLocation, error: self.error)
        }
    }
    
}

protocol hintDelegate {
    func getHint(hints: [Bool], pivotRow: Int, pivotColumn: Int, error: Bool)
}

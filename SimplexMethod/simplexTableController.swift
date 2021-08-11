//
//  simplexTableController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/10/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit
//import SwiftKeychainWrapper
import StoreKit

class simplexTableController: UIViewController {

    // IAP Products
    var products: [SKProduct] = []
    
    
    @IBOutlet var screenView: UIView!
    @IBOutlet var buttons: [CommonButton]!
    @IBOutlet weak var centerLine: UILabel!
    
    
    var problemType: String = "Maximize"
    
    // keeps track of each matrix operation so we can udno if necessary
    var allMatrixPositions: [Matrix] = []
    var step: Int = 0
    var locked: [Int] = []
    var currentLockedElement: [(Int, Int, Bool)] = []
    
    @IBOutlet var headerVariables: [UILabel]!
    @IBOutlet var Row1: [UILabel]!
    @IBOutlet var Row2: [UILabel]!
    @IBOutlet var Row3: [UILabel]!
    @IBOutlet var Row4: [UILabel]!
    @IBOutlet var ObjRow: [UILabel]!
    
    // max header variables
    var maxHeaderVariables: [String] = ["x", "y", "z", "u", "v", "w", "s", "P", "C"]
    var minHeaderVariables: [String] = ["u", "v", "w", "s", "x", "y", "z", "P", "C"]
    
    var numberOfInequalities: Int = 1
    var numberOfVariables: Int = 3
    
    var numberOfRows: Int = 1
    var numberOfColumns: Int = 2
    
    var matrixOfStrings: [[String]] = []
    var matrixOfLabels: [[UILabel]] = []
    
    var currentRow: Int = 0
    var currentColumn: Int = 7
    
    // this holds which rows are to swapped
    var clickedRows: [Int] = []
    
    // define an emapty matrix to hold coefficients to be sent
    var matrixOfNumbers: Matrix = Matrix(rows: 5, columns: 9)
  
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    var hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
    @IBOutlet weak var textForPointSize: UILabel!
    
    // lines
    var verticalLine = UIView()
    var headerLine = UIView()
    var objectiveLine = UIView()
    
    // hints
    var hints: [Bool] = [false, false, false, false, false, false]
    var pivotRow: Int = -1
    var pivotColumn: Int = -1
    var isPivotRowSet: Bool = false
    var isPivotColumnSet: Bool = false
    var negativeInCostant: Bool = false
    var isScaleActive: Bool = false
    
    var pivotElements = [(Int, Int, String)]()
    
    var error: Bool = false
    var errorMessage: String = ""
    
    // display important message
    var displayImportantMessage: Bool = false
    @IBOutlet weak var importantMessageButton: CommonButton!
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var SimplexTable: UIView!
    @IBOutlet weak var matrixStack: UIStackView!
    
    var ZERO: Fraction = Fraction(num: 0, den: 1)
    
    var offset: CGFloat = 0
    var pointSize: CGFloat = 24
    
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
        
        // check for available iap
        IAPProducts.store.requestProducts{ [weak self] success, products in
          guard let self = self else { return }
            if success {
                self.products = products!
                print(self.products)
            }
        }
        
        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
        pointSize = textForPointSize.font.pointSize
               
        background.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        for button in buttons {
            button.changeScheme(scheme: scheme)
        }
        
        centerLine.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        
        // change header variables if standard min
        if(problemType == "Standard Min") {
            for i in 0..<9 {
                headerVariables[i].text! = minHeaderVariables[i]
                headerVariables[i].displayFraction(pointSize: pointSize)
                headerVariables[i].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
        }
        else {
            for i in 0..<9 {
                headerVariables[i].text! = maxHeaderVariables[i]
                headerVariables[i].displayFraction(pointSize: pointSize)
                headerVariables[i].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
            }
        }
        
        
        print("THE INCOMING MATRIX IS ",matrixOfStrings)
//        print("stack at load is ", matrixStack.frame.size.height)
//        print("view at load is", SimplexTable.frame.size.height)
//

       
        
        matrixOfLabels.append(Row1)
        matrixOfLabels.append(Row2)
        matrixOfLabels.append(Row3)
        matrixOfLabels.append(Row4)
        matrixOfLabels.append(ObjRow)
        
        numberOfRows = matrixOfStrings.count
        
        print("NumberOfRows = \(numberOfRows), numberOfInequalities is \(numberOfInequalities)")
        print("NumberOfCols = \(numberOfColumns), numberOfCol is \(numberOfVariables)")
        
    
        numberOfColumns = matrixOfStrings[0].count
        
        setupGestures()
        
        // update labels with new values
        for i in 0..<numberOfRows {
            for j in 0..<numberOfColumns {
                currentRow = i
                currentColumn = j
                matrixOfLabels[i][j].text! = matrixOfStrings[i][j]
                convertToNumber(col: matrixOfLabels[i][j])
                
                
            }
        }
        
        for i in 0..<numberOfRows {
            if ( matrixOfStrings[i][8].contains("-") || matrixOfStrings[i][8].contains("–") ) {
                
                negativeInCostant = true
                displayImportantMessage = true
            //    importantMessageButton.isHidden = false
                
                
            }
        }
        
        pivotElements = matrixOfNumbers.findPivotElement(numberOfVariables: numberOfVariables)
        
         
        
        print("PfOSSIBLE PIVOTSD ARE ", pivotElements)
        
        currentLockedElement.append((pivotRow, pivotColumn, false))
        
        currentRow = 0
        currentColumn = 7
        allMatrixPositions.append(matrixOfNumbers)
        
        updateMatrix()
        
        importantMessageButton.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button1)
        importantMessageButton.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button1Text), for: .normal)
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        print("Start ViwdidLayout")
//
//        print("stack at layout is ", matrixStack.frame.size.height)
//        print("view at  layout is", SimplexTable.frame.size.height)
        
        offset = SimplexTable.frame.size.width / CGFloat((numberOfVariables+numberOfInequalities+2))
     
        verticalLine.removeFromSuperview()
        verticalLine = addVerticalLine(with: .black, andWidth: 2)
        SimplexTable.addSubview(verticalLine)
        
        headerLine.removeFromSuperview()
        headerLine = addHorizontalLine(with: .black, andWidth: 2, line: 1)
        SimplexTable.addSubview(headerLine)
        
        objectiveLine.removeFromSuperview()
        objectiveLine = addHorizontalLine(with: .black, andWidth: 2, line: numberOfInequalities+1)
        SimplexTable.addSubview(objectiveLine)
        
//        print("stack at end of layout is ", matrixStack.frame.size.height)
//        print("view at end of layout is", SimplexTable.frame.size.height)
//
//        print("End Viewdidlayout")
    }
    
    func updateMatrix() {
        hideEverything()
        showWhatsAllowed()
    }
    
    func hideEverything(){
        for row in matrixOfLabels {
            for col in row {
                col.isHidden = true
                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
                col.displayFraction(pointSize: pointSize)
            }
        }
        
        for col in headerVariables {
            col.isHidden = true
        }
        
        matrixOfLabels[currentRow][currentColumn].stopBlink()
        
    }
    
    func showWhatsAllowed() {
        
        matrixOfLabels[currentRow][currentColumn].blink()
        
        // show variable columns
        for i in 0..<numberOfInequalities {
            for j in 0..<numberOfVariables {
                matrixOfLabels[i][j].isHidden = false
                matrixOfLabels[numberOfRows-1][j].isHidden = false
                headerVariables[j].isHidden = false
            }
            
            if(problemType == "Standard Min"){
                // show slack variables
                for j in 4..<(numberOfInequalities+4) {
                    matrixOfLabels[i][j].isHidden = false
                    matrixOfLabels[numberOfRows-1][j].isHidden = false
                    headerVariables[j].isHidden = false
                }
            }
            else {
                // show slack variables
                for j in 3..<(numberOfInequalities+3) {
                    matrixOfLabels[i][j].isHidden = false
                    matrixOfLabels[numberOfRows-1][j].isHidden = false
                    headerVariables[j].isHidden = false
                }
            }
            
            
            // show P and C
            matrixOfLabels[i][7].isHidden = false
            matrixOfLabels[i][8].isHidden = false
            matrixOfLabels[numberOfRows-1][7].isHidden = false
            matrixOfLabels[numberOfRows-1][8].isHidden = false
            headerVariables[7].isHidden = false
            headerVariables[8].isHidden = false
        
        }
        
        
    }
    
    // convert string to double
    func convertToNumber(col: UILabel) {
        
        
        let element = Fraction(num: 0, den: 1)
        
        if(col.text! == "-0"){
            col.text! = "0"
        }
        
        if(col.text!.contains(".")){
        // it's a decimal
        // convert to fraction for display
                  
                    
            let decimal = Double(col.text!)!
                
            let (h,k): (Int,Int) = rAof(x0: abs(decimal))
                // add to matrixOfNumbers
            if(decimal < 0){
                element.isNegative = true
                element.update(-1*h,k)
            }
            else {
                element.isNegative = false
                element.update(h, k)
            }
               
            col.text! = element.fraction()
                   
            col.displayFraction(pointSize: pointSize)
           
        }
            
        else if( col.text!.contains("/")){
            // it's a fraction'
                    
            let numeratorDenonimator = col.text!.components(separatedBy: "/")
            let numerator = Int(numeratorDenonimator[0])!
            
            if(numerator < 0){
               element.isNegative = true
            }
            
            var denominator = 1
            
            if (Int(numeratorDenonimator[1]) != nil) {
                denominator = Int(numeratorDenonimator[1])!
            }
            
            
            
            
            element.update(numerator, denominator)
                    
            element.reduce()
                   
            col.text! = element.fraction()
            
            col.displayFraction(pointSize: pointSize)
                    
        }
            
        if(!col.text!.contains(".") && !col.text!.contains("/")){
            // it's an integer
            let number = Int(col.text!)!
            if(number < 0){
                element.isNegative = true
            }
            element.update(number, 1)
        }
        
        matrixOfNumbers.grid[currentRow][currentColumn] = element
        
    }
    
    // converts double to fraction
    func rAof (x0: Double, withPrecision eps: Double = 1.0E-6) -> (Int,Int) {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1,0,Int(a), 1)
        
        while( x-a > eps * Double(k)*Double(k)){
            x = 1.0/(x-a)
            a = floor(x)
            (h1,k1,h,k) = (h,k,h1+Int(a)*h, k1+Int(a)*k)
        }
        
        
        return (h,k)
        
        
    }
    
 
    
    func addVerticalLine(with color: UIColor?, andWidth borderWidth: CGFloat) -> UIView {
         let lineHeight =  matrixStack.frame.size.height
        //lineHeight = CGFloat(Float(lineHeight) * Float((numberOfInequalities+2))/6)
       // lineHeight = CGFloat(Float(lineHeight) * 4/5)
    
         
         let border = UIView()
        border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
         border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
         border.frame = CGRect(x: SimplexTable.frame.size.width - offset, y: 0, width: borderWidth, height: lineHeight)
        // SimplexTable.addSubview(border)
        
        return border
     }
    
    func addHorizontalLine(with color: UIColor?, andWidth borderWidth: CGFloat, line: Int) -> UIView {
         var lineHeight =  matrixStack.frame.size.height
        lineHeight = CGFloat(Float(lineHeight) * Float(line)/Float(numberOfInequalities+2) )
        
    
         
         let border = UIView()
         border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
         border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: 0, y: lineHeight, width: SimplexTable.frame.size.width, height: borderWidth)
        // SimplexTable.addSubview(border)
       
        return border
     }
    
    func updateMatrixOfLabels() {
        for i in 0..<matrixOfLabels.count {
            for j in 0..<matrixOfLabels[i].count {
                let fraction = matrixOfNumbers.grid[i][j].fraction()
               
                matrixOfLabels[i][j].text! = fraction
                matrixOfLabels[i][j].displayFraction(pointSize: pointSize)
            }
        }
    }

    @IBAction func undoAction(_ sender: Any) {
        
        
        if(step > 0){
            
            step -= 1
            error = false
            matrixOfLabels[currentRow][currentColumn].stopBlink()
            if(currentLockedElement[step].2 == false){
               // unlock pivot
                isPivotRowSet = false
                isPivotColumnSet = false
                
                // find new pivot elements
                pivotElements = allMatrixPositions[step].findPivotElement(numberOfVariables: numberOfVariables)
                hints = [false, false, false, false, false, false]
                
                    
            }
            
            if(currentLockedElement[step].2 == true){
                // locked the pivot
                pivotRow = currentLockedElement[step].0
                pivotColumn = currentLockedElement[step].1
                currentRow = pivotRow
                currentColumn = pivotColumn
                hints = [true, true, true, true, false, false]
                isPivotRowSet = true
                isPivotColumnSet = true
                pivotElements = [(pivotRow, pivotColumn, "Fixed")]
            }
            
//            if(locked.contains(step)){
//                // unlock pivot
//                isPivotRowSet = false
//                isPivotColumnSet = false
//                if let index = locked.firstIndex(of: step) {
//                    locked.remove(at: index)
//                }
//
//            }
            
            for i in 0..<matrixOfLabels.count {
                for j in 0..<matrixOfLabels[i].count {
                    let fraction = allMatrixPositions[step].grid[i][j].fraction()
                    matrixOfLabels[i][j].text! = fraction
                    matrixOfLabels[i][j].displayFraction(pointSize: pointSize)
                 }
            }
            print(pivotElements)
        matrixOfLabels[currentRow][currentColumn].blink()
            allMatrixPositions.removeLast()
            matrixOfNumbers = allMatrixPositions[step]
            
            currentLockedElement.removeLast()
            
            
        }
        
    }
    
    @IBAction func multByConstantButton(_ sender: Any) {
        var allowedToProceed: Bool = false
        print("Current Pivot Elements :", pivotElements)
        for element in pivotElements {
            if element.0 == currentRow && element.1 == currentColumn {
                allowedToProceed = true
            }
        }
        
        if allowedToProceed == true {
            performSegue(withIdentifier: "MultiplyByConstantSegue", sender: nil)
        }
        else {
           openPopUpMessage(message: "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element.")
        }
    }
    
    @IBAction func rowPlusRowButton(_ sender: Any) {
        print("Current Pivot Elements :", pivotElements)
        
        var allowedToProceed: Bool = false
        for element in pivotElements {
            if element.0 == currentRow && element.1 == currentColumn {
                allowedToProceed = true
            }
        }
        
        if allowedToProceed == true {
            performSegue(withIdentifier: "RowPlusRowSegue", sender: nil)
        }
        else {
            openPopUpMessage(message: "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element.")
        }
    }
    

    @IBAction func solutionButton(_ sender: Any) {
        
      
            if(IAPProducts.store.isProductPurchased(IAPProducts.InstantSolution)){
                performSegue(withIdentifier: "SolutionSegue", sender: nil)
            }
            else {
                print("Instant Solution is NOT purchased.")
                performSegue(withIdentifier: "InstantSolutionSegue", sender: nil)

            }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("start segue")
        if(segue.identifier == "swipeToPivot"){
            print("error message is: ", errorMessage)
            let vc = segue.destination as! PopUpNotification
            vc.messageText = errorMessage
            return
        }
        
        if(segue.identifier == "SolutionSegue" || segue.identifier == "InstantSolutionSegue"){
            
            if(IAPProducts.store.isProductPurchased(IAPProducts.InstantSolution)){
                print("Instant Solution is purchased")
                let vc = segue.destination as! SolutionController
                vc.matrix = matrixOfNumbers
                vc.numberOfInequalities = numberOfInequalities
                vc.numberOfVariables = numberOfVariables
                vc.problemType = problemType
                return
            }
            else {
                print("Instant Solution is NOT purchased.")
//                openPopUpMessage(message: "This is a premium ability.  Please consider supporting my work by purchasing the Instant Solution ability.  You only need to puchase it once.")
                
                // new
                let vc = segue.destination as! PopUpNotification
                vc.messageText = "This is a premium ability.  Please consider supporting my work by purchasing the Instant Solution ability.  You only need to puchase it once."
                
                return
            }
        }
        
        if(segue.identifier == "HintSegue") {
              
           //  matrixOfLabels[currentRow][currentColumn].stopBlink()
             
             let vc = segue.destination as! HintController
             vc.delegate = self
             vc.numberOfInequalities = numberOfInequalities
             vc.numberOfVariables = numberOfVariables
             vc.matrixOfNumbers = matrixOfNumbers
             vc.hints = hints
             vc.problemType = problemType
             vc.pivotRowLocation = pivotRow
             vc.pivotColumnLocation = pivotColumn
             vc.error = error
             vc.isScaleActive = isScaleActive
            return
         }
        
        var allowedToProceed: Bool = false
        var notOnPivot: Bool = true
         for element in pivotElements {
             if element.0 == currentRow && element.1 == currentColumn {
                 allowedToProceed = true
                 notOnPivot = false
             }
         }
        
        if(pivotElements.count == 0){
           // allowedToProceed = false
        }
         
        if allowedToProceed == true {
            print("Allowed to proceed")
            if(segue.identifier == "SwapSegue")  {
                        
                let vc = segue.destination as! SwapController
                vc.delegate = self
                vc.numberOfInequalities = numberOfInequalities
            }
            
            if(segue.identifier == "MultiplyByConstantSegue") {
                print("Trying to multiply")
                
                if(notOnPivot == true) {
                    print("can't mult. not on pivot")
                    let vc = segue.destination as! PopUpNotification
                    vc.messageText = "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element."
                    return
                }
                 
                let vc = segue.destination as! MultByConstantController
                vc.delegate = self
                vc.numberOfInequalities = numberOfInequalities
            }
            
            if(segue.identifier == "RowPlusRowSegue") {
                 
                let vc = segue.destination as! RowPlusRowController
                vc.delegate = self
                vc.numberOfInequalities = numberOfInequalities
            }
            
        }
        else {
            if(pivotElements.count == 0){
                openPopUpMessage(message: "ERROR: There are no eligible pivot elements indicating there no is optimal solution.")
            }
            else {
                print("Go to Popup with swipe request")
                let vc = segue.destination as! PopUpNotification
                vc.messageText = "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element."
                
//         openPopUpMessage(message: "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element.")
                
            }
        }

        return
    }
    
    func openPopUpMessage(message: String) {
       
//        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpNotification") as! PopUpNotification
//        vc.messageText = message
//        self.present(vc, animated: true, completion: nil)
        
        errorMessage = message
        performSegue(withIdentifier: "swipeToPivot", sender: nil)
        importantMessageButton.isHidden = true
    }
    
    
    @IBAction func importantMessageAction(_ sender: Any) {
       // openPopUpMessage(message: "You have a negative in the constant column.  There is a very specific way to deal with these constants.  If you choose your pivot column incorrectly, the hints from now on will be incorrect.  Click Hint now if you don't know how to choose the pivot column.")
    }
    
}



extension simplexTableController: SwapRowsDelegate {
    func swapRowsSelected(rows: [Int]) {
        
        
        
        clickedRows = rows
     
       
        step += 1
        var newMatrix = matrixOfNumbers
        newMatrix.swapRows(row1: clickedRows[0], row2: clickedRows[1])
        allMatrixPositions.append(newMatrix)
            
        matrixOfNumbers = newMatrix
        updateMatrixOfLabels()
        //isUnitColumn()
        
        
        
    }
}

extension simplexTableController:  MultiplyByConstantDelegate {
    func getConstant(row: Int, multiplyBy: Fraction) {
        
        var allowedToProceed: Bool = true
        var negativeInConstantColumn: Bool = false
        
//        if(pivotElements.count == ){
//            allowedToProceed = true
//        }
        
        for element in pivotElements {
            if(element.0 == currentRow){
                allowedToProceed = true
                isPivotRowSet = true
                isPivotColumnSet = true
                pivotRow = currentRow
                pivotColumn = currentColumn
                hints = [true, true, true, true, false, false]
                locked.append(step)
                print("You are locked on step ", step)
            }
            if(element.2 == "ConstantColumn"){
                negativeInConstantColumn = true
            }
        }
        
        
        if(multiplyBy == ZERO){
            openPopUpMessage(message: "You cannot multiply a row by 0.")
            return
        }
        
        if(allowedToProceed == false && negativeInConstantColumn == true){
            openPopUpMessage(message: "Because of the negative in the constant column it is extremely important you scale your pivot element to equal 1 now.")
            return
        }
        
        
        step += 1
        var newMatrix = matrixOfNumbers
        newMatrix.multiplyByConstant(row: row, con: multiplyBy)
        allMatrixPositions.append(newMatrix)
        matrixOfNumbers = newMatrix
        updateMatrixOfLabels()
        
        currentLockedElement.append((pivotRow, pivotColumn, true))
       
        if(matrixOfNumbers.isUnitColumn(column: currentColumn)) {
            openPopUpMessage(message: "This column is now a unit column.  You can move on to the next step of the simplex method.")
            reset()
        }
               
        
    }
}

extension simplexTableController: RowPlusConstantRowDelegate {
    func getInfo(rows: [Int], constant: Fraction) {
        
       // print("Change ROW IS \(rows[0]) and pivot row is \(rows[1])")
        
        
        var allowedToProceed: Bool = true
        var newMatrix = matrixOfNumbers
        newMatrix.rowPlusConstantRow(rows: rows, constant: constant)
        
        for element in pivotElements {
            if(element.0 == currentRow){
                
                allowedToProceed = true
                isPivotRowSet = true
                isPivotColumnSet = true
                pivotRow = currentRow
                pivotColumn = currentColumn
                hints = [true, true, true, true, false, false]
                locked.append(step)
                print("You are locked on step ", step)
            }
        }
        
        if(isPivotColumnSet == true && isPivotRowSet == true){
            if newMatrix.grid[pivotRow][pivotColumn] == ZERO {
                openPopUpMessage(message: "You attempted an operation that made your pivot element equal 0. You can't let your pivot element equal 0.  Remember your pivot element should equal 1.")
                return
            }
        }
        
        
            if newMatrix.grid[currentRow][currentColumn] == ZERO {
                openPopUpMessage(message: "You attempted an operation that made your pivot element equal 0. You can't let your pivot element equal 0.  Remember your pivot element should equal 1.")
                return
            }
        
        
    
        
        if(allowedToProceed == true){
            allMatrixPositions.append(newMatrix)
            matrixOfNumbers = newMatrix
            updateMatrixOfLabels()
            step += 1
            currentLockedElement.append((pivotRow, pivotColumn, true))
        }
        
        
        if(matrixOfNumbers.isUnitColumn(column: currentColumn)) {
            
            reset()
        }
        
        //isUnitColumn()
               
    }
    
    func reset() {
        openPopUpMessage(message: "This column is now a unit column and therefore is completed.")
        isPivotColumnSet = false
        isPivotRowSet = false
        pivotRow = -1
        pivotColumn = -1
        hints = [false, false, false, false, false, false]
        currentLockedElement[step].2 = false
        pivotElements = matrixOfNumbers.findPivotElement(numberOfVariables: numberOfVariables)
    }
}



extension simplexTableController: hintDelegate {
    func getHint(hints: [Bool], pivotRow: Int, pivotColumn: Int, error: Bool) {
        
        
        if(pivotRow != -1){
            self.isPivotRowSet = true
        }
        else {
            self.isPivotRowSet = false
        }
        if(pivotColumn != -1){
            self.isPivotColumnSet = true
            matrixOfLabels[currentRow][currentColumn].stopBlink()
            currentColumn = pivotColumn
        }
        else {
            self.isPivotColumnSet = false
        }
        
        if(isPivotRowSet == true && isPivotColumnSet == true){
            matrixOfLabels[currentRow][currentColumn].stopBlink()
            currentRow = pivotRow
            
        }
        
        self.hints = hints
        self.pivotRow = pivotRow
        self.pivotColumn = pivotColumn
        self.error = error
        
      //  print("PIVOT ROW SET is \(self.isPivotRowSet) and PIVOT COLUMN SET IS \(self.isPivotColumnSet)")
        updateMatrix()
    }
    
}


extension simplexTableController {
    
    @objc func swipeGesture (sender: UISwipeGestureRecognizer?) {
       
    
        if(isPivotRowSet == true && isPivotColumnSet == true){
            openPopUpMessage(message: "You are locked on a pivot element.  Complete the row operations to make a unit column. Click on Hints if you need help.")
            return
        }
        
        matrixOfLabels[currentRow][currentColumn].stopBlink()
        if sender != nil {
            
            if(problemType == "Standard Min"){
                
                switch sender!.direction {
                    case UISwipeGestureRecognizer.Direction.up: // up
                        if(isPivotRowSet == true){
                                    
                        }
                        else if(currentRow > 0) {
                            currentRow -= 1
                        }
                     case UISwipeGestureRecognizer.Direction.right: // right
                        switch currentColumn {
                        case numberOfVariables-1:
                            currentColumn = 4
                        case 3+numberOfInequalities:
                            break
                        default:
                            currentColumn += 1
                            
                            
                    }
                                
                    case UISwipeGestureRecognizer.Direction.down: // down
                        if(isPivotRowSet == true){
                                        
                        }
                        else if(currentRow < numberOfInequalities-1){
                                currentRow += 1
                        }
                    case UISwipeGestureRecognizer.Direction.left: // left
                        switch currentColumn {
                        case 7:
                            currentColumn = 3+numberOfInequalities
                        case 5...6:
                            currentColumn -= 1
                        case 4:
                            currentColumn = numberOfVariables-1
                        case 1...3:
                            currentColumn -= 1
                        default:
                            break
                            
                    }
                    
                        
                                    
                    default:
                        break
                }
            }
            else {
                switch sender!.direction {
                        case UISwipeGestureRecognizer.Direction.up: // up
                            if(isPivotRowSet == true){
                                
                            }
                            else if(currentRow > 0) {
                                currentRow -= 1
                            }
                            
                               
                            
                        case UISwipeGestureRecognizer.Direction.right: // right
                            if(isPivotColumnSet == true){
                                
                            }
                            else {
                              if(currentColumn < numberOfVariables+numberOfInequalities) {
                                    currentColumn += 1
                                }
                                if(currentColumn == numberOfVariables && numberOfVariables == 2){
                                    currentColumn += 1
                                    
                                }
                                
                                
                            }
                            
                                
                
                            case UISwipeGestureRecognizer.Direction.down: // down
                                if(isPivotRowSet == true){
                                    
                                }
                                else if(currentRow < numberOfInequalities-1){
                                    currentRow += 1
                                }
                            case UISwipeGestureRecognizer.Direction.left: // left
                                if(isPivotColumnSet == true){
                                    
                                }else {
                                    if(currentColumn == 7 && numberOfVariables != 3){
                                        currentColumn = numberOfVariables+numberOfInequalities
                                       
                                    }
                                    else if(currentColumn == 7 && numberOfVariables == 3){
                                        currentColumn = numberOfVariables+numberOfInequalities-1
                                        
                                    }
                                    else {
                                        if(currentColumn > 0){
                                            currentColumn -= 1
                                        }
                                        
                                        if(currentColumn == numberOfVariables && numberOfVariables == 2) {
                                            currentColumn -= 1
                                        }
                                    }
                                    
                                }
                                
                            default:
                                break
                            
                        }
            }
            
        }
        
        if(currentRow == pivotRow) {
            print("Youre in the pivot row")
        }
        if(currentColumn == pivotColumn){
            print("Youre in the pivot column")
        }
        matrixOfLabels[currentRow][currentColumn].blink()

    }
    
    
    
}



//
//
////
////  simplexTableController.swift
////  SimplexMethod
////
////  Created by Brian Veitch on 1/10/20.
////  Copyright © 2020 Brian Veitch. All rights reserved.
////
//
//import UIKit
//import SwiftKeychainWrapper
//import StoreKit
//
//class simplexTableController: UIViewController {
//
//    // IAP Products
//    var products: [SKProduct] = []
//
//
//    @IBOutlet var screenView: UIView!
//    @IBOutlet var buttons: [CommonButton]!
//    @IBOutlet weak var centerLine: UILabel!
//
//
//    var problemType: String = "Maximize"
//
//    // keeps track of each matrix operation so we can udno if necessary
//    var allMatrixPositions: [Matrix] = []
//    var step: Int = 0
//    var locked: [Int] = []
//
//    @IBOutlet var headerVariables: [UILabel]!
//    @IBOutlet var Row1: [UILabel]!
//    @IBOutlet var Row2: [UILabel]!
//    @IBOutlet var Row3: [UILabel]!
//    @IBOutlet var Row4: [UILabel]!
//    @IBOutlet var ObjRow: [UILabel]!
//
//    // max header variables
//    var maxHeaderVariables: [String] = ["x", "y", "z", "u", "v", "w", "s", "P", "C"]
//    var minHeaderVariables: [String] = ["u", "v", "w", "s", "x", "y", "z", "P", "C"]
//
//    var numberOfInequalities: Int = 1
//    var numberOfVariables: Int = 3
//
//    var numberOfRows: Int = 1
//    var numberOfColumns: Int = 2
//
//    var matrixOfStrings: [[String]] = []
//    var matrixOfLabels: [[UILabel]] = []
//
//    var currentRow: Int = 0
//    var currentColumn: Int = 7
//
//    // this holds which rows are to swapped
//    var clickedRows: [Int] = []
//
//    // define an emapty matrix to hold coefficients to be sent
//    var matrixOfNumbers: Matrix = Matrix(rows: 5, columns: 9)
//
//    // custom classes / structs
//    var colors = ColorScheme()
//    var scheme = UserDefaults.standard.integer(forKey: "scheme")
//    var hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
//    @IBOutlet weak var textForPointSize: UILabel!
//
//    // lines
//    var verticalLine = UIView()
//    var headerLine = UIView()
//    var objectiveLine = UIView()
//
//    // hints
//    var hints: [Bool] = [false, false, false, false, false, false]
//    var pivotRow: Int = -1
//    var pivotColumn: Int = -1
//    var isPivotRowSet: Bool = false
//    var isPivotColumnSet: Bool = false
//    var negativeInCostant: Bool = false
//    var isScaleActive: Bool = false
//
//    var pivotElements = [(Int, Int, String)]()
//
//    var error: Bool = false
//
//    // display important message
//    var displayImportantMessage: Bool = false
//    @IBOutlet weak var importantMessageButton: CommonButton!
//
//    @IBOutlet var background: UIView!
//    @IBOutlet weak var SimplexTable: UIView!
//    @IBOutlet weak var matrixStack: UIStackView!
//
//    var ZERO: Fraction = Fraction(num: 0, den: 1)
//
//    var offset: CGFloat = 0
//    var pointSize: CGFloat = 24
//
//    fileprivate func setupGestures() {
//        // add the swipe gestures
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        screenView.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        screenView.addGestureRecognizer(swipeLeft)
//
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
//        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
//        screenView.addGestureRecognizer(swipeDown)
//
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
//        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
//        screenView.addGestureRecognizer(swipeUp)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // check for available iap
//        IAPProducts.store.requestProducts{ [weak self] success, products in
//          guard let self = self else { return }
//            if success {
//                self.products = products!
//                print(self.products)
//            }
//        }
//
//        // set up color scheme
//        colors.changeColorScheme(scheme: scheme)
//        pointSize = textForPointSize.font.pointSize
//
//        background.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
//
//        for button in buttons {
//            button.changeScheme(scheme: scheme)
//        }
//
//        centerLine.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//
//        // change header variables if standard min
//        if(problemType == "Standard Min") {
//            for i in 0..<9 {
//                headerVariables[i].text! = minHeaderVariables[i]
//                headerVariables[i].displayFraction(pointSize: pointSize)
//                headerVariables[i].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//            }
//        }
//        else {
//            for i in 0..<9 {
//                headerVariables[i].text! = maxHeaderVariables[i]
//                headerVariables[i].displayFraction(pointSize: pointSize)
//                headerVariables[i].textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//            }
//        }
//
//
//        print("THE INCOMING MATRIX IS ",matrixOfStrings)
////        print("stack at load is ", matrixStack.frame.size.height)
////        print("view at load is", SimplexTable.frame.size.height)
////
//
//
//
//        matrixOfLabels.append(Row1)
//        matrixOfLabels.append(Row2)
//        matrixOfLabels.append(Row3)
//        matrixOfLabels.append(Row4)
//        matrixOfLabels.append(ObjRow)
//
//        numberOfRows = matrixOfStrings.count
//
//        print("NumberOfRows = \(numberOfRows), numberOfInequalities is \(numberOfInequalities)")
//        print("NumberOfCols = \(numberOfColumns), numberOfCol is \(numberOfVariables)")
//
//
//        numberOfColumns = matrixOfStrings[0].count
//
//        setupGestures()
//
//        // update labels with new values
//        for i in 0..<numberOfRows {
//            for j in 0..<numberOfColumns {
//                currentRow = i
//                currentColumn = j
//                matrixOfLabels[i][j].text! = matrixOfStrings[i][j]
//                convertToNumber(col: matrixOfLabels[i][j])
//
//
//            }
//        }
//
//        for i in 0..<numberOfRows {
//            if ( matrixOfStrings[i][8].contains("-") || matrixOfStrings[i][8].contains("–") ) {
//
//                negativeInCostant = true
//                displayImportantMessage = true
//            //    importantMessageButton.isHidden = false
//
//
//            }
//        }
//
//        pivotElements = matrixOfNumbers.findPivotElement(numberOfVariables: numberOfVariables)
//
//
//
//        print("PfOSSIBLE PIVOTSD ARE ", pivotElements)
//
//        currentRow = 0
//        currentColumn = 7
//        allMatrixPositions.append(matrixOfNumbers)
//
//        updateMatrix()
//
//        importantMessageButton.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button1)
//        importantMessageButton.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button1Text), for: .normal)
//
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
////        print("Start ViwdidLayout")
////
////        print("stack at layout is ", matrixStack.frame.size.height)
////        print("view at  layout is", SimplexTable.frame.size.height)
//
//        offset = SimplexTable.frame.size.width / CGFloat((numberOfVariables+numberOfInequalities+2))
//
//        verticalLine.removeFromSuperview()
//        verticalLine = addVerticalLine(with: .black, andWidth: 2)
//        SimplexTable.addSubview(verticalLine)
//
//        headerLine.removeFromSuperview()
//        headerLine = addHorizontalLine(with: .black, andWidth: 2, line: 1)
//        SimplexTable.addSubview(headerLine)
//
//        objectiveLine.removeFromSuperview()
//        objectiveLine = addHorizontalLine(with: .black, andWidth: 2, line: numberOfInequalities+1)
//        SimplexTable.addSubview(objectiveLine)
//
////        print("stack at end of layout is ", matrixStack.frame.size.height)
////        print("view at end of layout is", SimplexTable.frame.size.height)
////
////        print("End Viewdidlayout")
//    }
//
//    func updateMatrix() {
//        hideEverything()
//        showWhatsAllowed()
//    }
//
//    func hideEverything(){
//        for row in matrixOfLabels {
//            for col in row {
//                col.isHidden = true
//                col.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//                col.displayFraction(pointSize: pointSize)
//            }
//        }
//
//        for col in headerVariables {
//            col.isHidden = true
//        }
//
//        matrixOfLabels[currentRow][currentColumn].stopBlink()
//
//    }
//
//    func showWhatsAllowed() {
//
//        matrixOfLabels[currentRow][currentColumn].blink()
//
//        // show variable columns
//        for i in 0..<numberOfInequalities {
//            for j in 0..<numberOfVariables {
//                matrixOfLabels[i][j].isHidden = false
//                matrixOfLabels[numberOfRows-1][j].isHidden = false
//                headerVariables[j].isHidden = false
//            }
//
//            if(problemType == "Standard Min"){
//                // show slack variables
//                for j in 4..<(numberOfInequalities+4) {
//                    matrixOfLabels[i][j].isHidden = false
//                    matrixOfLabels[numberOfRows-1][j].isHidden = false
//                    headerVariables[j].isHidden = false
//                }
//            }
//            else {
//                // show slack variables
//                for j in 3..<(numberOfInequalities+3) {
//                    matrixOfLabels[i][j].isHidden = false
//                    matrixOfLabels[numberOfRows-1][j].isHidden = false
//                    headerVariables[j].isHidden = false
//                }
//            }
//
//
//            // show P and C
//            matrixOfLabels[i][7].isHidden = false
//            matrixOfLabels[i][8].isHidden = false
//            matrixOfLabels[numberOfRows-1][7].isHidden = false
//            matrixOfLabels[numberOfRows-1][8].isHidden = false
//            headerVariables[7].isHidden = false
//            headerVariables[8].isHidden = false
//
//        }
//
//
//    }
//
//    // convert string to double
//    func convertToNumber(col: UILabel) {
//
//
//        let element = Fraction(num: 0, den: 1)
//
//        if(col.text! == "-0"){
//            col.text! = "0"
//        }
//
//        if(col.text!.contains(".")){
//        // it's a decimal
//        // convert to fraction for display
//
//
//            let decimal = Double(col.text!)!
//
//            let (h,k): (Int,Int) = rAof(x0: abs(decimal))
//                // add to matrixOfNumbers
//            if(decimal < 0){
//                element.isNegative = true
//                element.update(-1*h,k)
//            }
//            else {
//                element.isNegative = false
//                element.update(h, k)
//            }
//
//            col.text! = element.fraction()
//
//            col.displayFraction(pointSize: pointSize)
//
//        }
//
//        else if( col.text!.contains("/")){
//            // it's a fraction'
//
//            let numeratorDenonimator = col.text!.components(separatedBy: "/")
//            let numerator = Int(numeratorDenonimator[0])!
//
//            if(numerator < 0){
//               element.isNegative = true
//            }
//
//            var denominator = 1
//
//            if (Int(numeratorDenonimator[1]) != nil) {
//                denominator = Int(numeratorDenonimator[1])!
//            }
//
//
//
//
//            element.update(numerator, denominator)
//
//            element.reduce()
//
//            col.text! = element.fraction()
//
//            col.displayFraction(pointSize: pointSize)
//
//        }
//
//        if(!col.text!.contains(".") && !col.text!.contains("/")){
//            // it's an integer
//            let number = Int(col.text!)!
//            if(number < 0){
//                element.isNegative = true
//            }
//            element.update(number, 1)
//        }
//
//        matrixOfNumbers.grid[currentRow][currentColumn] = element
//
//    }
//
//    // converts double to fraction
//    func rAof (x0: Double, withPrecision eps: Double = 1.0E-6) -> (Int,Int) {
//        var x = x0
//        var a = floor(x)
//        var (h1, k1, h, k) = (1,0,Int(a), 1)
//
//        while( x-a > eps * Double(k)*Double(k)){
//            x = 1.0/(x-a)
//            a = floor(x)
//            (h1,k1,h,k) = (h,k,h1+Int(a)*h, k1+Int(a)*k)
//        }
//
//
//        return (h,k)
//
//
//    }
//
//
//
//    func addVerticalLine(with color: UIColor?, andWidth borderWidth: CGFloat) -> UIView {
//         let lineHeight =  matrixStack.frame.size.height
//        //lineHeight = CGFloat(Float(lineHeight) * Float((numberOfInequalities+2))/6)
//       // lineHeight = CGFloat(Float(lineHeight) * 4/5)
//
//
//         let border = UIView()
//        border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//         border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
//         border.frame = CGRect(x: SimplexTable.frame.size.width - offset, y: 0, width: borderWidth, height: lineHeight)
//        // SimplexTable.addSubview(border)
//
//        return border
//     }
//
//    func addHorizontalLine(with color: UIColor?, andWidth borderWidth: CGFloat, line: Int) -> UIView {
//         var lineHeight =  matrixStack.frame.size.height
//        lineHeight = CGFloat(Float(lineHeight) * Float(line)/Float(numberOfInequalities+2) )
//
//
//
//         let border = UIView()
//         border.backgroundColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
//         border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
//        border.frame = CGRect(x: 0, y: lineHeight, width: SimplexTable.frame.size.width, height: borderWidth)
//        // SimplexTable.addSubview(border)
//
//        return border
//     }
//
//    func updateMatrixOfLabels() {
//        for i in 0..<matrixOfLabels.count {
//            for j in 0..<matrixOfLabels[i].count {
//                let fraction = matrixOfNumbers.grid[i][j].fraction()
//
//                matrixOfLabels[i][j].text! = fraction
//                matrixOfLabels[i][j].displayFraction(pointSize: pointSize)
//            }
//        }
//    }
//
//    @IBAction func undoAction(_ sender: Any) {
//
//
//        if(step > 0){
//
//            step -= 1
//
//            if(locked.contains(step)){
//                // unlock pivot
//                isPivotRowSet = false
//                isPivotColumnSet = false
//                if let index = locked.firstIndex(of: step) {
//                    locked.remove(at: index)
//                }
//            }
//
//            for i in 0..<matrixOfLabels.count {
//                for j in 0..<matrixOfLabels[i].count {
//                    let fraction = allMatrixPositions[step].grid[i][j].fraction()
//                    matrixOfLabels[i][j].text! = fraction
//                    matrixOfLabels[i][j].displayFraction(pointSize: pointSize)
//                 }
//            }
//
//
//            allMatrixPositions.removeLast()
//            matrixOfNumbers = allMatrixPositions[step]
//
//        }
//
//    }
//
//    @IBAction func solutionButton(_ sender: Any) {
//
//
//
//            if(IAPProducts.store.isProductPurchased(IAPProducts.InstantSolution)){
//                performSegue(withIdentifier: "SolutionSegue", sender: nil)
//            }
//            else {
//                print("Instant Solution is NOT purchased.")
//
//                // original
////                openPopUpMessage(message: "This is a premium ability.  Please consider supporting my work by purchasing the Instant Solution ability.  You only need to puchase it once.")
//
//                // new
//                performSegue(withIdentifier: "InstantSolutionSegue", sender: nil)
//
//            }
//
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if(segue.identifier == "SolutionSegue" || segue.identifier == "InstantSolutionSegue"){
//
//            if(IAPProducts.store.isProductPurchased(IAPProducts.InstantSolution)){
//                print("Instant Solution is purchased")
//                let vc = segue.destination as! SolutionController
//                vc.matrix = matrixOfNumbers
//                vc.numberOfInequalities = numberOfInequalities
//                vc.numberOfVariables = numberOfVariables
//                vc.problemType = problemType
//                return
//            }
//            else {
//                print("Instant Solution is NOT purchased.")
////                openPopUpMessage(message: "This is a premium ability.  Please consider supporting my work by purchasing the Instant Solution ability.  You only need to puchase it once.")
//
//                // new
//                let vc = segue.destination as! PopUpNotification
//                vc.messageText = "This is a premium ability.  Please consider supporting my work by purchasing the Instant Solution ability.  You only need to puchase it once."
//
//                return
//            }
//        }
//
//        if(segue.identifier == "HintSegue") {
//
//           //  matrixOfLabels[currentRow][currentColumn].stopBlink()
//
//             let vc = segue.destination as! HintController
//             vc.delegate = self
//             vc.numberOfInequalities = numberOfInequalities
//             vc.numberOfVariables = numberOfVariables
//             vc.matrixOfNumbers = matrixOfNumbers
//             vc.hints = hints
//             vc.problemType = problemType
//             vc.pivotRowLocation = pivotRow
//             vc.pivotColumnLocation = pivotColumn
//             vc.error = error
//             vc.isScaleActive = isScaleActive
//            return
//         }
//
//        var allowedToProceed: Bool = false
//         for element in pivotElements {
//             if element.0 == currentRow && element.1 == currentColumn {
//                 allowedToProceed = true
//             }
//         }
//
//        if(pivotElements.count == 0){
//            allowedToProceed = false
//        }
//
//        if allowedToProceed == true {
//            if(segue.identifier == "SwapSegue")  {
//
//                let vc = segue.destination as! SwapController
//                vc.delegate = self
//                vc.numberOfInequalities = numberOfInequalities
//            }
//
//            if(segue.identifier == "MultiplyByConstantSegue") {
//
//                let vc = segue.destination as! MultByConstantController
//                vc.delegate = self
//                vc.numberOfInequalities = numberOfInequalities
//            }
//
//            if(segue.identifier == "RowPlusRowSegue") {
//
//                let vc = segue.destination as! RowPlusRowController
//                vc.delegate = self
//                vc.numberOfInequalities = numberOfInequalities
//            }
//
//        }
//        else {
//            if(pivotElements.count == 0){
//                openPopUpMessage(message: "ERROR: There are no eligible pivot elements.")
//            }
//            else {
////                let vc = segue.destination as! PopUpNotification
////                vc.messageText = "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element."
//
//           openPopUpMessage(message: "Swipe left, right, up, down to move the pivot box onto an eligible pivot element.  Click Hint if you need help locating a pivot element.")
//
//            }
//        }
//
//        return
//    }
//
//    func openPopUpMessage(message: String) {
//
//        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpNotification") as! PopUpNotification
//        vc.messageText = message
//        self.present(vc, animated: true, completion: nil)
//
//        importantMessageButton.isHidden = true
//    }
//
//
//    @IBAction func importantMessageAction(_ sender: Any) {
//       // openPopUpMessage(message: "You have a negative in the constant column.  There is a very specific way to deal with these constants.  If you choose your pivot column incorrectly, the hints from now on will be incorrect.  Click Hint now if you don't know how to choose the pivot column.")
//    }
//
//}
//
//
//
//extension simplexTableController: SwapRowsDelegate {
//    func swapRowsSelected(rows: [Int]) {
//
//
//
//        clickedRows = rows
//
//
//        step += 1
//        var newMatrix = matrixOfNumbers
//        newMatrix.swapRows(row1: clickedRows[0], row2: clickedRows[1])
//        allMatrixPositions.append(newMatrix)
//
//        matrixOfNumbers = newMatrix
//        updateMatrixOfLabels()
//        //isUnitColumn()
//
//
//
//    }
//}
//
//extension simplexTableController:  MultiplyByConstantDelegate {
//    func getConstant(row: Int, multiplyBy: Fraction) {
//
//        var allowedToProceed: Bool = true
//        var negativeInConstantColumn: Bool = false
//
////        if(pivotElements.count == ){
////            allowedToProceed = true
////        }
//
//        for element in pivotElements {
//            if(element.0 == currentRow){
//                allowedToProceed = true
//                isPivotRowSet = true
//                isPivotColumnSet = true
//                pivotRow = currentRow
//                pivotColumn = currentColumn
//                hints = [true, true, true, true, false, false]
//                locked.append(step)
//            }
//            if(element.2 == "ConstantColumn"){
//                negativeInConstantColumn = true
//            }
//        }
//
//
//
//
//        if(allowedToProceed == false && negativeInConstantColumn == true){
//            openPopUpMessage(message: "Because of the negative in the constant column it is extremely important you scale your pivot element to equal 1 now.")
//            return
//        }
//
//
//        step += 1
//        var newMatrix = matrixOfNumbers
//        newMatrix.multiplyByConstant(row: row, con: multiplyBy)
//        allMatrixPositions.append(newMatrix)
//        matrixOfNumbers = newMatrix
//        updateMatrixOfLabels()
//
//        if(matrixOfNumbers.isUnitColumn(column: currentColumn)) {
//            openPopUpMessage(message: "This column is now a unit column and therefore is completed.")
//            reset()
//        }
//
//
//    }
//}
//
//extension simplexTableController: RowPlusConstantRowDelegate {
//    func getInfo(rows: [Int], constant: Fraction) {
//
//       // print("Change ROW IS \(rows[0]) and pivot row is \(rows[1])")
//
//        step += 1
//        var allowedToProceed: Bool = true
//        var newMatrix = matrixOfNumbers
//        newMatrix.rowPlusConstantRow(rows: rows, constant: constant)
//
//        for element in pivotElements {
//            if(element.0 == currentRow){
//
//                allowedToProceed = true
//                isPivotRowSet = true
//                isPivotColumnSet = true
//                pivotRow = currentRow
//                pivotColumn = currentColumn
//                hints = [true, true, true, true, false, false]
//                locked.append(step)
//            }
//        }
//
//        if(isPivotColumnSet == true && isPivotRowSet == true){
//            if newMatrix.grid[pivotRow][pivotColumn] == ZERO {
//                openPopUpMessage(message: "You attempted an operation that made your pivot element equal 0. You can't let your pivot element equal 0.  Remember your pivot element should equal 1.")
//                return
//            }
//        }
//
//
//            if newMatrix.grid[currentRow][currentColumn] == ZERO {
//                openPopUpMessage(message: "You attempted an operation that made your pivot element equal 0. You can't let your pivot element equal 0.  Remember your pivot element should equal 1.")
//                return
//            }
//
//
//
//
//        if(allowedToProceed == true){
//            allMatrixPositions.append(newMatrix)
//            matrixOfNumbers = newMatrix
//            updateMatrixOfLabels()
//        }
//
//
//        if(matrixOfNumbers.isUnitColumn(column: currentColumn)) {
//
//            reset()
//        }
//
//        //isUnitColumn()
//
//    }
//
//    func reset() {
//        openPopUpMessage(message: "This column is now a unit column and therefore is completed.")
//        isPivotColumnSet = false
//        isPivotRowSet = false
//        pivotRow = -1
//        pivotColumn = -1
//        hints = [false, false, false, false, false, false]
//        pivotElements = matrixOfNumbers.findPivotElement(numberOfVariables: numberOfVariables)
//    }
//}
//
//
//
//extension simplexTableController: hintDelegate {
//    func getHint(hints: [Bool], pivotRow: Int, pivotColumn: Int, error: Bool) {
//
//
//        if(pivotRow != -1){
//            self.isPivotRowSet = true
//        }
//        else {
//            self.isPivotRowSet = false
//        }
//        if(pivotColumn != -1){
//            self.isPivotColumnSet = true
//            matrixOfLabels[currentRow][currentColumn].stopBlink()
//            currentColumn = pivotColumn
//        }
//        else {
//            self.isPivotColumnSet = false
//        }
//
//        if(isPivotRowSet == true && isPivotColumnSet == true){
//            matrixOfLabels[currentRow][currentColumn].stopBlink()
//            currentRow = pivotRow
//
//        }
//
//        self.hints = hints
//        self.pivotRow = pivotRow
//        self.pivotColumn = pivotColumn
//        self.error = error
//
//      //  print("PIVOT ROW SET is \(self.isPivotRowSet) and PIVOT COLUMN SET IS \(self.isPivotColumnSet)")
//        updateMatrix()
//    }
//
//}
//
//
//extension simplexTableController {
//
//    @objc func swipeGesture (sender: UISwipeGestureRecognizer?) {
//
//
//        if(isPivotRowSet == true && isPivotColumnSet == true){
//            return
//        }
//
//        matrixOfLabels[currentRow][currentColumn].stopBlink()
//        if sender != nil {
//
//            if(problemType == "Standard Min"){
//
//                switch sender!.direction {
//                    case UISwipeGestureRecognizer.Direction.up: // up
//                        if(isPivotRowSet == true){
//
//                        }
//                        else if(currentRow > 0) {
//                            currentRow -= 1
//                        }
//                     case UISwipeGestureRecognizer.Direction.right: // right
//                        switch currentColumn {
//                        case numberOfVariables-1:
//                            currentColumn = 4
//                        case 3+numberOfInequalities:
//                            break
//                        default:
//                            currentColumn += 1
//
//
//                    }
//
//                    case UISwipeGestureRecognizer.Direction.down: // down
//                        if(isPivotRowSet == true){
//
//                        }
//                        else if(currentRow < numberOfInequalities-1){
//                                currentRow += 1
//                        }
//                    case UISwipeGestureRecognizer.Direction.left: // left
//                        switch currentColumn {
//                        case 7:
//                            currentColumn = 3+numberOfInequalities
//                        case 5...6:
//                            currentColumn -= 1
//                        case 4:
//                            currentColumn = numberOfVariables-1
//                        case 1...3:
//                            currentColumn -= 1
//                        default:
//                            break
//
//                    }
//
//
//
//                    default:
//                        break
//                }
//            }
//            else {
//                switch sender!.direction {
//                        case UISwipeGestureRecognizer.Direction.up: // up
//                            if(isPivotRowSet == true){
//
//                            }
//                            else if(currentRow > 0) {
//                                currentRow -= 1
//                            }
//
//
//
//                        case UISwipeGestureRecognizer.Direction.right: // right
//                            if(isPivotColumnSet == true){
//
//                            }
//                            else {
//                              if(currentColumn < numberOfVariables+numberOfInequalities) {
//                                    currentColumn += 1
//                                }
//                                if(currentColumn == numberOfVariables && numberOfVariables == 2){
//                                    currentColumn += 1
//
//                                }
//
//
//                            }
//
//
//
//                            case UISwipeGestureRecognizer.Direction.down: // down
//                                if(isPivotRowSet == true){
//
//                                }
//                                else if(currentRow < numberOfInequalities-1){
//                                    currentRow += 1
//                                }
//                            case UISwipeGestureRecognizer.Direction.left: // left
//                                if(isPivotColumnSet == true){
//
//                                }else {
//                                    if(currentColumn == 7 && numberOfVariables != 3){
//                                        currentColumn = numberOfVariables+numberOfInequalities
//
//                                    }
//                                    else if(currentColumn == 7 && numberOfVariables == 3){
//                                        currentColumn = numberOfVariables+numberOfInequalities-1
//
//                                    }
//                                    else {
//                                        if(currentColumn > 0){
//                                            currentColumn -= 1
//                                        }
//
//                                        if(currentColumn == numberOfVariables && numberOfVariables == 2) {
//                                            currentColumn -= 1
//                                        }
//                                    }
//
//                                }
//
//                            default:
//                                break
//
//                        }
//            }
//
//        }
//
//        if(currentRow == pivotRow) {
//            print("Youre in the pivot row")
//        }
//        if(currentColumn == pivotColumn){
//            print("Youre in the pivot column")
//        }
//        matrixOfLabels[currentRow][currentColumn].blink()
//
//    }
//
//
//
//}
//
//

//
//  SolutionControllerExample.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/28/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class SolutionControllerExample: UIViewController {

    var matrix: Matrix = Matrix(rows: 5, columns: 9)
    
    var numberOfInequalities: Int = 2
    var numberOfVariables: Int = 2
    
    var problemType: String = ""
    var notified: Bool = false
    
    var maxIteration: Int = 10
    var iteration: Int = 0
    
    var hintText: String = ""
    var error: Bool = false
    var errorMessage: String = "There is an error.  The Simplex Method cannot find a solution. You can use Hints to find out what happened."
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    
    // pivot location
    var pivotColumnLocation: Int = -1
    var pivotRowLocation: Int = -1
    
    // header variables
    var maxHeaderVariables: [String] = ["x", "y", "z", "u", "v", "w", "s", "P", "C"]
    var minHeaderVariables: [String] = ["u", "v", "w", "s", "x", "y", "z", "P", "C"]
    var headerVariables: [String] = []
    
    var matrixComplete: Bool = false
    var allMatrixPositions: [Matrix] = []
    var finalMatrix: Matrix = Matrix(rows: 5, columns: 9)
    var step: Int = 0
    
    var width: CGFloat = 20
    var height: CGFloat = 20
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textForPointSize: UILabel!
    @IBOutlet weak var dismissButton: CommonButton!
    
    var pointSize: CGFloat = 24
    
    var ONE: Fraction = Fraction(num: 1, den: 1)
    var ZERO: Fraction = Fraction(num: 0, den: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
        pointSize = textForPointSize.font.pointSize
              
        //mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        
        allMatrixPositions.append(matrix)
        
        if(problemType == "Standard Min"){
            headerVariables = minHeaderVariables
        }
        else {
            headerVariables = maxHeaderVariables
        }
        
        if(notified == false) {
            dismissButton.isHidden = true
        }
        
        findPivot()
        addTable()
        
        start()
        
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        mainStackView.layoutIfNeeded()
        mainStackView.sizeToFit()
        
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func start() {
        while matrixComplete == false && iteration < maxIteration {
            findPivot()
            scalePivot()
            rowPlusRow()
            iteration += 1
            print(iteration)
            
        }
        if(iteration >= maxIteration){
            error = true
            readAnswer()
        }
        else {
            finalMatrix = allMatrixPositions[step-1]
            readAnswer()
        }
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    func scalePivot() {
        if matrixComplete == true {
            return
        }
        if(matrix.grid[pivotRowLocation][pivotColumnLocation] != ONE){
            let reciprocal = matrix.grid[pivotRowLocation][pivotColumnLocation].reciprocate()
            matrix.multiplyByConstant(row: pivotRowLocation, con: reciprocal)
            allMatrixPositions.append(matrix)
            addScale(reciprocal: reciprocal, row: pivotRowLocation)
            addTable()
        }
        
    }
    
    func rowPlusRow() {
        if matrixComplete == true {
            return
        }
        for i in 0..<numberOfInequalities {
            if( i != pivotRowLocation && matrix.grid[i][pivotColumnLocation].num != 0){
                let negate = Fraction(num: -1, den: 1)*matrix.grid[i][pivotColumnLocation]
                matrix.rowPlusConstantRow(rows: [i+1,pivotRowLocation+1], constant: negate)
                allMatrixPositions.append(matrix)
                addRowPlusRow(negative: negate, changed: i, Pivot: pivotRowLocation)
                addTable()
            }
            
        }
        
        if(matrix.grid[4][pivotColumnLocation].num != 0){
            let negate = Fraction(num: -1, den: 1)*matrix.grid[4][pivotColumnLocation]
            matrix.rowPlusConstantRow(rows: [5,pivotRowLocation+1], constant: negate)
            allMatrixPositions.append(matrix)
            addRowPlusRow(negative: negate, changed: numberOfInequalities, Pivot: pivotRowLocation)
            addTable()
        }
    }
    
    func findPivot() {
        
        pivotRowLocation = -1
        pivotColumnLocation = -1
        
        var negativeInConstantRow: Int = -1
        var pivotColumnLocations: [Int] = []
        
        // negative in constant column?
        for i in 0..<numberOfInequalities {
            if(matrix.grid[i][8].num < 0) {
                // scan across row
                negativeInConstantRow = i
                break
            }
        }
        
        if(negativeInConstantRow != -1){
            for j in 0..<numberOfVariables+numberOfInequalities {
                if(matrix.grid[negativeInConstantRow][j].num < 0){
                    pivotColumnLocations.append(j)
                   
                }
            }
        }
        
        ///---------------------------------
        var tempArray: [Double] = []
        var smallestValue: Double = 0
        
        // negative in bottom row
        for j in 0...numberOfVariables+numberOfInequalities {
            tempArray.append(matrix.grid[4][j].asDouble())
        }
        
        smallestValue = tempArray.min()!
        if(smallestValue < 0){
            pivotColumnLocations.append(tempArray.firstIndex(of: smallestValue)!)
        }
        
        
        if(pivotColumnLocations.count == 0){
            matrixComplete = true
            hintText = "Matrix is complete."
            print(hintText)
        }
        else {
            pivotColumnLocation = pivotColumnLocations[0]
            findRow()
        }
        
    }
    
    func findRow() {
        // check the ratios
        // choose the smallest positive ratio
        // set pivotRowLocation
        
        var maxFraction = Fraction(num: 1000000, den: 1)
        
        error = true
        for i in 0..<numberOfInequalities {
            if(matrix.grid[i][pivotColumnLocation].num != 0 && matrix.grid[i][pivotColumnLocation].num != 0) {
                let ratio = matrix.grid[i][8] / matrix.grid[i][pivotColumnLocation]
                if(ratio.num > 0 && ratio <= maxFraction){
                    maxFraction = ratio
                    pivotRowLocation = i
                    error = false
                }
            }
        }
        if(error == true){
            matrixComplete = true
        }
        print("THE PIVOT IS ROW \(pivotRowLocation+1), Column \(pivotColumnLocation+1)")
        
    }
    
    func addTable() {
        let sview = UIView()
        sview.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.distribution = .fillProportionally
        stackview.frame = CGRect(x: 0, y:0, width: mainStackView.frame.size.width, height: 100)
        
        stackview.insertSubview(sview, at: 0)
        
        NSLayoutConstraint.activate([
            sview.leadingAnchor.constraint(equalTo: stackview.leadingAnchor),

            sview.trailingAnchor.constraint(equalTo: stackview.trailingAnchor),

            sview.topAnchor.constraint(equalTo: stackview.topAnchor, constant: -5),

            sview.bottomAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 5),
            
            sview.widthAnchor.constraint(equalTo: stackview.widthAnchor, multiplier: 1)
        ])
        
        
        var start: Int = 3
        if(problemType == "Standard Min"){
            start = 4
        }
        
        // add the header variables
        
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 10
        rowStackView.distribution = .fillEqually
        
        for j in 0..<numberOfVariables {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.text = headerVariables[j]
            label.displayFraction(pointSize: pointSize)
            label.adjustsFontSizeToFitWidth = true
            rowStackView.addArrangedSubview(label)
            
        }
         
        
        
        for j in start..<start+numberOfInequalities {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.text = headerVariables[j]
            label.displayFraction(pointSize: pointSize)
            label.adjustsFontSizeToFitWidth = true
            rowStackView.addArrangedSubview(label)
        }
        
        for j in 7...8 {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.text = headerVariables[j]
            label.displayFraction(pointSize: pointSize)
            label.adjustsFontSizeToFitWidth = true
            rowStackView.addArrangedSubview(label)
        }
        
        stackview.addArrangedSubview(rowStackView)
        stackview.sizeToFit()
        rowStackView.layoutIfNeeded()
        
        // add the coefficients
        for i in 0..<numberOfInequalities {
            // add the rows
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillEqually
            
            for j in 0..<numberOfVariables {
                let label = UILabel()
                label.textColor = .black
                label.textAlignment = .center
                label.text = "\(allMatrixPositions[step].grid[i][j].fraction())"
                label.displayFraction(pointSize: pointSize)
                label.adjustsFontSizeToFitWidth = true
                rowStackView.addArrangedSubview(label)
                rowStackView.sizeToFit()
                if(i == pivotRowLocation && j == pivotColumnLocation){
                    label.layer.borderWidth = 1
                }
                else {
                    label.layer.borderWidth = 0
                }
            }
            
            for j in start..<start+numberOfInequalities {
                let label = UILabel()
                label.textColor = .black
                label.textAlignment = .center
                label.text = "\(allMatrixPositions[step].grid[i][j].fraction())"
                label.displayFraction(pointSize: pointSize)
                label.adjustsFontSizeToFitWidth = true
                rowStackView.addArrangedSubview(label)
                rowStackView.sizeToFit()
                if(i == pivotRowLocation && j == pivotColumnLocation){
                    label.layer.borderWidth = 1
                }
                else {
                    label.layer.borderWidth = 0
                }
            }
            
            for j in 7...8 {
                let label = UILabel()
                label.textColor = .black
                label.textAlignment = .center
                label.text = "\(allMatrixPositions[step].grid[i][j].fraction())"
                label.displayFraction(pointSize: pointSize)
                label.adjustsFontSizeToFitWidth = true
                rowStackView.addArrangedSubview(label)
                rowStackView.sizeToFit()
                if(i == pivotRowLocation && j == pivotColumnLocation){
                    label.layer.borderWidth = 1
                }
                else {
                    label.layer.borderWidth = 0
                }
            }
            
            
            rowStackView.sizeToFit()
            stackview.addArrangedSubview(rowStackView)
            stackview.sizeToFit()
            rowStackView.layoutIfNeeded()
            
        }
        
        // add objective row
       
        let objectiveRow = UIStackView()
        objectiveRow.axis = .horizontal
        objectiveRow.spacing = 10
        objectiveRow.distribution = .fillEqually
        
        
        for j in 0..<numberOfVariables {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.text = "\(allMatrixPositions[step].grid[4][j].fraction())"
            label.displayFraction(pointSize: pointSize)
            label.adjustsFontSizeToFitWidth = true
            objectiveRow.addArrangedSubview(label)
            objectiveRow.sizeToFit()
        }
        
        for j in start..<start+numberOfInequalities {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.text = "\(allMatrixPositions[step].grid[4][j].fraction())"
            label.displayFraction(pointSize: pointSize)
            label.adjustsFontSizeToFitWidth = true
            objectiveRow.addArrangedSubview(label)
            objectiveRow.sizeToFit()
        }
        
        for j in 7...8 {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.text = "\(allMatrixPositions[step].grid[4][j].fraction())"
            label.displayFraction(pointSize: pointSize)
            label.adjustsFontSizeToFitWidth = true
            objectiveRow.addArrangedSubview(label)
            objectiveRow.sizeToFit()
        }
        
        stackview.addArrangedSubview(objectiveRow)
        stackview.layoutIfNeeded()
        stackview.sizeToFit()
        sview.layoutIfNeeded()
        sview.sizeToFit()
        
        mainStackView.addArrangedSubview(stackview)
        mainStackView.sizeToFit()
        mainStackView.layoutIfNeeded()
        step += 1
        
        // add borders
        addBorders(view: sview, stackview: stackview)
        
        addSpace()
        
    }
    
    func addSpace() {

    }
    
    func addScale(reciprocal: Fraction, row: Int) {
        let operationStackView = UIStackView()
            operationStackView.axis = .horizontal
            operationStackView.spacing = 5
            operationStackView.distribution = .fill
            operationStackView.translatesAutoresizingMaskIntoConstraints = false
            operationStackView.layer.borderWidth = 1
            
        var label = UILabel()
        
        label.textColor = .black
        label.text = reciprocal.fraction()
           // label.layer.borderWidth = 1

        if(label.text!.contains("/")){
           label.displayFraction(pointSize: pointSize+10)
        }
        else {
            label.displayFraction(pointSize: pointSize+10)
        }
        
        
        label.frame = CGRect()
        operationStackView.addArrangedSubview(label)
        label.contentMode = .scaleAspectFit
            
            
        var imageName = "R\(row+1)"
        var image = UIImage(named: imageName)
        let changedRow = UIImageView(image: image!)
        operationStackView.addArrangedSubview(changedRow)
        changedRow.contentMode = .scaleAspectFit
          //  changedRow.layer.borderWidth = 1
            
        imageName = "rightarrow"
        image = UIImage(named: imageName)
        let arrow = UIImageView(image: image)
        operationStackView.addArrangedSubview(arrow)
        arrow.contentMode = .scaleAspectFit
          //  arrow.layer.borderWidth = 1
            
        imageName = "R\(row+1)"
        image = UIImage(named: imageName)
        let newRow = UIImageView(image: image)
        operationStackView.addArrangedSubview(newRow)
        newRow.contentMode = .scaleAspectFit
         //   newRow.layer.borderWidth = 1
            
        label = UILabel()
        
        label.textColor = .black
        label.text = " "
        label.displayFraction(pointSize: pointSize)
        // label.layer.borderWidth = 1
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for:.horizontal)
            
        operationStackView.addArrangedSubview(label)
    
        mainStackView.addArrangedSubview(operationStackView)
        
                   
        addSpace()
    }
    
    func addRowPlusRow(negative: Fraction, changed: Int, Pivot: Int) {
        let operationStackView = UIStackView()
        operationStackView.axis = .horizontal
        operationStackView.spacing = 4
        operationStackView.distribution = .fill
    
        operationStackView.translatesAutoresizingMaskIntoConstraints = false
          operationStackView.layer.borderWidth = 1
          
        var imageName = "R\(changed+1)"
        var image = UIImage(named: imageName)
        let changedRow = UIImageView(image: image!)
        operationStackView.addArrangedSubview(changedRow)
        changedRow.contentMode = .scaleAspectFit
          //changedRow.clipsToBounds = true
         // changedRow.layer.borderWidth = 1
         
        var label = UILabel()
        label.textColor = .black
         
        label.text = negative.fraction()
        
        if(negative.num > 0){
            let signLabel = UILabel()
            signLabel.textColor = UIColor.black
            signLabel.text = "+"
            signLabel.displayFraction(pointSize: pointSize+10)
            operationStackView.addArrangedSubview(signLabel)
             
        }
        
        label.displayFraction(pointSize: pointSize+10)
          
        // label.layer.borderWidth = 1
        label.frame = CGRect()
        operationStackView.addArrangedSubview(label)
        // label.contentMode = .scaleAspectFit
        // label.clipsToBounds = true
          
          
        imageName = "R\(Pivot+1)"
        image = UIImage(named: imageName)
        let pivotRow1 = UIImageView(image: image!)
        operationStackView.addArrangedSubview(pivotRow1)
        pivotRow1.contentMode = .scaleAspectFit
        //  pivotRow1.clipsToBounds = true
         // pivotRow1.layer.borderWidth = 1

        imageName = "rightarrow"
        image = UIImage(named: imageName)
        let arrow = UIImageView(image: image)
        operationStackView.addArrangedSubview(arrow)
        arrow.contentMode = .scaleAspectFit
        //  arrow.clipsToBounds = true
         // arrow.layer.borderWidth = 1
         

        imageName = "R\(changed+1)"
        image = UIImage(named: imageName)
        let newRow = UIImageView(image: image!)
        operationStackView.addArrangedSubview(newRow)
        newRow.contentMode = .scaleAspectFit
    //  newRow.clipsToBounds = true
        //  newRow.layer.borderWidth = 1
          
        label = UILabel()
        label.font = UIFont(name: "Futura", size: pointSize)
        label.textColor = .black
        label.text = " "
          //label.layer.borderWidth = 1
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for:.horizontal)
          // label.frame = CGRect()
        operationStackView.addArrangedSubview(label)
          

        mainStackView.addArrangedSubview(operationStackView)
       
        addSpace()
    }
    
    func readAnswer() {
        
        
        
        
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: pointSize)
        label.text = ""
        
        if(error == true){
            label.text! += errorMessage
            if(iteration >= maxIteration){
                label.text! += "It appears the method is stuck in a cycle and cannot get rid of the negatives in the bottom row or constant column. This usually indicates no solution."
            }
            mainStackView.addArrangedSubview(label)
            return
        }
        
        var objective: String = "maximum"
        
        if(problemType != "Maximize") {
            objective = "minimum"
        }
        
        var listOfFractions: [String] = []
        
        
        // go column by column
        // determine if it's a unit column
        var variable: [String] = ["0", "0", "0"]
               
        for j in 0..<numberOfVariables {
            var zeros = 0
            var ones = 0
            var row = 0
            for i in 0...4 {
                if(matrix.grid[i][j] == ZERO){
                    zeros += 1
                }
                if(matrix.grid[i][j] == ONE){
                    ones += 1
                    row = i
                }
            }
            
            if(ones == 1 && zeros == 4) {
            // you have a unint column in row i
                variable[j] = finalMatrix.grid[row][8].fraction()
                if(finalMatrix.grid[row][8].den != 1){
                   listOfFractions.append(variable[j])
                }
                
            }
            else {
                variable[j] = "0"
            }
               
        }
        
        if(problemType == "Standard Min"){
            for i in 0..<numberOfInequalities {
                variable[i] = finalMatrix.grid[4][i+4].fraction()
                
                if(finalMatrix.grid[4][i+4].den != 1){
                   listOfFractions.append(variable[i])
                }
            }
               
        }
               
               //
               //
               //
               //
               //
               
        if(problemType == "Maximize"){
            label.text! += "A \(objective) of P = \(finalMatrix.grid[4][8].fraction()) at the point ( "
                   
        }
        else if problemType == "Standard Min" {
            label.text! += "A \(objective) of C = \(finalMatrix.grid[4][8].fraction()) at the point ( "
        }
               
        else {
                   
            label.text! += "A \(objective) of C = \(finalMatrix.grid[4][8].negateForText()) at the point ( "
        }
               
        if(problemType == "Standard Min"){
            for i in 0..<numberOfInequalities {
                label.text! += "\(variable[i]), "
            }
        }
        else {
            for i in 0..<numberOfVariables {
                label.text! += "\(variable[i]), "
            }
        }
        label.text!.removeLast()
        label.text!.removeLast()
        
        label.text! += " )"
        
        
        label.displayFractionV2(list: listOfFractions, pointSize: pointSize+4)
        mainStackView.addArrangedSubview(label)
               
    }
    
    func addBorders(view: UIView, stackview: UIStackView) {
        
       
         
        let width: CGFloat =  view.frame.size.width
        let height: CGFloat =  view.frame.size.height
        
        // add vertical line
        var factor = CGFloat(Float(numberOfVariables+numberOfInequalities+1) / Float(numberOfVariables+numberOfInequalities+2))
        
        let verticalLine = UIView()
        verticalLine.frame = CGRect(x: factor*width, y: 0, width: 3, height: height)
        verticalLine.backgroundColor = .black
        verticalLine.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        verticalLine.backgroundColor = .black
        view.addSubview(verticalLine)
        
       
        // add first horizontal line
        factor = CGFloat(1/Float(numberOfInequalities+2))
        let headerLine = UIView()
        headerLine.backgroundColor = .black
        headerLine.frame = CGRect(x: 0, y: factor*height, width: width, height: 3)
        headerLine.autoresizingMask = [.flexibleWidth]
        headerLine.backgroundColor = .black
        view.addSubview(headerLine)
        
        // add last horizontal line
        factor = CGFloat(Float(numberOfInequalities+1)/Float(numberOfInequalities+2))
        let objectiveLine = UIView()
        objectiveLine.backgroundColor = .black
        objectiveLine.frame = CGRect(x: 0, y: factor*height, width: width, height: 3)
       objectiveLine.autoresizingMask = [.flexibleWidth]
        objectiveLine.backgroundColor = .black
        view.addSubview(objectiveLine)
    }

}


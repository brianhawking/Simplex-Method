//
//  Matrix.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/6/2020.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//
import Foundation
import Accelerate

struct Matrix {
    
    // Matrix struct is adapted and extended from Apple documentation
    
    let rows: Int, columns: Int
    var grid: [[Fraction]] = []
    
    // A matrix of zeros
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        for _ in 0..<rows {
            let row = Array(repeating: Fraction(num: 0, den: 1), count: columns)
            grid.append(row)
        }
    }
    
    init(rows: Int, columns: Int, grid: [[Fraction]]) {
        self.rows = rows
        self.columns = columns
        self.grid = grid
    }
    
    // Identity matrix
    init(identityMatrixSize size: Int) {
        self.rows = size
        self.columns = size
        for _ in 0..<rows {
            let row = Array(repeating: Fraction(num: 0, den: 0), count: columns)
            grid.append(row)
        }
        for n in 0..<size {
            grid[n-1][n-1] = Fraction(num: 1, den: 1)
        }
    }
    

    func checkDimensionsAreValid() {
        let matrixIsValid = self.rows>0 && self.columns>0 && (self.grid.count == self.rows * self.columns)
        assert(matrixIsValid, "Error initialising matrix: Invalid dimensions of matrix")
    }
    
    func findPivotElement(numberOfVariables: Int) -> [(Int, Int, String)] {
        
        var negativeInConstant: Bool = false
        
        var pivotElements: [(Int, Int, String)] = []
        for i in 0..<rows-1 {
            
            if(grid[i][columns-1].num < 0){
                
                    negativeInConstant = true
                    
                    // scan across for other negatives
                for j in 0..<columns - 1 {
                    if(grid[i][j].num < 0){
                        
                        
                        // find pivot row in this column
                       // var max: Double = 100000
                        var maxAsFraction: Fraction = Fraction(num: 10000000, den: 1)
                      //  var minRatioRow: [(Int, Int)] = []
                     //   var currentRowMin: Int = -1
                        for k in 0..<rows-1 {
                           
                            if(grid[k][j].num != 0) {
                                let ratio = grid[k][columns-1] / grid[k][j]
                                
                                if (ratio.num > 0 && (ratio <= maxAsFraction || ratio == maxAsFraction)){
                                   // minRatioRow.append((k,j))
                                 //   currentRowMin = k
                                    maxAsFraction = ratio
                                    negativeInConstant = true
                                }
                        
                            }
                            
                            
                        }
                        
                        // any repeats
                        for k in 0..<rows-1 {
                            if(grid[k][j].num != 0) {
                                let ratio = grid[k][columns-1] / grid[k][j]
                                if(ratio == maxAsFraction){
                                   pivotElements.append((k, j, "ConstantColumn"))
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
        if(negativeInConstant == false){
            // find smallest in bottom row
            var tempArray: [Double] = []
            for j in 0..<columns - 1 {
                tempArray.append(grid[4][j].asDouble())
            }
            let smallest = tempArray.min()
            
            if(smallest! >= 0.0) {
                // no more pivots
                return []
            }
            
            var eligiblePivotColumms: [Int] = []
            for j in 0..<columns-1 {
                if(grid[4][j].asDouble() == smallest){
               // if(grid[4][j].asDouble() < 0){
                    eligiblePivotColumms.append(j)
                }
            }
        //    var pivotColumnLocation = tempArray.firstIndex(of: smallest!)!
            
           var maxAsFraction: Fraction = Fraction(num: 10000000, den: 1)
            
            for k in 0..<columns - 1 {
                if(grid[4][k].asDouble() == smallest){
                //if(grid[4][k].asDouble() < 0){
                    // check ratios
                    maxAsFraction = Fraction(num: 10000000, den: 1)
                    //var pivotRowLocation: Int = -1
                    for i in 0..<rows-1 {
                        if(grid[i][k].num != 0) {
                            let ratio = grid[i][columns-1] / grid[i][k]
                            if(ratio.num > 0 && ratio <= maxAsFraction) {
                              //  pivotRowLocation = i
                                maxAsFraction = ratio
                                
                            }
                        }
                        
                    }
                    
                    // the smallest ratio is maxAsFraction
                    
                    // any matching ratios
                    for i in 0..<rows-1 {
                        if(grid[i][k].num != 0) {
                            let ratio = grid[i][columns-1] / grid[i][k]
                            if(ratio == maxAsFraction) {
                               pivotElements.append((i, k, "BottomRow"))
                            }
                        }
                        
                    }
                    
                    
                }
            }
            
        }

        print("The list of pivot elements are ", pivotElements)
        return pivotElements
        
    }
    
    func isUnitColumn(column: Int) -> Bool {
        
        var numberOfZeros: Int = 0
        var numberOfOnes: Int = 0
        
        let ONE: Fraction = Fraction(num: 1, den: 1)
        let ZERO: Fraction = Fraction(num: 0, den: 1)
        
        for i in 0..<rows {
            if grid[i][column] == ONE {
                numberOfOnes += 1
            }
            else if grid[i][column] == ZERO {
                numberOfZeros += 1
            }
            else {
                return false
            }
        }
        
        if(numberOfZeros == rows - 1 && numberOfOnes == 1){
            return true
        }
        else {
            return false
        }
    }
    

    
//    func printMatrix() {
//        for i in 0..<rows {
//            for j in 0..<columns {
//                grid[i][j].show()
//            }
//        }
//    }
    
}
//
extension Matrix {
    
    // update matrix
    mutating func update(row: Int, col: Int, value: Fraction){
        grid[row][col] = value
    }
    
    mutating func swapRows(row1: Int, row2: Int) {
        
        let temp = grid[row1-1]
        grid[row1-1] = grid[row2-1]
        grid[row2-1] = temp
        
    }
    
    mutating func multiplyByConstant(row: Int, con: Fraction){
        
        let changeRow = grid[row]
        var newRow: [Fraction] = []
        for i in 0..<columns {
            let element = changeRow[i] * con
            newRow.append(element)
           // print(element.fraction())
        }
        
        
        
        for i in 0..<columns {
            grid[row][i] = newRow[i]
        }
        
    }
    
    mutating func rowPlusConstantRow(rows: [Int], constant: Fraction) {

       // print(rows, constant.show())
         
        let changeRow = grid[rows[0]-1]
     
        let pivotRow = grid[rows[1]-1]
        
      
       
        var newRow: [Fraction] = []
        
        for i in 0..<columns {
            let temp = constant * pivotRow[i]
            let element = changeRow[i] + temp
            //print((constant*pivotRow[i]).show())
           // print(element.show())
            newRow.append(element)
            
            // 1/2 + -7/4
            //
        }
        
        for i in 0..<columns {
            grid[rows[0]-1][i] = newRow[i]
            
        }
        
        
    }
    
    func searchForLeadingOne() {
        
    }
    
//
//    func indexIsValid(row: Int, column: Int) -> Bool {
//        return row >= 0 && row < rows && column >= 0 && column < columns
//    }
//
//    // Accessing elements of the matrix using subscript notation
//    subscript(row: Int, column: Int) -> Double {
//        get {
//            assert(indexIsValid(row: row, column: column), "Index out of range")
//            return grid[(row * columns) + column]
//        }
//        set {
//            assert(indexIsValid(row: row, column: column), "Index out of range")
//            grid[(row * columns) + column] = newValue
//        }
//    }
//
//    // Transposing a matrix
//    func transpose() -> Matrix {
//        var result = Matrix(rows: self.columns, columns: self.rows)
//        vDSP_mtransD(self.grid, 1, &result.grid, 1, UInt(result.rows), UInt(result.columns))
//        return result
//    }
//
//    // Multiplying two matrices: element-wise multiplication
//    func elementMultiply(_ matrix2: Matrix) -> Matrix {
//        assert(self.rows == matrix2.rows && self.columns == matrix2.columns)
//        return Matrix(rows: self.rows, columns: self.columns, grid: zip(self.grid, matrix2.grid).map(*))
//    }
//
//    // Inverse of a matrix
////    public func inverse() -> Matrix {
////        assert(self.rows == self.columns, "Error calculating inverse: matrix is not square")
////        var selfGrid = self.grid
////        var N = __CLPK_integer(sqrt(Double(selfGrid.count)))
////        var pivot = [__CLPK_integer](repeating: 0, count: Int(N))
////        var err : __CLPK_integer = 0
////        var workspace = [Double](repeating: 0.0, count: Int(N))
////        dgetrf_(&N, &N, &selfGrid, &N, &pivot, &err)
////        dgetri_(&N, &selfGrid, &N, &pivot, &workspace, &N, &err)
////        return Matrix(rows: self.rows, columns: self.columns, grid: selfGrid)
////    }
//
}


//
//// Printing a matrix
//extension Matrix : CustomStringConvertible {
//
//    public var description: String {
//        var returnString = ""
//        for row in 0..<self.rows {
//            let thisRow = Array(self.grid[row*(self.columns)..<((row+1)*self.columns)])
//            returnString += rowAsAString(thisRow) + "\n"
//        }
//        return returnString
//    }
//
//    func rowAsAString(_ a: [Double]) -> String {
//        let num = a.count
//
//        let maxSpace = 6 // If there are more columns than this, then some will be omitted from the printed output
//        let firstElements = 3
//        let lastElements = 3
//
//        var returnString = ""
//
//        if num<=maxSpace {
//            // Print whole matrix
//            for n in 0..<num {
//                returnString += numberAsString(number: a[n]) + " "
//            }
//        } else {
//            // Print partial matrix
//            for n in 0..<firstElements {
//                returnString += numberAsString(number: a[n]) + " "
//            }
//            returnString += "... "
//            for n in (num-lastElements)..<num {
//                returnString += numberAsString(number: a[n]) + " "
//            }
//        }
//        // Remove the last character
//        return returnString.substring(to: returnString.index(before: returnString.endIndex))
//    }
//
//    func numberAsString(number: Double) -> String {
//        var returnString: String
//        if abs(number)<10000 {
//            returnString = String(format: "%10g", number)+"   "
//        } else {
//            // Format larger numbers as scientific format of fixed length
//            returnString = String(format: "%10e", number)
//            if number>=0 {
//                returnString = " " + returnString
//            }
//        }
//        return returnString
//    }
//}
//
//// Operator overloading
//// --------------------
//
//// Note: Accelerate could be used here instead here of map/zip
//
//// Adding 2 matrices
//func +(left: Matrix, right: Matrix) -> Matrix {
//    assert(left.rows == right.rows && left.columns == right.columns)
//    return Matrix(rows: left.rows, columns: left.columns, grid: zip(left.grid, right.grid).map(+))
//}
//
//// Adding a scalar to a matrix -> the scalar is added to each element
//func +(left: Double, right: Matrix) -> Matrix {
//    return Matrix(rows: right.rows, columns: right.columns, grid: right.grid.map({$0+left}))
//}
//
//func +(left: Matrix, right: Double) -> Matrix {
//    return Matrix(rows: left.rows, columns: left.columns, grid: left.grid.map({$0+right}))
//}
//
//// Subtracting a scalar from a matrix -> the scalar is subtracted from each element
//func -(left: Double, right: Matrix) -> Matrix {
//    return Matrix(rows: right.rows, columns: right.columns, grid: right.grid.map({left-$0}))
//}
//
//func -(left: Matrix, right: Double) -> Matrix {
//    return Matrix(rows: left.rows, columns: left.columns, grid: left.grid.map({$0-right}))
//}
//
//// Subtraction with 2 matrices
//func -(left: Matrix, right: Matrix) -> Matrix {
//    assert(left.rows == right.rows && left.columns == right.columns)
//    return Matrix(rows: left.rows, columns: left.columns, grid: zip(left.grid, right.grid).map(-))
//}
//
//// Multiplying a matrix by minus 1
//prefix func -(right: Matrix) -> Matrix {
//    return -1.0*right
//}
//
//// Multiplying two matrices: matrix multiplication
//func *(left: Matrix, right: Matrix) -> Matrix {
//    assert(left.columns == right.rows)
//    var result = Matrix(rows: left.rows, columns: right.columns)
//    vDSP_mmulD(left.grid, 1, right.grid, 1, &result.grid, 1, UInt(left.rows), UInt(right.columns), UInt(left.columns))
//    // Note: this could also be achieved using cblas_dgemm
//    return result
//}
//
//// Multiplying a matrix by a scalar
//func *(left: Matrix, right: Double) -> Matrix {
//    return Matrix(rows: left.rows, columns: left.columns, grid: left.grid.map({$0*right}))
//}
//
//func *(left: Double, right: Matrix) -> Matrix {
//    return Matrix(rows: right.rows, columns: right.columns, grid: right.grid.map({$0*left}))
//}
//
//// Are two matrices equal
//func ==(left: Matrix, right: Matrix) -> Bool {
//    return (left.grid == right.grid) && (left.rows == right.rows) && (left.columns == right.columns)
//}
//
//// Useful functions for machine learning
//// -------------------------------------
//
//// Sigmoid function for double
//func sigmoid(_ input: Double) -> Double {
//    return 1/(1+exp(-input))
//}
//
//// Sigmoid function for matrix
//func sigmoid(_ input: Matrix) -> Matrix {
//    return Matrix(rows: input.rows, columns: input.columns, grid: input.grid.map({sigmoid($0)}))
//}
//
//// Logarithm of a matrix
//func log(_ input: Matrix) -> Matrix {
//    return Matrix(rows: input.rows, columns: input.columns, grid: input.grid.map({log($0)}))
//}
//
//// Sum the rows in each column of a matrix
//func sumRows(_ input: Matrix) -> Matrix {
//    var output = Matrix(rows: 1, columns: input.columns)
//    var sum = 0.0
//    for column in 0..<input.columns {
//        sum = 0
//        for row in 0..<input.rows {
//            sum += input[row,column]
//        }
//        output[0,column] = sum
//    }
//    return output
//}
//
//// Sum all elements of a matrix
//func sumAllElements(_ input: Matrix) -> Double {
//    return input.grid.reduce(0.0, +)
//}
//
//// Reading data into a matrix from a CSV file in the resources section of the playground
//func readDataFromFile(fileName: String, fileNameExtension: String) -> Matrix? {
//    // Read in data from file
//    var grid: [Double] = []
//    var rows = 0
//    var columns = 0
//
//    // Open the file
//    guard let fileURL = Bundle.main.url(forResource:fileName, withExtension: fileNameExtension) else {
//        print("File not found")
//        return nil
//    }
//
//    // Read the file contents to a String
//    guard let text = try? String(contentsOf: fileURL, encoding: String.Encoding.utf8)
//        else {
//            print("Error reading the file contents")
//            return nil
//    }
//
//    // Split the lines into a String array, removing any empty lines
//    let lines = text.components(separatedBy: String("\n")).filter( { $0 != "" } )
//
//    // Split each line into components
//    for line in lines {
//        rows += 1
//        let lineComponents = line.components(separatedBy: ",")
//        if rows == 1 { // first row
//            columns = lineComponents.count
//        }
//        if columns != lineComponents.count {
//            print("Error at file line:", rows)
//            print("Number of values in each line of file varies")
//            return nil
//        }
//        for component in lineComponents.enumerated() {
//            if let componentAsDouble = Double(component.1) {
//                grid.append(componentAsDouble)
//            } else {
//                print("Error at file line:", rows)
//                print("Can not convert file values to type Double")
//                return nil
//            }
//        }
//    }
//    return Matrix(rows: rows, columns: columns, grid: grid)
//}

//
//  Fraction.swift
//  System of Equations
//
//  Created by Brian Veitch on 1/6/2020
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import Foundation

class Fraction {

    var num: Int = 1
    var den: Int = 1
    var isNegative = false
    
    public init(num: Int, den: Int) {
    
           if(num < 0 && den < 0){
               // make both positive
               self.num = -1 * num
               self.den = -1 * den
           }
           else if(num > 0 && den < 0){
               self.num = -1 * num
               self.den = -1 * num
           }
           else {
               self.num = num
               self.den = den
           }
           if(self.num < 0){
               self.isNegative = true
           }
           self.reduce()
    }
    func show() -> (Int, Int) {
        return (num, den)
    }
    func update(_ num: Int, _ den: Int) {
        self.num = num
        self.den = den
    }
    
    func gcd(a:Int, b:Int) -> Int {
        if a == b {
            return a
        }
        else {
            if a > b {
                return gcd(a:a-b,b:b)
            }
            else {
                return gcd(a:a,b:b-a)
            }
        }
    }
    
    func reduce() -> Void {
        
        var divideBy: Int = 1
        let ratio: Double = Double(abs(num))/Double(den)
        let ratio2: Double = Double(den)/Double(abs(num))
        
        
        if(num == 0){
            num = 0
            den = 1
        }
        
        else if(floor(ratio) == ratio){
            // it's an integer
         //   print("it's the denonminator")
            divideBy = den
        }
        else if(floor(ratio2) == ratio2){
          //  print("it's the numerator")
            divideBy = abs(num)
        }
         
        else if (abs(num) > den) {
            let tempNum = abs(num) - (abs(num)/den) * den
            divideBy = self.gcd(a: tempNum, b: den)
        }
            
        else if (den > abs(num)){
           let tempDen = den - (den/abs(num)) * abs(num)
            divideBy = self.gcd(a: abs(num), b: tempDen)
        }
        else {
            
        }
       
        num = num / divideBy
        den = den / divideBy
      
    }
    
    func fraction() -> String {
        
        var dString: String = "/\(den)"
        if(den == 1 || num == 0){
            dString = ""
        }
        return "\(num)\(dString)"
        
    }
    
    func reciprocal () -> String {
        
        var numerator = num
        var denominator = den
        if(numerator < 0){
            numerator = num * -1
            denominator = den * -1
        }
        print("Fraction is ", numerator, " / ", denominator)
        if (numerator == 1){
            return "\(denominator)"
        }
        else {
            return "\(denominator)/\(numerator)"
        }
        
        
    }
    
    func reciprocalAsFraction() -> Fraction {
        if(num < 0){
            num = num * -1
            den = den * -1
        }
        
        return Fraction(num: den, den: num)
    }
    
    func reciprocate() -> Fraction {
        var numerator = num
        var denominator = den
        if(numerator < 0){
            numerator *= -1
            denominator *= -1
        }
        
        return Fraction(num: denominator, den: numerator)
        
    }
    
 
    
    func negateForText () -> String {
        let N = num * -1
        if (den == 1){
            return "\(N)"
        }
        else {
            return "\(N)/\(den)"
        }
    }
    
    func asDouble() -> Double {
        return Double(num)/Double(den)
    }
    
}

extension Fraction {
    // operator overload
    static func *(lhs: Fraction, rhs: Fraction) -> Fraction {
        
        let numerator = lhs.num * rhs.num
        let denominator = lhs.den * rhs.den
       // print("mult by constant: ", numerator, denominator)
        return Fraction(num: numerator, den: denominator)
    }
    
    static func /(lhs: Fraction, rhs: Fraction) -> Fraction {
        
        var numerator = lhs.num * rhs.den
        var denominator = lhs.den * rhs.num
        if(denominator < 0) {
            denominator *= -1
            numerator *= -1
        }
       // print("mult by constant: ", numerator, denominator)
        return Fraction(num: numerator, den: denominator)
    }
    
    static func <(lhs: Fraction, rhs: Fraction) -> Bool {
        
        let lhsDouble = lhs.asDouble()
        let rhsDouble = rhs.asDouble()
        if(lhsDouble < rhsDouble) {
            return true
        }
        else {
            return false
        }
      
    }
    
    static func <=(lhs: Fraction, rhs: Fraction) -> Bool {
        let leftSide = abs(lhs.num)*rhs.den
        let rightSide = abs(rhs.num)*lhs.den
        
        if(leftSide <= rightSide){
            return true
        }
        else {
            return false
        }
    }
    
    static func +(lhs: Fraction, rhs: Fraction) -> Fraction {
        // a/b + c/d = (ad + bc)/(bd)
        let numerator = (lhs.num * rhs.den) + (lhs.den * rhs.num)
        let denominator = lhs.den * rhs.den
        print("R1+cR2: \(lhs.num)/\(lhs.den) + \(rhs.num)/\(rhs.den)    / \(lhs.den)*\(rhs.den)")
        print("\(lhs.num) * \(rhs.den) + \(lhs.den)*\(rhs.num)   / \(lhs.den)*\(rhs.den) = \(numerator)/\(denominator)")
        return Fraction(num: numerator, den: denominator)
    }
    
    
    
    static func *(lhs: Int, rhs: Fraction) -> String {
        let numerator = lhs * rhs.num
        return "\(numerator)/\(rhs.den)"
    }
    
    static func ==(lhs: Fraction, rhs: Fraction) -> Bool {
        if (lhs.num == rhs.num && lhs.den == rhs.den){
            return true
        }
        else {
            return false
        }
    }
    static func !=(lhs: Fraction, rhs: Fraction) -> Bool {
        // a/b + c/d = (ad + bc)/(bd)
        if lhs == rhs {
            return false
        }
        else {
            return true
        }
    }
}

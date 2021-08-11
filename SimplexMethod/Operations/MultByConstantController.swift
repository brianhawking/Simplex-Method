//
//  MultByConstantController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/12/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class MultByConstantController: UIViewController {
    
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")

    var fraction: Fraction = Fraction(num: 1, den: 1)
    var rowToMultiply: Int = 0
    
    var delegate: MultiplyByConstantDelegate?
    
    var firstTime: Bool = true
    
    var numberOfInequalities: Int = 2
    
    @IBOutlet weak var mainView: CommonButton!
    @IBOutlet weak var constantLabel: UILabel!
    
    @IBOutlet weak var selectedRow: UIImageView!
    @IBOutlet weak var newRow: UIImageView!
    
    var selectedRowInt: Int = 0
    
    @IBOutlet var RowButtons: [UIButton]!
    var pointSize: CGFloat = 36
    
    
    @IBOutlet weak var deleteButton: KeypadButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colors.changeColorScheme(scheme: scheme)
        
        pointSize = constantLabel.font.pointSize
        
        for button in RowButtons {
            
            if(button.tag > numberOfInequalities){
                button.isHidden = true
            }
        }
        
        deleteButton.tintColor = colors.UIColorFromHex(rgbValue: colors.button1Text)
        
        adjustSizes()
    }
    
    func adjustSizes() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
    }
    func convertToFraction() {

        if(constantLabel.text! == ""){
            constantLabel.text! = "1"
        }

        var numerator: Int = 1
        var denominator: Int = 1

        if(constantLabel.text!.contains("/")){
            // find num, den
            let ND = constantLabel.text!.components(separatedBy: "/")

            numerator = Int(ND[0])!
            denominator = Int(ND[1])!


        }
        else {
            numerator = Int(constantLabel.text!)!
        }
        
        fraction.update(numerator, denominator)
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func DismissAction(_ sender: Any) {
        
        if(isNumberValid() == false){
            return
        }
        convertToFraction()
        
        if(constantLabel.text! == "" || fraction.den == 0){
            return
        }
        else {
            dismiss(animated: true) {
                
            self.delegate?.getConstant(row: self.rowToMultiply, multiplyBy: self.fraction)
            }
        }
        
    

        
    }
    
    @IBAction func enterNumbers(_ sender: UIButton) {
        
        if firstTime == true {
            constantLabel.text! = ""
            firstTime = false
        }
        
        switch sender.tag {
        case 1...10:
            constantLabel.text! += String(sender.tag-1)
            
        case 12:
        
            if(constantLabel.text!.contains("-")){
                constantLabel.text!.removeFirst()
            }
            else {
                constantLabel.text!.insert("-", at: constantLabel.text!.startIndex)
            }
            
        case 18:
            if(constantLabel.text!.count > 0){
               constantLabel.text!.removeLast()
            }
            
            
        case 21:
            if(constantLabel.text!.count == 0){
                return
            }
            
            if(!constantLabel.text!.contains("/")){
                // doesn't have fraction bar
                constantLabel.text! += "/"
            }
            
        default:
            break
        }
        
        
        constantLabel.displayFraction(pointSize: pointSize)
        
    }
    
    
    
    @IBAction func selectButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
           selectedRow.image = UIImage(named: "R1")
           newRow.image = UIImage(named: "R1")
        case 2:
            selectedRow.image = UIImage(named: "R2")
            newRow.image = UIImage(named: "R2")
        case 3:
            selectedRow.image = UIImage(named: "R3")
            newRow.image = UIImage(named: "R3")
        case 4:
            selectedRow.image = UIImage(named: "R4")
            newRow.image = UIImage(named: "R4")
        default:
            return
        }
        
        rowToMultiply = sender.tag-1
        
    }
    
    func isNumberValid() -> Bool {
        if(constantLabel.text! == "-"){
            constantLabel.text = "-1"
            return true
        }
        if(constantLabel.text! == "" || constantLabel.text! == " "){
            constantLabel.text! = "1"
            return true
        }
        let ND = constantLabel.text!.components(separatedBy: "/")

        if(ND.count == 2) {
            if(ND[1] == "" || Int(ND[1]) == 0){
                return false
            }
            
        }
        
        return true
    }
}

protocol MultiplyByConstantDelegate {
    func getConstant(row: Int, multiplyBy: Fraction)
}


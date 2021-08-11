//
//  SwapController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/11/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class SwapController: UIViewController {

    var delegate: SwapRowsDelegate?
    
    var numberOfInequalities: Int = 1
    
    @IBOutlet var rowButtons: [CommonButton]!
    @IBOutlet weak var leftRow: UIImageView!
    @IBOutlet weak var rightRow: UIImageView!
    @IBOutlet weak var swapButton: CommonButton!
    @IBOutlet weak var mainView: CommonButton!
    @IBOutlet weak var operationStackView: UIStackView!
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    
    var clickedRows: [Int] = [0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colors.changeColorScheme(scheme: scheme)
        
        for button in rowButtons {
            button.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2)
            button.isHidden = true
        }
        for i in 0..<numberOfInequalities {
            rowButtons[i].isHidden = false
        }
    }
   
    @IBAction func clickedRows(_ sender: UIButton) {
        
        if(clickedRows.contains(sender.tag)){
            if let index = clickedRows.firstIndex(where: {$0 ==  sender.tag}) {
                if(clickedRows[0] == sender.tag){
                    leftRow.image = UIImage(named: "")
                    clickedRows[index] = 0
                }
                else {
                    rightRow.image = UIImage(named: "")
                    clickedRows[index] = 0
                }
                
                
            }
            rowButtons[sender.tag-1].backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2)
        }
        else {
            
            if !(clickedRows.contains(0)) {
                return
            }
            
            if let index = clickedRows.firstIndex(where: {$0 ==  0}) {
                if (index == 0){
                    leftRow.image = UIImage(named: "R\(sender.tag)")
                    clickedRows[index] = sender.tag
                }
                else if(index == 1){
                    rightRow.image = UIImage(named: "R\(sender.tag)")
                    clickedRows[index] = sender.tag
                }
                else {
                    return
                }
            }
        
            rowButtons[sender.tag-1].backgroundColor = UIColor.red
         
            
        }
    }
    
    @IBAction func swapAction(_ sender: Any) {
        if(!clickedRows.contains(0)){
            dismiss(animated: true) {
                self.delegate?.swapRowsSelected(rows: self.clickedRows)
            }
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

protocol SwapRowsDelegate {
    func swapRowsSelected(rows: [Int])
}

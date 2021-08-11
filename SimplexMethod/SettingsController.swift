//
//  SettingsController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/23/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backgroundText: [UILabel]!
    
    @IBOutlet weak var schemeLabel: UILabel!
    
    
    @IBOutlet weak var button1: CommonButton!
    
    @IBOutlet var buttons: [CommonButton]!
    
 
    @IBOutlet var keypadButtons: [KeypadButton]!
    @IBOutlet weak var popup: PopUpButton!
    @IBOutlet weak var popupText: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    var colors = ColorScheme()
    var scheme: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if(!UserDefaults.standard.contains(key: "scheme")){
           UserDefaults.standard.set(0, forKey: "scheme")
        }
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))

        
        schemeLabel.text = String(UserDefaults.standard.integer(forKey: "scheme"))
        stepper.value = Double(UserDefaults.standard.integer(forKey: "scheme"))
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        backgroundView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        popup.backgroundColor = colors.UIColorFromHex(rgbValue: colors.popup)
        popupText.textColor = colors.UIColorFromHex(rgbValue: colors.popupText)
        
        
    }
    
    
    @IBAction func scheme(_ sender: UIStepper) {
        
        schemeLabel.text = String(Int(sender.value))
        colors.changeColorScheme(scheme: Int(sender.value))
        UserDefaults.standard.set(Int(sender.value), forKey: "scheme")
        scheme = UserDefaults.standard.integer(forKey: "scheme")
        
        backgroundView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        for button in buttons {
           button.changeScheme(scheme: scheme)
        }
        
        
        for button in keypadButtons {
            button.changeScheme(scheme: scheme)
        }
        
        popup.backgroundColor = colors.UIColorFromHex(rgbValue: colors.popup)
        popupText.textColor = colors.UIColorFromHex(rgbValue: colors.popupText)
        popup.layer.borderColor = colors.UIColorFromHex(rgbValue: colors.popupBorder).cgColor
    }
    

    

}

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

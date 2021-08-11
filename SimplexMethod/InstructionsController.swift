//
//  InstructionsController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/26/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class InstructionsController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var backgroundText: UITextView!
    
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.array(forKey: "scheme")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        backgroundText.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        backgroundText.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
    }
    


}

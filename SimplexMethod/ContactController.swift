//
//  ContactController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/26/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class ContactController: UIViewController {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet var backgroundText: [UILabel]!
    
    
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.array(forKey: "scheme")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        for text in backgroundText {
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
    }
    


}

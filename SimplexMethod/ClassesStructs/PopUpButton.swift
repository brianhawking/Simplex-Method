//
//  PopUpButton.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/11/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import Foundation
import UIKit

class PopUpButton : UIButton {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
      }

   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
      }

    func setup() {
        
        var colors = ColorScheme()
        // set up colors
        
        if(!UserDefaults.standard.contains(key: "scheme")){
           UserDefaults.standard.set(0, forKey: "scheme")
        }
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        // colors
        self.backgroundColor = colors.UIColorFromHex(rgbValue: colors.popup, alpha: 1)
        self.setTitleColor(colors.UIColorFromHex(rgbValue: colors.popupText, alpha: 1), for: .normal)
        self.layer.borderColor = colors.UIColorFromHex(rgbValue: colors.popupBorder).cgColor
      }
    
    
    

}

//
//  CommonButton.swift
//  Simplex Method
//
//  Created by Brian Veitch on 1/6/2020
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import Foundation
import UIKit

class CommonButton : UIButton {

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
        if(!UserDefaults.standard.contains(key: "scheme")){
           UserDefaults.standard.set(0, forKey: "scheme")
        }
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        // colors
        self.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2, alpha: 1)
        self.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button2Text, alpha: 1), for: .normal)
    
      }
    
    func changeScheme(scheme: Int) {
        var colors = ColorScheme()
        colors.changeColorScheme(scheme: scheme)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        // colors
        self.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2, alpha: 1)
        self.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button2Text, alpha: 1), for: .normal)
    }
    
    
    

}

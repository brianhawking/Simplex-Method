//
//  MenuButton.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/6/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import Foundation
import UIKit

class MenuButton : UIButton {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
      }

   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
      }

    func setup() {
        
        let colors = ColorScheme()
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        // colors
        self.backgroundColor = colors.UIColorFromHex(rgbValue: colors.lightButton, alpha: 1)
        self.setTitleColor(colors.UIColorFromHex(rgbValue: colors.lightText, alpha: 1), for: .normal)
    
      }
    
    
    

}

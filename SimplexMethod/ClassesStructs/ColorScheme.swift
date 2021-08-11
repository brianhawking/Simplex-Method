//
//  colorScheme.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/6/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import Foundation
import UIKit

struct ColorScheme {
    
    var button1: UInt32 = 0xA1582B
    var button1Text: UInt32 = 0xA23EFA
    var button2: UInt32 = 0x665EB8
    var button2Text: UInt32 = 0xFEC29C
    var background: UInt32 = 0xFEC29C
    var backgroundText: UInt32 = 0x000000
    var popup: UInt32 = 0xFFFFFF
    var popupText: UInt32 = 0x000000
    var popupBorder: UInt32 = 0x000000
    var border: UInt32 = 0x2010CC
    var labelBackground: UInt32 = 0xFFFFFF
    var text: UInt32 = 0x000000
    
    var lightButton: UInt32 = 0xFEC29C
    var lightText: UInt32 = 0x000000
    
    mutating func changeColorScheme(scheme: Int) {
        
        switch scheme {
        case 2:
            button1 = 0x816c61
            button1Text = 0xffffff
            button2 = 0x816c61
            button2Text = 0xffffff
            background = 0xa89b9d
            backgroundText = 0xffffff
            popup = 0x2A2C24
            popupText = 0xCFCFEA
            popupBorder = 0xffffff
            border = 0x2010CC
            text = 0x000000
            labelBackground = 0x000000
            lightButton = 0xFEC29C
            lightText = 0x000000
            
        case 1:
            background = 0x659Dbd
            backgroundText = 0xFFFFFF
            labelBackground = 0xbc986a
            button1 = 0xFFFFFF
            button1Text = 0x659dbd
            button2 = 0xbc986a
            button2Text = 0xffffff
            popup = 0xfbeec1
            popupText = 0x000000
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 3:
            background = 0x3EEFE6
            backgroundText = 0x00004F
            labelBackground = 0xFFFFFFF
            button1 = 0xfc4445
            button1Text = 0xffffff
            button2 = 0xfc4445
            button2Text = 0xffffff
            popup = 0x55bcc9
            popupText = 0xffffff
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
        
        case 4:
            background = 0x222629
            backgroundText = 0x86c232
            labelBackground = 0xffffff
            button1 = 0x6b6e70
            button1Text = 0x000000
            button2 = 0x61892f
            button2Text = 0x000000
            popup = 0x379683
            popupText = 0xffffff
            popupBorder = 0xffffff
            border = 0x2010CC
            text = 0x000000
            
        case 5:
            background = 0xe1b382
            backgroundText = 0x000000
            labelBackground = 0xFFFFFFF
            button1 = 0x12343b
            button1Text = 0xffffff
            button2 = 0x2d545e
            button2Text = 0xffffff
            popup = 0x3c89666
            popupText = 0x000000
            popupBorder = 0xffffff
            border = 0x2010CC
            text = 0x000000
            
        case 6:
            background = 0xb56062
            backgroundText = 0x000000
            labelBackground = 0xffffff
            button1 = 0x9e8ea5
            button1Text = 0xffffff
            button2 = 0xe68f83
            button2Text = 0xffffff
            popup = 0x964B4D
            popupText = 0xffffff
            popupBorder = 0xffffff
            border = 0x2010CC
            text = 0x000000
            
        case 7:
            background = 0x323334
            backgroundText = 0xffffff
            labelBackground = 0xa35c53
            button1 = 0xa35c53
            button1Text = 0xffffff
            button2 = 0xca955e
            button2Text = 0xffffff
            popup = 0xffffff
            popupText = 0x000000
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 8:
            background = 0xf8f8f8
            backgroundText = 0x323334
            labelBackground = 0xFFFFFFF
            button1 = 0xa35c53
            button1Text = 0xffffff
            button2 = 0xca955e
            button2Text = 0x000000
            popup = 0x9aa4a5
            popupText = 0x323334
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 9:
            background = 0xc3c1ac
            backgroundText = 0x121a1c
            labelBackground = 0xFFFFFFF
            button1 = 0x53ac98
            button1Text = 0xffffff
            button2 = 0x2c79a5
            button2Text = 0xffffff
            popup = 0x7e593f
            popupText = 0xc3c1ac
            popupBorder = 0x2c79a5
            border = 0x2010CC
            text = 0x000000
            
        case 10:
            background = 0x494b63
            backgroundText = 0xc1bcc2
            labelBackground = 0xed5b4d
            button1 = 0xed5b4d
            button1Text = 0xffffff
            button2 = 0x9fa5a6
            button2Text = 0xffffff
            popup = 0xf5f3ef
            popupText = 0x494b63
            popupBorder = 0x494b63
            border = 0x2010CC
            text = 0x000000
            
        case 11:
            background = 0x66fcf1
            backgroundText = 0x1f2833
            labelBackground = 0xffffff
            button1 = 0x45a293
            button1Text = 0x0b0c10
            button2 = 0x45a293
            button2Text = 0x0b0c10
            popup = 0xc5c6c7
            popupText = 0x0b0c10
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 12:
            background = 0x1f2833
            backgroundText = 0xc5c6c7
            labelBackground = 0x45a29e
            button1 = 0x66fcf1
            button1Text = 0x0b0c10
            button2 = 0xc5c6c7
            button2Text = 0x0b0c10
            popup = 0x66fcf1
            popupText = 0x1f2933
            popupBorder = 0x1f2933
            border = 0x2010CC
            text = 0x000000
        
        case 13:
            background = 0xf76c6c
            backgroundText = 0xf8e9a1
            labelBackground = 0x24305e
            button1 = 0x374785
            button1Text = 0xf8e9a1
            button2 = 0x24305e
            button2Text = 0xf8e9a1
            popup = 0xa8d0e6
            popupText = 0x24305e
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 14:
            background = 0xf4f4f4
            backgroundText = 0x373737
            labelBackground = 0xdcd0c0
            button1 = 0xdcd0c0
            button1Text = 0x373737
            button2 = 0xc0b283
            button2Text = 0x373737
            popup = 0x373737
            popupText = 0xdcd0c0
            popupBorder = 0xdcd0c0
            border = 0x2010CC
            text = 0x000000
            
        case 15:
            background = 0x0e0b16
            backgroundText = 0xe7dfdd
            labelBackground = 0x4717e6
            button1 = 0xa239ca
            button1Text = 0xe7dfdd
            button2 = 0xa239ca
            button2Text = 0xe7dfdd
            popup = 0xe7dfdd
            popupText = 0x0e0b16
            popupBorder = 0xa239ca
            border = 0x2010CC
            text = 0x000000
            
        case 16:
            background = 0x8fd8d2
            backgroundText = 0x000000
            labelBackground = 0xffffff
            button1 = 0xdf744a
            button1Text = 0x000000
            button2 = 0xdf744a
            button2Text = 0xfedcd2
            popup = 0xfedcd2
            popupText = 0x000000
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 17:
            background = 0xB2C7D6
            backgroundText = 0x000000
            labelBackground = 0xffffff
            button1 = 0xb37d4e
            button1Text = 0xB2C7D6
            button2 = 0x286da8
            button2Text = 0xffffff
            popup = 0x438496
            popupText = 0xffffff
            popupBorder = 0xcd5360
            border = 0x2010CC
            text = 0x000000
            
        case 18:
            background = 0xf7ce3e
            backgroundText = 0x1a2930
            labelBackground = 0xffffff
            button1 = 0x1a2930
            button1Text = 0xffffff
            button2 = 0x1a2930
            button2Text = 0xffffff
            popup = 0xc5c1c0
            popupText = 0x000000
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
        case 19:
            background = 0x292929
            backgroundText = 0xE1E1E1
            labelBackground = 0x078786
            button1 = 0xBB86FC
            button1Text = 0x00221E
            button2 = 0xBB86FC
            button2Text = 0x00221E
            popup = 0x057374
            popupText = 0xE1E1E1
            popupBorder = 0xBB86FC
            border = 0x2010CC
            text = 0x000000
            
        default:
            button1 = 0xA1582B
            button1Text = 0xFFFFFF
            button2 = 0x665EB8
            button2Text = 0xFEC29C
            background = 0xFEC29C
            backgroundText = 0x000000
            labelBackground = 0xffffff
            popup = 0xFFFFFF
            popupText = 0x000000
            popupBorder = 0x000000
            border = 0x2010CC
            text = 0x000000
            
            lightButton = 0xFEC29C
            lightText = 0x000000
        }
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
}



extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

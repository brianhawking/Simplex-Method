//
//  ViewController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/6/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomeController: UIViewController {

    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.array(forKey: "scheme")
    var hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
   
    // mainview
    @IBOutlet var mainView: UIView!
    @IBOutlet var backgroundText: [UILabel]!
    
    // side menu setup
    @IBOutlet weak var menuView: UIView!
    var menuShowing: Bool = false
    @IBOutlet weak var menuConstraint: NSLayoutConstraint!
    
    @IBOutlet var menuButtons: [MenuButton]!
    
    @IBOutlet var homeButtons: [CommonButton]!
    
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temporary allow instant solution
        //KeychainWrapper.standard.set(true, forKey: "com.brianveitch.SimplexMethod.InstantSolution")
        //KeychainWrapper.standard.removeObject(forKey: "com.brianveitch.SimplexMethod.InstantSolution")
        // set up colors
        
        if(!UserDefaults.standard.contains(key: "scheme")){
           UserDefaults.standard.set(0, forKey: "scheme")
        }
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        
        
        // toggle hints
        UserDefaults.standard.set(true, forKey: "hintsOn")
        hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
    
        for text in backgroundText{
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        setupButtons()
        
        menuView.layer.shadowOpacity = 0
        menuView.layer.shadowRadius = 6
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // chnage colors if needed
        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        for text in backgroundText{
            text.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        }
        
        for button in homeButtons {
            button.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2)
            button.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button2Text), for: .normal)
        }
        
    }
    
    func setupButtons() {
//        for button in homeButtons {
//            button.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2, alpha: 1)
//            button.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button2Text, alpha: 1), for: .normal)
//         }
        
        for button in menuButtons {
            button.backgroundColor = colors.UIColorFromHex(rgbValue: colors.lightButton)
            button.setTitleColor(colors.UIColorFromHex(rgbValue: colors.lightText), for: .normal)
        }
        
      
    }

    @IBAction func toggleMenu(_ sender: Any) {
        
        if (menuShowing) {
            // hide menu
            menuConstraint.constant = -175
            menuView.layer.shadowOpacity = 0
            mainView.layer.opacity = 1
           // mainView.isHidden = true
        }
        else {
            menuConstraint.constant = 0
            menuView.layer.shadowOpacity = 1
            mainView.layer.opacity = 0.8
            mainView.isHidden = false
            
    
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        menuShowing = !menuShowing
        
    }
    
    
    
    
}


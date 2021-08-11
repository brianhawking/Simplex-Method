//
//  PopUpNotification.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/16/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit

class PopUpNotification: UIViewController {

    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.integer(forKey: "scheme")
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var PopUp: PopUpButton!
    @IBOutlet weak var upgradeButton: CommonButton!
    
    @IBOutlet weak var message: UILabel!
    var messageText: String = ""
    var pointSize: CGFloat = 24
    
    @IBOutlet weak var dismissButton: CommonButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up color scheme
        colors.changeColorScheme(scheme: scheme)
        pointSize = message.font.pointSize
        
        upgradeButton.isHidden = true
        if(messageText.contains("This is a premium ability.")) {
            upgradeButton.isHidden = false
        }
        
        message.textColor = colors.UIColorFromHex(rgbValue: colors.popupText)
        
        message.text = messageText
        
        PopUp.backgroundColor = colors.UIColorFromHex(rgbValue: colors.popup)

    }
    
    @IBAction func dismissMessage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToUpgradeControllerSegue" {
            
            
            let vc = segue.destination as! UpgradeController
            vc.notified = true
        }
    }
    
    
    @IBAction func upgradeAction(_ sender: Any) {
        performSegue(withIdentifier: "ToUpgradeControllerSegue", sender: nil)
    }
    

}

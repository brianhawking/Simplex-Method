//
//  UpgradeController.swift
//  SimplexMethod
//
//  Created by Brian Veitch on 1/23/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import StoreKit

class UpgradeController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet var buttons: [CommonButton]!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var dismissButton: CommonButton!
    
    var notified: Bool = false
    
    var ZERO = Fraction(num: 0, den: 1)
    var ONE = Fraction(num: 1, den: 1)
    var price: String = "0.00"
    var product = SKProduct()
    
    
    // custom classes / structs
    var colors = ColorScheme()
    var scheme = UserDefaults.standard.array(forKey: "scheme")
    var hintsOn = UserDefaults.standard.bool(forKey: "hintsOn")
    
    // IAP stuff
    var products: [SKProduct] = []
    @IBOutlet weak var purchaseButton: CommonButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check for IAPs
        IAPProducts.store.requestProducts{ [weak self] success, products in
          guard let self = self else { return }
            if success {
                self.products = products!
                print(self.products)
                self.product = products![0]
                print("Price is", self.products[0])
                self.price = self.products[0].localizedPrice
                print(self.price)
                
            }
        }
        
        print("222 ", IAPProducts.store.price)
        
        // add purchase observer
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
        name: .IAPHelperPurchaseNotification,
        object: nil)
        print("111 ", price)
        
        
        

        colors.changeColorScheme(scheme: UserDefaults.standard.integer(forKey: "scheme"))
        
        mainView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        textView.textColor = colors.UIColorFromHex(rgbValue: colors.backgroundText)
        textView.backgroundColor = colors.UIColorFromHex(rgbValue: colors.background)
        for button in buttons {
            button.backgroundColor = colors.UIColorFromHex(rgbValue: colors.button2)
            button.setTitleColor(colors.UIColorFromHex(rgbValue: colors.button2Text), for: .normal)
        }
        self.purchaseButton.setTitle("Upgrade: \(IAPProducts.store.price)", for: .normal)
        
        if(notified == false){
            dismissButton.isHidden = true
        }
        
        checkPurchase()
        
    }
    
    func update() {
        
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String,
        
            let _ = products.firstIndex(where: { product -> Bool in
            product.productIdentifier == productID
            
        })
            else { return }
        
        self.checkPurchase()
    }
    
    func checkPurchase(){
        if(IAPProducts.store.isProductPurchased(IAPProducts.InstantSolution)){
            openPopUpMessage(message: "You now own this sweet premium ability! Thank you for your support. ")
            purchaseButton.setTitle("Owned!", for: .normal)
        }
        print("check purchase ", price)
        print("CHECKING")
    }
    
    @IBAction func restoreButton(_ sender: Any) {
        print("trying to restore")
        IAPProducts.store.restorePurchases()
        
        checkPurchase()
    }
    
    @IBAction func puchaseButton(_ sender: Any) {
        print("Trying to purchase")
        // filter through products
    
        if(IAPProducts.store.isProductPurchased(IAPProducts.InstantSolution)){
            purchaseButton.setTitle("Owned!", for: .normal)
            let messageToUser = "Congrats.  You already own this sweet premium ability!\n"
            openPopUpMessage(message: messageToUser)
        } else {
           IAPProducts.store.purchaseProduct(products, IAPProducts.InstantSolution)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
        let matrixOfNumbers: Matrix = Matrix(rows: 5, columns: 9, grid: [
            [Fraction(num: 1, den: 1), Fraction(num: 2, den: 1), ZERO, ONE, ZERO, ZERO, ZERO, ZERO, Fraction(num: 8, den: 1)],
            [Fraction(num: 3, den: 1), Fraction(num: 2, den: 1), ZERO, ONE, ZERO, ZERO, ZERO, ZERO, Fraction(num: 16, den: 1)],
            [ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO],
            [ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO, ZERO],
            [Fraction(num: -50, den: 1), Fraction(num: -54, den: 1), ZERO, ZERO, ZERO, ZERO, ZERO, ONE, ZERO]
            
        ])
        
        
        
        if(segue.identifier == "SolutionSegueExample"){
               
            let vc = segue.destination as! SolutionControllerExample
            vc.matrix = matrixOfNumbers
            vc.numberOfInequalities = 2
            vc.numberOfVariables = 2
            vc.problemType = "Maximize"
            vc.notified = notified
        }
    
    }
    
    func openPopUpMessage(message: String) {
        print(message)
        
        //
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpNotification") as! PopUpNotification
        vc.messageText = message
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

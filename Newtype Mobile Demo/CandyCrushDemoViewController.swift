//
//  CandyCrushDemoViewController.swift
//  Newtype Mobile Demo
//
//  Created by Franklin Ho on 1/26/15.
//  Copyright (c) 2015 Franklin Ho. All rights reserved.
//

import UIKit
import AdSupport

class CandyCrushDemoViewController: UIViewController {

    @IBOutlet weak var purchaseCompleteView: UIView!
    @IBOutlet weak var buyGoldView: UIView!
    @IBOutlet weak var stripedLollipopView: UIView!
    @IBOutlet weak var lollipopView: UIView!
    var buyGoldHidden = true
    var lollipopHidden = true
    var stripedLollipopHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lollipopView.hidden = lollipopHidden
        self.stripedLollipopView.hidden = stripedLollipopHidden
        self.buyGoldView.hidden = buyGoldHidden
        self.purchaseCompleteView.hidden = true
        
        var purchaseCompleteLayer : CALayer = purchaseCompleteView.layer
        
        purchaseCompleteLayer.masksToBounds = true
        purchaseCompleteLayer.cornerRadius = 10.0
        purchaseCompleteLayer.borderColor = UIColor.blackColor().CGColor
        purchaseCompleteLayer.borderWidth = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func lollipopViewCloseButtonWasTapped(sender: AnyObject) {
        println("Lollipop Close")
        self.lollipopView.alpha = 1
        
        UIView.animateWithDuration(0.3, animations: {
            self.lollipopView.alpha = 0

            }, completion: {
                (value: Bool) in
                self.lollipopView.hidden = true
        })
    }
    
    @IBAction func lollipopBuyButtonWasTapped(sender: AnyObject) {
        self.purchaseCompleteView.alpha = 0
        self.purchaseCompleteView.hidden = false
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: nil,
            animations: {
                self.purchaseCompleteView.alpha = 1
                
            },
            completion: {
                finished in
        })
        fireConversionCall("lollipop", productPrice: 2.00)
        
    }
    @IBAction func stripedLollipopBuyButtonWasTapped(sender: AnyObject) {
        println("Buy")
        
        self.purchaseCompleteView.alpha = 0
        self.purchaseCompleteView.hidden = false
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: nil,
            animations: {
                self.purchaseCompleteView.alpha = 1
                
            },
            completion: {
                finished in
        })
        
        fireConversionCall("stripelollipop", productPrice: 6.00)
        
    }

    
    @IBAction func stripedLollipopButtonWasTapped(sender: AnyObject) {
        println("Stripe!")
        self.stripedLollipopView.alpha = 0
        self.stripedLollipopView.hidden = false
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: nil,
            animations: {
                self.stripedLollipopView.alpha = 1
                
            },
            completion: {
                finished in
        })
        fireIntentCall("stripelollipop", productPrice: 6.00)
    }
    
    @IBAction func stripedLollipopViewCloseButtonWasTapped(sender: AnyObject) {
        
        self.stripedLollipopView.alpha = 1
        
        UIView.animateWithDuration(0.3, animations: {
            self.stripedLollipopView.alpha = 0
            
            }, completion: {
                (value: Bool) in
                self.stripedLollipopView.hidden = true
        })
    }
    
    @IBAction func lollipopButtonWasTapped(sender: AnyObject) {
        println("Normal!")
        self.lollipopView.alpha = 0
        self.lollipopView.hidden = false
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: nil,
            animations: {
                self.lollipopView.alpha = 1
                
            },
            completion: {
                finished in
        })
        fireIntentCall("lollipop", productPrice: 2.00)
        
    }
    @IBAction func buyGoldViewCloseButtonWasTapped(sender: AnyObject) {
        self.buyGoldView.alpha = 1
        
        UIView.animateWithDuration(0.3, animations: {
            self.buyGoldView.alpha = 0
            
            }, completion: {
                (value: Bool) in
                self.buyGoldView.hidden = true
        })
    }
    @IBAction func buyGoldButtonWasTapped(sender: AnyObject) {
        self.purchaseCompleteView.alpha = 0
        self.purchaseCompleteView.hidden = false
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: nil,
            animations: {
                self.purchaseCompleteView.alpha = 1
                
            },
            completion: {
                finished in
        })
        
        fireIntentCall("gold", productPrice: 0.99)
    }
    @IBAction func purchaseCompleteViewCloseButtonWasTapped(sender: AnyObject) {
        self.lollipopView.hidden = true
        self.stripedLollipopView.hidden = true
        
        self.purchaseCompleteView.alpha = 1
        
        UIView.animateWithDuration(0.3, animations: {
            self.purchaseCompleteView.alpha = 0
            
            }, completion: {
                (value: Bool) in
                self.purchaseCompleteView.hidden = true
        })
        
        self.buyGoldViewCloseButtonWasTapped(sender)
        
        

    }
    
    func identfierForAdvertising() -> String {
        if (ASIdentifierManager.sharedManager().advertisingTrackingEnabled) {
            var idfa : NSUUID = ASIdentifierManager.sharedManager().advertisingIdentifier
            
            return idfa.UUIDString
        }
        return ""
    }
    
    func fireIntentCall(productID: String, productPrice: Double) {
        let requestURL = "http://ads.newtypemobile.com/adserver/int?idfa=\(identfierForAdvertising())&product_id=\(productID)&advertiser_id=candycrush&product_price=\(productPrice)"
        let url = NSURL(string: requestURL)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(requestURL)
        }
    }
    
    func fireConversionCall(productID: String, productPrice: Double) {
        let requestURL = "http://ads.newtypemobile.com/adserver/conv?idfa=\(identfierForAdvertising())&product_id=\(productID)&advertiser_id=candycrush&product_price=\(productPrice)"
        let url = NSURL(string: requestURL)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(requestURL)
        }
    }
}

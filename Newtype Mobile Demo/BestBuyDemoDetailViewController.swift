//
//  BestBuyDemoDetailViewController.swift
//  Newtype Mobile Demo
//
//  Created by Franklin Ho on 1/26/15.
//  Copyright (c) 2015 Franklin Ho. All rights reserved.
//

import UIKit
import AdSupport

class BestBuyDemoDetailViewController: UIViewController {
    
    @IBOutlet weak var purchaseCompleteView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    var productID : Int?
    var productPrice : Double?

    @IBOutlet weak var productDetailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.purchaseCompleteView.hidden = true
        
        var buttonLayer : CALayer = buyButton.layer
        
        buttonLayer.masksToBounds = true
        buttonLayer.cornerRadius = 5.0
        buttonLayer.borderColor = UIColor.blackColor().CGColor
        buttonLayer.borderWidth = 2.0
        
        var purchaseCompleteLayer : CALayer = purchaseCompleteView.layer
        
        purchaseCompleteLayer.masksToBounds = true
        purchaseCompleteLayer.cornerRadius = 10.0
        purchaseCompleteLayer.borderColor = UIColor.blackColor().CGColor
        purchaseCompleteLayer.borderWidth = 5.0
        
        if self.productID != nil {
            self.productDetailImageView.image = UIImage(named: "\(productID!)d.jpg")
        }
        
        fireIntentCall()
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
    
    override func viewDidAppear(animated: Bool) {
        if self.productID != nil {
            self.productDetailImageView.image = UIImage(named: "\(productID!)d.jpg")
            println("\(productID)d.jpg")
        }
    }
    @IBAction func buyButtonTapped(sender: AnyObject) {
        self.purchaseCompleteView.hidden = false
        fireConversionCall()
    }
    @IBAction func purchaseCompleteCloseButtonTapped(sender: AnyObject) {
        
        self.purchaseCompleteView.hidden = true
    }
    
    func identfierForAdvertising() -> String {
        if (ASIdentifierManager.sharedManager().advertisingTrackingEnabled) {
            var idfa : NSUUID = ASIdentifierManager.sharedManager().advertisingIdentifier
            
            return idfa.UUIDString
        }
        return ""
    }
    
    func fireIntentCall() {
        let requestURL = "http://ads.newtypemobile.com/adserver/int?idfa=\(identfierForAdvertising())&product_id=\(self.productID!)&advertiser_id=bestbuy&product_price=\(self.productPrice!)"
        let url = NSURL(string: requestURL)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(requestURL)
        }
        
        
    }
    
    func fireConversionCall() {
        let requestURL = "http://ads.newtypemobile.com/adserver/conv?idfa=\(identfierForAdvertising())&product_id=\(self.productID!)&advertiser_id=candycrush&product_price=\(self.productPrice!)"
        let url = NSURL(string: requestURL)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(requestURL)
        }
    }


}

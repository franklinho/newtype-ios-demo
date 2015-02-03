//
//  BestBuyDemoDetailViewController.swift
//  Newtype Mobile Demo
//
//  Created by Franklin Ho on 1/26/15.
//  Copyright (c) 2015 Franklin Ho. All rights reserved.
//

import UIKit
import AdSupport
import PassKit

class BestBuyDemoDetailViewController: UIViewController {
    

    let SupportedPaymentNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
    let ApplePaySwagMerchantID = "merchant.com.newtypemobile.Newtype-Mobile-Demo"
    @IBOutlet weak var purchaseCompleteView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    var productID : Int?
    var productPrice : Double?
    var applePayCapable : Bool?
    var productName : String?

    @IBOutlet weak var productDetailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SupportedPaymentNetworks)){
            self.applePayCapable = true
            buyButton.setTitle("", forState: UIControlState.Normal)
            buyButton.setImage(UIImage(named: "ApplePayButton"), forState: UIControlState.Normal)
            
        } else {
            var buttonLayer : CALayer = buyButton.layer
            
            buttonLayer.masksToBounds = true
            buttonLayer.cornerRadius = 5.0
            buttonLayer.borderColor = UIColor.blackColor().CGColor
            buttonLayer.borderWidth = 2.0
        }
        
        self.purchaseCompleteView.hidden = true
        
        
        
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
            println("\(productID!)d.jpg")
        }
    }
    @IBAction func buyButtonTapped(sender: AnyObject) {
        if (self.applePayCapable == true) {
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = ApplePaySwagMerchantID
            request.supportedNetworks = SupportedPaymentNetworks
            request.merchantCapabilities = PKMerchantCapability.Capability3DS
            request.countryCode = "US"
            request.currencyCode = "USD"
            
            request.paymentSummaryItems = [
                PKPaymentSummaryItem(label: self.title, amount: NSDecimalNumber(double: self.productPrice!)),
                PKPaymentSummaryItem(label: "Best Buy", amount: NSDecimalNumber(double: self.productPrice!))
            ]
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController.delegate = self
            self.presentViewController(applePayController, animated: true, completion: nil)
            
            

            
        } else {
            self.purchaseCompleteView.hidden = false
            fireConversionCall()
        }
        
        
        
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
        let requestURL = "http://ads.newtypemobile.com/adserver/conv?idfa=\(identfierForAdvertising())&product_id=\(self.productID!)&advertiser_id=bestbuy&product_price=\(self.productPrice!)"
        let url = NSURL(string: requestURL)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            println(requestURL)
        }
    }


}

extension BestBuyDemoDetailViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        
        // 2
        Stripe.setDefaultPublishableKey("pk_test_hBpc3qwWTpzxaYoXEnul3hvp")  // Replace With Your Own Key!
        
        // 3
        
        STPAPIClient.sharedClient().createTokenWithPayment(payment) {
            (token, error) -> Void in
            if (error != nil) {
                println(error)
                completion(PKPaymentAuthorizationStatus.Failure)
                return
            }
            
            // 4
            
            // 5
            let url = NSURL(string: "http://ads.newtypemobile.com/adserver/pay")  // Replace with computers local IP Address!
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            // 6
            let body = ["stripeToken": token.tokenId,
                "amount": NSDecimalNumber(double: self.productPrice!),
                "description": self.title!
            ]
            
            var error: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions(), error: &error)
            
            // 7
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                if (error != nil) {
                    completion(PKPaymentAuthorizationStatus.Failure)
                } else {
                    completion(PKPaymentAuthorizationStatus.Success)
                    self.fireConversionCall()
                    
                }
            }
        }

    }
    
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

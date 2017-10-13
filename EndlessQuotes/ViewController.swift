//
//  ViewController.swift
//  EndlessQuotes
//
//  Created by Brian Chang on 7/13/17.
//  Copyright © 2017 Brian Chang. All rights reserved.
//

import UIKit
//import Social

class ViewController: UIViewController, UITextFieldDelegate, BranchShareLinkDelegate {

    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var creds: UILabel!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var customEvent: UITextField!
    @IBOutlet weak var rando: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var setuser: UIButton!
    @IBOutlet weak var sendevent: UIButton!
    @IBOutlet weak var redeem: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    var branchUniversalObject: BranchUniversalObject = BranchUniversalObject()
    var linkProperties: BranchLinkProperties = BranchLinkProperties()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userInput.delegate = self
        self.customEvent.delegate = self
    }
    
    func updateQuote() {
        getQuote()
        branchUniversalObject = BranchUniversalObject()
        branchUniversalObject.title = "Endless Quotes"
        branchUniversalObject.contentDescription = quote.text
        branchUniversalObject.imageUrl = "https://res.cloudinary.com/rheo-tv/image/upload/07686578-a838-496d-90d9-f8fd112ca978.jpg"
        branchUniversalObject.addMetadataKey("quote", value: quote.text!)
        
        linkProperties = BranchLinkProperties()

        branchUniversalObject.registerView()
    }
    
    @IBAction func randomButton(_ sender: UIButton) {
        updateQuote()
    }
    
    private func getQuote() {
        var quotes = ["dog", "cat", "fish", "bird", "pig", "chicken", "horse", "snake", "spider", "donkey", "rooster", "chinchilla"]
        let rand = arc4random_uniform(12)
        quote.text = quotes[Int (rand)]
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        branchUniversalObject.showShareSheet(with: linkProperties, andShareText: nil, from: nil, completionWithError: nil)
    }
    
//    @IBAction func shareButton(_ sender: UIButton) {
//        if let branchShareLink = BranchShareLink.init(universalObject: branchUniversalObject, linkProperties: linkProperties) {
//            branchShareLink.title = "Share your link!"
//            branchShareLink.shareText = "Shared with sharelink!"
//            branchShareLink.presentActivityViewController(from: self, anchor: share)
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sessionParams = Branch.getInstance().getLatestReferringParams()
        if (sessionParams?["quote"]) != nil {
            quote.text = sessionParams?["quote"] as? String
        } else {
            updateQuote()
        }
    }
    
    @IBAction func setID(_ sender: UIButton) {
        if userInput?.text != nil {
            Branch.getInstance().setIdentity(userInput.text)

        }
        refreshRewardsBalanceOfBucket()
    }

    @IBAction func sendEvent(_ sender: UIButton) {
        let branch = Branch.getInstance()
        
        if customEvent.text != "" {
            branch?.userCompletedAction(customEvent.text)
        }

        refreshRewardsBalanceOfBucket()

    }
    
    
    @IBAction func redeemCreds(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func refreshRewardsBalanceOfBucket() {
        let branch = Branch.getInstance()
        branch?.loadRewards { (changed, error) in
            if (error == nil) {
                self.creds.text = String(format: "%ld", (branch?.getCredits())!)
            }
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        Branch.getInstance().logout()
        refreshRewardsBalanceOfBucket()
    }
}


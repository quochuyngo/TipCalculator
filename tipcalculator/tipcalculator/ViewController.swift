//
//  ViewController.swift
//  tipcalculator
//
//  Created by Quoc Huy Ngo on 9/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    let tipercentages = [0.15, 0.2, 0.25]
    var key:String = "SegmentIndex"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set animation
        self.tipControl.alpha = 0
        self.view.alpha = 0;
        UIView.animateWithDuration(0.4, animations: {
            self.tipControl.alpha = 1
            self.view.alpha = 1
        })
        //set focus to the textField
        billTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTapScreen(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func caculateTip(sender: AnyObject) {
        let bill = Double(billTextField.text!) ?? 0
        let tip = bill * tipercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //get settings
        let defaults = NSUserDefaults.standardUserDefaults()
        let index = defaults.integerForKey(key)
        tipControl.selectedSegmentIndex = index
    }
    
    override func viewDidDisappear(animated: Bool) {

    }
    
}


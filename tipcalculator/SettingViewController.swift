//
//  SettingViewController.swift
//  tipcalculator
//
//  Created by Quoc Huy Ngo on 9/14/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tipPercentageControl:UISegmentedControl!
    var index:Int = 0
    var key:String = "SegmentIndex"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get settings
        index = defaults.integerForKey(key)
        
        //set settings default
        tipPercentageControl.selectedSegmentIndex = index;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tipPercentageValueChanged(sender: UISegmentedControl) {
        index = tipPercentageControl.selectedSegmentIndex
        //save settings
        defaults.setInteger(index, forKey: key)
    }
    
}

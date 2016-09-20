//
//  SettingsTableViewController.swift
//  Tip Calculator
//
//  Created by Quoc Huy Ngo on 9/18/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var tipPercentageSegmentControl: UISegmentedControl!
    @IBOutlet weak var clearDataSwitch: UISwitch!
    @IBOutlet weak var timeClearDataSlider: UISlider!
    @IBOutlet weak var timeClearDataLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set settings default
        tipPercentageSegmentControl.selectedSegmentIndex = Settings.segmentIndex;
        clearDataSwitch.on = Settings.isClearData
        if !Settings.isClearData{
            timeClearDataSlider.enabled = false
        }
        timeClearDataSlider.value = Float(Settings.timeToClearData)
        timeClearDataLabel.text = String(format:"%d minutes", Int(timeClearDataSlider.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        Settings.segmentIndex = tipPercentageSegmentControl.selectedSegmentIndex
        Settings.isClearData = clearDataSwitch.on
        Settings.timeToClearData = Int(timeClearDataSlider.value)
        //defaults.setObject(Settings.toDictionary(), forKey: Keys.APP_SETTINGS)
        print(Settings.toDictionary())
    }
    
    @IBAction func clearDataValueChanged(sender: AnyObject) {
        timeClearDataLabel.text = String(format:"%d minutes", Int(timeClearDataSlider.value))
    }
    
    @IBAction func clearDataValueChangedSwitch(sender: AnyObject) {
        if !clearDataSwitch.on{
            timeClearDataSlider.enabled = false
            timeClearDataLabel.enabled = false
        }
        else{
            timeClearDataSlider.enabled = true
            timeClearDataLabel.enabled = true
        }
    }
  }

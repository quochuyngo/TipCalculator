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
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var themeSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        //set settings default
        tipPercentageSegmentControl.selectedSegmentIndex = Settings.segmentIndex;
        clearDataSwitch.isOn = Settings.isClearData
        if !Settings.isClearData{
            timeClearDataSlider.isEnabled = false
        }
        themeSwitch.isOn = Settings.isLight
        timeClearDataSlider.value = Float(Settings.timeToClearData)
        timeClearDataLabel.text = String(format:"%d minutes", Int(timeClearDataSlider.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Settings.segmentIndex = tipPercentageSegmentControl.selectedSegmentIndex
        Settings.isClearData = clearDataSwitch.isOn
        Settings.timeToClearData = Int(timeClearDataSlider.value)
        Settings.isLight = themeSwitch.isOn
        //defaults.setObject(Settings.toDictionary(), forKey: Keys.APP_SETTINGS)
        print(Settings.toDictionary())
    }
    
    @IBAction func clearDataValueChanged(_ sender: AnyObject) {
        timeClearDataLabel.text = String(format:"%d minutes", Int(timeClearDataSlider.value))
    }
    
    @IBAction func clearDataValueChangedSwitch(_ sender: AnyObject) {
        if !clearDataSwitch.isOn{
            timeClearDataSlider.isEnabled = false
            timeClearDataLabel.isEnabled = false
        }
        else{
            timeClearDataSlider.isEnabled = true
            timeClearDataLabel.isEnabled = true
        }
    }
  }

//
//  ViewController.swift
//  tipcalculator
//
//  Created by Quoc Huy Ngo on 9/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet var recentTableView: UITableView!
    
    let tipercentages = [0.15, 0.2, 0.25]
    var bill:Double! = 0
    var tip:Double! = 0
    var isTextFieldFocused:Bool = true
    var recentBills = [Bill]()
    
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
        recentTableView.dataSource = self
        
        //get settings
        if let dict = NSUserDefaults.standardUserDefaults().objectForKey(Keys.APP_SETTINGS) as? Dictionary<String, AnyObject>{
            Settings.fromDictionary(dict)
            tipControl.selectedSegmentIndex = Settings.segmentIndex
        }
        
        //load recent bills
        recentBills = loadRecentBills()!
        
        if Settings.isClearData{
            //get time recent
            let timeRecent = NSUserDefaults.standardUserDefaults().integerForKey(Keys.MOST_RECENT)
            let curentTime = Time.getCurrentTime()
            if (curentTime - timeRecent) > Settings.timeToClearData {
                recentBills.removeAll()
            }
        }
        recentTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapScreen(sender: AnyObject) {
        view.endEditing(true)
        
        if isTextFieldFocused{
            isTextFieldFocused = false
            if(!(billTextField.text?.isEmpty)!){
                //recentBills.append(Bill(bill: bill, tip: tip)!)
                recentBills.insert(Bill(bill: bill, tip: tip)!, atIndex: 0)
                recentTableView.reloadData()
            }
            saveRecentBills()
        }
        
    }

    @IBAction func tipSegmentValueChanged(sender: AnyObject) {
        calculateTip()
        
        if(!(billTextField.text?.isEmpty)!){
            recentBills.append(Bill(bill: bill, tip: tip)!)
            recentTableView.reloadData()
        }
    }
    @IBAction func caculateTip(sender: AnyObject) {
        calculateTip()
    }
    @IBAction func billTouchDown(sender: AnyObject) {
        if !isTextFieldFocused{
            isTextFieldFocused = true
            billTextField.text = ""
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tipControl.selectedSegmentIndex = Settings.segmentIndex
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    func calculateTip(){
        bill = Double(billTextField.text!) ?? 0
        tip = bill * tipercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentBills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "RecentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecentTableViewCell
        
        let row = indexPath.row
        cell.billLabel.text = String(format:"%.2f$", recentBills[row].bill)
        cell.tiplabel.text = String(format:"%.2f$", recentBills[row].tip)
        return cell
    }
    
    func saveRecentBills(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recentBills, toFile: (Bill.ArchiveURL?.path)!)
        if !isSuccessfulSave{
            print("Failed to save recent bills")
        }
    }
    
    func loadRecentBills()-> [Bill]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile((Bill.ArchiveURL?.path)!) as? [Bill]
    }
}


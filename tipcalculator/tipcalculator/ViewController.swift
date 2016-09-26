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
        //billTextField.center.x -= view.bounds.width
        //self.view.alpha = 0;
        UIView.animate(withDuration: 0.4, delay:0.45, options: .transitionFlipFromLeft, animations: {
            
            self.billTextField.center.y += self.view.bounds.height
        })

        //set focus to the textField
        billTextField.becomeFirstResponder()
        recentTableView.dataSource = self
        
        //get settings
        if let dict = UserDefaults.standard.object(forKey: Keys.APP_SETTINGS) as? Dictionary<String, AnyObject>{
            Settings.fromDictionary(dictionary: dict)
            tipControl.selectedSegmentIndex = Settings.segmentIndex
        }
        
        //load recent bills
        recentBills = loadRecentBills()!
        
        if Settings.isClearData{
            //get time recent
            let timeRecent = UserDefaults.standard.integer(forKey: Keys.MOST_RECENT)
            let curentTime = Time.getCurrentTime()
            print(curentTime - timeRecent)
            print(Settings.timeToClearData )
            if (curentTime - timeRecent) > Settings.timeToClearData {
                recentBills.removeAll()
            }
        }
        self.automaticallyAdjustsScrollViewInsets = false
        recentTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapScreen(_ sender: AnyObject) {
        view.endEditing(true)
        
        if isTextFieldFocused{
            isTextFieldFocused = false
            if(!(billTextField.text?.isEmpty)!){
                //recentBills.append(Bill(bill: bill, tip: tip)!)
                recentBills.insert(Bill(bill: bill, tip: tip)!, at: 0)
                recentTableView.reloadData()
            }
            saveRecentBills()
        }
        
    }

    @IBAction func tipSegmentValueChanged(_ sender: AnyObject) {
        calculateTip()
        
        /*if(!(billTextField.text?.isEmpty)!){
            recentBills.append(Bill(bill: bill, tip: tip)!)
            recentTableView.reloadData()
        }*/
    }
    @IBAction func caculateTip(_ sender: AnyObject) {
        calculateTip()
    }
    
    @IBAction func billTextFieldTouchDown(_ sender: UITextField) {
        if !isTextFieldFocused{
            isTextFieldFocused = true
            billTextField.text = ""
            tipLabel.text = "$0.0"
            totalLabel.text = "$0.0"
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tipControl.selectedSegmentIndex = Settings.segmentIndex
        //set theme
        if Settings.isLight{
            Style.setLightTheme()
        }
        else{
            Style.setDarkThem()
        }
        self.view.backgroundColor = Style.backgroundColor
        self.view.tintColor = Style.textColor
        self.recentTableView.backgroundColor = Style.backgroundColor
        setTextColor(textColor: Style.textColor!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func calculateTip(){
        bill = Double(billTextField.text!) ?? 0
        tip = bill * tipercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = formatCurrency(total: tip) //String(format: "$%.2f", tip)
        totalLabel.text = formatCurrency(total: total)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentBills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecentTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! RecentTableViewCell
        
        let row = indexPath.row
        cell.billLabel.text = formatCurrency(total: recentBills[row].bill)//String(format:"%.2f$", recentBills[row].bill)
        cell.tiplabel.text = formatCurrency(total: recentBills[row].tip)//String(format:"%.2f$", recentBills[row].tip)
        return cell
    }
    
    func saveRecentBills(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recentBills, toFile: (Bill.ArchiveURL?.path)!)
        if !isSuccessfulSave{
            print("Failed to save recent bills")
        }
    }
    
    func loadRecentBills()-> [Bill]?{
        
        var recents = NSKeyedUnarchiver.unarchiveObject(withFile: (Bill.ArchiveURL?.path)!) as? [Bill]
        if recents == nil{
            recents = [Bill]()
        }
        return recents
    }
    
    func formatCurrency(total:Double)->String{
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current//NSLocale(localeIdentifier: "es_ES") as Locale!//
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 1;
        return formatter.string(from: NSNumber(value:total))!
    }
    
    func getLabelsInView(view:UIView) -> [UILabel]{
        var result = [UILabel]()
        for subview in view.subviews as [UIView]{
            if let labelView = subview as? UILabel{
                result += [labelView]
            }
            else{
                result += getLabelsInView(view: subview)
            }
        }
        return result
    }
    
    func setTextColor(textColor:UIColor){
        let labels = getLabelsInView(view: self.view)
        for label in labels{
            label.textColor = textColor
        }
    }
}


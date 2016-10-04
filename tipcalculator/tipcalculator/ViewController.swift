//
//  ViewController.swift
//  tipcalculator
//
//  Created by Quoc Huy Ngo on 9/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet var recentTableView: UITableView!
    @IBOutlet weak var totalView: UIView!
    
    let tipercentages = [0.15, 0.2, 0.25]
    var bill:Double! = 0
    var tip:Double! = 0
    var isTextFieldFocused:Bool = true
    var recentBills = [Bill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set animation textfield
        UIView.animate(withDuration: 0.4, delay:0.45, options: .transitionFlipFromLeft, animations: {
            
            self.billTextField.center.y += self.view.bounds.height
        })

        //set focus to the textField
        billTextField.becomeFirstResponder()
        
        //get settings
        if let dict = UserDefaults.standard.object(forKey: Keys.APP_SETTINGS) as? Dictionary<String, AnyObject>{
            Settings.fromDictionary(dictionary: dict)
            tipControl.selectedSegmentIndex = Settings.segmentIndex
        }
        
        //set default tip
        setDefault()
        
        //load recent bills
        recentBills = loadRecentBills()!
        if let oldBill = UserDefaults.standard.string(forKey: Keys.LAST_BILL){
            Settings.lastBill = oldBill
        }
        
        //set lastBill
        if Settings.isClearData{
            //get time recent
            let timeRecent = UserDefaults.standard.integer(forKey: Keys.MOST_RECENT)
            let curentTime = Time.getCurrentTime()
            if (curentTime - timeRecent) > Settings.timeToClearData {
                recentBills.removeAll()
                Settings.lastBill = ""
            }
        }
        billTextField.text = Settings.lastBill
        
        self.automaticallyAdjustsScrollViewInsets = false
        recentTableView.dataSource = self
        recentTableView.reloadData()
        
        self.billTextField.delegate = self
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
                recentBills.insert(Bill(bill: bill, tip: tip)!, at: 0)
                recentTableView.reloadData()
            }
            saveRecentBills()
        }
        
    }

    @IBAction func tipSegmentValueChanged(_ sender: AnyObject) {
        calculateTip()
    }
    
    @IBAction func caculateTip(_ sender: AnyObject) {
        Settings.lastBill = billTextField.text!
        calculateTip()
    }
    
    @IBAction func billTextFieldTouchDown(_ sender: UITextField) {
        if !isTextFieldFocused{
            isTextFieldFocused = true
            setDefault()
        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !string.isEmpty {
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789.").inverted
            //check string contains any charaters from CharactersSet
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            
            //limit number of characters
            let resultingStringLengthIsLegal = prospectiveText.characters.count <= 9
            
            //check decimal number format
            let scanner = Scanner(string: prospectiveText)
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal &&
            resultingStringLengthIsLegal && resultingTextIsNumeric
        }
        return result
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tipControl.selectedSegmentIndex = Settings.segmentIndex
        //set theme

        if Settings.isLight{
            Style.setLightTheme()
            themeAnimation(colorChange: UIColor.darkGray, view: view)
            //themeAnimation(colorChange: UIColor.gray, view: view)
        }
        else{
            Style.setDarkThem()
            themeAnimation(colorChange: UIColor.white, view: view)
            //themeAnimation(colorChange: UIColor.cyan, view: view)
            
        }
        ///self.view.backgroundColor = Style.backgroundColor
        self.recentTableView.backgroundColor = Style.backgroundColor
        setTextColor(textColor: Style.textColor!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    func calculateTip(){
        bill = Double(billTextField.text!) ?? 0
        tip = bill * tipercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = formatCurrency(total: tip) //String(format: "$%.2f", tip)
        totalLabel.text = formatCurrency(total: total)
        
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
    
    func setDefault(){
        let lastBill:String = ""
        billTextField.text = lastBill
        let tipDefault = formatCurrency(total: 0.0)
        billTextField.placeholder = tipDefault
        tipLabel.text = tipDefault
        totalLabel.text = tipDefault
    }
    
    //check input bill contain letters
    func containsLetters(input: String) -> Bool {
        for chr in input.characters {
            if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    //animation change theme
    func themeAnimation(colorChange:UIColor,view:UIView){
        UIView.animate(withDuration: 3, delay: 0.0, options:[UIViewAnimationOptions.transitionFlipFromBottom], animations: {
            self.view.backgroundColor = colorChange
            self.recentTableView.backgroundColor = colorChange
            self.view.backgroundColor = Style.backgroundColor
            self.recentTableView.backgroundColor = Style.backgroundColor
            //Style.setLightTheme()
            }, completion:nil)
    }
}

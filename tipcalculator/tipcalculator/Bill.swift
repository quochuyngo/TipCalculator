//
//  Bill.swift
//  Tip Calculator
//
//  Created by Quoc Huy Ngo on 9/16/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class Bill: NSObject, NSCoding{
    var bill:Double
    var tip:Double
    //var total:String
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("recentBills")
    
    init?(bill:Double, tip:Double){
        self.bill = bill
        self.tip = tip
        
        super.init()
        
        if bill < 0 || tip < 0{
            return nil
        }
        //self.total = total
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let bill = aDecoder.decodeDouble(forKey: PropertyKey.billKey)
        let tip = aDecoder.decodeDouble(forKey: PropertyKey.tipKey)
        
        self.init(bill:bill, tip:tip)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bill, forKey: PropertyKey.billKey)
        aCoder.encode(tip, forKey: PropertyKey.tipKey)
    }
}

struct PropertyKey{
    static let billKey = "bill"
    static let tipKey = "tip"
}


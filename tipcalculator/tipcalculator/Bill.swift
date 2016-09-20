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
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.URLByAppendingPathComponent("recentBills")
    
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
        let bill = aDecoder.decodeDoubleForKey(PropertyKey.billKey)
        let tip = aDecoder.decodeDoubleForKey(PropertyKey.tipKey)
        
        self.init(bill:bill, tip:tip)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(bill, forKey: PropertyKey.billKey)
        aCoder.encodeDouble(tip, forKey: PropertyKey.tipKey)
    }
}

struct PropertyKey{
    static let billKey = "bill"
    static let tipKey = "tip"
}


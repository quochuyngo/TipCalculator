//
//  Time.swift
//  Tip Calculator
//
//  Created by Quoc Huy Ngo on 9/18/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class Time{
    static func getCurrentTime()->Int{
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        let calendar = NSCalendar.current
        //let components = calendar.components([.Hour, .Minute, .Second], fromDate: currentDate)
        let hour = calendar.component(.hour, from: currentDate as Date)
        let minute = calendar.component(.minute, from: currentDate as Date)
        let curentTime = hour*60 + minute
        return curentTime
    }
}

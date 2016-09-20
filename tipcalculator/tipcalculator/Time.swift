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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: currentDate)
        let curentTime = components.hour*60 + components.minute
        return curentTime
    }

}

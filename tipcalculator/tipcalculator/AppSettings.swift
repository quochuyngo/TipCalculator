//
//  AppSettings.swift
//  Tip Calculator
//
//  Created by Quoc Huy Ngo on 9/18/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

struct Keys{
    static let SEGMENT_INDEX:String = "segmentIndex"
    static let TIME_CLEAR_DATA:String = "timeToClearData"
    static let MOST_RECENT:String = "mostRecent"
    static let APP_SETTINGS:String = "appSettings"
    static let IS_CLEAR_DATA:String = "isClearData"
}

struct Settings {
    static var segmentIndex:Int = 0
    static var timeToClearData:Int = 0
    static var isClearData:Bool = true
    
    static func toDictionary() -> Dictionary<String, AnyObject>{
        return [
            Keys.SEGMENT_INDEX : self.segmentIndex,
            Keys.TIME_CLEAR_DATA : self.timeToClearData,
            Keys.IS_CLEAR_DATA: self.isClearData
        ]
    }
    
    static func fromDictionary(dictionary:Dictionary<String, AnyObject>){
        if let segmentIndex = dictionary[Keys.SEGMENT_INDEX] as? Int{
            self.segmentIndex = segmentIndex
        }
        
        if let timeToClearData = dictionary[Keys.TIME_CLEAR_DATA] as? Int{
                    self.timeToClearData = timeToClearData
        }
        
        if let isClearData = dictionary[Keys.IS_CLEAR_DATA] as? Bool{
            self.isClearData = isClearData
        }

    }
}
//
//  Style.swift
//  Tip Calculator
//
//  Created by Quoc Huy Ngo on 9/22/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

struct Style{
    static var textColor:UIColor?
    static var backgroundColor:UIColor?
    
    static func setLightTheme(){
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.white//UIColor(red: 46/255, green: 228/255, blue: 185/255, alpha: 1)
    }
    
    static func setDarkThem(){
        self.textColor = UIColor.white
        self.backgroundColor = UIColor.darkGray
    }
}

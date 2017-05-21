//
//  Setting.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/16.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import Foundation
import UIKit

class Setting {
    
    static let blueColor = UIColor(red: 84/255, green: 136/255, blue: 174/255, alpha: 1)

    static let pinkColor = UIColor(red: 242/255, green: 156/255, blue: 177/255, alpha: 1)
    
    static var headImage = UIImage(named: "head")
    
    static var name = "昵称"
    
    static var signature = "没有个性签名"
    
    static var isChanged = false
    
    static var themeColor = blueColor
    
    static var useTouchIDCheck = false
    
    static var usePasswordCheck = false
}

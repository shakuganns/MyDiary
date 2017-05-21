//
//  AlertViewDelegate.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/5/18.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation

public protocol AlertViewDelegate:NSObjectProtocol {
    func onImageClick(imageID:Int) -> Void
    
    func onDelete(lookingDiarySection:Int,lookingDiaryRow:Int) -> Void
}

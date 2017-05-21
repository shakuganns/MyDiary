//
//  DiaryViewDelegate.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/8.
//  Copyright © 2016年 shakugan. All rights reserved.
//
import UIKit
import Foundation

public protocol DiaryViewDelegate:NSObjectProtocol {
    func onAddClick(button:UIButton,diary:Diary) -> Void
    
    func onPickerImage(index:Int) -> Void
}

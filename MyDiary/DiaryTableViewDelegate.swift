//
//  DiaryTableViewDelegate.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/16.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import Foundation

public protocol DiaryTableViewDelegate:NSObjectProtocol {
    func onMoreClick() -> Void
    
    func onImageClick(imageID:Int) -> Void
}

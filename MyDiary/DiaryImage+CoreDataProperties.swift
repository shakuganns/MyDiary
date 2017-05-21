//
//  DiaryImage+CoreDataProperties.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/5/18.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation
import CoreData


extension DiaryImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryImage> {
        return NSFetchRequest<DiaryImage>(entityName: "DiaryImage")
    }

    @NSManaged public var id: Int
    @NSManaged public var image: NSData?

}

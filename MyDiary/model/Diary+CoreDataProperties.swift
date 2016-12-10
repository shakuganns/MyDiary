//
//  Diary+CoreDataProperties.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/7.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary");
    }

    @NSManaged public var day: Int16
    @NSManaged public var mood: String?
    @NSManaged public var text: String?
    @NSManaged public var time: String?
    @NSManaged public var title: String?
    @NSManaged public var weather: String?
    @NSManaged public var week: Int16

}

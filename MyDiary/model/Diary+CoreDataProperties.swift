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

    @NSManaged public var mood: String?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var weather: String?
    @NSManaged public var location: String?
    @NSManaged public var imageID: Int
    @NSManaged public var date: Date

}

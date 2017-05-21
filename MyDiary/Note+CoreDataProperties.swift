//
//  Note+CoreDataProperties.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/5/19.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var text: String?

}

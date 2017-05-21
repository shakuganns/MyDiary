//
//  User+CoreDataProperties.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/5/17.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var headImage: NSData?
    @NSManaged public var name: String?
    @NSManaged public var signature: String?
    @NSManaged public var theme: String?
    @NSManaged public var touchID: NSNumber?

}

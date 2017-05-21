//
//  DataUtil.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/5/17.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation
import CoreData

final class DataUtil {
    
    var context = NSManagedObjectContext()
    
    static let shared = DataUtil()
    private init() {}
    
    func initUtil() -> Void {
        if #available(iOS 10.0, *) {
            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            print("iOS 10")
        } else {
            // Fallback on earlier versions
            let app = UIApplication.shared.delegate as! AppDelegate
            context = app.managedObjectContext
            print("iOS 9")
        }
    }
    
    func fetchObjects(name:String) -> [Any] {
        return fetchObjects(name:name,predicate: nil)
    }
    
    
    func fetchObjects(name:String,predicate:NSPredicate?) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: name,in: context)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        var fetchedObjects = [Any]()
        do {
            try fetchedObjects = context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return fetchedObjects
    }
    
}

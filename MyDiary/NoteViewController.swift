//
//  NoteViewController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/4/19.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation
import CoreData

class NoteViewController: UIViewController {
    
    @IBOutlet weak var navRightBtn: UIBarButtonItem!
    @IBOutlet weak var noteText: UITextView!
    var id = Int()
    
    override func viewDidLoad() {
        let context = DataUtil.shared.context
        let predicate = NSPredicate(format:"id='\(id)'")
        let fetchedObjects = DataUtil.shared.fetchObjects(name: "Note", predicate: predicate)
        if fetchedObjects.count == 0 {
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note",into: context) as! Note
            note.id = id as NSNumber
            note.text = "这是一个便签"
        } else {
            let note = fetchedObjects.first as! Note
            noteText.text = note.text == nil ? "" : note.text
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        navRightBtn.action = #selector(onNavRightClick)
    }
    
    func onNavRightClick() -> Void {
        let context = DataUtil.shared.context
        let predicate = NSPredicate(format:"id='\(id)'")
        let fetchedObjects = DataUtil.shared.fetchObjects(name: "Note", predicate: predicate)
        let note = fetchedObjects.first as! Note
        note.text = noteText.text
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}

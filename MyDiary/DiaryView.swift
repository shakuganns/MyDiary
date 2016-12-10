//
//  DiaryView.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/7.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit
import CoreData

class DiaryView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let emoji = [["☺︎","☹","♡"],["☼","☁︎","⚡︎","☔︎","❄︎"]]

    @IBOutlet weak var mood: UIPickerView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var title: UITextField!
    weak var delegate: DiaryViewDelegate?

    public func initView() -> Void {
        addBtn.addTarget(self, action: #selector(click(button:)), for: UIControlEvents.touchDown)
        mood.dataSource = self
        mood.delegate = self
    }
    
    func click(button : UIButton) {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        var context = NSManagedObjectContext()
        if #available(iOS 10.0, *) {
            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            print("iOS 10")
        } else {
            // Fallback on earlier versions
            let app = UIApplication.shared.delegate as! AppDelegate
            context = app.managedObjectContext
            print("iOS 9")
        }
        let diary = NSEntityDescription.insertNewObject(forEntityName: "Diary",into: context) as! Diary
        diary.day = Int16(comps.day!)
        diary.text = text.text.characters.count == 0 ? "No Text" : text.text
        diary.mood = emoji[0][mood.selectedRow(inComponent: 0)]
        diary.title = title.text?.characters.count == 0 ? "No Title" : title.text
        diary.weather = emoji[1][mood.selectedRow(inComponent: 1)]
        diary.week = Int16(comps.weekday!) - 1
        let minutes = comps.minute!<9 ? "0\(comps.minute!)" : "\(comps.minute!)"
        diary.time = "\(comps.hour!):\(minutes)"
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        if delegate != nil {
            delegate?.onAddClick(button: addBtn,diary: diary)
        }
        self.endEditing(true)
        print("save success!")
    }
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 4
        } else {
            return 5
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            switch row {
            case 0:
                return emoji[0][0]
            case 1:
                return emoji[0][1]
            case 2:
                return emoji[0][2]
//            case 3:
//                return emoji[0][3]
            default:
                break
            }
        } else {
            switch row {
            case 0:
                return emoji[1][0]
            case 1:
                return emoji[1][1]
            case 2:
                return emoji[1][2]
            case 3:
                return emoji[1][3]
            case 4:
                return emoji[1][4]
            default:
                break
            }
        }
        return ""
    }
}

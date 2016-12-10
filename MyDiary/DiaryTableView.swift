//
//  DiaryTableView.swift
//  MyDairy
//
//  Created by 钟圣麟 on 2016/12/7.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    var diaryArray = Array<Diary>()
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DiaryTableViewCell", owner: nil, options: nil)?.first as! DiaryTableViewCell
        }
        let view = cell?.viewWithTag(100)
        view?.layer.masksToBounds = true
        view?.layer.cornerRadius = 2   // 自己修改为所需的圆角弧度
        let date = cell?.viewWithTag(1) as! UILabel
        let week = cell?.viewWithTag(2) as! UILabel
        let time = cell?.viewWithTag(3) as! UILabel
        let title = cell?.viewWithTag(4) as! UILabel
        let text = cell?.viewWithTag(5) as! UILabel
        let weather = cell?.viewWithTag(6) as! UILabel
        let mood = cell?.viewWithTag(7) as! UILabel
        date.text = "\(diaryArray[diaryArray.count - indexPath.row - 1].day)"
        
        switch diaryArray[diaryArray.count - indexPath.row - 1].week {
        case 1:
            week.text = "Mon."
        case 2:
            week.text = "Tue."
        case 3:
            week.text = "Wed."
        case 4:
            week.text = "Thu."
        case 5:
            week.text = "Fri."
        case 6:
            week.text = "Sat."
        case 7:
            week.text = "Sun."
        default:
            break
        }
        
        time.text = diaryArray[diaryArray.count - indexPath.row - 1].time
        title.text = diaryArray[diaryArray.count - indexPath.row - 1].title
        text.text = diaryArray[diaryArray.count - indexPath.row - 1].text
        weather.text = diaryArray[diaryArray.count - indexPath.row - 1].weather
        mood.text = diaryArray[diaryArray.count - indexPath.row - 1].mood
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = CustomIOSAlertView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let customView = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as! AlertView
        customView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.94, height: 600)
        alert.containerView = customView
        alert.show()
//        alert.dialogView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        alert.containerView.frame = CGRect(x: (alert.frame.width-100)/2, y: (alert.frame.height-400)/2, width: alert.frame.width-100, height: 400)
//        alert.containerView.addSubview(Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as! AlertView)
        alert.dialogView.layer.borderWidth = 0
        alert.containerView.layer.cornerRadius = 6
//        alert.dialogView.backgroundColor = UIColor.clear
    }
    
    public func loadDiary() -> Void {
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        fetchRequest.fetchLimit = 3 //限定查询结果的数量
//        fetchRequest.fetchOffset = 0 //查询的偏移量
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Diary",in: context)
        fetchRequest.entity = entity
        //设置查询条件
        //            let predicate = NSPredicate(format:nil)
        //            fetchRequest.predicate = predicate
        
        var fetchedObjects = [Any]()
        //查询操作
        do {
            try fetchedObjects = context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        if fetchedObjects.count == 0 {
            return
        }
        //遍历查询的结果
        for index in 0...fetchedObjects.count-1 {
            diaryArray.append(fetchedObjects[index] as! Diary)
        }
    }
    
    public func addDiaryToTable(diary:Diary) -> Void {
        diaryArray.append(diary)
        tableView.reloadData()
    }
}

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
    
    var diaryArray = Array<Array<Diary>>()
    var diaryCount = Int()
    var delegate: DiaryTableViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var entryNumLabel: UILabel!
    @IBOutlet weak var moreBtn: UIImageView!
    
    func initView() -> Void {
        entryNumLabel.text = "\(diaryCount) entry"
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(pushTo))
        moreBtn.addGestureRecognizer(singleTap)
    }
    
    func pushTo() -> Void {
        if delegate != nil {
            delegate?.onMoreClick()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if header == nil {
            header = Bundle.main.loadNibNamed("DiaryTableViewSectionHeader", owner: nil, options: nil)?.first as? UITableViewHeaderFooterView
            header?.contentView.backgroundColor = UIColor.clear
            print("loadnib - tableviewHeader")
        }
        let label = header?.viewWithTag(1) as! UILabel
        let comps = DateUtil.formatDate(date: diaryArray[section][0].date)
        let todayComps = DateUtil.formatDate(date: Date())
        if comps.year! != todayComps.year! {
            label.text = "\(comps.year!).\(comps.month!)"
        } else {
            label.text =  "\(comps.month!)"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diary = diaryArray[indexPath.section][indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DiaryTableViewCell", owner: nil, options: nil)?.first as! DiaryTableViewCell
//            cell?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: (cell?.frame.height)!)
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
        let comps = DateUtil.formatDate(date: diary.date)
        date.text = "\(comps.day!)"
        week.text = DateUtil.weekdayInt2String(day: comps.weekday!,isAbbreviated: true)
        time.text = DateUtil.formatHourMinute(hour: comps.hour!, minute: comps.minute!)
        title.text = diary.title
        text.text = diary.text
        weather.text = diary.weather
        mood.text = diary.mood
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diaryArray[indexPath.section][indexPath.row]
        let comps = DateUtil.formatDate(date: diary.date)
        let alert = CustomIOSAlertView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let customView = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as! AlertView
        customView.initTapGesture(target: alert)
        customView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.94, height: UIScreen.main.bounds.height>600 ? 600 : UIScreen.main.bounds.height*0.9)
        customView.setTime(month: comps.month!, day: comps.day!, hour: comps.hour!,minute: comps.minute!, weekday
            : comps.weekday!)
        customView.setTitleText(title: diary.title!,text: diary.text!)
        customView.setWeather(weather: diary.weather!)
        customView.setLocation(location: diary.location == nil ? "No location" : diary.location!)
        customView.lookingDiarySection = indexPath.section
        customView.lookingDiaryRow = indexPath.row
        customView.diaryTableView = self
        alert.containerView = customView
        alert.show()
        customView.addCons()
        //dialogView在调用show()之后才初始化
        alert.dialogView.layer.borderWidth = 0
        alert.dialogView.clipsToBounds = true
        alert.dialogView.layer.cornerRadius = 24
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
        let object = fetchedObjects as! Array<Diary>
        var comps = DateUtil.formatDate(date: object[fetchedObjects.count-1].date)
        var yearMonth = "\(comps.year!)\(comps.month!)"
        var arraySection = 0
        diaryCount = fetchedObjects.count
        var arrayBeginIndex = fetchedObjects.count-1
        var arrayEndIndex = arrayBeginIndex
        //遍历查询的结果
        for index in (0...fetchedObjects.count-1).reversed() {
            comps = DateUtil.formatDate(date: object[index].date)
            let yearMonthTemp = "\(comps.year!)\(comps.month!)"
            arrayEndIndex = index
            if yearMonth != yearMonthTemp {
                var array = Array<Diary>()
                for i in (arrayEndIndex...arrayBeginIndex).reversed() {
                    array.append(object[i])
                }
                diaryArray.append(array)
                arraySection += 1
                yearMonth = yearMonthTemp
                arrayBeginIndex = arrayEndIndex - 1
            } else if index == fetchedObjects.count-1 {
                var array = Array<Diary>()
                for i in (0...arrayBeginIndex).reversed() {
                    array.append(object[i])
                }
                diaryArray.append(array)
            }
        }
        print("diaryCount:\(diaryCount)")
        print("section:\(diaryArray.count)")
    }

    
    public func addDiaryToTable(diary:Diary) -> Bool {
        var isAddSection = false
        if diaryArray.count == 0 {
            var array = Array<Diary>()
            array.append(diary)
            diaryArray.insert(array, at: 0)
            isAddSection = true
        } else {
            let firstCellComps = DateUtil.formatDate(date: diaryArray[0][0].date)
            let comps = DateUtil.formatDate(date: diary.date)
            if (firstCellComps.month! == comps.month!)&&(firstCellComps.year! == comps.year!) {
                diaryArray[0].insert(diary, at: 0)
                isAddSection = false
            } else {
                var array = Array<Diary>()
                array.append(diary)
                diaryArray.insert(array, at: 0)
                isAddSection = true
            }
        }
        updateCountLabel(isPlus: true)
//        tableView.reloadData()
        return isAddSection
    }
    
    func updateCountLabel(isPlus:Bool) -> Void {
        if isPlus {
            diaryCount += 1
        } else {
            diaryCount -= 1
        }
        entryNumLabel.text = "\(diaryCount) entry"
    }
    
}

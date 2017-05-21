//
//  SearchViewController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/4/18.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,AlertViewDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var keyword = ""
    private var diaryArray = Array<Array<Diary>>()
    private var diaryCount = Int()
    
  
    override func viewDidLoad() {
        themeInit()
        loadDiary()
    }
    
    func themeInit() -> Void {
        if Setting.themeColor == Setting.pinkColor {
            backgroundImage.image = UIImage(named: "pink")
        } else if Setting.themeColor == Setting.blueColor {
            backgroundImage.image = UIImage(named: "blue")
        }
    }
    
    public func loadDiary() -> Void {
        let predicate = NSPredicate(format:"title LIKE[cd] '*\(keyword)*' || text LIKE[cd] '*\(keyword)*'")
        let fetchedObjects = DataUtil.shared.fetchObjects(name: "Diary",predicate:predicate)
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
                for i in (arrayEndIndex+1...arrayBeginIndex).reversed() {
                    array.append(object[i])
                }
                diaryArray.append(array)
                arraySection += 1
                yearMonth = yearMonthTemp
                arrayBeginIndex = arrayEndIndex
            }
            if index == 0 {
                var array = Array<Diary>()
                for i in (0...arrayBeginIndex).reversed() {
                    array.append(object[i])
                }
                diaryArray.append(array)
            }
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
        print("section:\(diaryArray.count)")
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num:\(diaryArray[section].count)")
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
        let mail = cell?.viewWithTag(8) as! UILabel
        date.textColor = Setting.themeColor
        week.textColor = Setting.themeColor
        time.textColor = Setting.themeColor
        title.textColor = Setting.themeColor
        //        text.textColor = Setting.themeColor
        weather.textColor = Setting.themeColor
        mood.textColor = Setting.themeColor
        mail.textColor = Setting.themeColor
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
        alert.parentView = self.view
        let customView = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as! AlertView
        customView.initAlert(target: alert,imageID: diary.imageID)
        customView.delegate = self
        customView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.94, height: UIScreen.main.bounds.height>600 ? 600 : UIScreen.main.bounds.height*0.9)
        customView.setTime(month: comps.month!, day: comps.day!, hour: comps.hour!,minute: comps.minute!, weekday
            : comps.weekday!)
        customView.setTitleText(title: diary.title!,text: diary.text!)
        customView.titleLabel.textColor = Setting.themeColor
        customView.setWeather(weather: diary.weather!)
        customView.setLocation(location: diary.location == nil ? "No location" : diary.location!)
        customView.lookingDiarySection = indexPath.section
        customView.lookingDiaryRow = indexPath.row
        alert.containerView = customView
        alert.show()
        customView.addCons()
        //dialogView在调用show()之后才初始化
        alert.dialogView.layer.borderWidth = 0
        alert.dialogView.clipsToBounds = true
        alert.dialogView.layer.cornerRadius = 24
        alert.dialogView.viewWithTag(101)?.backgroundColor = Setting.themeColor
        alert.dialogView.viewWithTag(102)?.backgroundColor = Setting.themeColor
    }
    
    func onImageClick(imageID:Int) {
        print("onImageClick")
        let vc = PhotoViewController()
        vc.imageID = imageID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onDelete(lookingDiarySection: Int, lookingDiaryRow: Int) {
        let context = DataUtil.shared.context
        context.delete(diaryArray[lookingDiarySection][lookingDiaryRow])
        diaryArray[lookingDiarySection].remove(at: lookingDiaryRow)
        let indexPath = IndexPath(row: lookingDiaryRow, section: lookingDiarySection)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        if diaryArray[lookingDiarySection].count == 0 {
            diaryArray.remove(at: lookingDiarySection)
            tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.fade)
        }
    }

    
}

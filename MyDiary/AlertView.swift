//
//  AlertView.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/10.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit
import CoreData

class AlertView: UIView,UIAlertViewDelegate {

    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekAndTimeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var deleteBtn: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    var titleLabel: UILabel!
    
    weak var dialogView: CustomIOSAlertView!
    weak var diaryTableView: DiaryTableView!
    var lookingDiarySection = 0
    var lookingDiaryRow = 0
    
    
    public func initTapGesture(target:CustomIOSAlertView) -> Void {
        dialogView = target
        let singleTapClose = UITapGestureRecognizer.init(target: self, action: #selector(onCloseClick))
        closeBtn.addGestureRecognizer(singleTapClose)
        let singleTapDelete = UITapGestureRecognizer.init(target: self, action: #selector(onDeletClick))
        deleteBtn.addGestureRecognizer(singleTapDelete)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width:textView.frame.width * 0.9, height: 26))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(red: 84/255, green: 136/255, blue: 174/255, alpha: 1)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 20)
        textView.addSubview(titleLabel)
    }
    
    func addCons() -> Void {
        let centerXCons = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
        let topCons = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 16)
        textView.addConstraint(centerXCons)
        textView.addConstraint(topCons)
        OperationQueue.main.addOperation { 
            self.textView.setContentOffset(CGPoint(x:0,y:0), animated: false)
        }
    }
    
    func onCloseClick() -> Void {
        dialogView.close()
    }
    
    func onDeletClick() -> Void {
        let alert = UIAlertView(title: "提示", message: "你确定要删除吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }
    
    public func setTitleText(title:String,text:String) -> Void {
        titleLabel.text = title
        textView.text = "\n\n\(text)"
    }
    
    public func setTime(month:Int,day:Int,hour:Int,minute:Int,weekday:Int) -> Void {
        monthLabel.text = DateUtil.monthInt2String(month: month)
        dayLabel.text = "\(day)"
        weekAndTimeLabel.text = "\(DateUtil.weekdayInt2String(day: weekday, isAbbreviated: false))  \(DateUtil.formatHourMinute(hour: hour, minute: minute))"
    }
    
    public func setWeather(weather:String) -> Void {
        weatherIconLabel.text = weather
        switch weather {
        case "☼":
            weatherLabel.text = "SUNNY"
        case "☁︎":
            weatherLabel.text = "CLOUDY"
        case "⚡︎":
            weatherLabel.text = "THUNDERY"
        case "☔︎":
            weatherLabel.text = "RAINY"
        case "❄︎":
            weatherLabel.text = "SNOWY"
        default:
            weatherLabel.text = "Error"
        }
    }
    
    public func setLocation(location:String) -> Void {
        locationLabel.text = location
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
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
            let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Diary",in: context)
            fetchRequest.entity = entity
            context.delete(diaryTableView.diaryArray[lookingDiarySection][lookingDiaryRow])
            diaryTableView.diaryArray[lookingDiarySection].remove(at: lookingDiaryRow)
            let indexPath = IndexPath(row: lookingDiaryRow, section: lookingDiarySection)
            diaryTableView.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            if diaryTableView.diaryArray[lookingDiarySection].count == 0 {
                diaryTableView.diaryArray.remove(at: lookingDiarySection)
                diaryTableView.tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.fade)
            }
            diaryTableView.updateCountLabel(isPlus: false)
            dialogView.close()
        }
    }
    
}

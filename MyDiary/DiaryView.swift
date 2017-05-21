//
//  DiaryView.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/7.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DiaryView: UIView,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIActionSheetDelegate {
    
    let emoji = [["☺︎","☹","♡"],["☼","☁︎","⚡︎","☔︎","❄︎"]]
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBtn: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locateBtn: UIImageView!
//    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mood: UIPickerView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var title: UITextField!
    weak var delegate: DiaryViewDelegate?
    var isLocated = false
    var isLocating = false
    var location = ""
    

    public func initView() -> Void {
        addBtn.addTarget(self, action: #selector(onAddClick(button:)), for: UIControlEvents.touchDown)
        mood.dataSource = self
        mood.delegate = self
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 4
        let locateBtnSingleTap = UITapGestureRecognizer(target: self, action: #selector(onLocate))
        locateBtn.addGestureRecognizer(locateBtnSingleTap)
        //设置定位服务管理器代理
        locationManager.delegate = self
//        let locationLabelSingleTap = UITapGestureRecognizer(target: self, action: #selector(changeLocation))
//        locationLabel.addGestureRecognizer(locationLabelSingleTap)
        let imageBtnSingleTap = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageBtn.addGestureRecognizer(imageBtnSingleTap)
        let imageViewSingleTap = UITapGestureRecognizer(target: self, action: #selector(onImageViewClick))
        imageView.addGestureRecognizer(imageViewSingleTap)
    }
    
    
    func onImageViewClick() -> Void {
        if imageView.image != nil {
            let alert = UIAlertView(title: "移除图片", message: "要移除这张图片吗？", delegate: nil, cancelButtonTitle: "取消",otherButtonTitles: "确定")
            alert.delegate = self
            alert.show()
        }
    }
    
    func addImage() -> Void {
        let sheet = UIActionSheet()
        sheet.addButton(withTitle: "相册")
        sheet.addButton(withTitle: "相机")
        sheet.addButton(withTitle: "取消")
        sheet.title = "请选择图片来源"
        sheet.cancelButtonIndex = 2
        sheet.delegate = self
        sheet.show(in: self)
    }
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            if delegate != nil {
                delegate?.onPickerImage(index: buttonIndex)
            }
        } else {
            if delegate != nil {
                delegate?.onPickerImage(index: buttonIndex)
            }
        }
    }
    
    
    func themeInit() -> Void {
        bottomView.backgroundColor = Setting.themeColor
        moodLabel.textColor = Setting.themeColor
        weatherLabel.textColor = Setting.themeColor
        mood.reloadAllComponents()
    }
    
    func onAddClick(button : UIButton) {
        if (title.text?.characters.count)! > 16 {
            let alert = UIAlertView(title: "提示", message: "标题字数不允许大于16", delegate: nil, cancelButtonTitle: "好")
            alert.show()
        } else {
            let context = DataUtil.shared.context
            let diary = NSEntityDescription.insertNewObject(forEntityName: "Diary",into: context) as! Diary
            diary.date = Date()
            diary.text = text.text.characters.count == 0 ? "No Text" : text.text
            diary.mood = emoji[0][mood.selectedRow(inComponent: 0)]
            diary.title = title.text?.characters.count == 0 ? "No Title" : title.text
            diary.weather = emoji[1][mood.selectedRow(inComponent: 1)]
            diary.location = isLocated ? location : "No location"
            if imageView.image != nil {
                let imageData = UIImagePNGRepresentation(imageView.image!)! as NSData
                diary.imageID = imageData.hashValue
                let image = NSEntityDescription.insertNewObject(forEntityName: "DiaryImage",into: context) as! DiaryImage
                image.id = diary.imageID
                image.image = imageData
                print("imageID:\(image.id)")
            } else {
                diary.imageID = 0
            }
            do {
                try context.save()
                text.text = ""
                title.text = ""
            } catch {
                print(error.localizedDescription)
            }
            if delegate != nil {
                delegate?.onAddClick(button: addBtn,diary: diary)
            }
            self.endEditing(true)
            print("save success!")
        }
    }
    
    func onLocate() -> Void {
        if isLocated {
            locateBtn.image = UIImage(named: "location_error")
//            locationLabel.text = ""
            location = ""
            isLocated = false
        } else {
            //设置定位精度
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //更新距离
            locationManager.distanceFilter = 200
            ////发送授权申请
            locationManager.requestWhenInUseAuthorization()
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
                //允许使用定位服务的话，开启定位服务更新
                locateBtn.image = UIImage(named: "location")
//                locationLabel.text = "获取位置中……"
                locationManager.startUpdatingLocation()
                print("定位开始")
            } else {
                let alert = UIAlertView(title: "获取位置失败", message: "请尝试在设置-隐私-定位服务中打开定位服务", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
//                locationLabel.text = "获取位置失败"
            }
        }
    }
    
    func changeLocation() -> Void {
        if !isLocated {
            let alert = UIAlertView(title: "修改位置", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.alertViewStyle = UIAlertViewStyle.plainTextInput
            alert.textField(at: 0)?.text = location
            alert.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.title == "修改位置" {
            if buttonIndex == 1 {
                location = (alertView.textField(at: 0)?.text)!
                locateBtn.image = UIImage(named: "location")
                isLocated = true
            } else {
                self.locateBtn.image = UIImage(named: "location_error")
                isLocated = false
                location = ""
            }
        } else if alertView.title == "移除图片" {
            if buttonIndex == 1 {
                imageView.image = nil
            }
        }
    }
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 3
        } else {
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if view == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width/2.0, height: 0))
            label.textColor = Setting.themeColor
            label.textAlignment = NSTextAlignment.center
            label.font = label.font.withSize(20.0)
        } else {
            label = view as! UILabel
        }
        if component == 0 {
            switch row {
            case 0:
                label.text = emoji[0][0]
            case 1:
                label.text = emoji[0][1]
            case 2:
                label.text = emoji[0][2]
                //            case 3:
            //                return emoji[0][3]
            default:
                break
            }
        } else {
            switch row {
            case 0:
                label.text = emoji[1][0]
            case 1:
                label.text = emoji[1][1]
            case 2:
                label.text = emoji[1][2]
            case 3:
                label.text = emoji[1][3]
            case 4:
                label.text = emoji[1][4]
            default:
                break
            }
        }
        return label
    }
    
    
    //将经纬度转换为城市名
    func LonLatToCity(currLocation:CLLocation) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            
            if(error == nil) {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
//                城市
//                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //国家
//                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                //国家编码
//                let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
                //街道位置
//                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                //具体位置
                let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
                //省
//                var State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //区
//                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                
                
                //如果需要去掉“市”和“省”字眼
                
//                State = State.replacingOccurrences(of: "省", with: "")
//                let citynameStr = city.replacingOccurrences(of: "市", with: "")
//                let location = "\(State)\(city)\(SubLocality)\(FormattedAddressLines)\(Name)"
                self.location = "\(Name)"
//                self.locationLabel.text = location
                self.changeLocation()
                self.isLocated = true
            } else {
                print(error!.localizedDescription)
//                self.locationLabel.text = "获取位置失败"
                self.locateBtn.image = UIImage(named: "location_error")
            }
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        LonLatToCity(currLocation: currLocation)
    }
}

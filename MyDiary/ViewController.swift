//
//  ViewController.swift
//  MyDairy
//
//  Created by 钟圣麟 on 2016/12/6.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication


class ViewController: UIViewController,UIScrollViewDelegate,DiaryViewDelegate,DiaryTableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var titleContinier: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
//    let emoji = [["☺︎","☹","♡"],["☼","☁︎","⚡︎","☔︎","❄︎"]]
    var entires: DiaryTableView!
    var canlendar: CanlendarView!
    var diary: DiaryView!
    var scrollViewInited = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataUtil.shared.initUtil()  //初始化数据库辅助类
        initSetting()
        scrollView.delegate = self
        entires = Bundle.main.loadNibNamed("DiaryTableView", owner: nil, options: nil)?.first as! DiaryTableView
        canlendar = Bundle.main.loadNibNamed("CanlendarView", owner: nil, options: nil)?.first as! CanlendarView
        diary = Bundle.main.loadNibNamed("DiaryView", owner: nil, options: nil)?.first as! DiaryView
        diary.initView()
        diary.delegate = self
        entires.delegate = self
        entires.parentView = self.view
        canlendar.initView()
        
        entires.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        canlendar.frame = CGRect(x: self.view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        diary.frame = CGRect(x: self.view.frame.width*2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width*3, height: 0)
        scrollView.addSubview(entires)
        scrollView.addSubview(canlendar)
        scrollView.addSubview(diary)
        
        entires.loadDiary()
        entires.initView()
        
        segment.addTarget(self, action: #selector(onSegmentValueChanged), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        if Setting.useTouchIDCheck {
            entires.tableView.isHidden = true
            let authenticationContext = LAContext()
            var error: NSError?
            
            let isTouchIdAvailable = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error)
            
            if isTouchIdAvailable {
                print("恭喜，Touch ID可以使用！")
                //步骤2：获取指纹验证结果
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息", reply: {
                    (success, error) -> Void in
                    if success {
                        self.entires.tableView.isHidden = false
                        self.entires.tableView.reloadData()
                        print("恭喜，您通过了Touch ID指纹验证！")
                    } else {
                        print("抱歉，您未能通过Touch ID指纹验证！\n\(String(describing: error))")
                    }
                })
            } else {
                print("抱歉，Touch ID不可以使用！\n\(String(describing: error))")
            }
        }
//        addTest()
    }
    
    
//    func addTest() -> Void {
//        print("addTest")
//        let context = DataUtil.shared.context
//        let str = ["2014-01-26 17:40:50","2014-03-10 17:40:50","2014-03-26 17:40:50","2015-01-10 17:40:50","2015-01-13 17:40:50"]
//        let formatter = DateFormatter()
//        formatter.dateStyle = DateFormatter.Style.medium
//        formatter.timeStyle = DateFormatter.Style.short
//        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        let diary = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context) as! Diary
//        let date = formatter.date(from: str[4])
//        diary.date = date!
//        diary.text = "No Text"
//        diary.mood = emoji[0][1]
//        diary.title = "No Title"
//        diary.weather = emoji[1][1]
//        diary.location = "华东交大"
//        do {
//            try context.save()
//            entires.tableView.reloadData()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    private func initSetting() {
        let fetchedObjects = DataUtil.shared.fetchObjects(name: "User")
        if fetchedObjects.count != 0 {
            let user = fetchedObjects.first as! User
            Setting.headImage = UIImage(data: user.headImage! as Data)
            Setting.name = user.name!
            Setting.signature = user.signature!
            Setting.useTouchIDCheck = (user.touchID == 1)
            if user.theme == "蓝" {
                Setting.themeColor = Setting.blueColor
            } else if user.theme == "粉" {
                Setting.themeColor = Setting.pinkColor
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !scrollViewInited {
            print("initScrollView")
            changeNavigationFrame()
            //第三页大小适配scrollview必须在这里才有效果
            diary.frame = CGRect(x: self.view.frame.width*2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            canlendar.initViewSize()
            scrollViewInited = true
        }
        themeInit()
    }
    
    
    func themeInit() -> Void {
        if Setting.themeColor == Setting.pinkColor {
            backgroundImage.image = UIImage(named: "pink")
        } else if Setting.themeColor == Setting.blueColor {
            backgroundImage.image = UIImage(named: "blue")
        }
        segment.tintColor = Setting.themeColor
        topTitle.textColor = Setting.themeColor
        entires.themeInit()
        canlendar.themeInit()
        diary.themeInit()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        segment.selectedSegmentIndex = page
        self.view.endEditing(true)
    }
    
    func changeNavigationFrame() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationbar.frame = CGRect(x: 0, y: 0, width: self.navigationbar.frame.width, height: self.titleContinier.frame.height - 1)
    }
    
    //diaryView回调 成功添加日记后才会调用
    func onAddClick(button: UIButton,diary: Diary) {
        //是否需要添加section的标记
        let isAddSection = entires.addDiaryToTable(diary: diary)
        let index = 0
        let pageWidth = Int(scrollView.frame.width)
        scrollView.setContentOffset(CGPoint.init(x: pageWidth * index, y: 0), animated: true)
        let indexPath = IndexPath(row: 0, section: 0)
        if isAddSection {
            entires.tableView.insertSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.fade)
        } else {
            entires.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    func onPickerImage(index:Int) {
        if index == 0 {
            //判断设置是否支持图片库
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                //初始化图片控制器
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                //指定图片控制器类型
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.allowsEditing = true
                //弹出控制器，显示界面
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                print("读取相册错误")
            }
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                //创建图片控制器
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                //设置来源
                picker.sourceType = UIImagePickerControllerSourceType.camera
                //允许编辑
                picker.allowsEditing = true
                //打开相机
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                print("找不到相机")
            }
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        //显示的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        diary.imageView.image = image
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
    
    //entries 的回调
    func onMoreClick() {
        let mVC = MoreViewController()
        mVC.count[0] = "0"
        mVC.count[1] = "\(entires.diaryCount)"
        mVC.count[2] = "0"
        self.navigationController?.pushViewController(mVC, animated: true)
    }
    
    func onSegmentValueChanged() {
        let index = segment.selectedSegmentIndex
        let pageWidth = Int(scrollView.frame.width)
        scrollView.setContentOffset(CGPoint.init(x: pageWidth * index, y: 0), animated: true)
    }
    
    func onImageClick(imageID:Int) {
        print("onImageClick")
        let vc = PhotoViewController()
        vc.imageID = imageID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func keyboardWillAppear(notification:NSNotification) -> Void {
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        let keyboardBounds = info?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardBounds.size.height
        let options = (info?[UIKeyboardAnimationCurveUserInfoKey] as! Int) << 16
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(options)), animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self.diary.wrapperView.transform = CGAffineTransform(translationX: 0, y: keyboardHeight-176)
        }, completion: {
            (finished) -> Void in
        })
    }
    
    func keyboardWillDisappear(notification:Notification) -> Void {
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        let options = (info?[UIKeyboardAnimationCurveUserInfoKey] as! Int) << 16
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(options)), animations: {
            self.view.transform = CGAffineTransform.identity
            self.diary.wrapperView.transform = CGAffineTransform.identity
        }, completion: {
            (finished) -> Void in
        })
    }
 
    
}


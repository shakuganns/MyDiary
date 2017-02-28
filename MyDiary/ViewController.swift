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


class ViewController: UIViewController,UIScrollViewDelegate,DiaryViewDelegate,DiaryTableViewDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var titleContinier: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var entires: DiaryTableView!
    var canlendar: CanlendarView!
    var diary: DiaryView!
    var scrollViewInited = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        entires = Bundle.main.loadNibNamed("DiaryTableView", owner: nil, options: nil)?.first as! DiaryTableView
        canlendar = Bundle.main.loadNibNamed("CanlendarView", owner: nil, options: nil)?.first as! CanlendarView
        diary = Bundle.main.loadNibNamed("DiaryView", owner: nil, options: nil)?.first as! DiaryView
        diary.initView()
        diary.delegate = self
        entires.delegate = self
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
                        print("恭喜，您通过了Touch ID指纹验证！")
                    } else {
                        print("抱歉，您未能通过Touch ID指纹验证！\n\(error)")
                    }
                })
            } else {
                print("抱歉，Touch ID不可以使用！\n\(error)")
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
    
}


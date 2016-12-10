//
//  ViewController.swift
//  MyDairy
//
//  Created by 钟圣麟 on 2016/12/6.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UIScrollViewDelegate,DiaryViewDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var titleContinier: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var entires = DiaryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        entires = Bundle.main.loadNibNamed("DiaryTableView", owner: nil, options: nil)?.first as! DiaryTableView
        entires.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        let canlendar = Bundle.main.loadNibNamed("CanlendarView", owner: nil, options: nil)?.first as! UIView
        canlendar.frame = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        let diary = Bundle.main.loadNibNamed("DiaryView", owner: nil, options: nil)?.first as! DiaryView
        diary.frame = CGRect(x: scrollView.frame.width*2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        diary.initView()
        diary.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.frame.width*3, height: scrollView.frame.height)
        scrollView.addSubview(entires)
        scrollView.addSubview(canlendar)
        scrollView.addSubview(diary)
        
        entires.loadDiary()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        segment.addTarget(self, action: #selector(onSegmentValueChanged), for: UIControlEvents.valueChanged)
//        let addBtn = diary.viewWithTag(100) as! UIButton
//        addBtn.addTarget(self, action: #selector(click(button:)), for: UIControlEvents.touchDown)
    }
    
//    func click(button : UIButton) -> Void {
//        let calendar: Calendar = Calendar(identifier: .gregorian)
//        var comps: DateComponents = DateComponents()
//        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
//        var context = NSManagedObjectContext()
//        if #available(iOS 10.0, *) {
//            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            print("iOS 10")
//        } else {
//            // Fallback on earlier versions
//            let app = UIApplication.shared.delegate as! AppDelegate
//            context = app.managedObjectContext
//            print("iOS 9")
//        }
//        let diary = NSEntityDescription.insertNewObject(forEntityName: "Diary",into: context) as! Diary
//        diary.date = NSDate()
//        diary.text = "151561561564165456"
//        diary.mood = "good"
//        diary.title = "No Title"
//        diary.weather = "good"
//        diary.week = Int16(comps.weekday!) - 1
//        let minutes = comps.minute!<9 ? "0\(comps.minute!)" : "\(comps.minute!)"
//        diary.time = "\(comps.hour!):\(minutes)"
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//        entires.addDiaryToTable(diary: diary)
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeNavigationFrame()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        segment.selectedSegmentIndex = page
        self.view.endEditing(true)
    }
    
    //当应用被激活
    func applicationDidBecomeActive() {
        changeNavigationFrame()
    }
    
    func changeNavigationFrame() {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.navigationbar.frame = CGRect(x: 0, y: 0, width: self.navigationbar.frame.width, height: self.titleContinier.frame.height - 1)
    }
    
    //diaryView 回调
    func onAddClick(button: UIButton,diary: Diary) {
        entires.addDiaryToTable(diary: diary)
    }
    
    func onSegmentValueChanged() {
        let index = segment.selectedSegmentIndex
        let pageWidth = Int(scrollView.frame.width)
        scrollView.setContentOffset(CGPoint.init(x: pageWidth * index, y: 0), animated: true)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = LookDiaryViewController()
////        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }

}


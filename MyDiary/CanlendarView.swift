//
//  CanlendarView.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/12.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit

class CanlendarView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var animBtn: UIView!
    @IBOutlet weak var canlendarView: DAYCalendarView!
    
    var canlendarOpened = false
    var isAnimating = false
    
    
    func initView() -> Void {
        let comps = DateUtil.formatDate(date: Date())
        monthLabel.text = DateUtil.monthInt2String(month: comps.month!)
        dayLabel.text = "\(comps.day!)"
        weekdayLabel.text = DateUtil.weekdayInt2String(day: comps.weekday!, isAbbreviated: false)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(anim))
        animBtn.addGestureRecognizer(singleTap)
        canlendarView.weekdayHeaderWeekendTextColor = UIColor(red: 84/255, green: 136/255, blue: 174/255, alpha: 1 )
        canlendarView.selectedIndicatorColor = UIColor(red: 84/255, green: 136/255, blue: 174/255, alpha: 1 )
        canlendarView.reload(animated: false)
    }
    
    func initViewSize() {
        animBtn.layer.cornerRadius = animBtn.frame.width/2.0
    }
    
    func anim() -> Void {
        if isAnimating {
            return
        }
        print("start anim")
        isAnimating = true
        if !canlendarOpened {
            UIView.animate(withDuration: 0.5, animations: {
                self.canlendarView.frame.origin.y += self.canlendarView.frame.height
                self.monthLabel.frame.origin.y += self.canlendarView.frame.height
                self.dayLabel.frame.origin.y += self.canlendarView.frame.height
                self.weekdayLabel.frame.origin.y += self.canlendarView.frame.height
            },completion: {
                (finished) -> Void in
                self.canlendarOpened = true
                self.isAnimating = false
            })
            UIView.animate(withDuration: 0.5) { () -> Void in
                //指定旋转角度是180°
                self.animBtn.transform = self.animBtn.transform.rotated(by: CGFloat(M_PI))
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.canlendarView.frame.origin.y -= self.canlendarView.frame.height
                self.monthLabel.frame.origin.y -= self.canlendarView.frame.height
                self.dayLabel.frame.origin.y -= self.canlendarView.frame.height
                self.weekdayLabel.frame.origin.y -= self.canlendarView.frame.height
            },completion: {
                (finished) -> Void in
                self.canlendarOpened = false
                self.isAnimating = false
                
            })
            UIView.animate(withDuration: 0.5) { () -> Void in
                //指定旋转角度是180°
                self.animBtn.transform = self.animBtn.transform.rotated(by: CGFloat(M_PI))
            }
        }
        
    }
}

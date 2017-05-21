//
//  MyNavigationController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/16.
//  Copyright © 2016年 shakugan. All rights reserved.
//
//  解决隐藏navigationbar自带返回手势失效的问题
//
import UIKit

class MyNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取系统自带滑动手势的target对象
        let target = self.interactivePopGestureRecognizer?.delegate;

        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
        let pan = UIPanGestureRecognizer(target: target, action: NSSelectorFromString("handleNavigationTransition:"))
        
        // 设置手势代理，拦截手势触发
        pan.delegate = self
        
        // 给导航控制器的view添加全屏滑动手势
        self.view.addGestureRecognizer(pan)
        
        // 禁止使用系统自带的滑动手势
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.viewControllers.count != 1) && !(self.value(forKey: "_isTransitioning") as! Bool)
    }

}

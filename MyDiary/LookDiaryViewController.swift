//
//  LookDiaryViewController.swift
//  MyDairy
//
//  Created by 钟圣麟 on 2016/12/6.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit

class LookDiaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: 60)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

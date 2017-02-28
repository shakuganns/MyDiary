//
//  MoreViewController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/16.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var searchViewCon: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    weak var textField:UITextField!
    let icons = ["phone_book","diary","notice"]
    let texts = ["紧急联系人","日记本","绝对禁止"]
    var count = ["","",""]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let textField = searchBar.value(forKey: "_searchField") as! UITextField
        self.textField = textField
        textField.backgroundColor = Setting.themeColor
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        let barBackground = searchBar.value(forKey: "_background") as! UIView
        barBackground.removeFromSuperview()
        let image = UIImage(named: "magnifier")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        textField.leftView = imageView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textField.resignFirstResponder()
    }
    
    func keyboardWillAppear(notification:NSNotification) -> Void {
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        let keyboardBounds = info?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardBounds.size.height
        //上移动画options
        let options = (info?[UIKeyboardAnimationCurveUserInfoKey] as! Int) << 16
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(options)), animations: {
            self.searchViewCon.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }, completion: {
            (finished) -> Void in
        })
    }
    
    func keyboardWillDisappear(notification:Notification) -> Void {
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        //上移动画options
        let options = (info?[UIKeyboardAnimationCurveUserInfoKey] as! Int) << 16
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(options)), animations: {
            self.searchViewCon.transform = CGAffineTransform.identity
        }, completion: {
            (finished) -> Void in
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textField.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "moreCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MoreTableViewCell", owner: nil, options: nil)?.first as? UITableViewCell
        }
        let image = cell?.viewWithTag(1) as! UIImageView
        let title = cell?.viewWithTag(2) as! UILabel
        let count = cell?.viewWithTag(3) as! UILabel
        title.text = texts[indexPath.row]
        image.image = UIImage(named: icons[indexPath.row])
        count.text = self.count[indexPath.row]
        return cell!
    }

}

//
//  MoreViewController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/16.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var signText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchViewCon: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    weak var textField:UITextField!
    let icons = ["notice","diary","notice"]
    let texts = ["便签1","日记本","便签2"]
    var count = ["","",""]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        let textField = searchBar.value(forKey: "_searchField") as! UITextField
        self.textField = textField
        let barBackground = searchBar.value(forKey: "_background") as! UIView
        barBackground.removeFromSuperview()
        let image = UIImage(named: "magnifier")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        textField.leftView = imageView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTopClick)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        themeInit()
        signText.text = Setting.signature
        nameText.text = Setting.name
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = SearchViewController()
        vc.keyword = searchBar.text!
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    func themeInit() -> Void {
        headImage.image = Setting.headImage
        textField.backgroundColor = Setting.themeColor
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        topView.backgroundColor = Setting.themeColor
    }
    
    
    func onTopClick() -> Void {
        self.navigationController?.pushViewController(PersInfoViewController(), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = NoteViewController()
            vc.id = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.popViewController(animated: true)
        } else if indexPath.row == 2 {
            let vc = NoteViewController()
            vc.id = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

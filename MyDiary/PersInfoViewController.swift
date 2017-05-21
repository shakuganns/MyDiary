//
//  PersInfoViewController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/4/16.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import UIKit
import CoreData

class PersInfoViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var changeHeadBtn: UIButton!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var navRightBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let images = [["businessCard","describe"],["lock","theme"]]
    let isText = [[true,true],[false,true]]
    let isSwitch = [[false,false],[true,false]]
    
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundView?.backgroundColor = UIColor.clear
        navRightBtn.action = #selector(onNavRightClick)
        changeHeadBtn.addTarget(self, action: #selector(onChangeHeadClick), for: UIControlEvents.touchUpInside)
        headImage.image = Setting.headImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func onNavRightClick() -> Void {
        let context = DataUtil.shared.context
        let fetchedObjects = DataUtil.shared.fetchObjects(name: "User")
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let signCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        let touchIDCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        let themeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        let name = nameCell?.viewWithTag(2) as! UITextField
        let sign = signCell?.viewWithTag(2) as! UITextField
        let touchID = touchIDCell?.viewWithTag(3) as! UISwitch
        let theme = themeCell?.viewWithTag(4) as! UILabel
        if fetchedObjects.count == 0 {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User",into: context) as! User
            user.headImage = UIImagePNGRepresentation(headImage.image!) as NSData?
            user.name = name.text
            user.signature = sign.text
            user.touchID = touchID.isOn as NSNumber
            user.theme = theme.text
            changSetting(user: user)
        } else {
            let user = fetchedObjects.first as! User
            user.headImage = UIImagePNGRepresentation(headImage.image!) as NSData?
            user.name = name.text
            user.signature = sign.text
            user.touchID = touchID.isOn as NSNumber
            user.theme = theme.text
            changSetting(user: user)
        }
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func changSetting(user:User) -> Void {
        Setting.headImage = headImage.image
        Setting.name =  user.name!
        Setting.signature = user.signature!
        Setting.useTouchIDCheck = (user.touchID == 1)
        if user.theme == "粉" {
            Setting.themeColor = Setting.pinkColor
        } else if user.theme == "蓝" {
            Setting.themeColor = Setting.blueColor
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if header == nil {
            header = Bundle.main.loadNibNamed("PersInfoTableViewCell", owner: nil, options: nil)?.last as? UITableViewHeaderFooterView
            header?.contentView.backgroundColor = UIColor.clear
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "persinfoCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PersInfoTableViewCell", owner: nil, options: nil)?.first as? UITableViewCell
        }
        let image = cell?.viewWithTag(1) as! UIImageView
        let text = cell?.viewWithTag(2) as! UITextField
        let uiswitch = cell?.viewWithTag(3) as! UISwitch
        let describe = cell?.viewWithTag(4) as! UILabel
        if images[indexPath.section][indexPath.row] == "theme" {
            image.backgroundColor = Setting.themeColor
            image.layer.cornerRadius = image.frame.width/2
        } else {
            image.image = UIImage(named: images[indexPath.section][indexPath.row])
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                text.text = Setting.name
            } else {
                text.text = Setting.signature
            }
        } else {
            if indexPath.row == 0 {
                text.text = "加密"
                uiswitch.isOn = Setting.useTouchIDCheck
            } else {
                text.text = "主题"
                if Setting.themeColor == Setting.blueColor {
                    describe.text = "蓝"
                } else if Setting.themeColor == Setting.pinkColor {
                    describe.text = "粉"
                }
                text.isEnabled = false
                if describe.text == "粉" {
                    image.backgroundColor = Setting.pinkColor
                } else if describe.text == "蓝" {
                    image.backgroundColor = Setting.blueColor
                }
            }
        }
        if isText[indexPath.section][indexPath.row] {
            uiswitch.removeFromSuperview()
        } else {
            text.isEnabled = false
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && indexPath.section == 1 {
            let sheet = UIActionSheet()
            sheet.addButton(withTitle: "蓝")
            sheet.addButton(withTitle: "粉")
            sheet.addButton(withTitle: "取消")
            sheet.title = "选择颜色"
            sheet.cancelButtonIndex = 2
            sheet.delegate = self
            sheet.show(in: self.view)
        }
    }
    
    func onChangeHeadClick() -> Void {
        let sheet = UIActionSheet()
        sheet.addButton(withTitle: "相册")
        sheet.addButton(withTitle: "相机")
        sheet.addButton(withTitle: "取消")
        sheet.title = "选择头像来源"
        sheet.cancelButtonIndex = 2
        sheet.delegate = self
        sheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if actionSheet.title == "选择颜色" {
            let themeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
            let theme = themeCell?.viewWithTag(4) as! UILabel
            let image = themeCell?.viewWithTag(1) as! UIImageView
            if buttonIndex == 0 {
                theme.text = "蓝"
                image.backgroundColor = Setting.blueColor
            } else if buttonIndex == 1 {
                theme.text = "粉"
                image.backgroundColor = Setting.pinkColor
            }
        } else if actionSheet.title == "选择头像来源" {
            onPickerImage(index: buttonIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return images.count
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images[section].count
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
        headImage.image = image
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }


    
}



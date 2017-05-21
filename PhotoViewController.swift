//
//  PhotoViewController.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2017/4/18.
//  Copyright © 2017年 shakugan. All rights reserved.
//

import Foundation

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageID = Int()
    
    override func viewDidLoad() {
        let condition = "id='\(imageID)'"
        let predicate = NSPredicate(format: condition,"")
        let fetchedObjects = DataUtil.shared.fetchObjects(name: "DiaryImage", predicate: predicate)
        let data = fetchedObjects.first as! DiaryImage
        let imageData = data.image! as Data
        imageView.image = UIImage(data: imageData)
    }
    
}

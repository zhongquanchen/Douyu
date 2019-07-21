//
//  UIBarButtonItem_extension.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/21.
//  Copyright © 2019 Oscar. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    /*
    class func createItem(imageName: String, highImageName: String, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
 */
    //convience开头，2 在构造函数中明确表明一个设计构造函数（self）
    convenience init(imageName : String, highImageName: String = "", size: CGSize = CGSize.zero) {
        let btn = UIButton()
        
        //设置点击item
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != ""{
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        //设置btn尺寸
        if size == CGSize.zero{
            btn.sizeToFit()
        } else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        //创建item
        self.init(customView: btn)
        }
}

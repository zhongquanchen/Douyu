//
//  HomeViewController.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/21.
//  Copyright © 2019 Oscar. All rights reserved.
//

import UIKit
private let kTitleViewH : CGFloat = 40


class HomeViewController: UIViewController {
    //Mark:- 懒加载属性
    private lazy var pageTitleView: PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.backgroundColor = UIColor.purple
        
        return titleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        setupUI()
    }
}

//Mark:- 设置UI界面
extension HomeViewController{
    private func setupUI(){
        //0. 不需要调整uiscrollview的内边距
        //1. 设置导航栏
        setupNavigationBar()
        //2.添加titleview
        view.addSubview(pageTitleView)
    }
    
    private func setupNavigationBar(){
        //1.设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //2.设置右item
        let size = CGSize(width: 30, height: 30)
        //创建items
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        //放进 右边的btnl list
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}

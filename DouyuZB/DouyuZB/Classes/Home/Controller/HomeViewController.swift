//
//  HomeViewController.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/21.
//  Copyright © 2019 Oscar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//Mark:- 设置UI界面
extension HomeViewController{
    private func setupUI(){
        //1. 设置导航栏
        setupNavigationBar()
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

//
//  HomeViewController.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/21.
//  Copyright © 2019 Oscar. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    let titlecount = 4
    //Mark:- 懒加载属性
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.backgroundColor = .purple
        titleView.delegate = self
        
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = {[weak self] in
        //1.确定内容 frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBar
        let contentframe = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        //2.确定所有子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentframe, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
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
        //1. 设置导航栏
        setupNavigationBar()
        //2.添加titleview
        view.addSubview(pageTitleView)
        //3.添加cantentview
        view.addSubview(pageContentView)
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

//mark: d遵守pagetitleviewdelegate 协议
extension HomeViewController : PageTileViewDelegate{
    func pageTileView(titleView: PageTitleView, selectedIndex index: Int) {
        //print(index)
        pageContentView.setupCurrentIndex(currentIndex: index)
    }
}

//mark: 遵守pagecontenviewdelegate
extension HomeViewController : PageConetnViewDelegate {
    func pageContentView(contenView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

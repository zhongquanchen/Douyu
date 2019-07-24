//
//  PageContentView.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/22.
//  Copyright © 2019 Oscar. All rights reserved.
//

import UIKit

private let ContentCellID = "ContentCellID"

protocol PageConetnViewDelegate : class {
    func pageContentView(contenView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class PageContentView: UIView {
    //mark: 定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageConetnViewDelegate?
    
    //mark: 懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UIcollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        
        //UIcollectionView的三个协议
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ContentCellID")
        
        return collectionView
    }()
    
    //mark: 自定义函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//mark: 设置ui界面
extension PageContentView{
    private func setupUI(){
        //1.将所有子控制器添加到父控制器中
        for childVc in childVcs{
            parentViewController?.addChild(childVc)
        }
        //2.添加uiconnection view，用于在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


//mark: 遵守cuicollectionviewdatasource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.confingure cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //2. set cell content
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//Mark: 对外暴露的方法
extension PageContentView{
    func setupCurrentIndex(currentIndex : Int){
        //1.记录需要禁止c执行代理
        isForbidScrollDelegate = true
        
        //2.滚动到正确位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)

    }
}

//mark: 遵守UIcollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0.判断是否是点击时间
        if isForbidScrollDelegate {return}
        
        //1.获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断是左边还是右边
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX{//左滑
            //1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //2.计算sourceindex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //3.计算targtindex
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }else{
                targetIndex = sourceIndex + 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//right
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            //2.计算targetindex
            targetIndex = Int(currentOffsetX / scrollViewW)
            //3.计算sourceindex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
        }
        //3.将progres/sourceindex/targetindex传输
        delegate?.pageContentView(contenView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

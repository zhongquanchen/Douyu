//
//  PageTitleView.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/21.
//  Copyright © 2019 Oscar. All rights reserved.
//

import UIKit

private let kScrollLineH : CGFloat = 2

class PageTitleView: UIView {

    //Mark:- 定义属性
    private var titles : [String]
    
    //Mark:- 懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var scrollLine : UIView = {
       let scrollLine = UIView()
        scrollLine.backgroundColor = .orange
        return scrollLine
    }()
    
    //Mark:- 自定义构造函数
    init(frame: CGRect, titles : [String]){
        self.titles = titles
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView{
    private func setupUI(){
    //1.添加UIscrollview
        addSubview(scrollView)
        scrollView.frame = bounds
        
    //2.添加title对应label
        setupTitleLabels()
    //3.设置底线&滚动滑块
        setupBottonMenuScrollLine()
    }
    
    private func setupBottonMenuScrollLine()
    {
        let lineH : CGFloat = 0.5
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        //添加scrollline
        //获取第一个label
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = .orange
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
    
    private func setupTitleLabels()
    {
        // 确定label frame值
        let labelW :CGFloat = frame.width / CGFloat(titles.count)
        let labelH :CGFloat = frame.height - kScrollLineH
        let labelY :CGFloat = 0
        
        for (index, title) in titles.enumerated(){
            //创建uilabel
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = .white
            label.textAlignment = .center
            //label's frame
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            titleLabels.append(label)
            scrollView.addSubview(label)
        }
    }
}

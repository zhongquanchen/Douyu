//
//  PageTitleView.swift
//  DouyuZB
//
//  Created by Oscar on 2019/7/21.
//  Copyright © 2019 Oscar. All rights reserved.
//

import UIKit
//定义协议
protocol PageTileViewDelegate : class {
    func pageTileView(titleView: PageTitleView, selectedIndex index :Int)
}

//定义 constant
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (255, 255, 255)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

private let kScrollLineH : CGFloat = 2

class PageTitleView: UIView {

    //Mark:- 定义属性
    private var currentIndex : Int = 0
    private var titles : [String]
    weak var delegate : PageTileViewDelegate?
    
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
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
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
            label.textColor = UIColor(r:kNormalColor.0, g:kNormalColor.1, b:kNormalColor.2)
            label.textAlignment = .center
            //label's frame
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            titleLabels.append(label)
            scrollView.addSubview(label)
            
            //给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes: )))
            label.addGestureRecognizer(tapGes)
        }
    }
}

//mark: 监听label点击
extension PageTitleView {
    //时间监听要加@objc
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer){
        //1.获取当前label
        guard let currentlabel = tapGes.view as? UILabel else {return}
        //2.获取之前label
        let oldLabel = titleLabels[currentIndex]
        //3.切换文字颜色
        oldLabel.textColor = UIColor(r:kNormalColor.0, g:kNormalColor.1, b:kNormalColor.2)
        currentlabel.textColor = UIColor(r:kSelectColor.0, g:kSelectColor.1, b:kSelectColor.2)
        //4.保存最新label下标
        currentIndex = currentlabel.tag
        //5.更新滚动条
        let scrollLineX = CGFloat(currentlabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15){
            self.scrollLine.frame.origin.x = scrollLineX
        }
        //6.通知代理
        delegate?.pageTileView(titleView: self, selectedIndex: currentIndex)
    }
}

//mark: 对外暴露方法
extension PageTitleView{
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        //取出sourcelabel/targetlabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //颜色的渐变（难）
        //3.1取出变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2变化sourcelabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0-colorDelta.0 * progress, g: kSelectColor.1-colorDelta.1*progress, b:kSelectColor.2-colorDelta.2*progress)
        //3.2变化targetlabel
        targetLabel.textColor = UIColor(r: kNormalColor.0+colorDelta.0, g: kNormalColor.1+colorDelta.1, b: kNormalColor.2+colorDelta.2)
        
        //4.记录最新index
        currentIndex = targetIndex
    }
}

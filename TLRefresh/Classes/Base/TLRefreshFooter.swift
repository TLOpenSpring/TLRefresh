//
//  TLRefreshFooter.swift
//  Pods
//  设置一些构造方法
//  Created by Andrew on 16/7/25.
//
//

import UIKit



open class TLRefreshFooter: TLBaseRefresh {
    
    var isAutoHidden:Bool = false
    
  
    
    
    /// 忽略多少scrollView的contentInset的bottom
    open var ignoredScrollViewContentInsetBottom:CGFloat = 0

    //MARK: - 构造方法
   public init(block: TLRefreshingHandler?) {
        super.init(frame: CGRect.zero)
        self.refreshingHandler = block
        self.state = TLRefreshState.idle
    }
    
   public init(target:AnyObject,action:Selector) {
        super.init(frame: CGRect.zero)
        self.setRefreshingTarget(target, action: action)
        self.state = TLRefreshState.idle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.height = TLRefreshFooterHeight
        self.isAutoHidden = false
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil{
            if self.scrollView is UITableView || self.scrollView is UICollectionView{
//                self.scrollView?.tl_reloadDataBlock = {
//                    (totalCount:Int) in
//                    if self.isAutoHidden == true{
//                        self.hidden = totalCount == 0
//                    }
//                }
                if self.scrollView.tl_totalCount == 0{
                  self.isHidden = true
                }else{
                  self.isHidden = false
                }
            }
        }
    }
    
    
    //MARK: - help methods
    
   open func endRefreshingWithNoMoreData() -> Void {
        self.state = TLRefreshState.noMoreData
    }
   open func resetNoMoreData() -> Void {
        self.state = TLRefreshState.idle
    }
    

  
}










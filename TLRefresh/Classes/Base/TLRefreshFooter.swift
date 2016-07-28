//
//  TLRefreshFooter.swift
//  Pods
//  设置一些构造方法
//  Created by Andrew on 16/7/25.
//
//

import UIKit


@objc protocol TLRefreshFootProtocol {
    /**
     设置状态文字的显示颜色
     
     - parameter color: 要设置的颜色
     
     - returns:
     */
   optional func setStateLbColor(color color:UIColor) -> Void;
}


public class TLRefreshFooter: TLBaseRefresh,TLRefreshFootProtocol {
    
    var isAutoHidden:Bool = false
    
  
    
    
    /// 忽略多少scrollView的contentInset的bottom
    public var ignoredScrollViewContentInsetBottom:CGFloat = 0

    //MARK: - 构造方法
   public init(block: TLRefreshingHandler?) {
        super.init(frame: CGRectZero)
        self.refreshingHandler = block
        self.state = TLRefreshState.Idle
    }
    
   public init(target:AnyObject,action:Selector) {
        super.init(frame: CGRectZero)
        self.setRefreshingTarget(target, action: action)
        self.state = TLRefreshState.Idle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.height = TLRefreshFooterHeight
        self.isAutoHidden = false
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview != nil{
            if self.scrollView is UITableView || self.scrollView is UICollectionView{
//                self.scrollView?.tl_reloadDataBlock = {
//                    (totalCount:Int) in
//                    if self.isAutoHidden == true{
//                        self.hidden = totalCount == 0
//                    }
//                }
                if self.scrollView.tl_totalCount == 0{
                  self.hidden = true
                }else{
                  self.hidden = false
                }
            }
        }
    }
    
    
    //MARK: - help methods
    
   public func endRefreshingWithNoMoreData() -> Void {
        self.state = TLRefreshState.NoMoreData
    }
   public func resetNoMoreData() -> Void {
        self.state = TLRefreshState.Idle
    }
    
    /**
     设置状态文字的颜色
     
     - parameter color: 颜色
     */
   public func setStateLbColor(color color:UIColor) -> Void{}
  
}










//
//  TLRefreshBackFooter.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

public class TLRefreshBackFooter: TLRefreshFooter {

    var lastRefreshCount:Int = 0
    var lastBottomData:CGFloat = 0
    
    var tl_paddingBottomSpace:CGFloat = 50
    
  
    
    //MARK: - 父类方法
    
    override func scrollViewContentSizeDidChange(change: [String : AnyObject]) {
        super.scrollViewContentSizeDidChange(change)
        
        //内容的高度
        let contentHeight = (self.scrollView?.tl_contentHeight)! + ignoredScrollViewContentInsetBottom
        
        //表格的高度
        let scollheight = (scrollView?.height)! - (scrollViewOriginInset?.top)! - (scrollViewOriginInset?.bottom)! + ignoredScrollViewContentInsetBottom
        //设置位置和尺寸
        self.y = max(contentHeight, scollheight)
    }
    
    override func scrollViewPanStateDidChange(change: [String : AnyObject]) {
        super.scrollViewPanStateDidChange(change)
    }
    

    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]) {
        super.scrollViewContentOffsetDidChange(change)
        
        //如果正在刷新
        if state == TLRefreshState.Refreshing{
         return
        }
        
        
        self.scrollViewOriginInset = self.scrollView.contentInset
        
        
        //获取当前contentOffset
        let currentOffsetY = self.scrollView.tl_offsetY
        //尾部控件刚好出现的offsetY
        let happenOffsety = self.happenOffsetY()
        
        //如果是向下滚动看不见尾部控件，直接返回
        if(currentOffsetY < happenOffsety){
           return
        }
        
        //获取百分比
        let pullingPercent = (currentOffsetY - happenOffsety)/self.height
        if state == TLRefreshState.NoMoreData{
            self.pullingPercent = pullingPercent
            return
        }
        
        if self.scrollView.dragging == true{
            self.pullingPercent = pullingPercent
            //普通和即将刷新的临界点
            let normalPullingOffsetY = happenOffsety + self.height
            
            print("==self.state:\(self.state!);currentOffsetY:\(currentOffsetY);normalPullingOffsetY:\(normalPullingOffsetY)")
            
            if state == TLRefreshState.Idle && currentOffsetY > normalPullingOffsetY{
                
                //转为即将刷新状态
                setState(TLRefreshState.Pulling)
            }else if state == TLRefreshState.Pulling && currentOffsetY <= normalPullingOffsetY {
                //转为普通状态
                setState(.Idle)
            }
//            else if(self.state == TLRefreshState.Pulling){//即将刷新 && 手松开
//                //开始刷新
//                self.beginRefreshing()
//            }
            else if(pullingPercent < 1){
                self.pullingPercent = pullingPercent
            }
        }else{
             if(self.state == TLRefreshState.Pulling){//即将刷新 && 手松开
                //开始刷新
                self.beginRefreshing()
            }
        }
    }
    
    
    override func setState(refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        
        if state == TLRefreshState.NoMoreData || state == TLRefreshState.Idle{
            
            //如果是从刚刷新的状态变为闲置状态
            if oldState  == TLRefreshState.Refreshing{
                
             UIView.animateWithDuration(TLRefreshSlowAnimationDuration, animations: {
                
                self.scrollView.tl_insetBottom -= self.lastBottomData
                //自动调整透明度
                if self.isAutoChangeAlpha == true{
                    self.alpha = 0
                }
                }, completion: { (finished) in
                    self.pullingPercent = 0
                    if let handler = self.refreshEndHandler{
                        handler!()
                    }
             })
            }
         
            //获取ScrollView的内容超出View的高度
            let beyondHeight = self.heightForContentBreakView()
            
            if oldState == TLRefreshState.Refreshing && beyondHeight>0 && scrollView?.tl_totalCount != lastRefreshCount{
                self.scrollView.tl_offsetY = self.scrollView.tl_offsetY
            }
        }else if state == TLRefreshState.Refreshing{//正在刷新
         //记录刷新前的数量
            self.lastRefreshCount = (self.scrollView?.tl_totalCount)!
            
            UIView.animateWithDuration(TLRefreshFastAnimationDuration, animations: {
                
                var bottom = self.height + self.scrollViewOriginInset.bottom
                let h = self.heightForContentBreakView()
                
                if(h<0){
                  bottom -= h
                }
                
                self.lastBottomData = bottom - self.scrollView.tl_insetBottom
                self.scrollView.tl_insetBottom = bottom
               
                self.scrollView.tl_offsetY = self.happenOffsetY() + self.height
                }, completion: { (finished) in
                    self.executeRefreshCallBack()
            })
        }
    }
    
    
   
    
    //MARK: - Help methods
    /**
     获取ScrollView的内容超出View的高度
     */
    func heightForContentBreakView() -> CGFloat {
        if let originInset = scrollViewOriginInset{
            let h = (scrollView?.height)! - originInset.bottom - originInset.top
            return (scrollView?.contentSize.height)! - h
        }
        
        return 0
    }
    /**
     刚好看到上拉刷新控件时的contentOffset.y
     
     - returns:
     */
    func happenOffsetY() -> CGFloat {
        //获取ScrollView的内容超出View的高度
        let h = self.heightForContentBreakView()
        if h > 0{
            return h - (scrollViewOriginInset?.top)!
        }else{
            return -(scrollViewOriginInset?.top)!
        }
        
    }
}

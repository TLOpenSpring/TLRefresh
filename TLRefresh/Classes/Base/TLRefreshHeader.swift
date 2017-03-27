//
//  TLRefreshHeader.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

open class TLRefreshHeader: TLBaseRefresh {
    
    /// 存储上一次下拉刷新时间
    var lastUpdatedTimeKey:String = "lastUpdatedTimeKey"
    /// 上一次刷新成功的时间
    var lastUpdatedTime:Date?
    /// 忽略多少scrollView的contentInset的Top
    open var ignoredScrollViewContentInsetTop:CGFloat = 0

    //MARK: - 构造方法
    public init(block: TLRefreshingHandler?) {
        super.init(frame: CGRect.zero)
        self.refreshingHandler = block
        setState(TLRefreshState.idle)
    }
    
    public init(target:AnyObject,action:Selector) {
        super.init(frame: CGRect.zero)
        self.setRefreshingTarget(target, action: action)
        setState(TLRefreshState.idle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - 初始化方法
    override func initialization() {
        super.initialization()
        //设置自己的高度
        self.height = TLRefreshHeaderHeight
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.y =  -self.height  - ignoredScrollViewContentInsetTop
        
    }
    
    
    //MARK: - 重写父类的方法
    override func scrollViewContentSizeDidChange(_ change:String?) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override func scrollViewContentOffsetDidChange(_ change: String?) {
        super.scrollViewContentOffsetDidChange(change)
        
        //如果正在刷新
        if state == TLRefreshState.refreshing{
            if self.window == nil{
                return
            }
            
            //解决UITableView 用section 布局时，section块停留在页面不跟着滑动的问题
            var insetTop = -self.scrollView.tl_offsetY > self.scrollViewOriginInset.top ? -scrollView.tl_offsetY : self.scrollViewOriginInset.top
            
            insetTop = insetTop > self.height + self.scrollViewOriginInset.top ? self.height + self.scrollViewOriginInset.top : insetTop
            
            
            self.scrollView.tl_insetTop = insetTop

            return
        }
        
        scrollViewOriginInset = self.scrollView.contentInset
        
        //获取当前的contentOffset
        let offsetY = self.scrollView.tl_offsetY
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -self.scrollViewOriginInset.top
        
        
        //如果向上滚动看不见头部控件，直接返回
        if(offsetY > happenOffsetY){
          return
        }
        
        //普通状态 和 即将刷新状态的临界点
        let normalPullingOffsetY = happenOffsetY - self.height
        let pullingPercent = (happenOffsetY - offsetY) / self.height
        
//        TLLogUtils.log?.info("state:\(self.state!);normalPullingOffsetY:\(normalPullingOffsetY)")
        //如果手指正在拖动视图
        if(self.scrollView.isDragging == true){
            self.pullingPercent = pullingPercent
            if state  == TLRefreshState.idle && offsetY < normalPullingOffsetY{
              //转为即将刷新的状态
                setState(TLRefreshState.pulling)
            }else if state == TLRefreshState.pulling && offsetY >= normalPullingOffsetY{
               //转变为闲置状态
                setState(TLRefreshState.idle)
            }
         
        }else if(state == TLRefreshState.pulling){ //拖拉状态 && 手松开
          //开始刷新
            self.beginRefreshing()
        }else if(pullingPercent < 1){
         self.pullingPercent = pullingPercent
        }
    }
    
    
    override func setState(_ refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        
        if state == TLRefreshState.idle{
            //如果不是从刷新状态变过来的，return
            if oldState != TLRefreshState.refreshing{
              return
            }
            //保存刷新时间
            self.setRefreshTime()
            UIView.animate(withDuration: TLRefreshSlowAnimationDuration, animations: {
//                //#TODO
                self.scrollView.tl_insetTop = self.height+10
                
                 self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.height-10), animated: true)
                
                if self.isAutoChangeAlpha == true{
                  self.alpha = 0
                }
                
                }, completion: { (finished) in
                    
                    self.pullingPercent = 0
                    
                    if let handler = self.refreshEndHandler{
                       handler!()
                    }
            })
            
        }else if state == TLRefreshState.refreshing{
         
            DispatchQueue.main.async(execute: {
                
                UIView.animate(withDuration: TLRefreshFastAnimationDuration, animations: {
                    var top = self.ignoredScrollViewContentInsetTop + self.height
                    
                    //这里为了彻底显示出来刷新的View,所以高度乘以2倍
                    top = top*2 + 10
                    
                    //增加滚动区域的top
                    self.scrollView.tl_insetTop = top
                  
                    //设置滚动位置
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: -top), animated: true)
                    
                    }, completion: { (finished) in
                        self.executeRefreshCallBack()
                })
            })
        }
        
    }
    
    
  
}




extension TLRefreshHeader{
    
    /**
     保存刷新时间
     */
    func setRefreshTime() -> Void {
        
        let userDafulat = UserDefaults.standard
        userDafulat.set(Date(), forKey: self.lastUpdatedTimeKey)
        userDafulat.synchronize()
        
    }
    
    /**
     获取刷新时间
     
     - returns: 元组(时间类型 , 时间字符串)
     */
    func getRefreshTime() -> (date:Date,dateStr:String)? {
        let userDafulat = UserDefaults.standard
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd hh:mm"
        
        let date = userDafulat.object(forKey: lastUpdatedTimeKey)
        if let currentDate = date {
            if currentDate is Date{
                let  dateTime = currentDate as! Date
                let dateStr = dateFormatter.string(from: dateTime)
                
                return (date:dateTime,dateStr:dateStr)
            }
        }

        return nil
    }
}














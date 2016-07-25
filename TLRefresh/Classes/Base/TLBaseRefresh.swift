//
//  TLBaseRefresh.swift
//  Pods
//
//  Created by Andrew on 16/7/22.
//
//

import UIKit

/**
 刷新的几种状态
 
 - Idle:        闲置状态
 - Pulling:     拉取中...
 - Refreshing:  刷新中
 - WillRefresh: 即将刷新的状态
 - NoMoreData:  没有更多数据的状态
 */
enum TLRefreshState {
    /// 闲置状态
    case Idle
    /// 拉取中...
    case Pulling
    /// 刷新中
    case Refreshing
    /// 即将刷新的状态
    case WillRefresh
    /// 没有更多数据的状态
    case NoMoreData
    
}
/// 正在刷新的回调
public typealias TLRefreshingHandler = (()->())?
/// 进入刷新状态后的回调
public typealias TLRefreshBeginedCompletionHandler = (()->())?
/// 结束刷新后的回调
public typealias TLRefreshEndCompletionHander = (()->())?


public class TLBaseRefresh: UIView {
    /// 记录UIScrollView刚开始的inset
    var scrollViewOriginInset:UIEdgeInsets!
    /// 所有的刷新都是基于该控件
    internal var scrollView:UIScrollView!
    //滑动手势
    var pan:UIPanGestureRecognizer?
    /// 刷新状态
    internal var state:TLRefreshState?
    //回调函数
    /// 正在刷新的回调函数
    var refreshingHandler:TLRefreshingHandler?
    /// 进入刷新状态后的回调
    var refreshBeginedHandler:TLRefreshBeginedCompletionHandler?
    /// 结束刷新后的回调
    var refreshEndHandler:TLRefreshEndCompletionHander?
    /// 回调方法
    var refreshAction:Selector?
    /// 回调对象
    var refreshTarget:AnyObject?
    
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     系统初始化的方法
     */
    func initialization() -> Void {
        
    }

    
    
    
    //MARK: - 刷新状态控制
   public func beginRefreshing() -> Void {
        UIView.animateWithDuration(TLRefreshSlowAnimationDuration) { 
            self.alpha = 1
        }
        
        if (self.window != nil){
            setState(.Refreshing)
        }else{
            if self.state != TLRefreshState.Refreshing{
                setState(.Refreshing)
                //重新刷新
                self.setNeedsDisplay()
            }
        }
        
    }
   public func begingRefreshing(completionHandler:TLRefreshingHandler?) -> Void {
        self.refreshingHandler = completionHandler
        beginRefreshing()
    }
    
    
    /**
     结束刷新状态
     */
   public func endRefreshing() -> Void
    {
        setState(.Idle)
    }
    func endRereshing(completionHandler:(()->())?) -> Void {
        self.refreshEndHandler = completionHandler
        endRefreshing()
    }
    
    /**
     判断是否正在刷新
     
     - returns:
     */
   public func isRefreshing() -> Bool {
        return self.state == TLRefreshState.Refreshing || self.state == TLRefreshState.WillRefresh
    }
    
    //MARK: - UIScrollView
    func scrollViewContentOffsetDidChange(change:[String:AnyObject]) -> Void { }
    /**
     当scrollView的contentSize发生改变的时候调用
     
     - parameter change:
     */
    func scrollViewContentSizeDidChange(change:[String:AnyObject]) -> Void { }
    /**
     当ScrollView发生拖拽状态的时候调用
     
     - parameter change:
     */
    func scrollViewPanStateDidChange(change:[String:AnyObject]) -> Void {  }
    
    /**
     Tells the view that its superview is about to change to the specified superview.
     The default implementation of this method does nothing. Subclasses can override it to perform additional actions whenever the superview changes.
     
     - parameter newSuperview:
     */
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let superView = newSuperview as? UIScrollView{
         //先移除监听
            self.removeObservers()
            
            //设置宽度
            self.width = superView.width
            self.x = 0
            
            //记录UIScrollView
            self.scrollView = superView
            scrollView?.alwaysBounceVertical = true
            //记录UIScrollView最开始的contentInset
            scrollViewOriginInset = (self.scrollView?.contentInset)!
            
            //添加监听
            self.addObservers()
        }
    }
    
    
    //MARK: - 设置回调对象和回调方法
    
    func setRefreshingTarget(target:AnyObject,action:Selector) -> Void {
        self.refreshTarget = target
        self.refreshAction = action
    }
    
    
    
    //MARK: - 监听
    func addObservers() -> Void {
        let options = NSKeyValueObservingOptions.Old
        self.scrollView?.addObserver(self, forKeyPath: TLRefreshKeyPathContentOffset, options: options, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: TLRefreshKeyPathContentSize, options: options, context: nil)
        
        pan = self.scrollView?.panGestureRecognizer
        
        self.scrollView?.addObserver(self, forKeyPath: TLRefreshKeyPathPanState, options: options, context: nil)
    }
    
    func removeObservers() -> Void {
        scrollView?.removeObserver(self, forKeyPath: TLRefreshKeyPathPanState)
        scrollView?.removeObserver(self, forKeyPath: TLRefreshKeyPathContentSize)
        scrollView?.removeObserver(self, forKeyPath: TLRefreshKeyPathContentOffset)
        pan = nil
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //如果不支持交互，直接返回
        if self.userInteractionEnabled == false{
            return
        }
        
        
        if keyPath == TLRefreshKeyPathContentSize{
            self.scrollViewContentSizeDidChange(change!)
        }
        
        if self.hidden{
            return
        }
        if keyPath == TLRefreshKeyPathContentOffset{
            self.scrollViewContentOffsetDidChange(change!)
        }else if(keyPath == TLRefreshKeyPathContentSize){
            self.scrollViewPanStateDidChange(change!)
        }
        
    }
    
    
    //MARK: - 执行回调函数
    func executeRefreshCallBack() -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            if let handler = self.refreshingHandler{
                handler!()
            }
            
            if let handler = self.refreshBeginedHandler{
                handler!()
            }
            
            if let handler = self.refreshEndHandler{
                handler!()
            }
        }
    }
    
    //MARK: - 设置刷新状态
    /**
     设置刷新状态
     
     - parameter refreshState: 刷新状态
     */
    func setState(refreshState:TLRefreshState) -> Void {
        self.state = refreshState
        
        dispatch_async(dispatch_get_main_queue()) {
           self.setNeedsLayout()
        }
        
      
    }
    
    
}












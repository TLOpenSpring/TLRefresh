//
//  TLBaseRefresh.swift
//  Pods
//
//  Created by Andrew on 16/7/22.
//
//

import UIKit
//import Willow

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
    case idle
    /// 拉取中...
    case pulling
    /// 刷新中
    case refreshing
    /// 即将刷新的状态
    case willRefresh
    /// 没有更多数据的状态
    case noMoreData
    
}
/// 正在刷新的回调
public typealias TLRefreshingHandler = (()->())?
/// 进入刷新状态后的回调
public typealias TLRefreshBeginedCompletionHandler = (()->())?
/// 结束刷新后的回调
public typealias TLRefreshEndCompletionHander = (()->())?


open class TLBaseRefresh: UIView {
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
    
    //MARK: - 自定义属性
    /// 拖拽的百分比
    var pullingPercent:CGFloat = 0 {
        didSet{
            if(isRefreshing() == true){
             return
            }
            if isAutoChangeAlpha == true{
                self.alpha = pullingPercent
            }
        }
    }
    /// 根据拖拽的百分比自动切换透明度
    var isAutoChangeAlpha:Bool = true{
        didSet{
            if(isRefreshing() == true){
                return
            }
            if(isAutoChangeAlpha == true){
                self.alpha = self.pullingPercent
            }else{
                self.alpha = 1
            }
        }
    }
    
    
    //MARK: - 构造方法
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
        self.backgroundColor = UIColor.clear
        
        
//        TLLogUtils.log?.debug("Debug Message")
//        // Option 1
//        TLLogUtils.log?.debug("Debug Message")    // Debug Message
//        TLLogUtils.log?.info("Info Message")      // Info Message
//        TLLogUtils.log?.event("Event Message")    // Event Message
//        TLLogUtils.log?.warn("Warn Message")      // Warn Message
//        TLLogUtils.log?.error("Error Message")    // Error Message
    }
    

    
    
    
    //MARK: - 刷新状态控制
   open func beginRefreshing() -> Void {
        UIView.animate(withDuration: TLRefreshSlowAnimationDuration, animations: { 
            self.alpha = 1
        }) 
    
    self.pullingPercent = 1
        
        if (self.window != nil){
            setState(.refreshing)
        }else{
            if self.state != TLRefreshState.refreshing{
                setState(.willRefresh)
                //重新刷新
                self.setNeedsDisplay()
            }
        }
        
    }
   open func begingRefreshing(_ completionHandler:TLRefreshingHandler?) -> Void {
        self.refreshingHandler = completionHandler
        beginRefreshing()
    }
    
    
    /**
     结束刷新状态
     */
   open func endRefreshing() -> Void
    {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf!.setState(.idle)
        }
    }
    func endRereshing(_ completionHandler:(()->())?) -> Void {
        self.refreshEndHandler = completionHandler
        endRefreshing()
    }
    
    /**
     判断是否正在刷新
     
     - returns:
     */
   open func isRefreshing() -> Bool {
        return self.state == TLRefreshState.refreshing || self.state == TLRefreshState.willRefresh
    }
    
    //MARK: - UIScrollView
    func scrollViewContentOffsetDidChange(_ change:String?) -> Void { }
    /**
     当scrollView的contentSize发生改变的时候调用
     
     - parameter change:
     */
    func scrollViewContentSizeDidChange(_ change:String?) -> Void { }
    /**
     当ScrollView发生拖拽状态的时候调用
     
     - parameter change:
     */
    func scrollViewPanStateDidChange(_ change:String?) -> Void {  }
    
    /**
     Tells the view that its superview is about to change to the specified superview.
     The default implementation of this method does nothing. Subclasses can override it to perform additional actions whenever the superview changes.
     
     - parameter newSuperview:
     */
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
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
    
    func setRefreshingTarget(_ target:AnyObject,action:Selector) -> Void {
        self.refreshTarget = target
        self.refreshAction = action
    }
    
    
    
    //MARK: - 监听
    func addObservers() -> Void {
        let options = NSKeyValueObservingOptions.old
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
    
   
  
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //如果不支持交互，直接返回
        if self.isUserInteractionEnabled == false{
            return
        }
        
        if let changeKindValue = change?[.kindKey] as? UInt, let changeType = NSKeyValueChange(rawValue: changeKindValue) {
            switch changeType {
            case .setting:
                print("Setting")
                break
            case .insertion:
                print("Insertion")
                break
            case .removal:
                print("Removal")
                break
            case .replacement:
                print("Replacement")
                break
            }
        }
    
        
        
        
        
        if keyPath == TLRefreshKeyPathContentSize{
//            self.scrollViewContentSizeDidChange(change as! [String : AnyObject])
            self.scrollViewContentOffsetDidChange(nil)
        }
        
        if self.isHidden{
            return
        }
        if keyPath == TLRefreshKeyPathContentOffset{
            self.scrollViewContentOffsetDidChange(nil)
        }else if(keyPath == TLRefreshKeyPathPanState){
            self.scrollViewPanStateDidChange(nil)
        }
    
    }
    
    
    //MARK: - 执行回调函数
    func executeRefreshCallBack() -> Void {
        DispatchQueue.main.async {
            
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
    func setState(_ refreshState:TLRefreshState) -> Void {
        state = refreshState
        
        DispatchQueue.main.async {
           self.setNeedsLayout()
        }
        
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == TLRefreshState.willRefresh{
           state = TLRefreshState.refreshing
        }
    }
    
    /**
     设置状态文字的颜色
     
     - parameter color: 颜色
     */
    public func setStateLbColor(color:UIColor) -> Void{}
    

}












//
//  TLRefreshBackStateFooter.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

open class TLRefreshBackStateFooter: TLRefreshBackFooter {

    /// 文字距离圈圈、箭头的距离
    var labelLeftInset:CGFloat = 10
  
    var stateTitles:[TLRefreshState:String] = [TLRefreshState:String]()
    
    /// 显示刷新状态的lb
    var stateLb:UILabel!
    
    override func initialization() {
        super.initialization()
        
        stateLb = TLControlUtils.createStateLabel()
        self.addSubview(stateLb)
        
        //初始化文字
        setTitle(TLRefreshBackFooterIdleText, state: TLRefreshState.idle)
        setTitle(TLRefreshBackFooterPullingText, state: TLRefreshState.pulling)
        setTitle(TLRefreshBackFooterRefreshingText, state: TLRefreshState.refreshing)
        setTitle(TLRefreshBackFooterNoMoreDataText, state: TLRefreshState.noMoreData)
        
       
    }
  
    

    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.labelLeftInset = TLRefreshLabelLeftInset
        
        let originX:CGFloat = self.width/2 - kStateLbWidth/2
        let originY:CGFloat = self.height/2 - 20/2
        
        self.stateLb.frame = CGRect(x: originX, y: originY, width: kStateLbWidth, height: 20)
    }
    
    /**
     设置不同刷新状态下的显示文字
     
     - parameter title: 显示的标题
     - parameter state: 刷新状态
     */
    func setTitle(_ title:String?,state:TLRefreshState) -> Void {
        if (title == nil){
            return;
        }
        self.stateTitles[state] = title;
        self.stateLb.text = self.stateTitles[state];
    }
    
    /**
     获取刷新状态下的标题
     
     - parameter state: 刷新状态
     
     - returns: 标题
     */
    func titleForState(_ state:TLRefreshState) -> String {
        return self.stateTitles[state]!;
    }
    
    
    override func setState(_ refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        self.stateLb.text = titleForState(refreshState)
    }
    
    /**
     设置状态文字的颜色
     
     - parameter color:
     */
    open override func setStateLbColor(color:UIColor) -> Void {
        stateLb.textColor = color
    }
    
}













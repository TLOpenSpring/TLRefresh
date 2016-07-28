//
//  TLRefreshBackStateFooter.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

public class TLRefreshBackStateFooter: TLRefreshBackFooter {

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
        setTitle(TLRefreshBackFooterIdleText, state: TLRefreshState.Idle)
        setTitle(TLRefreshBackFooterPullingText, state: TLRefreshState.Pulling)
        setTitle(TLRefreshBackFooterRefreshingText, state: TLRefreshState.Refreshing)
        setTitle(TLRefreshBackFooterNoMoreDataText, state: TLRefreshState.NoMoreData)
        
       
    }
  
    

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.labelLeftInset = TLRefreshLabelLeftInset
        
        let originX:CGFloat = self.width/2 - kStateLbWidth/2
        let originY:CGFloat = self.height/2 - 20/2
        
        self.stateLb.frame = CGRectMake(originX, originY, kStateLbWidth, 20)
    }
    
    /**
     设置不同刷新状态下的显示文字
     
     - parameter title: 显示的标题
     - parameter state: 刷新状态
     */
    func setTitle(title:String?,state:TLRefreshState) -> Void {
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
    func titleForState(state:TLRefreshState) -> String {
        return self.stateTitles[state]!;
    }
    
    
    override func setState(refreshState: TLRefreshState) {
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
    public override func setStateLbColor(color color:UIColor) -> Void {
        stateLb.textColor = color
    }
    
}













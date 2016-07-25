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
        
        stateLb = UILabel()
        stateLb.frame = CGRectMake(0, 0, tl_screen_width, 20)
        stateLb.font = UIFont.systemFontOfSize(16);
        stateLb.textColor = UIColor.redColor()
        stateLb.autoresizingMask = .FlexibleWidth;
        stateLb.textAlignment = .Center;
        stateLb.backgroundColor = UIColor.whiteColor()
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
        super.setState(refreshState)
        self.stateLb.text = titleForState(refreshState)
    }
    
}













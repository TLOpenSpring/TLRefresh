//
//  TLRefreshStateHeader.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

public class TLRefreshStateHeader: TLRefreshHeader {

    /// 显示上次更新时间的label
    var lastUpdateTimeLb:UILabel!
    /// 显示更新状态的label
    var stateLb:UILabel!
    /// 文字距离圈圈、箭头的距离
    var labelLeftInset:CGFloat = 10
    
    var stateTitles:[TLRefreshState:String] = [TLRefreshState:String]()
    
    
    override func initialization() {
        super.initialization()
        
        stateLb = TLControlUtils.createStateLabel()
        stateLb.textAlignment = .Center
        self.addSubview(stateLb)
        
        lastUpdateTimeLb = TLControlUtils.createStateLabel()
        lastUpdateTimeLb.text = "最后更新:"
        lastUpdateTimeLb.textColor = stateLb.textColor
        lastUpdateTimeLb.textAlignment = .Center
        self.addSubview(lastUpdateTimeLb)
        
        self.setTitle(TLRefreshHeaderIdleText, state: TLRefreshState.Idle)
        self.setTitle(TLRefreshHeaderPullingText, state: TLRefreshState.Pulling)
        self.setTitle(TLRefreshHeaderRefreshingText, state: TLRefreshState.Refreshing)
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if self.stateLb.hidden == true{
         return
        }
        
        if self.lastUpdateTimeLb.hidden == true{
           self.stateLb.frame = self.bounds
        }else{
            let originX:CGFloat = self.width/2 - kStateLbWidth/2
            let originY:CGFloat = 10
            var rect = CGRectMake(originX,originY, kStateLbWidth, 20)
            stateLb.frame = rect
            
            
            //设置时间标签的坐标
            rect = CGRectMake(stateLb.x, CGRectGetMaxY(stateLb.frame)+5, stateLb.width, 20)
            lastUpdateTimeLb.frame = rect
         

        }
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
    
    override func setState(refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        
        self.stateLb.text = self.stateTitles[refreshState];
        
        //设置最后的更新时间
        let result = self.getRefreshTime()
        if(result?.dateStr.isEmpty == false){
            self.lastUpdateTimeLb.text = "最后更新:\(result!.dateStr)"
        }
    }
    
    public override func setStateLbColor(color color: UIColor) {
        super.setStateLbColor(color: color)
        
        self.stateLb.textColor = color
        self.lastUpdateTimeLb.textColor = color
    }
    
}

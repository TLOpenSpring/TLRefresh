//
//  TLRefreshNormalFooter.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

public class TLRefreshNormalFooter: TLRefreshBackStateFooter {

    var arrowIv:UIImageView!
    var activityIndicatorView:UIActivityIndicatorView!
    
    override func initialization() {
        super.initialization()
        
        self.backgroundColor = UIColor.blueColor()
        
        let bundlePath = NSBundle.mainBundle().pathForResource("TLRefresh", ofType: "bundle")
        
        let Path = NSBundle.mainBundle().pathForResource("TLRefresh/Classes/TLRefresh", ofType: "bundle")
        
        let image = NSBundle.mainBundle().pathForResource("arrow", ofType: "png")
        let image1 = NSBundle.mainBundle().pathForResource("arrow@2x", ofType: "png")
        
        
        let img = UIImage(named: "arrow")
        arrowIv = UIImageView(image: img)
        arrowIv.image = img
        self.arrowIv.backgroundColor = UIColor.grayColor()
        self.addSubview(arrowIv)
        
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.stopAnimating()
        self.addSubview(activityIndicatorView)
    }



    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var arrowCenterX = self.width * 0.5
        if(self.stateLb.hidden == false){
          arrowCenterX = self.labelLeftInset + self.stateLb.height
        }
        
        let arrowCenterY = self.height * 0.5
        let arrowCenter = CGPointMake(arrowCenterX, arrowCenterY)
        
        //箭头
        if(self.arrowIv.image == nil){
          self.arrowIv.size  = CGSizeMake(30, 80)
        }else{
            self.arrowIv.size = (self.arrowIv.image?.size)!
        }
        self.arrowIv.center = arrowCenter
        //转子
        self.activityIndicatorView.center = arrowCenter
        self.activityIndicatorView.size = CGSizeMake(100, 100)
        self.arrowIv.tintColor = self.stateLb.textColor
        
        
        let originY:CGFloat = self.height/2 - 20/2
        self.stateLb.frame = CGRectMake(CGRectGetMaxX(arrowIv.frame), originY, tl_screen_width-arrowIv.maxX, 20)
    }
    
    /**
     继承父类设置的状态
     
     - parameter refreshState: 刷新的状态
     */
    override func setState(refreshState: TLRefreshState) {
        super.setState(refreshState)
        
        print("refreshState:\(refreshState)")
        
        if refreshState == TLRefreshState.Idle
        {
            self.arrowIv.hidden = true
            self.activityIndicatorView.stopAnimating()
        }else if(refreshState == TLRefreshState.Pulling){
            self.arrowIv.hidden = false
            self.activityIndicatorView.stopAnimating()
        }else if(state == TLRefreshState.Refreshing){
            self.arrowIv.hidden = true
            self.activityIndicatorView.startAnimating()
        }
        else if(state == TLRefreshState.NoMoreData){
            self.arrowIv.hidden = true
            self.activityIndicatorView.stopAnimating()
        }
        
    }
    
    
    
    
    
    
}

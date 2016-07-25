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
        
        let imgBundle = NSBundle(forClass: TLRefreshNormalFooter.self)
        
        
        let myUrl = imgBundle.URLForResource("test", withExtension: "bundle")
        let myBundle = NSBundle(URL: myUrl!)
        let infoImg = UIImage(contentsOfFile: (myBundle!.pathForResource("arrow", ofType: "png"))!)
        
        
        arrowIv = UIImageView(image: infoImg)
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
        self.arrowIv.size = (self.arrowIv.image?.size)!
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
            self.arrowIv.hidden = false
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

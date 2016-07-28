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
    
    
    private var arrowImg:UIImage!
    
    override func initialization() {
        super.initialization()
       
        
        let imgBundle = NSBundle(forClass: TLRefreshNormalFooter.self)
        
        
        let myUrl = imgBundle.URLForResource("Settings", withExtension: "bundle")
        let myBundle = NSBundle(URL: myUrl!)
        let infoImg = UIImage(contentsOfFile: (myBundle!.pathForResource("arrow", ofType: "png"))!)
        
        arrowImg = infoImg!
        
        arrowIv = UIImageView(image: infoImg)
        self.addSubview(arrowIv)
        
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.stopAnimating()
        self.addSubview(activityIndicatorView)
        setState(TLRefreshState.Idle)
    }



    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //箭头
        var arrowOriginX = self.width/2 - arrowImg.size.width/2 - arrowImg.size.width*4-labelLeftInset
        let arrowOriginY = self.height/2 - arrowImg.size.height/2
        self.arrowIv.frame = CGRectMake(arrowOriginX, arrowOriginY, arrowImg.size.width, arrowImg.size.height)
        //转子
        self.activityIndicatorView.center = self.arrowIv.center
        self.activityIndicatorView.size = CGSizeMake(100, 100)
        self.arrowIv.tintColor = self.stateLb.textColor
        
        
        
        let originY:CGFloat = self.height/2 - 20/2
        self.stateLb.frame = CGRectMake(CGRectGetMaxX(arrowIv.frame)+labelLeftInset, originY, tl_screen_width-arrowIv.maxX, 20)
        
     
    }
    
    /**
     继承父类设置的状态
     
     - parameter refreshState: 刷新的状态
     */
    override func setState(refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        
        print("refreshState:\(refreshState)")
        
        if refreshState == TLRefreshState.Idle
        {
            
            if(oldState == TLRefreshState.Refreshing){
                
                self.arrowIv.transform = CGAffineTransformMakeRotation(0.0000001-CGFloat(M_PI))
                UIView.animateWithDuration(TLRefreshSlowAnimationDuration, animations: {
                    self.activityIndicatorView.alpha = 0
                    
                    }, completion: { (finished) in
                        self.activityIndicatorView.alpha = 1
                        self.activityIndicatorView.stopAnimating()
                        self.arrowIv.hidden = false
                })
            }else{
                self.arrowIv.hidden = false
                self.activityIndicatorView.stopAnimating()
                UIView.animateWithDuration(TLRefreshFastAnimationDuration, animations: {
                      self.arrowIv.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
                    }, completion: nil)
            }
            
           
        }else if(refreshState == TLRefreshState.Pulling){
            self.arrowIv.hidden = false
            self.activityIndicatorView.stopAnimating()
            
            UIView.animateWithDuration(TLRefreshFastAnimationDuration, animations: {
                self.arrowIv.transform = CGAffineTransformIdentity
                }, completion: nil)
            
     
            
        }else if(state == TLRefreshState.Refreshing){
            self.arrowIv.hidden = true
            self.activityIndicatorView.startAnimating()
        }
        else if(state == TLRefreshState.NoMoreData){
            self.arrowIv.hidden = true
            self.activityIndicatorView.stopAnimating()
        }
        
    }
    
    public override func setStateLbColor(color color: UIColor) {
        super.setStateLbColor(color: color)
        self.arrowIv.tintColor = color
    }
    
    
    
    
    
}

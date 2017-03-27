//
//  TLRefreshNormalFooter.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import UIKit

open class TLRefreshNormalFooter: TLRefreshBackStateFooter {

    var arrowIv:UIImageView!
    var activityIndicatorView:UIActivityIndicatorView!
    
    
    fileprivate var arrowImg:UIImage!
    
    override func initialization() {
        super.initialization()
       
        
        let imgBundle = Bundle(for: TLRefreshNormalFooter.self)
        let infoImg = TLControlUtils.getArrowImg(imgBundle)
        arrowImg = infoImg!
        
        arrowIv = UIImageView(image: infoImg)
        self.addSubview(arrowIv)
        
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.stopAnimating()
        self.addSubview(activityIndicatorView)
        setState(TLRefreshState.idle)
    }



    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //箭头
        var arrowOriginX = self.stateLb.minX - labelLeftInset
        let arrowOriginY = self.height/2 - arrowImg.size.height/2
        self.arrowIv.frame = CGRect(x: arrowOriginX, y: arrowOriginY, width: arrowImg.size.width, height: arrowImg.size.height)
        //转子
        self.activityIndicatorView.center = self.arrowIv.center
        self.activityIndicatorView.size = CGSize(width: 100, height: 100)
        self.arrowIv.tintColor = self.stateLb.textColor
        
    }
    
    /**
     继承父类设置的状态
     
     - parameter refreshState: 刷新的状态
     */
    override func setState(_ refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        
        
        if refreshState == TLRefreshState.idle
        {
            
            if(oldState == TLRefreshState.refreshing){
                
                self.arrowIv.transform = CGAffineTransform(rotationAngle: 0.0000001-CGFloat(M_PI))
                UIView.animate(withDuration: TLRefreshSlowAnimationDuration, animations: {
                    self.activityIndicatorView.alpha = 0
                    
                    }, completion: { (finished) in
                        self.activityIndicatorView.alpha = 1
                        self.activityIndicatorView.stopAnimating()
                        self.arrowIv.isHidden = false
                })
            }else{
                self.arrowIv.isHidden = false
                self.activityIndicatorView.stopAnimating()
                UIView.animate(withDuration: TLRefreshFastAnimationDuration, animations: {
                      self.arrowIv.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
                    }, completion: nil)
            }
            
           
        }else if(refreshState == TLRefreshState.pulling){
            self.arrowIv.isHidden = false
            self.activityIndicatorView.stopAnimating()
            
            UIView.animate(withDuration: TLRefreshFastAnimationDuration, animations: {
                self.arrowIv.transform = CGAffineTransform.identity
                }, completion: nil)
            
     
            
        }else if(state == TLRefreshState.refreshing){
            self.arrowIv.isHidden = true
            self.activityIndicatorView.startAnimating()
        }
        else if(state == TLRefreshState.noMoreData){
            self.arrowIv.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
        
    }
    
    open override func setStateLbColor(color: UIColor) {
        super.setStateLbColor(color: color)
        self.arrowIv.tintColor = color
    }
    
    
    
    
    
}

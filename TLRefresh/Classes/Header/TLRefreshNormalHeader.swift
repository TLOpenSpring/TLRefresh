//
//  TLRefreshNormalHeader.swift
//  Pods
//
//  Created by Andrew on 16/7/28.
//
//

import UIKit

public class TLRefreshNormalHeader: TLRefreshStateHeader {

    var arrowIv:UIImageView!
    var activityIndicatorView:UIActivityIndicatorView!    
    private var arrowImg:UIImage!
    
    override func initialization() {
        super.initialization()
        
        
        let imgBundle = NSBundle(forClass: TLRefreshNormalHeader.self)
        let infoImg = TLControlUtils.getArrowImg(imgBundle)
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
        var arrowOriginX = self.stateLb.minX - labelLeftInset
        let arrowOriginY = self.height/2 - arrowImg.size.height/2
        self.arrowIv.frame = CGRectMake(arrowOriginX, arrowOriginY, arrowImg.size.width, arrowImg.size.height)
        //转子
        self.activityIndicatorView.center = self.arrowIv.center
        self.activityIndicatorView.size = CGSizeMake(100, 100)
        self.arrowIv.tintColor = self.stateLb.textColor

    }
    
    override func setState(refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        //如果是闲置状态
        switch refreshState {
            
        case TLRefreshState.Idle:
            //如果是从刷新状态变过来的
            if oldState == TLRefreshState.Refreshing{
                self.arrowIv.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(TLRefreshSlowAnimationDuration, animations: {
                    self.activityIndicatorView.alpha = 0
                    }, completion: { (finished) in
                        //如果执行动画时发现当前状态不是闲置状态，则直接返回
                        if self.state != TLRefreshState.Idle{
                            return
                        }
                        
                        self.arrowIv.alpha = 1
                        self.activityIndicatorView.stopAnimating()
                        self.arrowIv.hidden = false
                        
                })
            }else{
                self.arrowIv.hidden = false
                self.activityIndicatorView.stopAnimating()
                
                UIView.animateWithDuration(TLRefreshFastAnimationDuration, animations: {
                    self.arrowIv.transform = CGAffineTransformIdentity
                })
            }
            
        case TLRefreshState.Pulling:
            self.arrowIv.hidden = false
            self.activityIndicatorView.stopAnimating()
            UIView.animateWithDuration(TLRefreshFastAnimationDuration, animations: {
               //进行翻转
                self.arrowIv.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
                }, completion: nil)
            
        case TLRefreshState.Refreshing:
            self.arrowIv.hidden = true
            self.activityIndicatorView.startAnimating()
            self.activityIndicatorView.alpha = 1
            
        default:
            break
        }
       
    }
    
    
    
    /**
     设置状态文字显示的颜色
     
     - parameter color:
     */
    public override func setStateLbColor(color color: UIColor) {
        super.setStateLbColor(color: color)
        self.arrowIv.tintColor = color
    }
    
    
    
    
    
    
    
}

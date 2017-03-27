//
//  TLRefreshNormalHeader.swift
//  Pods
//
//  Created by Andrew on 16/7/28.
//
//

import UIKit

open class TLRefreshNormalHeader: TLRefreshStateHeader {

    var arrowIv:UIImageView!
    var activityIndicatorView:UIActivityIndicatorView!    
    fileprivate var arrowImg:UIImage!
    
    override func initialization() {
        super.initialization()
        
        
        let imgBundle = Bundle(for: TLRefreshNormalHeader.self)
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
        let arrowOriginY = self.height/2 - arrowImg.size.height/4
        self.arrowIv.frame = CGRect(x: arrowOriginX, y: arrowOriginY, width: arrowImg.size.width/2, height: arrowImg.size.height/2)
        //转子
        self.activityIndicatorView.center = self.arrowIv.center
        self.activityIndicatorView.size = CGSize(width: 100, height: 100)
        self.arrowIv.tintColor = self.stateLb.textColor

    }
    
    override func setState(_ refreshState: TLRefreshState) {
        let oldState = self.state;
        if (state == refreshState){
            return;
        }
        super.setState(refreshState)
        //如果是闲置状态
        switch refreshState {
            
        case TLRefreshState.idle:
            //如果是从刷新状态变过来的
            if oldState == TLRefreshState.refreshing{
                self.arrowIv.transform = CGAffineTransform.identity
                
                UIView.animate(withDuration: TLRefreshSlowAnimationDuration, animations: {
                    self.activityIndicatorView.alpha = 0
                    }, completion: { (finished) in
                        //如果执行动画时发现当前状态不是闲置状态，则直接返回
                        if self.state != TLRefreshState.idle{
                            return
                        }
                        
                        self.arrowIv.alpha = 1
                        self.activityIndicatorView.stopAnimating()
                        self.arrowIv.isHidden = false
                        
                })
            }else{
                self.arrowIv.isHidden = false
                self.activityIndicatorView.stopAnimating()
                
                UIView.animate(withDuration: TLRefreshFastAnimationDuration, animations: {
                    self.arrowIv.transform = CGAffineTransform.identity
                })
            }
            
        case TLRefreshState.pulling:
            self.arrowIv.isHidden = false
            self.activityIndicatorView.stopAnimating()
            UIView.animate(withDuration: TLRefreshFastAnimationDuration, animations: {
               //进行翻转
                self.arrowIv.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
                }, completion: nil)
            
        case TLRefreshState.refreshing:
            self.arrowIv.isHidden = true
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
    open override func setStateLbColor(color: UIColor) {
        super.setStateLbColor(color: color)
        self.arrowIv.tintColor = color
    }
    
    
    
    
    
    
    
}

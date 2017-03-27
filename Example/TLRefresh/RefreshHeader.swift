//
//  RefreshHeader.swift
//  TLRefresh
//
//  Created by Andrew on 16/7/28.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class RefreshHeader: UIView {
    
    var titlelb:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect = CGRect(x: 10, y: 5, width: 100, height: 20)
        titlelb = UILabel(frame: rect)
        titlelb.textColor = UIColor.red
        titlelb.font = UIFont.boldSystemFont(ofSize: 18)
        self.addSubview(titlelb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let originX:CGFloat = self.frame.width/2 - 100/2
        let originY:CGFloat = self.frame.height/2 - 20/2
        
        titlelb.frame = CGRect(x: originX, y: originY, width: 100, height: 20)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

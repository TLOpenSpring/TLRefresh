//
//  TLControlUtils.swift
//  Pods
//
//  Created by Andrew on 16/7/28.
//
//

import UIKit

class TLControlUtils: NSObject {
   static let tl_screen_width = UIScreen.mainScreen().bounds.width
   static let tl_screen_height = UIScreen.mainScreen().bounds.height
    
      static func createStateLabel() -> UILabel {
        
        let stateLb = UILabel()
        stateLb.frame = CGRectMake(0, 0, tl_screen_width, 20)
        stateLb.textColor = UIColor(red: 103/255, green: 103/255, blue: 103/255, alpha: 1)
        stateLb.autoresizingMask = .FlexibleWidth;
        stateLb.textAlignment = .Center;
        stateLb.backgroundColor = UIColor.clearColor()
        stateLb.font = UIFont.boldSystemFontOfSize(15)
        
        return stateLb
    }
    
   static func getArrowImg(imgBundle:NSBundle) -> UIImage? {
        let myUrl = imgBundle.URLForResource("Settings", withExtension: "bundle")
        let myBundle = NSBundle(URL: myUrl!)
        let infoImg = UIImage(contentsOfFile: (myBundle!.pathForResource("arrow", ofType: "png"))!)
        
        return infoImg
    }
}

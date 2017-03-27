//
//  TLControlUtils.swift
//  Pods
//
//  Created by Andrew on 16/7/28.
//
//

import UIKit

class TLControlUtils: NSObject {
   static let tl_screen_width = UIScreen.main.bounds.width
   static let tl_screen_height = UIScreen.main.bounds.height
    
      static func createStateLabel() -> UILabel {
        
        let stateLb = UILabel()
        stateLb.frame = CGRect(x: 0, y: 0, width: tl_screen_width, height: 20)
        stateLb.textColor = UIColor(red: 103/255, green: 103/255, blue: 103/255, alpha: 1)
        stateLb.autoresizingMask = .flexibleWidth;
        stateLb.textAlignment = .center;
        stateLb.backgroundColor = UIColor.clear
        stateLb.font = UIFont.boldSystemFont(ofSize: 15)
        
        return stateLb
    }
    
   static func getArrowImg(_ imgBundle:Bundle) -> UIImage? {
//        let myUrl = imgBundle.url(forResource: "Settings", withExtension: "bundle")
//        let myBundle = Bundle(url: myUrl!)
//        let infoImg1 = UIImage(contentsOfFile: (myBundle!.path(forResource: "arrow", ofType: "png"))!)
    
    
    let img = UIImage(named: "arrow")
    
    print("img:\(img)")
    
    
    
    let url = URL(string: "http://7xkxhx.com1.z0.glb.clouddn.com/arrow@2x.png")!
    
    do {
         let data = try? Data(contentsOf: url)
        
        let infoImg = UIImage(data: data!)
        return infoImg
    }
    
    
    
    
    
    
    
        
        return nil
    }
}

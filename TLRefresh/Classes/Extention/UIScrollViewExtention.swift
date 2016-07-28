//
//  UIScrollViewExtention.swift
//  Pods
//
//  Created by Andrew on 16/7/25.
//
//

import Foundation
import UIKit


var TLRefereshHeadKey = "TLRefereshHeadKey"
var TLRefereshFooterKey = "TLRefereshFooterKey"

var TLreloadDataBlockKey = "tl_reloadDataBlockKey"

extension UIScrollView{
    /// 获取总行数
    var tl_totalCount:Int{
        get{
            var count = 0
            if self is UITableView{
                let table = self as! UITableView
                for item in 0..<table.numberOfSections {
                    count += table.numberOfRowsInSection(item)
                }
            }
            
            if self is UICollectionView{
                let collectionView = self as! UICollectionView
                for item in 0..<collectionView.numberOfSections() {
                    count += collectionView.numberOfItemsInSection(item)
                }
            }
            
            return count
        }
    }
    
  
   public var tl_header:TLRefreshHeader?{
        get{
            return (objc_getAssociatedObject(self, &TLRefereshHeadKey) as? TLRefreshHeader)
        }
        set{
            var temp = newValue
            
            if(temp == nil){
                return
            }
            
            self.insertSubview(temp!, atIndex: 0)
            self.willChangeValueForKey("tl_header") //KVO
            objc_setAssociatedObject(self, &TLRefereshHeadKey, temp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("tl_header")
        }
    }
    
   public var tl_footer:TLRefreshFooter?{
        get{
         return objc_getAssociatedObject(self, &TLRefereshFooterKey) as? TLRefreshFooter
        }
        set{
            var temp = newValue
        
            if(temp == nil){
                return
            }
            
            self.insertSubview(newValue!, atIndex: 0)
            self.willChangeValueForKey("tl_footer")
            objc_setAssociatedObject(self, &TLRefereshFooterKey, temp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("tl_footer")
        }
    }
    
    
    
    
    //MARK: -  tl_reloadDataBlock
    

    public var tl_reloadDataBlock:((Int)->())?{
        
        var temp = tl_reloadDataBlock
        if(temp != nil){
            temp!(tl_totalCount)
        }
       return temp
    }
    
    func executeReloaDataBlock() -> Void {
        if let hander = self.tl_reloadDataBlock{
            hander(tl_totalCount)
        }
    }

    
}




extension UIScrollView{

    var tl_insetTop:CGFloat{
        get{
            return self.contentInset.top
        }
        set{
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
    }
    
    var tl_insetBottom:CGFloat{
        get{
        return self.contentInset.bottom
        }
        set{
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
    }
    
    var tl_insetLeft:CGFloat{
        
        get{
         return self.contentInset.left
        }
        set{
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
    }
    
    var tl_insetRight:CGFloat{
        get{
            return self.contentInset.right
        }
        set{
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
    }
    
    var tl_offsetX:CGFloat{
        get{
             return self.contentOffset.x
        }
        set{
            var offset = self.contentOffset;
            offset.x = newValue;
            self.contentOffset = offset;
        }
    }
    var tl_offsetY:CGFloat{
        get{
            return self.contentOffset.y
        }
        set{
            var offset = self.contentOffset;
            offset.y = newValue;
            self.contentOffset = offset;
        }
    }
    
    var tl_contentWidth:CGFloat{
        get{
         return self.contentSize.width
        }
        set{
            var size = self.contentSize;
            size.width = newValue;
            self.contentSize = size;
        }
    }
    var tl_contentHeight:CGFloat{
        get{
            return self.contentSize.height
        }
        set{
            var size = self.contentSize;
            size.height = newValue;
            self.contentSize = size;
        }
    }
}








//
//  Refresh.swift
//  Pods
//
//  Created by Andrew on 16/7/22.
//
//

import UIKit

let tl_screen_width = UIScreen.mainScreen().bounds.width
let tl_screen_height = UIScreen.mainScreen().bounds.height

let TLRefreshLabelLeftInset:CGFloat = 25;
let TLRefreshHeaderHeight:CGFloat = 54.0;
let TLRefreshFooterHeight:CGFloat = 44.0;
let TLRefreshFastAnimationDuration:Double = 0.25;
let TLRefreshSlowAnimationDuration:Double = 0.4;

let TLRefreshKeyPathContentOffset = "contentOffset";
let TLRefreshKeyPathContentInset = "contentInset";
let TLRefreshKeyPathContentSize = "contentSize";
let TLRefreshKeyPathPanState = "state";

let TLRefreshHeaderIdleText = "下拉可以刷新";
let TLRefreshHeaderPullingText = "松开立即刷新";
let TLRefreshHeaderRefreshingText = "正在刷新数据中...";

let TLRefreshAutoFooterIdleText = "点击或上拉加载更多";
let TLRefreshAutoFooterRefreshingText = "正在加载更多的数据...";
let TLRefreshAutoFooterNoMoreDataText = "已经全部加载完毕";

let TLRefreshBackFooterIdleText = "上拉可以加载更多";
let TLRefreshBackFooterPullingText = "松开立即加载更多";
let TLRefreshBackFooterRefreshingText = "正在加载更多的数据...";
let TLRefreshBackFooterNoMoreDataText = "已经全部加载完毕";

let TLRefreshHeaderLastTimeText = "最后更新：";
let TLRefreshHeaderDateTodayText = "今天";
let TLRefreshHeaderNoneLastDateText = "无记录";

public class Refresh: NSObject {
  public static func performBlock(delay:NSTimeInterval,completionHander:()->()) -> Void {
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                    Int64(delay * Double(NSEC_PER_SEC))) // 1
        dispatch_after(popTime, dispatch_get_main_queue(), completionHander);
    }

}


extension UIView{
    
    var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    
    var x:CGFloat{
        
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var size:CGSize{
        get{
         return self.frame.size
        }
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var maxX:CGFloat{
      return CGRectGetMaxX(self.frame)
    }
    
    var minX:CGFloat{
      return CGRectGetMinX(self.frame)
    }
    
    var maxY:CGFloat{
      return CGRectGetMaxY(self.frame)
    }
    
    var minY:CGFloat{
     return CGRectGetMinY(self.frame)
    }
    
    
}










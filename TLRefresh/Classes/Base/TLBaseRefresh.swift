//
//  TLBaseRefresh.swift
//  Pods
//
//  Created by Andrew on 16/7/22.
//
//

import UIKit

enum TLRefreshState {
    /// 闲置状态
    case Idle
    /// 拉取中...
    case Pulling
    /// 刷新中
    case Refreshing
    /// 即将刷新的状态 
    case WillRefresh
    
}

class TLBaseRefresh: NSObject {

}

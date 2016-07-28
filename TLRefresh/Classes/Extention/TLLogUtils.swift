//
//  TLLogUtils.swift
//  Pods
//
//  Created by Andrew on 16/7/28.
//
//

import UIKit
import Willow

class TLLogUtils: NSObject {
    
    
   static var instance:TLLogUtils?
    
    static  var log:Logger?{
      return createLog()
    }
    
   static func shardInstance() -> TLLogUtils {
        if instance == nil{
           instance = TLLogUtils()
        }
        return instance!
    }

   static func createLog() -> Logger
    {
        
        
        let purple = UIColor.purpleColor()
        let blue = UIColor.blueColor()
        let green = UIColor.greenColor()
        let orange = UIColor.orangeColor()
        let red = UIColor.redColor()
        let white = UIColor.whiteColor()
        let black = UIColor.blackColor()
        
        let colorFormatters: [LogLevel: [Formatter]] = [
            LogLevel.Debug: [ColorFormatter(foregroundColor: purple, backgroundColor: nil)],
            LogLevel.Info: [ColorFormatter(foregroundColor: blue, backgroundColor: nil)],
            LogLevel.Event: [ColorFormatter(foregroundColor: green, backgroundColor: nil)],
            LogLevel.Warn: [ColorFormatter(foregroundColor: black, backgroundColor: orange)],
            LogLevel.Error: [ColorFormatter(foregroundColor: white, backgroundColor: red)]
        ]
        
        let configuration = LoggerConfiguration(formatters: colorFormatters)
        let log = Logger(configuration: configuration)
        
        //是否显示日志信息，这是个开关
        log.enabled = false
        
        return log
    }
}

//
//  ViewController.swift
//  TLRefresh
//
//  Created by Andrew on 07/22/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

import UIKit
import TLRefresh

let screen_width = UIScreen.mainScreen().bounds.width
let screen_height = UIScreen.mainScreen().bounds.height

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableview:UITableView!
    var arrayData:Array<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "刷新控件"
        arrayData = ["普通刷新","自定义刷新","gif动画刷新"]
        initView()
    }
    
    func initView() -> Void {
        let rect = CGRectMake(0, 0, screen_width, screen_height-64)
        tableview = UITableView(frame: rect)
        tableview.delegate=self
        tableview.dataSource=self
        self.view.addSubview(tableview)
        
        tableview.tl_footer = TLRefreshNormalFooter(block: {
            
            print("执行了刷新代码")
            
            Refresh.performBlock(3, completionHander: {
                self.tableview.tl_footer?.endRefreshing()
            })
        })
        
    }

    
    //MARK: - UItableivew delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId="cellId"
        var cell = tableview.dequeueReusableCellWithIdentifier(cellId)
        if(cell == nil){
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)

        }
        cell?.textLabel?.text = arrayData[indexPath.row]
        return cell!
    }

}


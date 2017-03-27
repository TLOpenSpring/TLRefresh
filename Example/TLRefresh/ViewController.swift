//
//  ViewController.swift
//  TLRefresh
//
//  Created by Andrew on 07/22/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

import UIKit
import TLRefresh


let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableview:UITableView!
    var arrayData:Array<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "刷新控件"
        arrayData = ["普通刷新",
                     "自定义刷新",
                     "gif动画刷新",
                     "普通刷新",
                     "自定义刷新",
                     "gif动画刷新",
                     "普通刷新",
                     "自定义刷新",
                     "自定义刷新"
                   ]
        initView()
    }
    
    func initView() -> Void {
        let rect = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        tableview = UITableView(frame: rect)
        tableview.delegate=self
        tableview.dataSource=self
        self.view.addSubview(tableview)
        
        tableview.tl_footer = TLRefreshNormalFooter(block: {
            
            Refresh.performBlock(3, completionHander: {
                self.tableview.tl_footer?.endRefreshing()
            })
        })

//      self.tableview.tl_footer?.setStateLbColor(color: UIColor.redColor())
        
        self.tableview.tl_header = TLRefreshNormalHeader(block: {
            Refresh.performBlock(3, completionHander: {
                self.tableview.tl_header?.endRefreshing()
            })
        })
        
    }

    
    //MARK: - UItableivew delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="cellId"
        var cell = tableview.dequeueReusableCell(withIdentifier: cellId)
        if(cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)

        }
        cell?.textLabel?.text = arrayData[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: screen_width, height: 50)
        let view = RefreshHeader(frame: rect)
        view.titlelb.text = "Section\(section)"
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NormalController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


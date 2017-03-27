//
//  NormalController.swift
//  TLRefresh
//
//  Created by Andrew on 2017/3/27.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import TLRefresh

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class NormalController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    var arrayData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
        initData()
    }
    
    func initView() -> Void {
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        tableView = UITableView()
        tableView.frame = rect
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.tl_header = TLRefreshHeader(block: { 
            self.arrayData.removeAll()
            self.initData()
            self.tableView.reloadData()
        })
        
        
        tableView.tl_footer = TLRefreshNormalFooter(block: { 
            self.initData()
            self.tableView.reloadData()
        })
        
        
    }
    
    func initData() -> Void {
      
        for item in 1...10 {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            
            let date = Date()
            let dateStr = formatter.string(from: date)
            arrayData.append(dateStr)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        if arrayData.count > 0 {
            cell?.textLabel?.text = arrayData[indexPath.row]
        }
        
        return cell!
    }

}

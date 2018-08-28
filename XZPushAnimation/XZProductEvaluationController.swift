//
//  XZProductEvaluationController.swift
//  TestPushAnimation
//
//  Created by admin on 2018/8/27.
//  Copyright © 2018年 XZ. All rights reserved.
//  宝贝评价

import UIKit

class XZProductEvaluationController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductEvaluationViewControllerCell")
    }
    
}

extension XZProductEvaluationController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductEvaluationViewControllerCell", for: indexPath)
        
        let redC = CGFloat(arc4random_uniform(256)) / 255.0
        let blueC = CGFloat(arc4random_uniform(256)) / 255.0
        let greenC = CGFloat(arc4random_uniform(256)) / 255.0
        
        cell.backgroundColor = UIColor(red: redC, green: blueC, blue: greenC, alpha: 1.0)
//        cell.textLabel?.text = String.init(format: "第%d行", indexPath.row)
        
        return cell
    }
    
}

//
//  XZShareViewController.swift
//  XZPushAnimation
//
//  Created by admin on 2018/8/24.
//  Copyright © 2018年 XZ. All rights reserved.
//

import UIKit

class XZShareViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        view.backgroundColor = UIColor.clear
    }
    
    @IBAction func dissmissController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

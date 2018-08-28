//
//  XZDetailViewController.swift
//  XZPushAnimation
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 XZ. All rights reserved.
//

import UIKit

class XZDetailViewController: UIViewController {
    /// 底部工具栏
    @IBOutlet weak var bottomToolBar: UIView!
    /// tableView
    @IBOutlet weak var tableView: UITableView!
    // 是否移除子视图
    var hasRemoved = true
    
    var startPoint: CGPoint = CGPoint.zero
    
//    /// 子控制器视图初始frame
//    lazy var originRect: CGRect? = {
//        let height = UIScreen.main.bounds.height -  bottomToolBar.frame.origin.y
//
//        let frameValue = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - height)
//        print("frameValue：",frameValue,"\n")
        
//        return frameValue
//        return tableView.frame
//    }()
    
    private let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    /// 宝贝评价控制器
    private lazy var evalution:XZProductEvaluationController? = {
        let evaluationController = storyBoard.instantiateViewController(withIdentifier: "XZProductEvaluationController") as? XZProductEvaluationController
        // 添加手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        evaluationController?.view.addGestureRecognizer(panGesture)
        
        return evaluationController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailViewController()
    }
    
    /// 左上角返回
    @objc func backAction() {
//        var originRect = self.originRect,
        guard let evalution = self.evalution
        else { return }
        
        if hasRemoved == false {
            UIView.animate(withDuration: 0.25) {
//                originRect.origin.x = evalution.view.bounds.width
//                evalution.view.frame = originRect
                
//                var frameValue = self.tableView.frame
//                frameValue.origin.x = view.frame.width
                evalution.view.frame.origin.x = self.view.frame.width
                
                self.hasRemoved = true
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 手势
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        
        guard let evalution = self.evalution // ,
//            var originRect = originRect
            else {
                return
        }
        
        let currentPoint = sender.location(in: view)
        
        switch sender.state {
        case .began:
            startPoint = currentPoint
        case .changed:
            let dx = currentPoint.x - startPoint.x
            
            if dx > 0 {
//                evalution.view.frame = CGRect(x: dx, y: 0, width: originRect.width, height: originRect.height)
//                evalution.view.frame = CGRect(x: dx, y: tableView.frame.origin.y, width: tableView.frame.width, height: tableView.frame.height)
                evalution.view.frame.origin.x = dx
            } else {
//                originRect.origin.x = 0
//                evalution.view.frame = originRect
//                evalution.view.frame = tableView.frame
                evalution.view.frame.origin.x = 0
                return
            }
        case .ended:
            let dx = currentPoint.x - startPoint.x
            
            if dx > 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    if (dx > 45) { // 超过45就移除子视图
//                        originRect.origin.x = evalution.view.bounds.width
//                        evalution.view.frame = CGRect(x: self.tableView.frame.width, y: self.tableView.frame.origin.y, width: self.tableView.frame.width, height: self.tableView.frame.height)
                        evalution.view.frame.origin.x = self.view.bounds.width
                        self.hasRemoved = true
                    } else {
//                        originRect.origin.x = 0
                        evalution.view.frame.origin.x = 0
                        self.hasRemoved = false
                    }
//                    evalution.view.frame.origin.x = originRect.origin.x
                    
//                    evalution.view.frame = originRect
                }, completion: { (_) in
                    
                })
            }else {
//                originRect.origin.x = 0
//                evalution.view.frame = originRect
//                evalution.view.frame = self.tableView.frame
                
                evalution.view.frame.origin.x = 0
            }
        default:
            break
        }
    }
  
    deinit {
        print("XZDetailViewController --- deinit")
    }
}

// MARK: - UITableViewDataSource/UITableViewDelegate
extension XZDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewControllerCell", for: indexPath)
        
        if indexPath.row == 5 {
            cell.textLabel?.text = String.init(format: "第%d行  分享", indexPath.row)
            cell.backgroundColor = UIColor.green
        }else if indexPath.row == 7 {
           cell.textLabel?.text = String.init(format: "第%d行  查看评价", indexPath.row)
            cell.backgroundColor = UIColor.yellow
        }else {
            cell.textLabel?.text = String.init(format: "第%d行  分享", indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 5 { // "分享"
            
            let shareController = storyBoard.instantiateViewController(withIdentifier: "XZShareViewController")
            
            shareController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            self.present(shareController, animated: true, completion: nil)
        
        }else if indexPath.row == 7 { // "查看评价"
            
            // 将子视图添加到页面
            setupEvalutionView()
            
            // 设置从右向左的动画
            UIView.animate(withDuration: 0.3) {
                self.evalution?.view.frame.origin.x = 0
            }
        }
    }
}

// MARK: - 添加子控制器以及子控制器视图
extension XZDetailViewController {
    
    // 将子视图添加到页面
    func setupEvalutionView() {
        guard let evalution = evalution // ,
//            let originRect = originRect
            else { return }
        
//        evalution.view.frame = originRect
//        evalution.view.frame.origin.x = originRect.width
        
//        var frameValue = self.tableView.frame
//        frameValue.origin.x = self.tableView.frame.width
        
        let xValue = view.frame.width
        let yValue:CGFloat = 0
        let w = view.frame.width
        let h = view.frame.height - bottomToolBar.frame.height
        
        evalution.view.frame = CGRect.init(x: xValue, y: yValue, width: w, height: h)
//            CGRect(x: xValue, y: yValue, width: w, height: h)
//        evalution.view.frame = frameValue
        
        evalution.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) |  UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue)))
        
        view.addSubview(evalution.view)
        addChildViewController(evalution)
        
        hasRemoved = false
    }
    
    /// 设置页面
    func setupDetailViewController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "返回_黑色"), style: .plain, target: self, action: #selector(backAction))
        //
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailViewControllerCell")
    }
    
}

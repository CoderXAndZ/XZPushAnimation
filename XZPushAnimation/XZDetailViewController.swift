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
//    var framePoint: CGPoint = CGPoint.zero
    var originPoint: CGPoint = CGPoint.zero
    
    /// 子控制器视图初始frame
    lazy var originRect: CGRect? = {
        let height = UIScreen.main.bounds.height -  bottomToolBar.frame.origin.y
        
        let frameValue = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - height)
        print("frameValue：",frameValue,"\n")
        return frameValue
    }()
    
    private let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    /// 宝贝评价控制器
    private lazy var evalution:XZProductEvaluationController? = {
        let evaluationController = storyBoard.instantiateViewController(withIdentifier: "XZProductEvaluationController") as? XZProductEvaluationController
        
        return evaluationController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "返回_黑色"), style: .plain, target: self, action: #selector(backAction))
        //
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailViewControllerCell")
    }
    
    /// 左上角返回
    @objc func backAction() {
        
        guard var originRect = self.originRect,
            let evalution = self.evalution
        else { return }
        
        if hasRemoved == false {
            UIView.animate(withDuration: 0.25) {
                originRect.origin.x = evalution.view.bounds.width
                evalution.view.frame = originRect
                
                self.hasRemoved = true
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 手势
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        
        guard let evalution = self.evalution,
            var originRect = originRect
            else {
                return
        }
        
        let currentPoint = sender.location(in: view)
        switch sender.state {
        case .began:
            startPoint = currentPoint // sender.location(in: view)
//            framePoint = evalution.view.frame.origin
            originPoint = sender.location(in: evalution.view)
            
            print("began ===== startPoint:",startPoint,"\n","\n","originPoint:",originPoint,"\n")
        case .changed:
//            let currentPoint = sender.location(in: view)
            let dx = currentPoint.x - startPoint.x
            
            print("changed ==== currentPoint:",currentPoint,"\n","dx:",dx,"\n")
            
            if dx > 0 {
                evalution.view.frame = CGRect(x: (startPoint.x + dx - originPoint.x), y: 0, width: evalution.view.frame.size.width, height: evalution.view.frame.size.height)
            } else  {
                originRect.origin.x = 0
                evalution.view.frame = originRect
                return
            }
        case .ended:
//            let currentPoint = sender.location(in: view)
            let dx = abs(currentPoint.x - startPoint.x)
            print("ended ===== dx：",dx,"\n")
            if dx > 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    if (dx > 45) { // 超过45就移除子视图
                        originRect.origin.x = evalution.view.bounds.width
                        
                        self.hasRemoved = true
                    } else {
                        originRect.origin.x = 0
                        
                        self.hasRemoved = false
                    }
                    evalution.view.frame = originRect
                }, completion: { (_) in
                    
                })
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
        guard let evalution = evalution,
            let originRect = originRect
            else { return }
        
        evalution.view.frame = originRect
        evalution.view.frame.origin.x = originRect.width
        view.addSubview(evalution.view)
        addChildViewController(evalution)
        
        hasRemoved = false
        // 添加手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        evalution.view.addGestureRecognizer(panGesture)
    }
}

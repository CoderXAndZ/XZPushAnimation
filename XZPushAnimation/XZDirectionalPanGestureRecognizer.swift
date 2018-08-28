//
//  XZDirectionalPanGestureRecognizer.swift
//  XZPushAnimation
//
//  Created by admin on 2018/8/28.
//  Copyright © 2018年 XZ. All rights reserved.
//  带方向的滑动手势PanGestureRecognizer

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// 滑动手势的方向
public enum XZPanGestureDirection : Int {
    
    case left

    case right
    
    case up
    
    case down
}

class XZDirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    /// 滑动方向
    open var direction: XZPanGestureDirection?
    /// 是否拖动
    private var dragging = false
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .failed {
            return
        }
        
        let velocity = self.velocity(in: view)
        
        // check direction only on the first move
        if dragging == false && velocity.equalTo(.zero) == false {
            let velocities = [
                                XZPanGestureDirection.right :velocity.x,
                                XZPanGestureDirection.down : velocity.y,
                                XZPanGestureDirection.left : -velocity.x,
                                XZPanGestureDirection.up : -velocity.y
                              ]
            let keysSorted = (velocities as NSDictionary).keysSortedByValue(using: #selector(NSNumber.compare(_:)))
            // Fails the gesture if the highest velocity isn't in the same direction as `direction` property.
            if  (keysSorted.last as! XZPanGestureDirection) != self.direction {
                state = .failed
            }
            
            dragging = true
        }
        
    }
    
    override func reset() {
        super.reset()
        
        dragging = false
    }
}


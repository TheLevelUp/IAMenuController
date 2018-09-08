/*  IAScreenEdgeGestureRecognizer.swift
 *  IAScreenEdgeGestureRecognizer
 *
 *  Created by Taylor Wright-Sanson on 9/7/18.
 *  Created by Mark Adams on 12/16/11.
 *  MIT License
 */

import UIKit.UIGestureRecognizerSubclass

@objc public class IAScreenEdgeGestureRecognizer: UIPanGestureRecognizer {

  override init(target: Any?, action: Selector?) {
    super.init(target: target, action: action)

    cancelsTouchesInView = true
  }

  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    if let touch = touches.first {
      let location = touch.location(in: view)
      if location.x > 50 {
        state = .failed
        return
      }
    }

    super.touchesBegan(touches, with: event)
  }
}

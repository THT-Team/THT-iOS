//
//  UITapGestureRecognizer.swift
//  DSKit
//
//  Created by SeungMin on 4/20/24.
//

import UIKit

extension UITapGestureRecognizer {
  public typealias UITapGestureTargetClosure = (UITapGestureRecognizer) -> ()
  
  private class UITapGestureClosureWrapper: NSObject {
    let closure: UITapGestureTargetClosure
    init(_ closure: @escaping UITapGestureTargetClosure) {
      self.closure = closure
    }
  }
  
  private struct AssociatedKeys {
    static var targetClosure = "targetClosure"
  }
  
  private var targetClosure: UITapGestureTargetClosure? {
    get {
      guard let closureWrapper = objc_getAssociatedObject(
        self, 
        &AssociatedKeys.targetClosure
      ) as? UITapGestureClosureWrapper else { return nil }
      return closureWrapper.closure
      
    } set(newValue) {
      guard let newValue = newValue else { return }
      objc_setAssociatedObject(
        self,
        &AssociatedKeys.targetClosure,
        UITapGestureClosureWrapper(newValue),
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  @objc func closureAction() {
    guard let targetClosure = targetClosure else { return }
    targetClosure(self)
  }
  
  public func addAction(closure: @escaping UITapGestureTargetClosure) {
    targetClosure = closure
    addTarget(self, action: #selector(UITapGestureRecognizer.closureAction))
  }
}

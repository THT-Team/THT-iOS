//
//  TFBaseHostingController.swift
//  DSKit
//
//  Created by SeungMin on 7/31/25.
//

import UIKit
import SwiftUI

public class TFBaseHostingController<Content: SwiftUI.View>: TFBaseViewController {
  
  private let hostingController: SwiftUI.UIHostingController<Content>
  
  public init(rootView: Content) {
    self.hostingController = SwiftUI.UIHostingController(rootView: rootView)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(hostingController)
    view.addSubview(hostingController.view)
    
    hostingController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    hostingController.didMove(toParent: self)
  }
}

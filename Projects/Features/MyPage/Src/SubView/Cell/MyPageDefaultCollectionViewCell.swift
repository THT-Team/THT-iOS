//
//  MyPageDefaultCell.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/14/24.
//

import UIKit

import DSKit

import Then
import SnapKit
import MyPageInterface

final class MyPageDefaultCollectionViewCell: TFBaseCollectionViewCell {

  private(set) lazy var containerView = MyPageCellContainerView(frame: .zero)

  override func makeUI() {
    contentView.addSubview(containerView)

    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageDefaultCellPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let cmp = MyPageDefaultCollectionViewCell()
      return cmp
    }
    .frame(width: 375, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    .previewLayout(.sizeThatFits)
  }
}
#endif

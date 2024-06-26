//
//  MyPageDefaultTableVIewCell.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/14/24.
//

import UIKit

import DSKit

import Then
import SnapKit
import MyPageInterface

final class MyPageDefaultTableViewCell: TFBaseTableViewCell {

  private(set) lazy var containerView = MyPageCellContainerView(frame: .zero)

  override func makeUI() {
    self.selectionStyle = .none
    contentView.addSubview(containerView)
    self.backgroundColor = .clear

    containerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(6)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-6)
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [self] in
      containerView.isSelected = selected
    })
  }
}

enum MyPageDefaultTableVIewCellStyle {
  case alarmCell
  case normal
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageDefaultTableViewCellPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let cmp = MyPageDefaultTableViewCell()
      return cmp
    }
    .frame(width: 375, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    .previewLayout(.sizeThatFits)
  }
}
#endif

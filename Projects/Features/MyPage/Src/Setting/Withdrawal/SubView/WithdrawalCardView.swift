//
//  WithdrawalCardView.swift
//  MyPage
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import DSKit

open class TFCardView: TFBaseView {

  private let imageView = UIImageView().then {
    $0.image = DSKitAsset.Bx.withdraw.image
    $0.contentMode = .scaleAspectFit
  }

  private let titleLabel = UILabel().then {
    $0.font = .thtH4M
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "타이틀아팅틀"
    $0.textAlignment = .center
  }

  private let contentLabel = UILabel().then {
    $0.font = .thtP1R
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.numberOfLines = 0
    $0.text = "컨텐트아팅텐트"
    $0.textAlignment = .center
  }

  open override func makeUI() {
    addSubviews(imageView, titleLabel, contentLabel)

    imageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.centerY.equalToSuperview().offset(-20)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(30)
    }

    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(30)
    }
  }
}
//
//    private lazy var cardView = UIView().then {
//      $0.backgroundColor = DSKitAsset.Color.neutral700.color
//      $0.layer.cornerRadius = 8
//      $0.layer.shadowColor = DSKitAsset.Color.neutral900.color.cgColor
//      $0.layer.shadowOffset = CGSize(width: 0, height: 2)
//      $0.layer.shadowRadius = 4
//      $0.layer.shadowOpacity = 0.1
//    }
//    
//    public override func makeUI() {
//      addSubviews(cardView)
//      
//      cardView.snp.makeConstraints {
//        $0.edges.equalToSuperview()
//      }
//    }
//    
//    public func addCardSubview(_ view: UIView) {
//      cardView.addSubview(view)
//    }
//    
//    public func addCardSubviews(_ views: UIView...) {
//      views.forEach { cardView.addSubview($0) }
//    }
//    
//    public func addCardSubviews(_ views: [UIView]) {
//      views.forEach { cardView.addSubview($0) }
//    }
//    
//    public func addCardSubview(_ view: UIView, closure: (ConstraintMaker) -> Void) {
//      cardView.addSubview(view)
//      view.snp.makeConstraints(closure)
//    }
//    
//    public func addCardSubviews(_ views: UIView..., closure: (ConstraintMaker) -> Void) {
//      views.forEach { cardView.addSubview($0) }
//      views.forEach { $0.snp.makeConstraints(closure) }
//    }
//    
//    public func addCardSubviews(_ views: [UIView], closure: (ConstraintMaker) -> Void) {
//      views.forEach { cardView.addSubview($0) }
//      views.forEach { $0.snp.makeConstraints(closure) }
//    }
//    
//    public func addCardSubview(_ view: UIView, closure: (ConstraintMaker) -> Void, touchUp: @escaping () -> Void) {
//      cardView.addSubview(view)
//      view.snp.makeConstraints(closure)
//      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpAction(_:))))
//    }
//    
//    @objc private func touchUpAction(_ sender: UITapGestureRecognizer) {
//      sender.view.map { $0.alpha = 0.5 }
//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//        sender.view.map { $0.alpha = 1 }
//      }
//    }
//    
//  public func addCardSubviews(_ views: UIView..., closure: (ConstraintMaker) -> Void, touchUp: @escaping () -> Void) {
//    views.forEach { cardView.addSubview($0) }
//  }
//}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFCardViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return TFCardView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif

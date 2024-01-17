//
//  TopicBannerView.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import DSKit
import SnapKit

final class TFTopicBannerView: TFBaseView {
  private var isDrawed = false
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.chatTopicBackground.color
    view.layer.borderWidth = 1
    view.layer.borderColor = DSKitAsset.Color.chatTopicBorder.color.cgColor
    view.clipsToBounds = true
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 23
    return view
  }()
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fill
    stackView.alignment = .center
    return stackView
  }()
  private lazy var titleLabel: TFPaddingLabel = {
    let label = TFPaddingLabel()
    label.layer.borderWidth = 1
    label.layer.borderColor = DSKitAsset.Color.primary500.color.cgColor
    label.textColor = DSKitAsset.Color.primary500.color
    label.font = UIFont.thtSubTitle2Sb
    label.textAlignment = .center
    label.clipsToBounds = true
    label.layer.cornerRadius = 15
    return label
  }()

  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtSubTitle2Sb
    label.numberOfLines = 2
    label.textAlignment = .left
    label.lineBreakMode = .byCharWrapping
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeUI() {

    self.addSubview(containerView)
    containerView.addSubview(stackView)
    stackView.addArrangedSubviews([titleLabel, contentLabel])

    containerView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-20)
    }

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(8)
    }
  }

  override func layoutSubviews() {
    guard !isDrawed else { return }
    containerView.layoutIfNeeded()
    addDownTriangle(targetView: containerView, length: 30)
    isDrawed = true
  }

  func bind(title: String, content: String) {
    titleLabel.text = title
    contentLabel.text = content
  }
  // https://stackoverflow.com/questions/42881069/how-can-i-make-a-triangular-uiview
  func addDownTriangle(targetView: UIView, length: CGFloat) {
    let startPoint = CGPoint(
      x: targetView.frame.width / 2,
      y: targetView.frame.height - 3)

    let path1 = makeReverseArcTrianglePath(startPoint, length: length, radius: 3)
    let path2 = makeReverseArcTrianglePath(
      CGPoint(x: startPoint.x, y: startPoint.y - 4),
      length: length - 2,
      radius: 2)

    let shape = CAShapeLayer()
    shape.path = path1
    shape.fillColor = DSKitAsset.Color.chatTopicBackground.color.cgColor
    shape.strokeColor = DSKitAsset.Color.chatTopicBorder.color.cgColor
    let shape2 = CAShapeLayer()
    shape2.path = path2
    shape2.fillColor = DSKitAsset.Color.chatTopicBackground.color.cgColor

    self.layer.addSublayer(shape)
    self.layer.addSublayer(shape2)
  }

  func makeReverseArcTrianglePath(_ startPoint: CGPoint, length: CGFloat, radius: CGFloat) -> CGPath {
    let delta = length
    let radius = 2.0

    let point1 = CGPoint(
      x: startPoint.x - delta / 2,
      y: startPoint.y)
    let point2 = CGPoint(
      x:point1.x + delta/2,
      y: point1.y + delta/2)
    let point3 = CGPoint(
      x:point1.x + delta,
      y:point1.y)

    let path = CGMutablePath()
    path.move(to: startPoint)
    path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
    path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
    path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
    path.closeSubpath()

    return path
  }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatTopicBannerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {

      let myView = TFTopicBannerView()
      myView.bind(title: "반려동물", content: "띄어쓰기없이쓰면몇글자이락요아임ㄴㅇ럼ㄴㅇ")
      return myView
    }
    .frame(width: UIScreen.main.bounds.width, height: 80)
    .previewLayout(.sizeThatFits)
  }
}
#endif


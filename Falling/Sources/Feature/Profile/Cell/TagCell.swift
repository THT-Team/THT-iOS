//
//  TagCell.swift
//  Falling
//
//  Created by Kanghos on 2023/10/02.
//

import UIKit

import SnapKit

final class TagCollectionViewCell: UICollectionViewCell {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.distribution = .fill
    return stackView
  }()
  private lazy var emojiView: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle1R
    label.text = "🍅"
    label.numberOfLines = 1
    return label
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle1R
    label.textColor = FallingAsset.Color.neutral50.color
    label.text = "칩 텍스트"
    label.textAlignment = .left
    label.numberOfLines = 1
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    setUpView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpView() {
    contentView.backgroundColor = FallingAsset.Color.neutral700.color
    contentView.clipsToBounds = true
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubviews([emojiView, titleLabel])

    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.width.equalTo(40).priority(.low)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-15)
      $0.height.equalTo(40)
    }
    emojiView.snp.makeConstraints {
      $0.size.equalTo(20)
    }
  }
//
  override func layoutSubviews() {
    super.layoutSubviews()
    setUpLayer()
  }

  private func setUpLayer() {
    contentView.layer.cornerRadius = contentView.frame.height / 2
    contentView.layer.masksToBounds = true
  }

  func configure(_ viewModel: TagItemViewModel) {
    self.titleLabel.text = viewModel.title
  }
}

struct TagItemViewModel {
  let emojiCode: String
  let title: String

  var emoji: String {
    return "🍅"
  }
  var emojiImage: UIImage {
    return UIImage(systemName: "xmark")!
  }

  init(_ emojiType: EmojiType) {
    self.title = emojiType.name
    self.emojiCode = emojiType.emojiCode
  }

  init(emojiCode: String, title: String) {
    self.emojiCode = emojiCode
    self.title = title
  }
}
#if DEBUG
import SwiftUI

struct TagCellRepresentable: UIViewRepresentable {
    typealias UIViewType = TagCollectionViewCell

    func makeUIView(context: Context) -> UIViewType {
      return TagCollectionViewCell()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
      uiView.configure(TagItemViewModel(
        emojiCode: "1233",
        title: "산책하기")
      )
    }
}
struct TagCellPreview: PreviewProvider {
    static var previews: some View {
        Group {
            TagCellRepresentable()
                .frame(width: 100, height: 40)
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif

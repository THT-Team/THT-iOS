//
//  MyBubbleCell.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import DSKit

import Kingfisher
import ChatInterface

final class MyChatBubbleCell: TFBaseCollectionViewCell {
  enum State {
    case onlyContent
    case contentWithDate
  }

  private lazy var contentLabel: TFPaddingLabel = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = TFPaddingLabel(padding: padding)
    label.backgroundColor = DSKitAsset.Color.primary500.color
    label.textColor = DSKitAsset.Color.neutral700.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 0
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtCaption2R
    label.textAlignment = .right
    label.isHidden = true
    return label
  }()

  override func makeUI() {
    self.contentView.addSubviews(contentLabel, dateLabel)
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color

    contentLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.trailing.equalToSuperview().offset(-16)

      $0.bottom.equalToSuperview().offset(-13)
    }

    dateLabel.snp.makeConstraints {
      $0.trailing.equalTo(contentLabel.snp.leading).offset(-8)
      $0.height.equalTo(20)
      $0.bottom.equalTo(contentLabel)
    }
  }
  // 경우의 수 2가지
  /*
   3. 메세지 + 날짜
   4. 메세지만
   */
  func bind(_ item: ChatRoom, state: State) {
    self.contentLabel.text = item.currentMessage
    self.dateLabel.text = item.messageTime.toTimeString()
    bind(state)
  }

  private func bind(_ state: State) {
    switch state {
    case .onlyContent:
      self.dateLabel.isHidden = true
    case .contentWithDate:
      self.dateLabel.isHidden = false
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.isHidden = true
    contentLabel.text = nil
    dateLabel.text = nil
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyChatBubbleCellViewPreview: PreviewProvider {

  static let model = ChatRoom(
    chatRoomIndex: 1,
    partnerName: "nickname",
    partnerProfileURL: "",
    currentMessage: "테스트 메세지asdfkljaslk\naasfassdlfjasdlfkjasdflaksfjsdl\nasdf",
    messageTime: Date(),
    isAvailableChat: true
  )
  static var previews: some View {
    Group {
      UIViewPreview {
        let cell = MyChatBubbleCell()
        cell.bind(model, state: .contentWithDate)
        return cell
      }
      .frame(width: UIScreen.main.bounds.width, height: 110)
      UIViewPreview {
        let cell = MyChatBubbleCell()
        cell.bind(model, state: .onlyContent)
        return cell
      }
      .frame(width: UIScreen.main.bounds.width, height: 110)
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif


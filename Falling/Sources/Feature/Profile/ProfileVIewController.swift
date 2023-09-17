//
//  ProfileVIewController.swift
//  Falling
//
//  Created by Kanghos on 2023/09/15.
//

import UIKit

import SnapKit

final class ProfileViewController: TFBaseViewController {

  private lazy var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.5)
    return view
  }()

  private lazy var topicBarView = TFTopicBarView()

  private lazy var profileCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 300)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(cellType: UICollectionViewCell.self)
    collectionView.layer.cornerRadius = 12
    collectionView.clipsToBounds = true
    return collectionView
  }()

  private lazy var nextTimeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("다음에")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = FallingAsset.Color.neutral50.color
    config.baseBackgroundColor = FallingAsset.Color.neutral500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    return stackView
  }()

  private lazy var chatButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("대화히기")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = FallingAsset.Color.neutral700.color
    config.baseBackgroundColor = FallingAsset.Color.primary500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  override func makeUI() {
    self.view.backgroundColor = .black.withAlphaComponent(0.1)
    self.view.isOpaque = false
    [dimmedView, topicBarView, profileCollectionView, stackView].forEach {
      self.view.addSubview($0)
    }

    stackView.addArrangedSubview(nextTimeButton)
    stackView.addArrangedSubview(chatButton)

    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    topicBarView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().offset(100)
    }
    profileCollectionView.snp.makeConstraints {
      $0.top.equalTo(topicBarView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(100)
      $0.leading.trailing.equalTo(topicBarView)
    }

    stackView.snp.makeConstraints {
      $0.centerY.equalTo(profileCollectionView.snp.bottom)
      $0.leading.trailing.equalTo(profileCollectionView).inset(10)
      $0.height.equalTo(46)
    }
  }

  override func bindViewModel() {
    topicBarView.configure(title: "애완동물aa", content: "띄어쓰기 asdfasdfasd\n 띄어쓰기 ")
    topicBarView.closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
  }
  @objc
  private func closeButtonTap(sender: UIButton) {
    self.dismiss(animated: true)
  }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UICollectionViewCell.self)
    cell.backgroundColor = FallingAsset.Color.disabled.color
    return cell
  }
}

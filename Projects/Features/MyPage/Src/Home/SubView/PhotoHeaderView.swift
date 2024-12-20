//
//  PhotoHeaderView.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import UIKit

import DSKit

import Then
import SnapKit

protocol PhotoHeaderViewDelegate: AnyObject {
  func didTapPhotoEditButton(_ index: Int)
  func didTapPhotoAddButton(_ index: Int)
  func didTapNicknameEditButton(_ nickname: String)
}

struct PhotoHeaderModel {
  var dataSource: [PhotoHeaderCellViewModel]
  var nickname: String
}

final class PhotoHeaderView: UICollectionReusableView {
  weak var delegate: PhotoHeaderViewDelegate?

  var model: PhotoHeaderModel?

  var dataSource: [PhotoHeaderCellViewModel] = [
    .init(cellType: .required),
    .init(cellType: .required),
    .init(cellType: .optional)
  ] {
    didSet {
      DispatchQueue.main.async {
        self.photoCollectionView.reloadData()
      }
    }
  }
  
  var photoUpdate: (() -> Void)?

  private(set) lazy var nicknameLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH5Sb
    $0.text = "닉네임"
  }

  private(set) lazy var nicknameEditButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.edit.image, for: .normal)
    $0.addAction(UIAction { [weak self] _ in
      TFLogger.dataLogger.debug("닉네임 수정 버튼 클릭")
      self?.delegate?.didTapNicknameEditButton("닉네임")
    }, for: .touchUpInside)
  }

  private(set) lazy var photoCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: PhotoHeaderViewCollectionViewCell.self)
    collectionView.backgroundColor = DSKitAsset.Color.neutral600.color
    collectionView.isScrollEnabled = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    return collectionView
  }()

  private lazy var descriptionLabel = UILabel().then {
    $0.text = "매력적인 사진으로 무디들에게 나를 어필해보세요. 프로필 완성도가 높아지면 상대방에게 좋아요를 더 많이 받을 수 있어요 🔥"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.numberOfLines = 2
    $0.font = .thtCaption1R
  }

  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    self.addSubview(container)
    container.addSubviews(
      nicknameLabel, nicknameEditButton,
      photoCollectionView,
      descriptionLabel
    )
    container.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().priority(.high)
      $0.leading.trailing.equalToSuperview()
    }
    nicknameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview()
    }

    nicknameEditButton.snp.makeConstraints {
      $0.centerY.equalTo(nicknameLabel)
      $0.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
    }

    photoCollectionView.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(150) .priority(.low)
    }

    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(photoCollectionView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
  func bind(model: PhotoHeaderModel) {
    self.dataSource = model.dataSource
    self.nicknameLabel.text = model.nickname
  }
}

extension PhotoHeaderView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      for: indexPath,
      cellType: PhotoHeaderViewCollectionViewCell.self
    )

    let viewModel: PhotoHeaderCellViewModel

    viewModel = dataSource[indexPath.item]
    cell.bind(viewModel)
    cell.addButtonTap = { [weak self] in
      self?.delegate?.didTapPhotoAddButton(indexPath.item)
    }
    cell.editButtonTap = { [weak self] in
      self?.delegate?.didTapPhotoEditButton(indexPath.item)
    }
    return cell
  }
}

extension PhotoHeaderView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    TFLogger.dataLogger.debug("사진 수정 버튼 클릭")
    delegate?.didTapPhotoEditButton(indexPath.item)
  }
}

extension PhotoHeaderView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let ratio: Double = 106/140
    let width = (collectionView.bounds.width - 40) / 3
    let height = width / ratio
    return CGSize(width: width, height: height)
  }
}

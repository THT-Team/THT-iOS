//
//  ImageTestViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/08/14.
//

import UIKit
import Photos
import PhotosUI

import SnapKit
import RxSwift
import RxCocoa

final class ImageTestViewController: TFBaseViewController {

  private let viewModel: ImageTestViewModel

  private var selectedAssetIdentifiers = [String]()
  private var selection = [String: PHPickerResult]()
  private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
  private var currentAssetIdentifier: String?
  private var imageDataRelay = PublishRelay<Data>()

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 16
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = FallingAsset.Color.primary500.color.cgColor
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var downloadedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 16
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = FallingAsset.Color.primary600.color.cgColor
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  init(viewModel: ImageTestViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func navigationSetting() {
    super.navigationSetting()

    let defaultNavigationSetting = UINavigationBarAppearance()
    defaultNavigationSetting.titlePositionAdjustment.horizontal = -CGFloat.greatestFiniteMagnitude
    defaultNavigationSetting.titleTextAttributes = [.font: UIFont.thtH4Sb, .foregroundColor: FallingAsset.Color.neutral50.color]
    defaultNavigationSetting.backgroundColor = FallingAsset.Color.neutral700.color
    defaultNavigationSetting.shadowColor = nil
    navigationItem.standardAppearance = defaultNavigationSetting
    navigationItem.scrollEdgeAppearance = defaultNavigationSetting

    navigationItem.title = "이미지 테스트"

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoButtonTap))
  }

  private let emptyView = TFEmptyView(
    image: FallingAsset.Bx.noMudy.image,
    title: "진행 중인 대화가 없어요",
    subTitle: "먼저 마음이 잘 맞는 무디들을 찾아볼까요?",
    buttonTitle: "이미지 업로드하기"
  )

  override func makeUI() {
    self.view.addSubview(emptyView)
    self.view.addSubview(imageView)
    self.view.addSubview(downloadedImageView)
    emptyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    imageView.snp.makeConstraints {
      $0.top.leading.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(300)
      $0.width.equalToSuperview().dividedBy(2)
    }
    downloadedImageView.snp.makeConstraints {
      $0.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.equalTo(imageView.snp.trailing)
      $0.width.height.equalTo(imageView)
    }
  }

  override func bindViewModel() {
    let editButtonTap = emptyView.button.rx.tap.asDriver()
    let input = ImageTestViewModel.Input(
      editButtonTap: editButtonTap,
      imageData: self.imageDataRelay.asDriver(onErrorDriveWith: .empty())
    )
    emptyView.isHidden = false

    let output = viewModel.transform(input: input)
    output.downloadURL
      .debug("download URL")
      .drive(onNext: { [weak self] downloadURL in
        self?.downloadedImageView.setResource(downloadURL)
      })
      .disposed(by: disposeBag)
  }

  deinit {
    print("[Deinit]: \(self)")
  }
}

extension ImageTestViewController: PHPickerViewControllerDelegate {

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true)
    let existingSelection = self.selection
    var newSelection = [String: PHPickerResult]()
    for result in results {
      let identifier = result.assetIdentifier!
      newSelection[identifier] = existingSelection[identifier] ?? result
    }

    // Track the selection in case the user deselects it later.
    selection = newSelection
    selectedAssetIdentifiers = results.map(\.assetIdentifier!)
    selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()

    if selection.isEmpty {

    } else {
      displayNext()
    }
  }

  func displayNext() {
    guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
    currentAssetIdentifier = assetIdentifier

    let progress: Progress?
    let itemProvider = selection[assetIdentifier]!.itemProvider
    if itemProvider.canLoadObject(ofClass: UIImage.self) {
      progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
        DispatchQueue.main.async {
          self?.handleCompletion(assetIdentifier: assetIdentifier, object: image, error: error)
        }
      }
    } else {
      progress = nil
    }
  }
  func handleCompletion(assetIdentifier: String, object: Any?, error: Error? = nil) {
    guard currentAssetIdentifier == assetIdentifier else { return }
    if let image = object as? UIImage {
      displayImage(image)
      self.imageDataRelay.accept(image.compressToData()!)
    }
  }

  func displayImage(_ image: UIImage?) {
    self.imageView.image = image
  }

  @objc
  func addPhotoButtonTap() {
    presentPicker(filter: .images)
  }

  private func presentPicker(filter: PHPickerFilter? = .images) {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())

    // Set the filter type according to the user’s selection.
    configuration.filter = filter
    // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
    configuration.preferredAssetRepresentationMode = .current
    // Set the selection behavior to respect the user’s selection order.
    configuration.selection = .ordered
    // Set the selection limit to enable multiselection.
    configuration.selectionLimit = 0
    // Set the preselected asset identifiers with the identifiers that the app tracks.
    configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    present(picker, animated: true)
  }
}

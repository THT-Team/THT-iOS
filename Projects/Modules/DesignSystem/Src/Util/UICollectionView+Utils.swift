//
//  UICollectionView+Utils.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

extension UICollectionViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}

public extension UICollectionView {

  func register<T: UICollectionViewCell>(cellType: T.Type) {
    self.register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  func register<T: UICollectionReusableView>(viewType: T.Type, kind: String) {
    self.register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable cell")
    }
    return cell
  }
  func dequeueReusableView<T: UICollectionReusableView>(for indexPath: IndexPath, ofKind elementKind: String, viewType: T.Type = T.self) -> T {
    guard let reusableView = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable view")
    }
    return reusableView
  }
}

extension Reactive where Base: UICollectionView {
  public func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
  (cellType: Cell.Type = Cell.self)
  -> (_ source: Source)
  -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
  -> Disposable where Source.Element == Sequence {
    return self.items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
  }
}

import UIKit
import ObjectiveC

private enum CVBlurAssoc {
    static var overlay = "cv.blur.overlay"
    static var isBusy  = "cv.blur.isBusy"
}

public extension UICollectionView {
    private var _blurOverlay: UIImageView? {
        get { objc_getAssociatedObject(self, &CVBlurAssoc.overlay) as? UIImageView }
        set { objc_setAssociatedObject(self, &CVBlurAssoc.overlay, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    private var _isBlurring: Bool {
        get { (objc_getAssociatedObject(self, &CVBlurAssoc.isBusy) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &CVBlurAssoc.isBusy, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 컬렉션뷰 위에 스냅샷 블러 표시
    /// - Parameters:
    ///   - radius: 블러 반경(포인트). 내부에서 @2x/@3x 보정
    ///   - downsample: 스냅샷 해상도 배율(0.25~1.0). 낮출수록 빠름
    ///   - animate: 페이드 시간
    func showSnapshotBlur(radius: CGFloat = 12,
                          downsample: CGFloat = 0.5,
                          animate: TimeInterval = 0.2) {
        guard !_isBlurring else { return }
        _isBlurring = true

        // 오버레이 준비
        let overlay = _blurOverlay ?? {
            let v = UIImageView(frame: bounds)
            v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            v.contentMode = .scaleToFill
            v.isUserInteractionEnabled = false
            addSubview(v)
            _blurOverlay = v
            return v
        }()

        // 스냅샷에서 오버레이가 찍히지 않도록 잠시 숨김
        let prevHidden = overlay.isHidden
        overlay.isHidden = true

        // 다운샘플 스냅샷 캡처
        let fmt = UIGraphicsImageRendererFormat()
        fmt.opaque = true
        let clamped = max(0.1, min(downsample, 1.0))
        fmt.scale = UIScreen.main.scale * clamped

        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: fmt)
        let snapshot = renderer.image { _ in
            // drawHierarchy가 시각적으로 더 자연스러운 경우가 많음
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }

        // 블러는 백그라운드에서, 적용은 메인에서
        DispatchQueue.global(qos: .userInitiated).async {
            let blurred = snapshot.gaussianBlurred(radius: radius)
            DispatchQueue.main.async {
                overlay.image = blurred
                overlay.alpha = 0
                overlay.isHidden = false
                UIView.animate(withDuration: animate) { overlay.alpha = 1 }
                self._isBlurring = false
            }
        }

        // 원상복귀 (스냅샷 이미 캡처됨)
        overlay.isHidden = prevHidden
    }

    /// 블러 오버레이 제거
    func hideSnapshotBlur(animate: TimeInterval = 0.15) {
        guard let overlay = _blurOverlay else { return }
        UIView.animate(withDuration: animate, animations: {
            overlay.alpha = 0
        }, completion: { _ in
            overlay.removeFromSuperview()
            self._blurOverlay = nil
        })
    }

    /// 스크롤 정지 시 새로운 프레임으로 블러 갱신 (옵션)
    func refreshSnapshotBlurIfNeeded(radius: CGFloat = 12, downsample: CGFloat = 0.5) {
        guard _blurOverlay != nil else { return }
        showSnapshotBlur(radius: radius, downsample: downsample, animate: 0.0) // 부드럽게 교체하고 싶으면 0.1~0.2
    }
}

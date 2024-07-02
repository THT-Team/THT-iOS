//
//  ImageView+Util.swift
//  DSKit
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit
import Kingfisher

extension UIImageView {
  public func setImage(urlString: String, downsample: CGFloat = 50) {
    let url = URL(string: urlString)
    #if DEBUG
    self.image = DSKitAsset.Image.Test.test1.image
    #else
    setImage(url: url, downsample: downsample)
    #endif
  }

  public func setImage(url: URL?, downsample: CGFloat) {
    let processor = DownsamplingImageProcessor(size: CGSize(width: downsample, height: downsample))
                 |> RoundCornerImageProcessor(cornerRadius: 12)
    self.kf.indicatorType = .activity
    self.kf.setImage(
        with: url,
        placeholder: nil,
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ])
    {
        result in
        switch result {
        case .success: break
        case .failure(let error):
            print("Job failed: \(error.localizedDescription)")
        }
    }
  }

}

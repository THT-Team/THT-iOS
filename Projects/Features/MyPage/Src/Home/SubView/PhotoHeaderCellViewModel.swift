//
//  PhotoHeaderCellViewModel.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import Foundation

struct PhotoHeaderCellViewModel {
  enum CellType {
    case required
    case optional
  }
  var url: URL?
  let cellType: CellType
}

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
  var data: Data?
  let cellType: CellType
}

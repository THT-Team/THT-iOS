//
//  PhotoCellViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

struct PhotoCellViewModel {
  enum CellType {
    case required
    case optional
  }

  let id = UUID()
  var data: Data?
  let cellType: CellType
}

extension PhotoCellViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

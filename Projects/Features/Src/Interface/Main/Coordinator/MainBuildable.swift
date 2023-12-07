//
//  MainBuildable.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation
import Core

protocol MainBuildable {
  func build(rootViewControllable: ViewControllable) -> MainCoordinating
}

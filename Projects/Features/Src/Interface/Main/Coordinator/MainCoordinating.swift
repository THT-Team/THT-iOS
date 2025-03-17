//
//  MainCoordinating.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol MainCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }
}

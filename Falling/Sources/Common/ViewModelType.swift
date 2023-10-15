//
//  ViewModelType.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/29.
//

import Foundation

import RxSwift

protocol ViewModelType {
	associatedtype Input
	associatedtype Output
	
	func transform(input: Input) -> Output
}

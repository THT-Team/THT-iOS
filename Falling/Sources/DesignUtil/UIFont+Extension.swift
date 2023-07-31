//
//  UIFont+Extension.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/17.
//

import UIKit

extension UIFont {
	private enum FontStr: String {
		/// weight 400
		case regular = "Pretendard-Regular"
		/// weight 500
		case medium = "Pretendard-Medium"
		/// weight 600
		case semiBold = "Pretendard-SemiBold"
		/// weight 700
		case bold = "Pretendard-Bold"
		/// weight 800
		case extraBold = "Pretendard-ExtraBold"
	}
}

extension UIFont {
	// MARK: - Heading
	static let thtH1R = UIFont(name: FontStr.regular.rawValue, size: 30)
	static let thtH1M = UIFont(name: FontStr.medium.rawValue, size: 30)
	static let thtH1Sb = UIFont(name: FontStr.semiBold.rawValue, size: 30)
	static let thtH1B = UIFont(name: FontStr.bold.rawValue, size: 30)
	static let thtH1Eb = UIFont(name: FontStr.extraBold.rawValue, size: 30)
	
	static let thtH2R = UIFont(name: FontStr.regular.rawValue, size: 26)
	static let thtH2M = UIFont(name: FontStr.medium.rawValue, size: 26)
	static let thtH2Sb = UIFont(name: FontStr.semiBold.rawValue, size: 26)
	static let thtH2B = UIFont(name: FontStr.bold.rawValue, size: 26)
	static let thtH2Eb = UIFont(name: FontStr.extraBold.rawValue, size: 26)
	
	static let thtH3R = UIFont(name: FontStr.regular.rawValue, size: 24)
	static let thtH3M = UIFont(name: FontStr.medium.rawValue, size: 24)
	static let thtH3Sb = UIFont(name: FontStr.semiBold.rawValue, size: 24)
	static let thtH3B = UIFont(name: FontStr.bold.rawValue, size: 24)
	static let thtH3Eb = UIFont(name: FontStr.extraBold.rawValue, size: 24)
	
	static let thtH4R = UIFont(name: FontStr.regular.rawValue, size: 19)
	static let thtH4M = UIFont(name: FontStr.medium.rawValue, size: 19)
	static let thtH4Sb = UIFont(name: FontStr.semiBold.rawValue, size: 19)
	static let thtH4B = UIFont(name: FontStr.bold.rawValue, size: 19)
	static let thtH4Eb = UIFont(name: FontStr.extraBold.rawValue, size: 19)
	
	static let thtH5R = UIFont(name: FontStr.regular.rawValue, size: 17)
	static let thtH5M = UIFont(name: FontStr.medium.rawValue, size: 17)
	static let thtH5Sb = UIFont(name: FontStr.semiBold.rawValue, size: 17)
	static let thtH5B = UIFont(name: FontStr.bold.rawValue, size: 17)
	static let thtH5Eb = UIFont(name: FontStr.extraBold.rawValue, size: 17)
	
	// MARK: - SubTitle
	static let thtSubTitle1R = UIFont(name: FontStr.regular.rawValue, size: 16)
	static let thtSubTitle1M = UIFont(name: FontStr.medium.rawValue, size: 16)
	static let thtSubTitle1Sb = UIFont(name: FontStr.semiBold.rawValue, size: 16)
	static let thtSubTitle1B = UIFont(name: FontStr.bold.rawValue, size: 16)
	
	static let thtSubTitle2R = UIFont(name: FontStr.regular.rawValue, size: 15)
	static let thtSubTitle2M = UIFont(name: FontStr.medium.rawValue, size: 15)
	static let thtSubTitle2Sb = UIFont(name: FontStr.semiBold.rawValue, size: 15)
	static let thtSubTitle2B = UIFont(name: FontStr.bold.rawValue, size: 15)
	
	// MARK: - P
	static let thtP1R = UIFont(name: FontStr.regular.rawValue, size: 14)
	static let thtP1M = UIFont(name: FontStr.medium.rawValue, size: 14)
	static let thtP1Sb = UIFont(name: FontStr.semiBold.rawValue, size: 14)
	static let thtP1B = UIFont(name: FontStr.bold.rawValue, size: 14)
	
	static let thtP2R = UIFont(name: FontStr.regular.rawValue, size: 12)
	static let thtP2M = UIFont(name: FontStr.medium.rawValue, size: 12)
	static let thtP2Sb = UIFont(name: FontStr.semiBold.rawValue, size: 12)
	static let thtP2B = UIFont(name: FontStr.bold.rawValue, size: 12)
	
	// MARK: - Caption
	static let thtCaption1R = UIFont(name: FontStr.regular.rawValue, size: 11)
	static let thtCaption1M = UIFont(name: FontStr.medium.rawValue, size: 11)
	static let thtCaption1Sb = UIFont(name: FontStr.semiBold.rawValue, size: 11)
	static let thtCaption1B = UIFont(name: FontStr.bold.rawValue, size: 11)
	
	static let thtCaption2R = UIFont(name: FontStr.regular.rawValue, size: 10)
	static let thtCaption2M = UIFont(name: FontStr.medium.rawValue, size: 10)
	static let thtCaption2Sb = UIFont(name: FontStr.semiBold.rawValue, size: 10)
	static let thtCaption2B = UIFont(name: FontStr.bold.rawValue, size: 10)
	
	// MARK: - Exception
	static let thtEx1 = UIFont(name: FontStr.semiBold.rawValue, size: 13)
	
	static let thtEx4R = UIFont(name: FontStr.regular.rawValue, size: 22)
	static let thtEx4M = UIFont(name: FontStr.medium.rawValue, size: 22)
	static let thtEx4Sb = UIFont(name: FontStr.semiBold.rawValue, size: 22)
	static let thtEx4B = UIFont(name: FontStr.bold.rawValue, size: 22)
	static let thtEx4Eb = UIFont(name: FontStr.extraBold.rawValue, size: 22)
}

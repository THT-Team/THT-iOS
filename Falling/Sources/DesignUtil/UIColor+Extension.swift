//
//  UIColor+Extension.swift
//  Falling
//
//  Created by Kanghos on 2023/07/18.
//

import UIKit

extension UIColor {
    private enum ColorName: String {
        case Disabled
        case Error
        case Event

        case Netural50
        case Netural300
        case Netural400
        case Netural500
        case Netural600
        case Netural700
        case Netural900

        case Payment

        case Primary300
        case Primary400
        case Primary500
        case Primary600
    }
}

extension UIColor {
    static let disabled = UIColor(named: ColorName.Disabled.rawValue)!
    static let error = UIColor(named: ColorName.Error.rawValue)!
    static let event = UIColor(named: ColorName.Event.rawValue)!

    static let netural50 = UIColor(named: ColorName.Netural50.rawValue)!
    static let netural300 = UIColor(named: ColorName.Netural300.rawValue)!
    static let netural400 = UIColor(named: ColorName.Netural400.rawValue)!
    static let netural500 = UIColor(named: ColorName.Netural500.rawValue)!
    static let netural600 = UIColor(named: ColorName.Netural600.rawValue)!
    static let netural700 = UIColor(named: ColorName.Netural700.rawValue)!
    static let netural900 = UIColor(named: ColorName.Netural900.rawValue)!

    static let payment = UIColor(named: ColorName.Payment.rawValue)!

    static let primary300 = UIColor(named: ColorName.Primary300.rawValue)!
    static let primary400 = UIColor(named: ColorName.Primary400.rawValue)!
    static let primary500 = UIColor(named: ColorName.Primary500.rawValue)!
    static let primary600 = UIColor(named: ColorName.Primary600.rawValue)!
}

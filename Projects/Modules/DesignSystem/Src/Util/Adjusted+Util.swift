//
//  Float.swift
//  DSKit
//
//  Created by Kanghos on 7/22/24.
//

import UIKit
import Core

public extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 390
        return self * ratio
    }

    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 844
        return self * ratio
    }
}

public extension Double {
    var adjusted: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 390)
        return self * ratio
    }

    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 844)
        return self * ratio
    }
}

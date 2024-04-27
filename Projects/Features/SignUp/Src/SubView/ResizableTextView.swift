//
//  ResizableTextView.swift
//  SignUp
//
//  Created by kangho lee on 4/27/24.
//

import UIKit

public class ResizableTextView: UITextView {
    let minimumHeight: CGFloat = 40
    let maximumHeight: CGFloat = 120
    
    public override var intrinsicContentSize: CGSize {
        var newSize = super.intrinsicContentSize
        newSize.height = min(maximumHeight, max(minimumHeight, newSize.height))
        self.isScrollEnabled = newSize.height == maximumHeight
        return newSize
    }
}

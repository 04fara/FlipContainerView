//
//  RoundView.swift
//  FlipContainerView
//
//  Created by Farid Kopzhassarov on 21/01/2022.
//

import UIKit

class RoundView: UIView {
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext(),
            roundedRectPath: UIBezierPath = .init(roundedRect: rect, cornerRadius: layer.cornerRadius)
        ctx?.addPath(roundedRectPath.cgPath)
        roundedRectPath.addClip()
        tintColor.setFill()
        roundedRectPath.fill()
        ctx?.fillPath()
    }
}

//
//  GradientDimView.swift
//  FlipContainerView
//
//  Created by Farid Kopzhassarov on 21/01/2022.
//

import UIKit

class GradientDimView: UIView {
    var colors: [UIColor]! {
        didSet {
            let layer = layer as! CAGradientLayer
            if let colors = colors {
                print(colors.map { $0.cgColor })
                layer.colors = colors.map { $0.cgColor }
            } else {
                layer.colors = nil
            }
        }
    }

    var locations: NSNumber? {
        didSet {
            let layer = layer as! CAGradientLayer
            if let locations = locations {
                layer.locations = [locations]
            } else {
                layer.locations = nil
            }
        }
    }

    var startPoint: CGPoint! {
        didSet {
            if let startPoint = startPoint {
                let layer = layer as! CAGradientLayer
                layer.startPoint = startPoint
            }
        }
    }

    var endPoint: CGPoint! {
        didSet {
            if let endPoint = endPoint {
                let layer = layer as! CAGradientLayer
                layer.endPoint = endPoint
            }
        }
    }

    var isReversed: Bool = false {
        didSet {
            if isReversed != oldValue {
                reverse()
            }
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    init(colors: [UIColor] = [.clear, .black], locations: NSNumber? = 0, startPoint: CGPoint = .init(x: 0, y: 0.5), endPoint: CGPoint = .init(x: 1, y: 0.5)) {
        super.init(frame: .zero)

        defer {
            self.colors = colors
            self.locations = locations
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func reverse() {
        swap(&startPoint, &endPoint)
    }
}

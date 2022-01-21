//
//  FlipContainerVC.swift
//  FlipContainerView
//
//  Created by Farid Kopzhassarov on 21/01/2022.
//

import UIKit

private func CATransform3DRotateAndPerspective(_ perspective: CGFloat, _ angle: CGFloat, _ x: CGFloat, _ y: CGFloat, _ z: CGFloat) -> CATransform3D {
    var _perspective = CATransform3DIdentity
    _perspective.m34 = perspective

    return CATransform3DRotate(_perspective, angle, x, y, z)
}

// MARK: TODO make view rotate with respect to acceleration
// MARK: TODO come up with better naming for properties
class FlipContainerVC<Front: UIViewController, Back: UIViewController>: UIViewController {
    // MARK: store enum here or in separate class?
    enum FlipContainerState {
        case front
        case back
    }

    private(set) var state: FlipContainerState
    private let frontVC: Front
    private let backVC: Back
    var frontView: UIView { return frontVC.view }
    var backView: UIView { return backVC.view }

    private let containerView: UIView = {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let dimView: GradientDimView = {
        let view: GradientDimView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0

        return view
    }()

    var cornerRadius: CGFloat {
        get {
            return frontVC.view.layer.cornerRadius
        }

        set {
            frontVC.view.layer.cornerRadius = newValue
            backVC.view.layer.cornerRadius = newValue
        }
    }

    var flipsInfinitely: Bool
    var sensitivity: CGFloat

    private let timingParameters: UISpringTimingParameters = .init(dampingRatio: 0.25, initialVelocity: .zero)
    private var flipAnimator: UIViewPropertyAnimator
    private var tempAnimator: UIViewPropertyAnimator? // needed in case of changing animation duration mid animator's running

    var animationDuration: CGFloat {
        get {
            return flipAnimator.duration
        }

        set {
            let newAnimator: UIViewPropertyAnimator = .init(duration: newValue, timingParameters: timingParameters)
            if flipAnimator.isRunning {
                tempAnimator = newAnimator
            } else {
                flipAnimator = newAnimator
            }
        }
    }

    init(frontVC: Front, backVC: Back, flipsInfinitely: Bool = false) {
        self.state = .front
        self.frontVC = frontVC
        self.backVC = backVC
        self.flipsInfinitely = flipsInfinitely
        self.sensitivity = 2
        self.flipAnimator = .init(duration: 1, timingParameters: timingParameters)

        super.init(nibName: nil, bundle: nil)

        self.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(frontVC)
        addChild(backVC)
        view.addSubview(containerView)
        containerView.addSubview(frontVC.view)
        containerView.addSubview(backVC.view)
        containerView.addSubview(dimView)
        frontVC.didMove(toParent: self)
        backVC.didMove(toParent: self)

        frontView.isHidden = false
        backView.isHidden = true

        // MARK: FIXME should gestureRecognizers be stored as properties?
        let panRecognizer: UIPanGestureRecognizer = .init(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panRecognizer)
    }

    override func viewWillLayoutSubviews() {
        frontVC.view.translatesAutoresizingMaskIntoConstraints = false
        backVC.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            frontVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            frontVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            frontVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            frontVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            backVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            backVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            dimView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    // MARK: - target-action selectors
    // extensions of generic classes can't contain @objc members
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let from: UIView,
            to: UIView,
            toState: FlipContainerState
        switch state {
        case .front:
            from = frontView
            to = backView
            toState = .back
        case .back:
            from = backView
            to = frontView
            toState = .front
        }

        let distance90Degree = view.frame.width / sensitivity // flip sensitivity, i.e. pan distance to make single 90 degree flip
        var translation = sender.translation(in: view)
        var x = translation.x

        // normalize translation on x axis
        if !flipsInfinitely {
            if x.magnitude > 2 * distance90Degree {
                translation.x = (2 * distance90Degree + pow(x.magnitude - 2 * distance90Degree, 0.75)) * (x > 0 ? 1 : -1) // log10
                x = translation.x
            }
        } else if x.magnitude > 4 * distance90Degree {
            translation.x = x.remainder(dividingBy: 4 * distance90Degree)
        }

        switch sender.state {
        case .began:
            if flipAnimator.isRunning {
                flipAnimator.stopAnimation(false)
                flipAnimator.finishAnimation(at: .current)
                let rotationAngle = atan2(containerView.transform3D.m31, containerView.transform3D.m11)
                translation.x = (rotationAngle / (.pi / 2)) * distance90Degree
                sender.setTranslation(translation, in: view)
                dimView.alpha = translation.x.magnitude / distance90Degree
            }
        case .changed:
            let rotations = Int(x.magnitude / distance90Degree)
            if rotations == 0 || rotations == 3 {
                from.isHidden = false
                to.isHidden = true
                from.addSubview(dimView)
            } else if rotations == 1 || rotations == 2 {
                from.isHidden = true
                to.isHidden = false
                to.addSubview(dimView)
            }
            let xRemainder = x.remainder(dividingBy: 2 * distance90Degree)
            let transform = CATransform3DRotateAndPerspective(-1 / 2000, (xRemainder / distance90Degree) * .pi / 2, 0, 1, 0)
            containerView.transform3D = transform
            dimView.isReversed = xRemainder < 0
            dimView.alpha = xRemainder.magnitude / distance90Degree
        case .cancelled:
            fallthrough
        case .ended:
            fallthrough
        default:
            state = from.isHidden ? toState : state

            let displayLink: CADisplayLink = .init(target: self, selector: #selector(updateDimView))
            displayLink.add(to: .main, forMode: .default)

            flipAnimator.addAnimations { [weak self] in
                self?.containerView.transform3D = CATransform3DRotateAndPerspective(-1 / 2000, 0, 0, 1, 0)
            }
            flipAnimator.addCompletion { [weak self] _ in
                if let newAnimator = self?.tempAnimator {
                    self?.flipAnimator = newAnimator
                    self?.tempAnimator = nil
                }
                displayLink.invalidate()
            }
            flipAnimator.startAnimation()
        }
    }

    @objc func updateDimView() {
        guard let presentation = containerView.layer.presentation() else { return }

        let distance90Degree = view.frame.width / sensitivity
        let rotationAngle = atan2(presentation.transform.m31, presentation.transform.m11)
        dimView.isReversed = rotationAngle < 0
        dimView.alpha = ((rotationAngle / (.pi / 2)) * distance90Degree).magnitude / distance90Degree
    }
}

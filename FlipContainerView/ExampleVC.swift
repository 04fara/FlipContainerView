//
//  ExampleVC.swift
//  FlipContainerView
//
//  Created by Farid Kopzhassarov on 21/01/2022.
//

import UIKit

class ExampleVC: UIViewController {
    private var flipContainerVC: FlipContainerVC<UIViewController, UIViewController>!

    // flipContainer's configuration controls
    private var flipsInfinitelyLabel: UILabel!
    private var flipsInfinitelySwitch: UISwitch!

    private var sensitivityLabel: UILabel!
    private var sensitivityValueLabel: UILabel!
    private var sensitivitySlider: UISlider!

    private var animationDurationLabel: UILabel!
    private var animationDurationValueLabel: UILabel!
    private var animationDurationSlider: UISlider!

    // MARK: TODO spring parameters sliders
    // MARK: TODO perspective slider ?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // MARK: - begin frontVC and backVC setup
        let frontVC: UIViewController = .init(),
            backVC: UIViewController = .init()
        frontVC.view = RoundView()
        backVC.view = RoundView()
        frontVC.view.backgroundColor = .systemBackground
        backVC.view.backgroundColor = .systemBackground
        let label1: UILabel = .init()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .secondarySystemBackground
        label1.text = "RED"
        frontVC.view.addSubview(label1)
        let label2: UILabel = .init()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .secondarySystemBackground
        label2.text = "BLUE"
        backVC.view.addSubview(label2)
        NSLayoutConstraint.activate([
            label1.centerXAnchor.constraint(equalTo: frontVC.view.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: frontVC.view.centerYAnchor),
            label1.heightAnchor.constraint(equalToConstant: 30),
            label2.centerXAnchor.constraint(equalTo: backVC.view.centerXAnchor),
            label2.centerYAnchor.constraint(equalTo: backVC.view.centerYAnchor),
            label2.heightAnchor.constraint(equalToConstant: 30)
        ])
        // MARK: - end frontVC and backVC setup

        flipContainerVC = .init(frontVC: frontVC, backVC: backVC, flipsInfinitely: false)
        flipContainerVC.view.backgroundColor = .systemBackground
        flipContainerVC.view.tintColor = .secondarySystemBackground
        //flipContainerVC.state

        flipContainerVC.frontView.layer.borderColor = UIColor.systemRed.cgColor
        flipContainerVC.frontView.layer.borderWidth = 1
        flipContainerVC.backView.layer.borderColor = UIColor.systemBlue.cgColor
        flipContainerVC.backView.layer.borderWidth = 1

        view.addSubview(flipContainerVC.view)
        addChild(flipContainerVC)
        flipContainerVC.didMove(toParent: self)

        // MARK: - begin flipContainer's configuration controls
        flipsInfinitelyLabel = .init()
        flipsInfinitelyLabel.backgroundColor = .systemBackground
        flipsInfinitelyLabel.text = "Flips infinitely"
        view.addSubview(flipsInfinitelyLabel)
        flipsInfinitelySwitch = .init()
        flipsInfinitelySwitch.backgroundColor = .systemBackground
        flipsInfinitelySwitch.addTarget(self, action: #selector(flipsInfinitelySwitchValueChanged(_:)), for: .valueChanged)
        flipsInfinitelySwitch.isOn = false
        view.addSubview(flipsInfinitelySwitch)

        sensitivityLabel = .init()
        sensitivityLabel.backgroundColor = .systemBackground
        sensitivityLabel.text = "Sensitivity"
        view.addSubview(sensitivityLabel)
        sensitivityValueLabel = .init()
        sensitivityValueLabel.backgroundColor = .systemBackground
        sensitivityValueLabel.text = "2.00"
        view.addSubview(sensitivityValueLabel)
        sensitivitySlider = .init()
        sensitivitySlider.backgroundColor = .systemBackground
        sensitivitySlider.addTarget(self, action: #selector(sensitivitySliderValueChanged(_:)), for: .valueChanged)
        sensitivitySlider.isContinuous = true
        sensitivitySlider.minimumValue = 0.50
        sensitivitySlider.maximumValue = 4
        sensitivitySlider.value = 2
        view.addSubview(sensitivitySlider)

        animationDurationLabel = .init()
        animationDurationLabel.backgroundColor = .systemBackground
        animationDurationLabel.text = "Animation duration"
        view.addSubview(animationDurationLabel)
        animationDurationValueLabel = .init()
        animationDurationValueLabel.backgroundColor = .systemBackground
        animationDurationValueLabel.text = "1.00 s"
        view.addSubview(animationDurationValueLabel)
        animationDurationSlider = .init()
        animationDurationSlider.backgroundColor = .systemBackground
        animationDurationSlider.addTarget(self, action: #selector(animationDurationSliderValueChanged(_:)), for: .valueChanged)
        animationDurationSlider.isContinuous = true
        animationDurationSlider.minimumValue = 0.50
        animationDurationSlider.maximumValue = 10
        animationDurationSlider.value = 1
        view.addSubview(animationDurationSlider)
        // MARK: - end flipContainer's configuration controls
    }

    override func viewWillLayoutSubviews() {
        flipContainerVC.view.translatesAutoresizingMaskIntoConstraints = false
        flipsInfinitelyLabel.translatesAutoresizingMaskIntoConstraints = false
        flipsInfinitelySwitch.translatesAutoresizingMaskIntoConstraints = false
        sensitivityLabel.translatesAutoresizingMaskIntoConstraints = false
        sensitivityValueLabel.translatesAutoresizingMaskIntoConstraints = false
        sensitivitySlider.translatesAutoresizingMaskIntoConstraints = false
        animationDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        animationDurationValueLabel.translatesAutoresizingMaskIntoConstraints = false
        animationDurationSlider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            flipContainerVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flipContainerVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            flipContainerVC.view.bottomAnchor.constraint(equalTo: flipsInfinitelySwitch.topAnchor, constant: -25),
            flipContainerVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),

            flipsInfinitelyLabel.centerYAnchor.constraint(equalTo: flipsInfinitelySwitch.centerYAnchor),
            flipsInfinitelyLabel.leadingAnchor.constraint(equalTo: flipContainerVC.view.leadingAnchor),
            flipsInfinitelySwitch.bottomAnchor.constraint(equalTo: sensitivityLabel.topAnchor, constant: -25),
            flipsInfinitelySwitch.trailingAnchor.constraint(equalTo: flipContainerVC.view.trailingAnchor),

            sensitivityLabel.bottomAnchor.constraint(equalTo: sensitivitySlider.topAnchor, constant: -10),
            sensitivityLabel.leadingAnchor.constraint(equalTo: flipContainerVC.view.leadingAnchor),
            sensitivityValueLabel.bottomAnchor.constraint(equalTo: sensitivitySlider.topAnchor, constant: -10),
            sensitivityValueLabel.trailingAnchor.constraint(equalTo: flipContainerVC.view.trailingAnchor),
            sensitivitySlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sensitivitySlider.widthAnchor.constraint(equalTo: flipContainerVC.view.widthAnchor),
            sensitivitySlider.bottomAnchor.constraint(equalTo: animationDurationLabel.topAnchor, constant: -25),

            animationDurationLabel.bottomAnchor.constraint(equalTo: animationDurationSlider.topAnchor, constant: -10),
            animationDurationLabel.leadingAnchor.constraint(equalTo: flipContainerVC.view.leadingAnchor),
            animationDurationValueLabel.bottomAnchor.constraint(equalTo: animationDurationSlider.topAnchor, constant: -10),
            animationDurationValueLabel.trailingAnchor.constraint(equalTo: flipContainerVC.view.trailingAnchor),
            animationDurationSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationDurationSlider.widthAnchor.constraint(equalTo: flipContainerVC.view.widthAnchor),
            animationDurationSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
    }
}

// MARK: - target-action selectors
extension ExampleVC {
    @objc func flipsInfinitelySwitchValueChanged(_ sender: UISwitch) {
        flipContainerVC.flipsInfinitely = sender.isOn
    }

    @objc func sensitivitySliderValueChanged(_ sender: UISlider) {
        let roundedStepValue = round(sender.value / 0.25) * 0.25
        sender.value = roundedStepValue
        sensitivityValueLabel.text = "\(String(format: "%.2f", sender.value))"
        flipContainerVC.sensitivity = CGFloat(sender.value)
    }

    @objc func animationDurationSliderValueChanged(_ sender: UISlider) {
        let roundedStepValue = round(sender.value / 0.25) * 0.25
        sender.value = roundedStepValue
        animationDurationValueLabel.text = "\(String(format: "%.2f", sender.value)) s"
        flipContainerVC.animationDuration = CGFloat(sender.value)
    }
}


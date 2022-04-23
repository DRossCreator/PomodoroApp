//
//  ViewController.swift
//  HWPomodoro
//
//  Created by Daniil Yarkovenko on 23.04.2022.
//

import UIKit

class ViewController: UIViewController {

    let imageConfig = UIImage.SymbolConfiguration(pointSize: Metric.imagePointSize, weight: .thin , scale: .large)

    private lazy var timeLabel: UILabel = {
        let label = UILabel()

        label.text = Strings.workTimeLabelText
        label.textColor = .orange
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Metric.timeLabelFontSize, weight: .light)

        return label
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(UIImage(systemName: "play", withConfiguration: imageConfig), for: .normal)
        button.addTarget(self, action: #selector(startButtonTap), for: .touchUpInside)
        button.tintColor = .orange
        button.heightAnchor.constraint(equalToConstant: Metric.startStopButtonHeight).isActive = true

        return button
    }()

    @objc private func startButtonTap(sender: UIButton!) { }

    private lazy var parentStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = Metric.parentStackViewSpacing

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHieracly()
        setupLayout()
        setupView()
    }

    //MARK: privateFunctions

    private func setupHieracly() {
        view.addSubview(parentStackView)

        parentStackView.addArrangedSubview(timeLabel)
        parentStackView.addArrangedSubview(startButton)
    }

    private func setupLayout() {
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        parentStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true

    }

    private func setupView() {
        view.backgroundColor = .white
    }
}

// MARK: - Constants

extension ViewController {

    enum Metric {
        static let imagePointSize: CGFloat = 40
        static let workTime = 7 //actually 1500 sec
        static let restTime = 5 //actually 300 sec
        static let startStopButtonHeight: CGFloat = 60
        static let timeLabelFontSize: CGFloat = 60
        static let parentStackViewSpacing: CGFloat = 50
        static let backProgressLayerRadius: CGFloat = 150
        static let foreLayerRadius: CGFloat = 150
        static let backLayerLineWith: CGFloat = 5
        static let foreLayerLineWith: CGFloat = 25
        static let workPeriodAnimationDuration: Double = 9 //actually 1500
        static let restPeriodAnimationDuration: Double = 7 //actually 300
    }

    enum Strings {
        static let workTimeLabelText: String = "00:07" //actually 25:00
        static let restTimeLabelText: String = "00:05" //actually 05:00
    }
}


//
//  ViewController.swift
//  HWPomodoro
//
//  Created by Daniil Yarkovenko on 23.04.2022.
//

import UIKit

class ViewController: UIViewController {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: Metric.imagePointSize, weight: .thin , scale: .large)

    private var foreProgressLayer = CAShapeLayer()
    private var backProgressLayer = CAShapeLayer()
    private var animation = CABasicAnimation(keyPath: "strokeEnd")
    private var timer = Timer()

    private var workTime = Metric.workTime
    private var restTime = Metric.restTime
    private var workPeriod = true
    private var isTamerStarted = false
    private var isAnimationStarted = false

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

    private lazy var parentStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = Metric.parentStackViewSpacing

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
        setupHieracly()
        setupLayout()
        setupView()

    }

    //MARK: isWorkTime

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc private func updateTimer() {
        if workPeriod {

            if workTime < 1 {
                SettingElementColors()
                restTime = Metric.restTime
                timeLabel.text = Strings.restTimeLabelText
                workPeriod = false
                startAnimation()
            } else {
                workTime -= 1
                timeLabel.text = formatTime(workTime)
            }

        } else {

            if restTime < 1 {
                SettingElementColors()
                workTime = Metric.workTime
                timeLabel.text = Strings.workTimeLabelText
                workPeriod = true
                startAnimation()
            } else {
                restTime -= 1
                timeLabel.text = formatTime(restTime)
            }

        }

    }

    private func formatTime(_ time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        return String(format: "%02i:%02i", minutes, seconds)
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

    private func drawBackLayer() {
        let center = view.center
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi

        backProgressLayer.path = UIBezierPath(arcCenter: center, radius: Metric.backProgressLayerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.strokeColor = UIColor.orange.cgColor
        backProgressLayer.lineWidth = Metric.backLayerLineWith
        view.layer.addSublayer(backProgressLayer)
    }

    private func drawForeLayer() {
        let center = view.center
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi

        foreProgressLayer.path = UIBezierPath(arcCenter: center, radius: Metric.foreLayerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.orange.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineCap = .round
        foreProgressLayer.lineWidth = Metric.foreLayerLineWith
        view.layer.addSublayer(foreProgressLayer)
    }

    //MARK: Animation

    private func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }

    private func startAnimation() {
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = durationUpdate()
        animation.isRemovedOnCompletion = true
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func durationUpdate() -> Double {

        if workPeriod {
            animation.duration = Metric.workPeriodAnimationDuration
        } else {
            animation.duration = Metric.restPeriodAnimationDuration
        }

        return animation.duration
    }

    private func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }

    private func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }

    //MARK: isStarted

    @objc private func startButtonTap(sender: UIButton!) {
        if !isTamerStarted {
            drawForeLayer()
            startTimer()
            startResumeAnimation()
            isTamerStarted = true
            startButton.setImage(UIImage(systemName: "pause", withConfiguration: imageConfig), for: .normal)
        } else {
            pauseAnimation()
            timer.invalidate()
            isTamerStarted = false
            startButton.setImage(UIImage(systemName: "play", withConfiguration: imageConfig), for: .normal)
        }
    }

    private func SettingElementColors() {
        if workPeriod {
            timeLabel.textColor = .systemMint
            startButton.tintColor = .systemMint
            foreProgressLayer.strokeColor = UIColor.systemMint.cgColor
            backProgressLayer.strokeColor = UIColor.systemMint.cgColor
        } else {
            timeLabel.textColor = .orange
            startButton.tintColor = .orange
            foreProgressLayer.strokeColor = UIColor.orange.cgColor
            backProgressLayer.strokeColor = UIColor.orange.cgColor
        }
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

//
//  ViewController.swift
//  HapticFeedbackTest
//
//  Created by Brandon Suarez on 2/22/24.
//

import UIKit

class ViewController: UIViewController {
    enum ActionType {
        case notificationError
        case notificationSuccess
        case notificationWarning
        
        case impactHeavy
        case impactMedium
        case impactLight
        
        case action
    }
    
    let device = UIDevice.current
    
    let mainStackView = UIStackView()
    
    lazy var topStackView: UIStackView = {
        let colors: [UIColor] = [.systemRed, .systemGreen, .systemOrange]
        let actions: [UIAction] = [generateAction(type: .notificationError), generateAction(type: .notificationSuccess), generateAction(type: .notificationWarning)]
        let buttons: [UIButton] = [
            generateButton(title: "Error", action: actions[0], backGroundColor: colors[0]),
            generateButton(title: "Success", action: actions[1], backGroundColor: colors[1]),
            generateButton(title: "Warning", action: actions[2], backGroundColor: colors[2])
        ]
        
        let stackView = generateContainerStack(title: "Notifications Feedback", buttons: buttons)
        return stackView
    }()
    
    lazy var midStackView: UIStackView = {
        let colors: [UIColor] = [
            .init(red: 197/255, green: 217/255, blue: 232/255, alpha: 1),
            .init(red: 140/255, green: 181/255, blue: 209/255, alpha: 1),
            .init(red: 84/255, green: 129/255, blue: 191/255, alpha: 1)
        ]
        let actions: [UIAction] = [generateAction(type: .impactLight), generateAction(type: .impactMedium), generateAction(type: .impactHeavy)]
        let buttons: [UIButton] = [
            generateButton(title: "Light", action: actions[0], backGroundColor: colors[0]),
            generateButton(title: "Medium", action: actions[1], backGroundColor: colors[1]),
            generateButton(title: "Heavy", action: actions[2], backGroundColor: colors[2])
        ]
        
        let stackView = generateContainerStack(title: "Impact Feedback", buttons: buttons)
        return stackView
    }()
    
    lazy var bottonStackView: UIStackView = {
        let action = generateAction(type: .action)
        let button = generateButton(title: "Selection", action: action, backGroundColor: .systemGreen)
        
        let switchButton = UISwitch()
        
        let stackView = generateContainerStack(title: "Selection Feedback", buttons: [button, switchButton])
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if device.orientation.isLandscape {
            print("Landscape")
        }
        
        if device.orientation.isPortrait {
            print("Portrait")
        }
    }


}

extension ViewController {
    func setupController() {
        view.backgroundColor = .white
        title = "Haptics"
        navigationController?.navigationBar.prefersLargeTitles = true
        device.beginGeneratingDeviceOrientationNotifications()
        
        view.addSubview(mainStackView)
        setupStackView(with: [topStackView, midStackView, bottonStackView])
        setupInfoButton()
        
    }
    
    func setupInfoButton() {
        let button = UIBarButtonItem(image: .init(systemName: "info.circle"), style: .plain, target: self, action: #selector(didTapInfoButton))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func didTapInfoButton() {
        let viewController = UIViewController()
        let label = UILabel()
        label.text = "Sample Test"
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            label.leftAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leftAnchor),
            label.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor),
            label.rightAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        viewController.view.backgroundColor = .systemGray6
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                200
            })]
            sheet.prefersGrabberVisible = true
            sheet.prefersPageSizing = true
        }
        
        let gesture = UISelectionFeedbackGenerator()
        gesture.selectionChanged()
        
        if viewController.isBeingDismissed {
            gesture.selectionChanged()
        }
        
        self.present(viewController, animated: true)
    }
    
    func setupStackView(with stackViews: [UIView]) {
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 20
        
        stackViews.forEach { stackView in
            mainStackView.addArrangedSubview(stackView)
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if device.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
                mainStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
                mainStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
                mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
                mainStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
                mainStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

    }
    
    // Stack Generator
    func generateContainerStack(title: String, buttons: [UIView]) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        let horizontalStack = UIStackView(arrangedSubviews: buttons)
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .equalCentering
        horizontalStack.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, horizontalStack])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 30
        
        return stackView
    }
    
    // Butons Generator
    func generateButton(title: String, action: UIAction, backGroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.layer.cornerRadius = 10
        button.backgroundColor = backGroundColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    // Action generator
    func generateAction(type: ActionType) -> UIAction {
        switch type {
        // MARK: - Impact
        case .impactHeavy:
            return UIAction { _ in
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
            }
            
        case .impactMedium:
            return UIAction { _ in
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            }
            
        case .impactLight:
            return UIAction { _ in
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
            }
        // MARK: - Notification
        case .notificationError:
            return UIAction { _ in
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
            
        case .notificationSuccess:
            return UIAction { _ in
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            
        case .notificationWarning:
            return UIAction { _ in
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
            
        // MARK: - Action
        case .action:
            return UIAction { _ in
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
    }
}

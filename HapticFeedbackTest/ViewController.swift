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
        case impactRigid
        case impactSoft
        
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
            .init(red: 84/255, green: 129/255, blue: 191/255, alpha: 1),
            .systemGray5,
            .systemGray2
        ]
        
        let actions: [UIAction] = [generateAction(type: .impactLight),
                                   generateAction(type: .impactMedium),
                                   generateAction(type: .impactHeavy),
                                   generateAction(type: .impactSoft),
                                   generateAction(type: .impactRigid)
        ]
        
        let buttons: [UIButton] = [
            generateButton(title: "Light", action: actions[0], backGroundColor: colors[0]),
            generateButton(title: "Medium", action: actions[1], backGroundColor: colors[1]),
            generateButton(title: "Heavy", action: actions[2], backGroundColor: colors[2]),
            generateButton(title: "Soft", action: actions[3], backGroundColor: colors[3]),
            generateButton(title: "Rigid", action: actions[4], backGroundColor: colors[4])
        ]
        
        let stackView = generateContainerStack(title: "Impact Feedback", buttons: buttons)
        return stackView
    }()
    
    lazy var bottomStackView: UIStackView = {
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
        setupStackView(with: [topStackView, midStackView, bottomStackView])
        setupInfoButton()
        
    }
    
    func setupInfoButton() {
        let button = UIBarButtonItem(image: .init(systemName: "info.circle"), style: .plain, target: self, action: #selector(didTapInfoButton))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func didTapInfoButton() {
        let viewController = UIViewController()
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "There are three classes to generate haptic feedback, those are: UIImpactFeedbackGenerator, UINotificationFeedbackGenerator, and UISelectionFeedbackGenerator, in order to use them, there are 4 steps to follow:\n\n1.-Instantiate the class\n2.-Prepare the generator\n3.-Triggering the generator\n4.-releasing the generator"
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
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersPageSizing = true
        }
        
        let gesture = UISelectionFeedbackGenerator()
        gesture.selectionChanged()
        
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
        
        var contentStack = UIStackView()
        
        if buttons.count <= 3 {
            buttons.forEach { view in
                contentStack.addArrangedSubview(view)
            }
            contentStack.axis = .horizontal
            
        } else if buttons.count > 3 {
            
            let topStack = UIStackView(arrangedSubviews: [buttons[0], buttons[1], buttons[2]])
            topStack.axis = .horizontal
            topStack.alignment = .center
            topStack.distribution = .equalCentering
            topStack.spacing = 10
            
            let bottomStack = UIStackView(arrangedSubviews: [buttons[3], buttons[4]])
            bottomStack.axis = .horizontal
            bottomStack.alignment = .center
            bottomStack.distribution = .equalCentering
            bottomStack.spacing = 10
            
            contentStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
            contentStack.axis = .vertical
        }
        
        contentStack.alignment = .center
        contentStack.distribution = .equalCentering
        contentStack.spacing = 10
        
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, contentStack])
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
        
        case .impactRigid:
            return UIAction { _ in
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.prepare()
                generator.impactOccurred()
            }
        case .impactSoft:
            return UIAction { _ in
                let generator = UIImpactFeedbackGenerator(style: .soft)
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

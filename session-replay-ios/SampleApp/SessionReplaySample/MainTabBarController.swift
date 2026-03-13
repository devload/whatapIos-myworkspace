import UIKit
import WhatapSessionRecorder
import WhatapSessionSnapshot

class MainTabBarController: UITabBarController {

    private var eventsSentCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let productsVC = ProductsViewController()
        productsVC.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "grid.fill"), tag: 1)

        let messagesVC = MessagesViewController()
        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(systemName: "message.fill"), tag: 2)

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 3)

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 4)

        viewControllers = [homeVC, productsVC, messagesVC, profileVC, settingsVC]

        setupStatusBar()
    }

    private func setupStatusBar() {
        let statusLabel = UILabel()
        statusLabel.text = "Recording..."
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = .systemRed
        statusLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension MainTabBarController: SessionRecorderDelegate {
    func recorder(_ recorder: SessionRecorder, didCaptureSnapshot snapshot: FullSnapshot) {}

    func recorder(_ recorder: SessionRecorder, didSendEvents count: Int) {
        eventsSentCount += count
    }

    func recorder(_ recorder: SessionRecorder, didFailWithError error: Error) {
        print("Session recorder error: \(error)")
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

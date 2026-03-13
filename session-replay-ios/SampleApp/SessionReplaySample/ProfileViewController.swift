import UIKit

class ProfileViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let avatarView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let editProfileButton = UIButton()

    private let statsStackView = UIStackView()

    private let sectionPersonal = UIView()
    private let sectionPreferences = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Profile"
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        setupAvatar()
        setupStats()
        setupPersonalSection()
        setupPreferencesSection()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func setupAvatar() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.backgroundColor = .systemPurple
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = "John Doe"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.backgroundColor = .systemBlue
        editProfileButton.layer.cornerRadius = 8
        editProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false

        avatarView.addSubview(avatarImageView)
        avatarView.addSubview(nameLabel)
        avatarView.addSubview(editProfileButton)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),

            editProfileButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            editProfileButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant: 120),
            editProfileButton.heightAnchor.constraint(equalToConstant: 36),
            editProfileButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor)
        ])

        stackView.addArrangedSubview(avatarView)
    }

    private func setupStats() {
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 12
        statsStackView.translatesAutoresizingMaskIntoConstraints = false

        let stats = [
            ("Orders", "24"),
            ("Reviews", "12"),
            ("Points", "1,250"),
            ("Level", "Gold")
        ]

        for (title, value) in stats {
            let statView = StatView()
            statView.configure(title: title, value: value)
            statsStackView.addArrangedSubview(statView)
        }

        stackView.addArrangedSubview(statsStackView)
    }

    private func setupPersonalSection() {
        sectionPersonal.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Personal Information"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let formStack = UIStackView()
        formStack.axis = .vertical
        formStack.spacing = 16
        formStack.translatesAutoresizingMaskIntoConstraints = false

        let fields = [
            ("Full Name", "John Doe"),
            ("Email", "john.doe@example.com"),
            ("Phone", "+1 (555) 123-4567"),
            ("Address", "123 Main St, City, Country")
        ]

        for (label, value) in fields {
            let fieldView = FormFieldView()
            fieldView.configure(label: label, value: value)
            formStack.addArrangedSubview(fieldView)
        }

        sectionPersonal.addSubview(titleLabel)
        sectionPersonal.addSubview(formStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: sectionPersonal.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: sectionPersonal.leadingAnchor),

            formStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            formStack.leadingAnchor.constraint(equalTo: sectionPersonal.leadingAnchor),
            formStack.trailingAnchor.constraint(equalTo: sectionPersonal.trailingAnchor),
            formStack.bottomAnchor.constraint(equalTo: sectionPersonal.bottomAnchor)
        ])

        stackView.addArrangedSubview(sectionPersonal)
    }

    private func setupPreferencesSection() {
        sectionPreferences.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Preferences"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let prefsStack = UIStackView()
        prefsStack.axis = .vertical
        prefsStack.spacing = 12
        prefsStack.translatesAutoresizingMaskIntoConstraints = false

        let prefs: [(String, Bool)] = [
            ("Push Notifications", true),
            ("Email Updates", true),
            ("Dark Mode", false),
            ("Auto-play Videos", true)
        ]

        for (title, isOn) in prefs {
            let toggleRow = ToggleRow()
            toggleRow.configure(title: title, isOn: isOn)
            prefsStack.addArrangedSubview(toggleRow)
        }

        sectionPreferences.addSubview(titleLabel)
        sectionPreferences.addSubview(prefsStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: sectionPreferences.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: sectionPreferences.leadingAnchor),

            prefsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            prefsStack.leadingAnchor.constraint(equalTo: sectionPreferences.leadingAnchor),
            prefsStack.trailingAnchor.constraint(equalTo: sectionPreferences.trailingAnchor),
            prefsStack.bottomAnchor.constraint(equalTo: sectionPreferences.bottomAnchor)
        ])

        stackView.addArrangedSubview(sectionPreferences)
    }
}

class StatView: UIView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .systemGray
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(valueLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

class FormFieldView: UIView {
    private let label = UILabel()
    private let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false

        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        addSubview(textField)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),

            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configure(label: String, value: String) {
        self.label.text = label
        textField.text = value
    }
}

class ToggleRow: UIView {
    private let titleLabel = UILabel()
    private let toggle = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        toggle.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(toggle)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: centerYAnchor),

            topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
    }

    func configure(title: String, isOn: Bool) {
        titleLabel.text = title
        toggle.isOn = isOn
    }
}

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        return tv
    }()

    private let sections: [(String, [SettingItem])] = [
        ("Display", [
            .segment(title: "Theme", options: ["Light", "Dark", "Auto"], selected: 0),
            .slider(title: "Font Size", value: 16, min: 12, max: 24),
            .toggle(title: "Bold Text", isOn: false)
        ]),
        ("Notifications", [
            .toggle(title: "Push Notifications", isOn: true),
            .toggle(title: "Email Notifications", isOn: true),
            .toggle(title: "Sound", isOn: true),
            .toggle(title: "Vibration", isOn: false)
        ]),
        ("Privacy", [
            .toggle(title: "Location Services", isOn: false),
            .toggle(title: "Analytics", isOn: true),
            .toggle(title: "Crash Reports", isOn: true),
            .picker(title: "Data Sharing", options: ["None", "Anonymous", "Full"], selected: 1)
        ]),
        ("Account", [
            .button(title: "Change Password", color: .systemBlue),
            .button(title: "Two-Factor Auth", color: .systemBlue),
            .button(title: "Linked Accounts", color: .systemBlue),
            .button(title: "Log Out", color: .systemRed)
        ]),
        ("About", [
            .info(title: "Version", value: "2.1.0"),
            .info(title: "Build", value: "2026.03.11"),
            .button(title: "Rate App", color: .systemOrange),
            .button(title: "Contact Support", color: .systemBlue)
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(SettingSegmentCell.self, forCellReuseIdentifier: "SegmentCell")
        tableView.register(SettingSliderCell.self, forCellReuseIdentifier: "SliderCell")
        tableView.register(SettingPickerCell.self, forCellReuseIdentifier: "PickerCell")
        tableView.register(SettingButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.register(SettingInfoCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

enum SettingItem {
    case toggle(title: String, isOn: Bool)
    case segment(title: String, options: [String], selected: Int)
    case slider(title: String, value: Float, min: Float, max: Float)
    case picker(title: String, options: [String], selected: Int)
    case button(title: String, color: UIColor)
    case info(title: String, value: String)
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].1[indexPath.row]

        switch item {
        case .toggle(let title, let isOn):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! SettingToggleCell
            cell.configure(title: title, isOn: isOn)
            return cell

        case .segment(let title, let options, let selected):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as! SettingSegmentCell
            cell.configure(title: title, options: options, selected: selected)
            return cell

        case .slider(let title, let value, let min, let max):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as! SettingSliderCell
            cell.configure(title: title, value: value, min: min, max: max)
            return cell

        case .picker(let title, let options, let selected):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! SettingPickerCell
            cell.configure(title: title, options: options, selected: selected)
            return cell

        case .button(let title, let color):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! SettingButtonCell
            cell.configure(title: title, color: color)
            return cell

        case .info(let title, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! SettingInfoCell
            cell.configure(title: title, value: value)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].1[indexPath.row]
        if case .button(let title, _) = item {
            if title == "Log Out" {
                let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Log Out", style: .destructive))
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: title, message: "This feature is coming soon!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }
}

class SettingToggleCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let toggle = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        toggle.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(title: String, isOn: Bool) {
        titleLabel.text = title
        toggle.isOn = isOn
    }
}

class SettingSegmentCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let segment = UISegmentedControl()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        segment.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(segment)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            segment.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            segment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(title: String, options: [String], selected: Int) {
        titleLabel.text = title
        segment.removeAllSegments()
        for (index, option) in options.enumerated() {
            segment.insertSegment(withTitle: option, at: index, animated: false)
        }
        segment.selectedSegmentIndex = selected
    }
}

class SettingSliderCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let slider = UISlider()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .systemGray
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)

        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(slider)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    @objc private func sliderChanged() {
        valueLabel.text = String(format: "%.0f", slider.value)
    }

    func configure(title: String, value: Float, min: Float, max: Float) {
        titleLabel.text = title
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        valueLabel.text = String(format: "%.0f", value)
    }
}

class SettingPickerCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let pickerButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        pickerButton.backgroundColor = .systemGray5
        pickerButton.layer.cornerRadius = 8
        pickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        pickerButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(pickerButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            pickerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pickerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pickerButton.widthAnchor.constraint(equalToConstant: 120),
            pickerButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    func configure(title: String, options: [String], selected: Int) {
        titleLabel.text = title
        pickerButton.setTitle(options[selected], for: .normal)
        pickerButton.setTitleColor(.label, for: .normal)
    }
}

class SettingButtonCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, color: UIColor) {
        textLabel?.text = title
        textLabel?.textColor = color
    }
}

class SettingInfoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.textColor = .systemGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String) {
        textLabel?.text = title
        detailTextLabel?.text = value
    }
}

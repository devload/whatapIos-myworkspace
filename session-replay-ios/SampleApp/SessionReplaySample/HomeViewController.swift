import UIKit

class HomeViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let headerView = UIView()
    private let greetingLabel = UILabel()
    private let dateLabel = UILabel()

    private let searchContainer = UIView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton()

    private let categoriesLabel = UILabel()
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private let featuredLabel = UILabel()
    private let featuredStackView = UIStackView()

    private let quickActionsLabel = UILabel()
    private let actionsStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Home"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        setupHeader()
        setupSearch()
        setupCategories()
        setupFeatured()
        setupQuickActions()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        greetingLabel.text = "Good Morning, John!"
        greetingLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.text = "Tuesday, March 11, 2026"
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(greetingLabel)
        headerView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            greetingLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        stackView.addArrangedSubview(headerView)
    }

    private func setupSearch() {
        searchContainer.translatesAutoresizingMaskIntoConstraints = false

        searchTextField.placeholder = "Search products, brands..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemGray6
        searchTextField.translatesAutoresizingMaskIntoConstraints = false

        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.tintColor = .white
        searchButton.layer.cornerRadius = 8
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        searchContainer.addSubview(searchTextField)
        searchContainer.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),

            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            searchButton.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 44),
            searchButton.heightAnchor.constraint(equalToConstant: 44),

            searchContainer.heightAnchor.constraint(equalToConstant: 44)
        ])

        stackView.addArrangedSubview(searchContainer)
    }

    private func setupCategories() {
        categoriesLabel.text = "Categories"
        categoriesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        categoriesLabel.translatesAutoresizingMaskIntoConstraints = false

        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoriesCollectionView.dataSource = self

        stackView.addArrangedSubview(categoriesLabel)
        stackView.addArrangedSubview(categoriesCollectionView)
    }

    private func setupFeatured() {
        featuredLabel.text = "Featured Products"
        featuredLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        featuredStackView.axis = .horizontal
        featuredStackView.spacing = 12
        featuredStackView.distribution = .fillEqually
        featuredStackView.translatesAutoresizingMaskIntoConstraints = false

        for i in 0..<3 {
            let card = ProductCardView()
            card.configure(
                title: "Product \(i + 1)",
                price: "$\(99 + i * 20)",
                color: [.systemBlue, .systemGreen, .systemOrange][i]
            )
            featuredStackView.addArrangedSubview(card)
        }

        stackView.addArrangedSubview(featuredLabel)
        stackView.addArrangedSubview(featuredStackView)
    }

    private func setupQuickActions() {
        quickActionsLabel.text = "Quick Actions"
        quickActionsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 12
        actionsStackView.distribution = .fillEqually
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false

        let actions = [
            ("wallet.pass.fill", "Wallet", UIColor.systemPurple),
            ("gift.fill", "Rewards", UIColor.systemPink),
            ("bell.fill", "Alerts", UIColor.systemRed),
            ("qrcode.viewfinder", "Scan", UIColor.systemTeal)
        ]

        for (icon, title, color) in actions {
            let actionButton = QuickActionButton()
            actionButton.configure(icon: icon, title: title, color: color)
            actionButton.addTarget(self, action: #selector(actionTapped(_:)), for: .touchUpInside)
            actionsStackView.addArrangedSubview(actionButton)
        }

        NSLayoutConstraint.activate([
            actionsStackView.heightAnchor.constraint(equalToConstant: 80)
        ])

        stackView.addArrangedSubview(quickActionsLabel)
        stackView.addArrangedSubview(actionsStackView)
    }

    @objc private func actionTapped(_ sender: QuickActionButton) {
        let alert = UIAlertController(title: sender.titleText, message: "Action tapped!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let categories = ["Electronics", "Fashion", "Home", "Sports", "Books", "Food"]
        let icons = ["laptopcomputer", "tshirt.fill", "house.fill", "sportscourt.fill", "book.fill", "fork.knife"]
        cell.configure(name: categories[indexPath.item], icon: icons[indexPath.item])
        return cell
    }
}

class CategoryCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12

        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }

    func configure(name: String, icon: String) {
        nameLabel.text = name
        iconImageView.image = UIImage(systemName: icon)
    }
}

class ProductCardView: UIView {
    private let imageView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        backgroundColor = .systemBackground

        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        priceLabel.textColor = .systemBlue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(priceLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(title: String, price: String, color: UIColor) {
        titleLabel.text = title
        priceLabel.text = price
        imageView.backgroundColor = color.withAlphaComponent(0.3)
    }
}

class QuickActionButton: UIButton {
    private let iconView = UIImageView()
    private let titleLbl = UILabel()
    var titleText: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconView)
        addSubview(titleLbl)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            titleLbl.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }

    func configure(icon: String, title: String, color: UIColor) {
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        titleLbl.text = title
        titleText = title
    }
}

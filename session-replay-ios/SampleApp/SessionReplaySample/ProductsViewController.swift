import UIKit

class ProductsViewController: UIViewController {

    private let segmentControl = UISegmentedControl(items: ["All", "Popular", "New", "Sale"])
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 16
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        layout.itemSize = CGSize(width: width, height: width + 60)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private let products: [(String, String, String, UIColor)] = [
        ("Wireless Earbuds", "$79.99", "🎵", .systemBlue),
        ("Smart Watch", "$199.99", "⌚", .systemPurple),
        ("Laptop Stand", "$49.99", "💻", .systemGray),
        ("USB-C Hub", "$39.99", "🔌", .systemOrange),
        ("Mechanical Keyboard", "$129.99", "⌨️", .systemRed),
        ("Webcam HD", "$89.99", "📷", .systemGreen),
        ("Monitor Light", "$59.99", "💡", .systemYellow),
        ("Mouse Pad XL", "$29.99", "🖱️", .systemTeal),
        ("Desk Organizer", "$34.99", "📁", .systemIndigo),
        ("Cable Manager", "$19.99", "🔗", .systemPink),
        ("Phone Stand", "$24.99", "📱", .systemTeal),
        ("Power Bank", "$44.99", "🔋", .systemBrown)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Products"
        view.backgroundColor = .systemBackground

        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(segmentControl)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = products[indexPath.item]
        cell.configure(name: product.0, price: product.1, emoji: product.2, color: product.3)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let detailVC = ProductDetailViewController()
        detailVC.productName = product.0
        detailVC.productPrice = product.1
        detailVC.productColor = product.3
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class ProductCell: UICollectionViewCell {
    private let imageView = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addButton = UIButton()
    private let ratingStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 16

        imageView.font = UIFont.systemFont(ofSize: 48)
        imageView.textAlignment = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        priceLabel.textColor = .systemBlue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 16
        addButton.translatesAutoresizingMaskIntoConstraints = false

        ratingStack.axis = .horizontal
        ratingStack.spacing = 2
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = .systemYellow
            star.widthAnchor.constraint(equalToConstant: 10).isActive = true
            star.heightAnchor.constraint(equalToConstant: 10).isActive = true
            ratingStack.addArrangedSubview(star)
        }

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingStack)
        contentView.addSubview(addButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            ratingStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            priceLabel.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    func configure(name: String, price: String, emoji: String, color: UIColor) {
        nameLabel.text = name
        priceLabel.text = price
        imageView.text = emoji
    }
}

class ProductDetailViewController: UIViewController {
    var productName: String = ""
    var productPrice: String = ""
    var productColor: UIColor = .systemBlue

    private let scrollView = UIScrollView()
    private let imageView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let quantityLabel = UILabel()
    private let stepper = UIStepper()
    private let addToCartButton = UIButton()
    private let buyNowButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Product Details"
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        imageView.backgroundColor = productColor.withAlphaComponent(0.3)
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = productName
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.text = productPrice
        priceLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        priceLabel.textColor = .systemBlue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.text = "⭐⭐⭐⭐⭐ (128 reviews)"
        ratingLabel.textColor = .systemGray
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionTextView.text = "This is a high-quality product with amazing features. Perfect for everyday use and built to last. Features include premium materials, ergonomic design, and advanced technology."
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        quantityLabel.text = "Quantity: 1"
        quantityLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false

        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)

        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.layer.cornerRadius = 12
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false

        buyNowButton.setTitle("Buy Now", for: .normal)
        buyNowButton.backgroundColor = .systemGreen
        buyNowButton.layer.cornerRadius = 12
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        buyNowButton.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(quantityLabel)
        scrollView.addSubview(stepper)
        scrollView.addSubview(addToCartButton)
        scrollView.addSubview(buyNowButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 280),
            imageView.heightAnchor.constraint(equalToConstant: 280),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            descriptionTextView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            quantityLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            quantityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            stepper.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 16),

            addToCartButton.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 24),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addToCartButton.widthAnchor.constraint(equalToConstant: 160),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),

            buyNowButton.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            buyNowButton.leadingAnchor.constraint(equalTo: addToCartButton.trailingAnchor, constant: 16),
            buyNowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buyNowButton.heightAnchor.constraint(equalToConstant: 50),

            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: buyNowButton.bottomAnchor, constant: 40)
        ])
    }

    @objc private func stepperChanged() {
        quantityLabel.text = "Quantity: \(Int(stepper.value))"
    }
}

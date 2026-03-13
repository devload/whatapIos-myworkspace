import UIKit

class MessagesViewController: UIViewController {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    private let conversations: [(String, String, String, String, Bool)] = [
        ("Alice Johnson", "Hey, did you see the new products?", "2m ago", "AJ", true),
        ("Bob Smith", "Thanks for your order!", "15m ago", "BS", false),
        ("Carol White", "Your package has been shipped", "1h ago", "CW", false),
        ("David Brown", "Meeting at 3pm tomorrow", "2h ago", "DB", true),
        ("Emma Davis", "Can you review my code?", "3h ago", "ED", false),
        ("Frank Miller", "Happy birthday! 🎂", "5h ago", "FM", false),
        ("Grace Wilson", "Check out this article", "1d ago", "GW", false),
        ("Henry Taylor", "Let's grab lunch", "2d ago", "HT", true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Messages"
        view.backgroundColor = .systemBackground

        searchBar.placeholder = "Search messages"
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        view.addSubview(searchBar)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        let convo = conversations[indexPath.row]
        cell.configure(name: convo.0, message: convo.1, time: convo.2, initials: convo.3, unread: convo.4)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let convo = conversations[indexPath.row]
        let chatVC = ChatViewController()
        chatVC.contactName = convo.0
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

class ConversationCell: UITableViewCell {
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let unreadBadge = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none

        avatarView.backgroundColor = .systemBlue
        avatarView.layer.cornerRadius = 28
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarLabel.textColor = .white
        avatarLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(avatarLabel)

        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .systemGray
        messageLabel.numberOfLines = 1
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .systemGray2
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        unreadBadge.backgroundColor = .systemBlue
        unreadBadge.layer.cornerRadius = 6
        unreadBadge.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(unreadBadge)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 56),
            avatarView.heightAnchor.constraint(equalToConstant: 56),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            unreadBadge.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            unreadBadge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            unreadBadge.widthAnchor.constraint(equalToConstant: 12),
            unreadBadge.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    func configure(name: String, message: String, time: String, initials: String, unread: Bool) {
        nameLabel.text = name
        messageLabel.text = message
        timeLabel.text = time
        avatarLabel.text = initials
        unreadBadge.isHidden = !unread
    }
}

class ChatViewController: UIViewController {

    private let tableView = UITableView()
    private let messageInputContainer = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton()

    private let messages: [(String, Bool)] = [
        ("Hey! How are you?", false),
        ("I'm good, thanks! Did you check out the new products?", true),
        ("Yes! They look amazing 😍", false),
        ("Which one is your favorite?", true),
        ("I really like the wireless earbuds", false),
        ("Great choice! They're on sale right now", true),
        ("Oh really? I might get them then!", false)
    ]

    var contactName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = contactName
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: "ChatBubbleCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6

        messageInputContainer.backgroundColor = .systemBackground
        messageInputContainer.layer.shadowColor = UIColor.black.cgColor
        messageInputContainer.layer.shadowOpacity = 0.1
        messageInputContainer.layer.shadowOffset = CGSize(width: 0, height: -1)
        messageInputContainer.translatesAutoresizingMaskIntoConstraints = false

        messageTextField.placeholder = "Type a message..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.backgroundColor = .systemGray6
        messageTextField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.backgroundColor = .systemBlue
        sendButton.tintColor = .white
        sendButton.layer.cornerRadius = 20
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        messageInputContainer.addSubview(messageTextField)
        messageInputContainer.addSubview(sendButton)
        view.addSubview(tableView)
        view.addSubview(messageInputContainer)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor),

            messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageInputContainer.heightAnchor.constraint(equalToConstant: 90),

            messageTextField.leadingAnchor.constraint(equalTo: messageInputContainer.leadingAnchor, constant: 16),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputContainer.safeAreaLayoutGuide.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubbleCell", for: indexPath) as! ChatBubbleCell
        let msg = messages[indexPath.row]
        cell.configure(message: msg.0, isOutgoing: msg.1)
        return cell
    }
}

class ChatBubbleCell: UITableViewCell {
    private let bubbleView = UIView()
    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        bubbleView.layer.cornerRadius = 16
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.addSubview(messageLabel)
        contentView.addSubview(bubbleView)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16)
        ])
    }

    func configure(message: String, isOutgoing: Bool) {
        messageLabel.text = message

        if isOutgoing {
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        } else {
            bubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .label
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        }
    }
}

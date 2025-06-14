import UIKit

class GradeCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let nameLabel = UILabel()
    private let codeCreditLabel = UILabel()
    private let gradeLabel = UILabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup
    private func setupViews() {
        // nameLabel
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping

        // codeCreditLabel
        codeCreditLabel.font = UIFont.systemFont(ofSize: 15)
        codeCreditLabel.textColor = .secondaryLabel
        codeCreditLabel.numberOfLines = 1
        codeCreditLabel.lineBreakMode = .byTruncatingTail

        // gradeLabel
        gradeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        gradeLabel.textColor = .systemBlue
        gradeLabel.textAlignment = .right
        gradeLabel.setContentHuggingPriority(.required, for: .horizontal)
        gradeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        gradeLabel.numberOfLines = 1

        // Left vertical stack
        let leftStack = UIStackView(arrangedSubviews: [nameLabel, codeCreditLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 6

        // Horizontal stack
        let container = UIStackView(arrangedSubviews: [leftStack, gradeLabel])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120) // 기존 100 → 120으로 확장
        ])
    }

    // MARK: - Configure Method
    func configure(name: String, code: String, credit: Int, grade: String) {
        nameLabel.text = name
        codeCreditLabel.text = "\(code) • \(credit)학점"
        gradeLabel.text = grade
    }
}

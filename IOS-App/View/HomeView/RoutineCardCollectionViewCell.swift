import UIKit

final class RoutineCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!         // rounded white background
    @IBOutlet weak var stackView: UIStackView!   // vertical stack inside card

    // appearance constants
    private let cornerRadius: CGFloat = 34
    private let dividerInset: CGFloat = 12
    private let dividerTag = 999

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // card rounded and clipping
        cardView.layer.cornerRadius = cornerRadius
        cardView.clipsToBounds = true
        cardView.backgroundColor = .white

        // cell shadow (drawn by cell's layer)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false

        // stack view default config
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // sync shadow path to rounded card shape for crisp shadow
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // remove arranged subviews to avoid duplicates
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    // MARK: - Configure

    func configureRoutineCell(completed: [RoutineCardModel], pending: [RoutineCardModel]) {
        // clear anything left (defensive)
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Build the card: header "Completed", a small area (if empty show placeholder), then header "Pending" and rows
        addSectionHeader(title: "Completed")
        if completed.isEmpty {
            addPlaceholderRow(text: "No tasks completed yet")
        } else {
            for item in completed {
                addRow(for: item, isPending: false)
            }
        }

        // small separator (optional)
        addSectionHeader(title: "Pending")

        for item in pending {
            addRow(for: item, isPending: true)
        }

        // remove the final divider (we don't want a trailing line at the bottom of the card)
        removeTrailingDividerIfNeeded()
    }

    // MARK: - Helpers (row builders)

    private func addSectionHeader(title: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = title
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        // give header small top/bottom padding by embedding in container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12).isActive = true
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 2).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2).isActive = true
        stackView.addArrangedSubview(container)
    }

    private func addPlaceholderRow(text: String) {
        let placeholderContainer = UIView()
        placeholderContainer.translatesAutoresizingMaskIntoConstraints = false

        let pill = UIView()
        pill.backgroundColor = UIColor(white: 0.95, alpha: 1)
        pill.layer.cornerRadius = 18
        pill.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.45, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        placeholderContainer.addSubview(pill)
        pill.addSubview(label)
        // pin pill inside container
        NSLayoutConstraint.activate([
            pill.leadingAnchor.constraint(equalTo: placeholderContainer.leadingAnchor, constant: 12),
            pill.trailingAnchor.constraint(equalTo: placeholderContainer.trailingAnchor, constant: -12),
            pill.topAnchor.constraint(equalTo: placeholderContainer.topAnchor, constant: 4),
            pill.bottomAnchor.constraint(equalTo: placeholderContainer.bottomAnchor, constant: -4),

            // label inside pill
            label.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 12)
        ])

        // Ensure placeholder fills stack width so its internal constraints behave correctly
        stackView.addArrangedSubview(placeholderContainer)
        placeholderContainer.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

        addDivider()
    }


    private func addRow(for item: RoutineCardModel, isPending: Bool) {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        row.backgroundColor = UIColor(white: 0.95, alpha: 1)
        row.layer.cornerRadius = 20
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = item.title
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.text = item.timeText
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Priority tweaks so timeLabel keeps its intrinsic size and title takes remaining space
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        row.addSubview(titleLabel)
        row.addSubview(timeLabel)

        if let sub = item.subtitle, !sub.isEmpty {
            let subtitleLabel = UILabel()
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
            subtitleLabel.textColor = UIColor(white: 0.55, alpha: 1)
            subtitleLabel.text = sub
            subtitleLabel.numberOfLines = 0                 // allow wrapping
            subtitleLabel.lineBreakMode = .byWordWrapping
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

            // Give subtitle a higher resistance so it is visible when space available
            subtitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

            row.addSubview(subtitleLabel)

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 12),
                titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 8),

                subtitleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 12),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
                subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

                timeLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12),
                timeLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

                subtitleLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8)
            ])
        } else {
            // reduce minimum row height to allow more compact card
            let minRowHeight: CGFloat = 36
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 12),
                titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

                timeLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12),
                timeLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

                row.heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight)
            ])
        }

        stackView.addArrangedSubview(row)

        // Force row to match stack width so its internal constraints calculate correctly
        row.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

        addDivider()
    }

    private func addDivider() {
        let d = UIView()
        d.translatesAutoresizingMaskIntoConstraints = false
        d.backgroundColor = UIColor(white: 0.90, alpha: 1)
        d.tag = dividerTag
        stackView.addArrangedSubview(d)
        NSLayoutConstraint.activate([
            d.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            d.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: dividerInset),
            d.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -dividerInset)
        ])
    }

    private func removeTrailingDividerIfNeeded() {
        if let last = stackView.arrangedSubviews.last, last.tag == dividerTag {
            stackView.removeArrangedSubview(last)
            last.removeFromSuperview()
        }
    }

    // MARK: - make compositional layout measure the cell properly
    // This lets the layout use the cell's measured intrinsic height
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let targetSize = CGSize(width: layoutAttributes.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let autoLayoutSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(autoLayoutSize.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

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

    /// Pending section is presented before Completed (per facilitator request)
    func configureRoutineCell(completed: [RoutineCardModel], pending: [RoutineCardModel]) {
        // clear anything left (defensive)
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Build the card: header "Pending" first, then header "Completed"
        addSection(title: "Pending", items: pending, placeholder: "No pending tasks")
        addSection(title: "Completed", items: completed, placeholder: "No tasks completed yet")

        // remove final divider if present
        removeTrailingDividerIfNeeded()
    }

    // MARK: - Section builder (shared grey background containing multiple rows)

    private func addSection(title: String, items: [RoutineCardModel], placeholder: String) {
        // header
        addSectionHeader(title: title)

        // container that will hold all rows and provide the shared grey background
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(white: 0.95, alpha: 1)
        container.layer.cornerRadius = 20
        container.clipsToBounds = true

        // inner stack where each row is a transparent view (so grey container shows through)
        let innerStack = UIStackView()
        innerStack.axis = .vertical
        innerStack.spacing = 0
        innerStack.alignment = .fill
        innerStack.distribution = .fill
        innerStack.translatesAutoresizingMaskIntoConstraints = false

        // --- IMPORTANT: use layout margins so both rows and dividers align to the same inset ---
        innerStack.isLayoutMarginsRelativeArrangement = true
        innerStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        container.addSubview(innerStack)
        // pin inner stack to container
        NSLayoutConstraint.activate([
            innerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            innerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            innerStack.topAnchor.constraint(equalTo: container.topAnchor),
            innerStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        // add rows (or placeholder) to innerStack
        if items.isEmpty {
            // placeholder row inside shared background
            let placeholderRow = UIView()
            placeholderRow.translatesAutoresizingMaskIntoConstraints = false
            placeholderRow.backgroundColor = .clear

            let label = UILabel()
            label.text = placeholder
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor(white: 0.45, alpha: 1)
            label.translatesAutoresizingMaskIntoConstraints = false

            placeholderRow.addSubview(label)
            NSLayoutConstraint.activate([
                // note: label leading/trailing are 0 relative to the row because the innerStack
                // already provides horizontal margins
                label.leadingAnchor.constraint(equalTo: placeholderRow.leadingAnchor, constant: 0),
                label.trailingAnchor.constraint(lessThanOrEqualTo: placeholderRow.trailingAnchor, constant: 0),
                label.topAnchor.constraint(equalTo: placeholderRow.topAnchor, constant: 12),
                label.bottomAnchor.constraint(equalTo: placeholderRow.bottomAnchor, constant: -12),
                placeholderRow.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])

            innerStack.addArrangedSubview(placeholderRow)
        } else {
            for (index, item) in items.enumerated() {
                let row = makeTransparentRow(for: item)
                innerStack.addArrangedSubview(row)

                // add internal divider between rows (not after last)
                if index < items.count - 1 {
                    let div = UIView()
                    div.translatesAutoresizingMaskIntoConstraints = false
                    div.backgroundColor = UIColor(white: 0.85, alpha: 1) // your bold divider color
                    innerStack.addArrangedSubview(div)
                    NSLayoutConstraint.activate([
                        div.heightAnchor.constraint(equalToConstant: 1),
                        // pin to innerStack's layout margins so divider has left/right padding
                        div.leadingAnchor.constraint(equalTo: innerStack.layoutMarginsGuide.leadingAnchor),
                        div.trailingAnchor.constraint(equalTo: innerStack.layoutMarginsGuide.trailingAnchor)
                    ])
                }
            }
        }

            // add container to main stack and make it match width
            stackView.addArrangedSubview(container)
            container.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

    //        addDivider() // divider below the shared section (consistent with previous behavior)
    }


    private func makeTransparentRow(for item: RoutineCardModel) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.backgroundColor = .clear

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
            subtitleLabel.numberOfLines = 0
            subtitleLabel.lineBreakMode = .byWordWrapping
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

            row.addSubview(subtitleLabel)

            NSLayoutConstraint.activate([
                // use 0 leading because innerStack provides the 12pt margin
                titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 0),
                titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 12),

                subtitleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 0),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

                timeLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: 0),
                timeLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

                subtitleLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -12)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 0),
                titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

                timeLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: 0),
                timeLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

                row.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])
        }

        return row
    }


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

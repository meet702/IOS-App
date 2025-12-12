//
//  MemoryLaneCardCollectionViewCell.swift
//  Home-Test
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class MemoryLaneCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!

    // Tags / keys
    private let gradientOverlayTag = 999

    // tuning
    private let cardCornerRadius: CGFloat = 31
    private let gradientBottomAlpha: CGFloat = 0.65
    private let gradientTopPadding: CGFloat = 8.0 // how many pts above the text the gradient should start
    // fallback height if text measurement fails
    private let fallbackGradientHeight: CGFloat = 120

    // keep a reference to the overlay view so we can update/remove it easily
    private weak var overlayView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()

        // appearance
        cardView.layer.cornerRadius = cardCornerRadius
        cardView.clipsToBounds = true
        cardView.backgroundColor = .white

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        cardTextLabel.textColor = .white
        cardTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        // cell shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // keep shadow matched to card bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius).cgPath

        // update gradient layer to match overlayView size (if present)
        if let overlay = overlayView {
            if let g = overlay.layer.sublayers?.first as? CAGradientLayer {
                g.frame = overlay.bounds
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // clean up overlay and image
        overlayView?.removeFromSuperview()
        overlayView = nil
        imageView.image = nil
    }

    // Public configure
    func configureMemoryLaneCell(imageName: String? = "image 102",
                                 title: String = "Visit the memory",
                                 subtitle: String = "Let’s take a walk down memory lane") {
        cardTextLabel.text = title
        subtitleLabel.text = subtitle

        if let name = imageName {
            imageView.image = UIImage(named: name)
        } else {
            imageView.image = nil
        }

        // Ensure layout is valid so label frames are measurable
        // We need to wait until AutoLayout laid out the labels; forcing layoutIfNeeded here helps when cell is being configured in data source callback.
        contentView.layoutIfNeeded()
        cardView.layoutIfNeeded()
        imageView.layoutIfNeeded()

        // Add/update overlay positioned to start just above the top of the text
        addOrUpdateOverlayPinnedToText()
    }

    // MARK: - Overlay logic

    private func addOrUpdateOverlayPinnedToText() {
        // Remove existing overlay (safe)
        overlayView?.removeFromSuperview()
        overlayView = nil

        // Compute top of text relative to cardView
        // Convert label bounds to cardView coordinate space
        let titleRectInCard = cardTextLabel.convert(cardTextLabel.bounds, to: cardView)
        let subtitleRectInCard = subtitleLabel.convert(subtitleLabel.bounds, to: cardView)

        // pick top-most (smallest y) of the two labels
        var topOfTextY = min(titleRectInCard.minY, subtitleRectInCard.minY)

        // If conversion produced values outside card (or 0), fallback to measuring from bottom using default ratio
        if topOfTextY.isNaN || topOfTextY < -cardView.bounds.height || topOfTextY > cardView.bounds.height {
            // fallback: place overlay to cover bottom area (fallback height)
            let overlay = makeOverlayView()
            cardView.addSubview(overlay)
            overlay.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                overlay.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
                overlay.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
                overlay.heightAnchor.constraint(equalToConstant: fallbackGradientHeight)
            ])
            overlayView = overlay
            // ensure gradient fills overlay (layoutSubviews will set layer.frame)
            setNeedsLayout()
            layoutIfNeeded()
            bringLabelsAboveOverlay()
            return
        }

        // Subtract small padding so gradient starts slightly above the text
        topOfTextY = max(0, topOfTextY - gradientTopPadding)

        // Create overlay and pin its top to that position and bottom to cardView bottom
        let overlay = makeOverlayView()
        cardView.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false

        // We set top constraint relative to cardView.top + topOfTextY
        let topConstraint = overlay.topAnchor.constraint(equalTo: cardView.topAnchor, constant: topOfTextY)
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            topConstraint,
            overlay.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        overlayView = overlay

        // Force layout so the gradient layer gets a correct frame immediately
        overlay.layoutIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()

        bringLabelsAboveOverlay()
    }

    private func makeOverlayView() -> UIView {
        let overlay = UIView()
        overlay.backgroundColor = .clear
        overlay.isUserInteractionEnabled = false
        overlay.tag = gradientOverlayTag

        // create gradient layer
        let g = CAGradientLayer()
        g.colors = [
            UIColor.black.withAlphaComponent(0.30).cgColor,
            UIColor.black.withAlphaComponent(0.0).cgColor
        ]
        g.startPoint = CGPoint(x: 0.5, y: 1.0)
        g.endPoint = CGPoint(x: 0.5, y: 0.0)
        g.locations = [0.0, 1.0]

        // initial frame is zero; it will be sized in layoutSubviews or immediately after constraints applied
        g.frame = overlay.bounds
        overlay.layer.addSublayer(g)
        overlay.layer.masksToBounds = true

        return overlay
    }

    private func bringLabelsAboveOverlay() {
        // ensure labels are on top
        cardView.bringSubviewToFront(cardTextLabel)
        cardView.bringSubviewToFront(subtitleLabel)
        cardTextLabel.layer.zPosition = 100
        subtitleLabel.layer.zPosition = 100
    }
}

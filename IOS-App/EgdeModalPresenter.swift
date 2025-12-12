import UIKit

/// EdgeModalPresenter - edge-to-edge bottom modal presenter.
/// Usage:
///   let presenter = EdgeModalPresenter()
///   presenter.heightFraction = 0.40
///   presenter.setContent(detailsVC)        // safe to call BEFORE presenting
///   presenter.presentAnimated(from: self)
final class EdgeModalPresenter: UIViewController {

    // Public configuration
    var heightFraction: CGFloat = 0.40   // 0.40 => 40% of available height
    var dimAlpha: CGFloat = 0.45
    var cornerRadius: CGFloat = 16

    // Private UI
    private let dimView = UIView()
    private let container = UIView()
    private let grabber = UIView()
    private var containerHeightConstraint: NSLayoutConstraint!
    private var contentVC: UIViewController?
    private var originalContainerHeight: CGFloat = 200
    private var isAnimating = false

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addGestures()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeightConstraintIfNeeded()
        // put container offscreen initially
        if container.transform == .identity {
            container.transform = CGAffineTransform(translationX: 0, y: containerHeightConstraint.constant)
            dimView.alpha = 0
        }
    }

    // MARK: - Public API

    /// Embed a view controller inside the container.
    /// Safe to call BEFORE presenting: this method will ensure the presenter's view is loaded.
    func setContent(_ vc: UIViewController) {
        // Ensure our view hierarchy exists
        loadViewIfNeeded()

        // Remove previous if any
        contentVC?.willMove(toParent: nil)
        contentVC?.view.removeFromSuperview()
        contentVC?.removeFromParent()

        // Add child
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(vc.view)

        // Layout constraints: fill container but keep top below grabber and respect safe area bottom
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 12),
            vc.view.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])

        vc.didMove(toParent: self)
        contentVC = vc
    }

    /// Present from any view controller
    func presentAnimated(from presentingVC: UIViewController, completion: (() -> Void)? = nil) {
        presentingVC.present(self, animated: false) {
            UIView.animate(withDuration: 0.32, delay: 0, options: [.curveEaseOut], animations: {
                self.dimView.alpha = self.dimAlpha
                self.container.transform = .identity
            }, completion: { _ in completion?() })
        }
    }

    /// Dismiss the presenter with animation
    func dismissAnimated(completion: (() -> Void)? = nil) {
        guard !isAnimating else { return }
        isAnimating = true
        UIView.animate(withDuration: 0.28, delay: 0, options: [.curveEaseIn], animations: {
            self.dimView.alpha = 0
            self.container.transform = CGAffineTransform(translationX: 0, y: self.containerHeightConstraint.constant)
        }, completion: { _ in
            self.dismiss(animated: false) {
                self.isAnimating = false
                completion?()
            }
        })
    }

    // MARK: - Private UI setup
    private func setupViews() {
        view.backgroundColor = .clear

        // Dim view
        dimView.backgroundColor = .black
        dimView.alpha = 0
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Container - edge-to-edge
        container.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 239/255, alpha: 1) // #FEF8EF
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = cornerRadius
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        container.clipsToBounds = true
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowRadius = 8
        container.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.addSubview(container)

        containerHeightConstraint = container.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),    // FULL WIDTH
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),  // FULL WIDTH
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerHeightConstraint
        ])

        // Grabber handle
        grabber.backgroundColor = UIColor.systemGray4
        grabber.layer.cornerRadius = 3
        grabber.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(grabber)
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            grabber.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 36),
            grabber.heightAnchor.constraint(equalToConstant: 6)
        ])
    }

    private func updateHeightConstraintIfNeeded() {
        let safeHeight = view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        let desired = max(120, floor(safeHeight * heightFraction))
        if containerHeightConstraint.constant != desired {
            containerHeightConstraint.constant = desired
            originalContainerHeight = desired
            view.layoutIfNeeded()
        }
    }

    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimTapped))
        dimView.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        container.addGestureRecognizer(pan)
    }

    @objc private func dimTapped() { dismissAnimated() }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        let t = g.translation(in: view)
        switch g.state {
        case .changed:
            let y = max(0, t.y)
            container.transform = CGAffineTransform(translationX: 0, y: y)
            dimView.alpha = max(0, dimAlpha * (1 - (y / (originalContainerHeight * 1.2))))
        case .ended, .cancelled:
            let velocity = g.velocity(in: view).y
            if t.y > (originalContainerHeight * 0.35) || velocity > 1000 {
                dismissAnimated()
            } else {
                UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: [.curveEaseOut], animations: {
                    self.container.transform = .identity
                    self.dimView.alpha = self.dimAlpha
                }, completion: nil)
            }
        default: break
        }
    }
}

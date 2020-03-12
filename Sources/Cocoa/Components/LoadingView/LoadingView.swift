//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Configuration where Type: LoadingView {
    public static var plain: Self {
        .init {
            $0.gradientView.colors = [.white, .white]
            $0.configure(message: nil)
        }
    }
}

final public class LoadingView: XCView {
    public typealias Configuration = Xcore.Configuration<LoadingView>
    public static var gradientViewClass: GradientView.Type = GradientView.self
    public private(set) lazy var gradientView = LoadingView.gradientViewClass.init()
    public let progressView = ProgressView()
    public let lhsImageView = UIImageView()
    public let rhsImageView = UIImageView()
    public let titleLabel = UILabel().apply {
        $0.font = .app(style: .footnote)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    public let footerLabel = UILabel().apply {
        $0.font = .app(style: .caption2)
        $0.textColor = UIColor.white.alpha(0.7)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    /// The default value is `.appTint`.
    public var navigationBarTintColor: UIColor = .appTint

    /// A convenience property to automatically adjust content mode to be
    /// `.scaleAspectFit` if the `image` is large or `.center` when the `image` is
    /// small or same size as `self`.
    ///
    /// The default value is `false`.
    public var isContentModeAutomaticallyAdjusted = false {
        didSet {
            adjustContentModeIfNeeded()
        }
    }

    private lazy var imagesStackView = UIStackView(arrangedSubviews: [
        lhsImageView,
        rhsImageView
    ]).apply {
        // Please don't change this number as this is the actual
        // distance between the arrow and logo.
        $0.spacing = 34
        $0.alignment = .center
    }

    private lazy var stackView = UIStackView(arrangedSubviews: [
        self.imagesStackView,
        self.titleLabel
    ]).apply {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = .maximumPadding
    }

    public var configuration: Configuration = .plain {
        didSet {
            configuration.configure(self)
        }
    }

    public convenience init(configuration: Configuration) {
        self.init(frame: .zero)
        self.configuration = configuration
        configuration.configure(self)
    }

    public override func commonInit() {
        setupGradientView()

        addSubview(stackView)
        stackView.anchor.make {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multiplier(0.7)
        }

        addSubview(progressView)
        progressView.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.top.equalToSuperview().inset(AppConstants.statusBarPlusNavBarHeight)
        }

        [lhsImageView, rhsImageView].forEach {
            $0.tintColor = .white
            $0.contentMode = .scaleAspectFit
        }

        addSubview(footerLabel)
        footerLabel.anchor.make {
            $0.horizontally.equalToSuperviewSafeArea().inset(CGFloat.defaultPadding)
            $0.bottom.equalToSuperviewSafeArea().inset(CGFloat.defaultPadding)
        }

        adjustContentModeIfNeeded()
    }

    private func setupGradientView() {
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        gradientView.anchor.edges.equalToSuperview()
    }

    private func adjustContentModeIfNeeded() {
        [lhsImageView, rhsImageView].forEach {
            $0.isContentModeAutomaticallyAdjusted = isContentModeAutomaticallyAdjusted
        }
    }

    /// Automatically set the width relative to the height to ensure image bounds
    /// are correct.
    private func updateImageViewConstraintsIfNeeded(image: UIImage?) {
        guard !rhsImageView.isHidden, let image = image else { return }

        rhsImageView.anchor.make {
            $0.width.equalTo(rhsImageView.anchor.height).multiplier(image.size.width / image.size.height)
        }
    }

    public func configure(message: String?, rhsImage: ImageRepresentable? = nil, footerMessage: String? = nil) {
        titleLabel.text = message
        rhsImageView.isHidden = rhsImage == nil
        titleLabel.isHidden = message == nil
        rhsImageView.setImage(rhsImage) { [weak self] image in
            self?.updateImageViewConstraintsIfNeeded(image: image)
        }
        footerLabel.text = footerMessage
    }

    // MARK: - UIAppearance Properties

    @objc public dynamic var titleTextColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    @objc public dynamic var titleFont: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }

    @objc public dynamic var footerTextColor: UIColor {
        get { footerLabel.textColor }
        set { footerLabel.textColor = newValue }
    }

    @objc public dynamic var footerFont: UIFont {
        get { footerLabel.font }
        set { footerLabel.font = newValue }
    }
}

// MARK: - ViewMaskable

extension LoadingView: ViewMaskable {
    @discardableResult
    public static func add(to superview: UIView) -> LoadingView {
        add(to: superview, configuration: .plain)
    }

    @discardableResult
    public static func add(to superview: UIView, configuration: Configuration) -> LoadingView {
        LoadingView().apply {
            superview.addSubview($0)
            $0.anchor.edges.equalToSuperview()
            $0.configuration = configuration
        }
    }

    public func dismiss(_ completion: (() -> Void)?) {
        UIView.animate(withDuration: .slow, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }

    public var preferredNavigationBarTintColor: UIColor {
        navigationBarTintColor
    }
}

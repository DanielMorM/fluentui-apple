//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - NavigationBarTopAccessoryViewAttributes

/// Layout attributes for a navigation bar's top accessory view.
@objc(MSFNavigationBarTopAccessoryViewAttributes)
open class NavigationBarTopAccessoryViewAttributes: NSObject {
    /// The width multiplier is the propotion of the navigation bar's width that the top accessory view will occupy.
    @objc public let widthMultiplier: CGFloat

    /// The maximum width of the top accessory view.
    @objc public let maxWidth: CGFloat

    /// The minimum width of the top accessory view.
    @objc public let minWidth: CGFloat

    @objc public init(widthMultiplier: CGFloat, maxWidth: CGFloat, minWidth: CGFloat) {
        self.widthMultiplier = widthMultiplier
        self.maxWidth = maxWidth
        self.minWidth = minWidth
        super.init()
    }

    public override init() {
        self.widthMultiplier = 1.0
        self.maxWidth = .greatestFiniteMagnitude
        self.minWidth = .zero
    }
}

/// Layout attributes for a navigation bar's top search bar.
@objc(MSFNavigationBarTopSearchBarAttributes)
open class NavigationBarTopSearchBarAttributes: NavigationBarTopAccessoryViewAttributes {
    @objc public override init() {
        super.init(widthMultiplier: Constants.widthMultiplier, maxWidth: Constants.viewMaxWidth, minWidth: Constants.viewMinWidth)
    }

    private struct Constants {
        static let widthMultiplier: CGFloat = 0.375
        static let viewMinWidth: CGFloat = 264
        static let viewMaxWidth: CGFloat = 552
    }
}

// MARK: - NavigationBarTitleAccessory

@objc(MSFNavigationBarTitleAccessoryDelegate)
/// Handles user interactions with a `NavigationBar` with an accessory.
public protocol NavigationBarTitleAccessoryDelegate {
    @objc func navigationBarDidTapOnTitle(_ sender: NavigationBar)
}

/// The specifications for an accessory to show in the title or subtitle of the navigation bar.
@objc(MSFNavigationBarTitleAccessory)
open class NavigationBarTitleAccessory: NSObject {
    /// Specifies a location where the title accessory should appear within the navigation bar.
    @objc(MSFNavigationBarTitleAccessoryLocation)
    public enum Location: Int {
        case title
        case subtitle
    }

    /// The style of title accessory to show.
    @objc(MSFNavigationBarTitleAccessoryStyle)
    public enum Style: Int {
        case disclosure
        case downArrow
    }

    /// The location of the accessory.
    public let location: Location
    /// The style of the accessory.
    public let style: Style
    /// A delegate that handles title press actions.
    public weak var delegate: NavigationBarTitleAccessoryDelegate?

    public init(location: Location, style: Style, delegate: NavigationBarTitleAccessoryDelegate? = nil) {
        self.location = location
        self.style = style
        self.delegate = delegate
    }
}

// MARK: - NavigationBarBackButtonDelegate
/// Handles presses from the back button shown with a leading-aligned title.
@objc(MSFNavigationBarBackButtonDelegate)
protocol NavigationBarBackButtonDelegate {
    func backButtonWasPressed()
}

// MARK: - NavigationBar

/// UINavigationBar subclass, with a content view that contains various custom UIElements
/// Contains the MSNavigationTitleView class and handles passing animatable progress through
/// Custom UI can be hidden if desired
@objc(MSFNavigationBar)
open class NavigationBar: UINavigationBar, TokenizedControlInternal, TwoLineTitleViewDelegate {
    /// If the style is `.custom`, UINavigationItem's `navigationBarColor` is used for all the subviews' backgroundColor
    @objc(MSFNavigationBarStyle)
    public enum Style: Int {
        case `default`
        case primary
        case system
        case custom
    }

    @objc public static func navigationBarBackgroundColor(fluentTheme: FluentTheme?) -> UIColor {
        return backgroundColor(for: .system, theme: fluentTheme)
    }

    /// Describes the sizing behavior of navigation bar elements (title, avatar, bar height)
    @objc(MSFNavigationBarElementSize)
    public enum ElementSize: Int {
        case automatic, contracted, expanded
    }

    @objc(MSFNavigationBarShadow)
    public enum Shadow: Int {
        case automatic
        case alwaysHidden
    }

    public typealias TokenSetKeyType = NavigationBarTokenSet.Tokens
    public lazy var tokenSet: NavigationBarTokenSet = .init(style: { [weak self] in
        self?.style ?? NavigationBar.defaultStyle
    })

    static let expansionContractionAnimationDuration: TimeInterval = 0.1 // the interval over which the expansion/contraction animations occur

    private static var defaultStyle: Style = .primary

    private struct Constants {
        static let systemHeight: CGFloat = 44
        static let normalContentHeight: CGFloat = 44
        static let expandedContentHeight: CGFloat = 48

        static let leftBarButtonItemLeadingMargin: CGFloat = GlobalTokens.spacing(.size80)
        static let leftBarButtonItemTrailingMargin: CGFloat = GlobalTokens.spacing(.size80)
        static let rightBarButtonItemHorizontalPadding: CGFloat = GlobalTokens.spacing(.size100)

        static let obscuringAnimationDuration: TimeInterval = 0.12
        static let revealingAnimationDuration: TimeInterval = 0.25
    }

    /// An object that conforms to the `MSFPersona` protocol and provides text and an optional image for display as an `MSAvatar` next to the large title. Only displayed if `showsLargeTitle` is true on the current navigation item. If avatar is nil, it won't show the avatar view.
    @objc open var personaData: Persona? {
        didSet {
            titleView.personaData = personaData
        }
    }

    /// A string to optionally customize the accessibility label of the large title's avatar
    @objc open var avatarCustomAccessibilityLabel: String? {
        didSet {
            titleView.avatarCustomAccessibilityLabel = avatarCustomAccessibilityLabel
        }
    }

    /// An element size to describe the behavior of large title's avatar. If `.automatic`, avatar will resize when `expand(animated:)` and `contract(animated:)` are called.
    @objc open var avatarSize: ElementSize = .automatic {
        didSet {
            updateElementSizes()
        }
    }

    @objc public func visibleAvatarView() -> UIView? {
        if contentStackView.alpha != 0 {
            return titleView.visibleAvatarView()
        }

        return nil
    }

    /// Returns the first match of an optional view for a bar button item with the given tag.
    @objc public func barButtonItemView(with tag: Int) -> UIView? {
        if showsLargeTitle {
            let totalBarButtonItemViews = leftBarButtonItemsStackView.arrangedSubviews + rightBarButtonItemsStackView.arrangedSubviews
            for view in totalBarButtonItemViews {
                if view.tag == tag {
                    return view
                }
            }
        } else {
            let totalBarButtonItems = (topItem?.leftBarButtonItems ?? []) + (topItem?.rightBarButtonItems ?? [])
            for item in totalBarButtonItems {
                if item.tag == tag {
                    return item.value(forKey: "view") as? UIView
                }
            }
        }
        return nil
    }

    /// An element size to describe the behavior of the navigation bar's expanded height. Set automatically when the values of `avatarSize` and `titleSize` are changed. The bar will lock to expanded size if either element is set to `.expanded`, lock to contracted if both elements are `.contracted`, and stay automatic in any other case.
    @objc open private(set) dynamic var barHeight: ElementSize = .automatic {
        didSet {
            guard barHeight != oldValue else {
                return
            }

            let originalIsExpanded = isExpanded

            switch barHeight {
            case .automatic:
                if isExpanded {
                    expand(true)
                } else {
                    contract(true)
                }
            case .contracted:
                contract(true)
            case .expanded:
                expand(true)
            }

            isExpanded = originalIsExpanded
        }
    }

    /// An element size to describe the behavior of the navigation bar's large title. If `.automatic`, the title label will resize when `expand(animated:)` and `contract(animated:)` are called.
    @objc open var titleSize: ElementSize = .automatic {
        didSet {
            updateElementSizes()
        }
    }

    /// An optional closure to be called when the avatar view is tapped, if it is present.
    @objc open var onAvatarTapped: (() -> Void)? {
        didSet {
            titleView.onAvatarTapped = onAvatarTapped
        }
    }

     /// The navigation bar's default leading content margin.
    @objc public static let defaultContentLeadingMargin: CGFloat = 8

     /// The navigation bar's default trailing content margin.
    @objc public static let defaultContentTrailingMargin: CGFloat = 6

    /// The navigation bar's leading content margin.
    @objc open var contentLeadingMargin: CGFloat = defaultContentLeadingMargin {
        didSet {
            if oldValue != contentLeadingMargin {
                updateContentStackViewMargins(forExpandedContent: contentIsExpanded)
            }
        }
    }

    /// The navigation bar's trailing content margin.
    @objc open var contentTrailingMargin: CGFloat = defaultContentTrailingMargin {
        didSet {
            if oldValue != contentTrailingMargin {
                updateContentStackViewMargins(forExpandedContent: contentIsExpanded)
            }
        }
    }

    open override var center: CGPoint {
        get { return super.center }
        set {
            var newValue = newValue
            // Workaround for iOS bug: when nav bar is hidden and device is rotated, the hidden nav bar get pushed up by additional 20px (status bar height) and when nav bar gets shown it animates from too far position leaving a 20px gap that shows window background (black by default) - this will then also affect nav bar hiding animation.
            newValue.y = max(-frame.height / 2, newValue.y)
            super.center = newValue
        }
    }

    var titleView = AvatarTitleView() {
        willSet {
            titleView.removeFromSuperview()
        }
        didSet {
            contentStackView.insertArrangedSubview(titleView, at: 0)
            titleView.setContentHuggingPriority(.required, for: .horizontal)
            titleView.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }

    // @objc dynamic - so we can do KVO on this
    @objc dynamic private(set) var style: Style = defaultStyle

    let backgroundView = UIView() //used for coloration
    //used to cover the navigationbar during animated transitions between VCs
    private let contentStackView = ContentStackView() //used to contain the various custom UI Elements
    private let rightBarButtonItemsStackView = UIStackView()
    private let leftBarButtonItemsStackView = UIStackView()
    private let leadingSpacerView = UIView() //defines the leading space between the left and right barbuttonitems stack
    private let trailingSpacerView = UIView() //defines the trailing space between the left and right barbuttonitems stack
    private var topAccessoryView: UIView?
    private var topAccessoryViewConstraints: [NSLayoutConstraint] = []

    private var showsLargeTitle: Bool = true {
        didSet {
            if showsLargeTitle == oldValue {
                return
            }
            updateAccessibilityElements()
            updateViewsForLargeTitlePresentation(for: topItem)
        }
    }

    private var leftBarButtonItemsObserver: NSKeyValueObservation?
    private var rightBarButtonItemsObserver: NSKeyValueObservation?
    private var titleObserver: NSKeyValueObservation?
    private var subtitleObserver: NSKeyValueObservation?
    private var titleAccessoryObserver: NSKeyValueObservation?
    private var titleImageObserver: NSKeyValueObservation?
    private var navigationBarColorObserver: NSKeyValueObservation?
    private var accessoryViewObserver: NSKeyValueObservation?
    private var topAccessoryViewObserver: NSKeyValueObservation?
    private var topAccessoryViewAttributesObserver: NSKeyValueObservation?
    private var navigationBarStyleObserver: NSKeyValueObservation?
    private var navigationBarShadowObserver: NSKeyValueObservation?
    private var usesLargeTitleObserver: NSKeyValueObservation?

    private let backButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage.staticImageNamed("back-24x24"), style: .plain, target: nil, action: #selector(NavigationBarBackButtonDelegate.backButtonWasPressed))

    weak var backButtonDelegate: NavigationBarBackButtonDelegate? {
        didSet {
            backButtonItem.target = backButtonDelegate
        }
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initBase()

    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBase()
    }

    /// Custom base initializer, used regardless of entry point
    /// Sets up the custom interface
    private func initBase() {
        clipsToBounds = true

        contain(view: backgroundView)

        setupContentStackView()
        contentStackView.isLayoutMarginsRelativeArrangement = true
        updateContentStackViewMargins(forExpandedContent: true)
        contentStackView.addInteraction(UILargeContentViewerInteraction())

        //leftBarButtonItemsStackView: layout priorities are slightly lower to make sure titleView has the highest priority in horizontal spacing
        contentStackView.addArrangedSubview(leftBarButtonItemsStackView)
        leftBarButtonItemsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        leftBarButtonItemsStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        //titleView
        contentStackView.addArrangedSubview(titleView)
        titleView.setContentHuggingPriority(.required, for: .horizontal)
        titleView.setContentCompressionResistancePriority(.required, for: .horizontal)

        //leadingSpacerView
        contentStackView.addArrangedSubview(leadingSpacerView)
        leadingSpacerView.backgroundColor = .clear
        leadingSpacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leadingSpacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        //trailingSpacerView
        contentStackView.addArrangedSubview(trailingSpacerView)
        trailingSpacerView.backgroundColor = .clear
        trailingSpacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        trailingSpacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        //rightBarButtonItemsStackView: layout priorities are slightly lower to make sure titleView has the highest priority in horizontal spacing
        contentStackView.addArrangedSubview(rightBarButtonItemsStackView)
        rightBarButtonItemsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightBarButtonItemsStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        isTranslucent = false

        // Cache the system shadow color
        systemShadowColor = standardAppearance.shadowColor

        updateColors(for: topItem)
        updateViewsForLargeTitlePresentation(for: topItem)
        updateAccessibilityElements()

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateColors(for: self?.topItem)
        }
    }

    private func updateTopAccessoryView(for navigationItem: UINavigationItem?) {
        if let topAccessoryView = topAccessoryView {
            topAccessoryView.removeFromSuperview()
        }

        self.topAccessoryView = navigationItem?.topAccessoryView

        if let topAccessoryView = self.topAccessoryView {
            topAccessoryView.translatesAutoresizingMaskIntoConstraints = false

            let insertionIndex = contentStackView.arrangedSubviews.firstIndex(of: leadingSpacerView)! + 1
            contentStackView.insertArrangedSubview(topAccessoryView, at: insertionIndex)

            NSLayoutConstraint.deactivate(topAccessoryViewConstraints)
            topAccessoryViewConstraints.removeAll()

            topAccessoryViewConstraints.append(contentsOf: [
                topAccessoryView.centerXAnchor.constraint(equalTo: centerXAnchor),
                topAccessoryView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

            if let attributes = navigationItem?.topAccessoryViewAttributes {
                let widthConstraint = topAccessoryView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: attributes.widthMultiplier)
                widthConstraint.priority = .defaultHigh

                let maxWidthConstraint = topAccessoryView.widthAnchor.constraint(lessThanOrEqualToConstant: attributes.maxWidth)
                maxWidthConstraint.priority = .defaultHigh

                topAccessoryViewConstraints.append(contentsOf: [
                    widthConstraint,
                    maxWidthConstraint,
                    topAccessoryView.widthAnchor.constraint(greaterThanOrEqualToConstant: attributes.minWidth)
                ])
            }

            NSLayoutConstraint.activate(topAccessoryViewConstraints)
        }
    }

    // Manually contains the content stack view with lower priority constraints in order to avoid invalid simultaneous constraints when nav bar is hidden.
    private func setupContentStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        let identifierHeader = String(describing: type(of: contentStackView))

        let leading = contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        leading.identifier = identifierHeader + "_containmentLeading"

        let trailing = contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.identifier = identifierHeader + "_containmentTrailing"
        trailing.priority = .defaultHigh

        let top = contentStackView.topAnchor.constraint(equalTo: topAnchor)
        top.identifier = identifierHeader + "_containmentTop"

        let bottom = contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.identifier = identifierHeader + "_containmentBottom"
        bottom.priority = .defaultHigh

        NSLayoutConstraint.activate([leading, trailing, top, bottom])

        if #available(iOS 15.0, *) {
            // These are consistent with UIKit's default navigation bar
            contentStackView.minimumContentSizeCategory = .large
            contentStackView.maximumContentSizeCategory = .extraExtraLarge
        }
    }

    private func updateContentStackViewMargins(forExpandedContent contentIsExpanded: Bool) {
        let contentHeight = contentIsExpanded ? Constants.expandedContentHeight : Constants.normalContentHeight
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: contentLeadingMargin,
            bottom: -(contentHeight - Constants.systemHeight),
            trailing: contentTrailingMargin
        )
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }

        tokenSet.update(newWindow.fluentTheme)
        titleView.tokenSet.update(newWindow.fluentTheme)
        titleView.tokenSet.setOverrides(from: tokenSet, mapping: [
            .titleColor: .titleColor,
            .titleFont: .titleFont,
            .subtitleColor: .subtitleColor,
            .subtitleFont: .subtitleFont,
            .largeTitleFont: .largeTitleFont
        ])

        updateColors(for: topItem)
    }

    /// Guarantees that the custom UI remains on top of the subview stack
    /// Fetches the current navigation item and triggers a UI update
    open override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(backgroundView)
        bringSubviewToFront(contentStackView)
        updateAccessibilityElements()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // contentStackView's content extends its bounds outside of navigation bar bounds
        return super.point(inside: point, with: event) ||
            contentStackView.point(inside: convert(point, to: contentStackView), with: event)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass {
            updateElementSizes()
            updateContentStackViewMargins(forExpandedContent: contentIsExpanded)

            // change bar button image size depending on device rotation
            if showsLargeTitle, let navigationItem = topItem {
                updateBarButtonItems(with: navigationItem)
            }
        }
    }

    /// Override the avatar with given style rather than using avatar data
    /// - Parameter style: style used in  the avatar
    @objc open func overrideAvatar(with style: MSFAvatarStyle) {
        titleView.avatarOverrideStyle = style
    }

    // MARK: Element size handling

    private var currentAvatarSize: ElementSize {
        if traitCollection.verticalSizeClass == .compact {
            return .contracted
        }
        return avatarSize
    }
    private var currentTitleSize: ElementSize {
        if traitCollection.verticalSizeClass == .compact {
            return .contracted
        }
        return titleSize
    }
    private var currentBarHeight: ElementSize {
        if currentAvatarSize == .expanded || currentTitleSize == .expanded {
            return .expanded
        } else if currentAvatarSize == .contracted && currentTitleSize == .contracted {
            return .contracted
        } else {
            return .automatic
        }
    }

    private var contentIsExpanded: Bool {
        return barHeight == .automatic ? isExpanded : barHeight == .expanded
    }

    private func updateElementSizes() {
        titleView.avatarSize = currentAvatarSize
        barHeight = currentBarHeight
    }

    // MARK: UINavigationItem & UIBarButtonItem handling

    func updateColors(for navigationItem: UINavigationItem?) {
        let color = navigationItem?.navigationBarColor(fluentTheme: tokenSet.fluentTheme)

        switch style {
        case .primary, .default, .custom:
            titleView.style = .primary
        case .system:
            titleView.style = .system
        }

        standardAppearance.backgroundColor = color
        backgroundView.backgroundColor = color
        tintColor = tokenSet[.buttonTintColor].uiColor
        standardAppearance.titleTextAttributes[NSAttributedString.Key.foregroundColor] = tokenSet[.titleColor].uiColor
        standardAppearance.largeTitleTextAttributes[NSAttributedString.Key.foregroundColor] = tokenSet[.titleColor].uiColor

        // Update the scroll edge appearance to match the new standard appearance
        scrollEdgeAppearance = standardAppearance

        navigationBarColorObserver = navigationItem?.observe(\.customNavigationBarColor) { [unowned self] navigationItem, _ in
            // Unlike title or barButtonItems that depends on the topItem, navigation bar color can be set from the parentViewController's navigationItem
            self.updateColors(for: navigationItem)
        }
    }

    func update(with navigationItem: UINavigationItem) {
        let (actualStyle, actualItem) = actualStyleAndItem(for: navigationItem)
        style = actualStyle
        updateColors(for: actualItem)
        showsLargeTitle = navigationItem.usesLargeTitle
        updateShadow(for: navigationItem)
        updateTopAccessoryView(for: navigationItem)
        updateSubtitleView(for: navigationItem)

        titleView.update(with: navigationItem)

        if navigationItem.backButtonTitle == nil {
            navigationItem.backButtonTitle = ""
        }
        updateBarButtonItems(with: navigationItem)

        // Force layout to avoid animation
        layoutIfNeeded()

        leftBarButtonItemsObserver = navigationItem.observe(\UINavigationItem.leftBarButtonItems) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        rightBarButtonItemsObserver = navigationItem.observe(\UINavigationItem.rightBarButtonItems) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        titleObserver = navigationItem.observe(\UINavigationItem.title) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        subtitleObserver = navigationItem.observe(\UINavigationItem.subtitle) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        titleAccessoryObserver = navigationItem.observe(\UINavigationItem.titleAccessory) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        titleImageObserver = navigationItem.observe(\UINavigationItem.titleImage) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        accessoryViewObserver = navigationItem.observe(\UINavigationItem.accessoryView) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        topAccessoryViewObserver = navigationItem.observe(\UINavigationItem.topAccessoryView) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        topAccessoryViewAttributesObserver = navigationItem.observe(\UINavigationItem.topAccessoryViewAttributes) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        navigationBarStyleObserver = navigationItem.observe(\UINavigationItem.navigationBarStyle) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        navigationBarShadowObserver = navigationItem.observe(\UINavigationItem.navigationBarShadow) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        usesLargeTitleObserver = navigationItem.observe(\UINavigationItem.usesLargeTitle) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
    }

    func actualStyleAndItem(for navigationItem: UINavigationItem) -> (style: Style, item: UINavigationItem) {
        if navigationItem.navigationBarStyle != .default {
            return (navigationItem.navigationBarStyle, navigationItem)
        }
        if let items = items?.prefix(while: { $0 != navigationItem }),
            let item = items.last(where: { $0.navigationBarStyle != .default }) {
            return (item.navigationBarStyle, item)
        }
        return (NavigationBar.defaultStyle, navigationItem)
    }

    private func createBarButtonItemButton(with item: UIBarButtonItem, isLeftItem: Bool) -> UIButton {
        let button = BadgeLabelButton(type: .system)
        button.item = item
        button.shouldUseWindowColorInBadge = style != .system

        if #available(iOS 15.0, *) {
            let insets: NSDirectionalEdgeInsets
            if isLeftItem {
                insets = NSDirectionalEdgeInsets(top: 0,
                                                 leading: Constants.leftBarButtonItemLeadingMargin,
                                                 bottom: 0,
                                                 trailing: Constants.leftBarButtonItemTrailingMargin)
            } else {
                insets = NSDirectionalEdgeInsets(top: 0,
                                                 leading: Constants.rightBarButtonItemHorizontalPadding,
                                                 bottom: 0,
                                                 trailing: Constants.rightBarButtonItemHorizontalPadding)
            }

            button.configuration?.contentInsets = insets
        } else {
            let leftInset: CGFloat
            let rightInset: CGFloat
            if isLeftItem {
                if effectiveUserInterfaceLayoutDirection == .rightToLeft {
                    leftInset = Constants.leftBarButtonItemTrailingMargin
                    rightInset = Constants.leftBarButtonItemLeadingMargin
                } else {
                    leftInset = Constants.leftBarButtonItemLeadingMargin
                    rightInset = Constants.leftBarButtonItemTrailingMargin
                }
            } else {
                leftInset = Constants.rightBarButtonItemHorizontalPadding
                rightInset = Constants.rightBarButtonItemHorizontalPadding
            }
            button.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: leftInset,
                                                    bottom: 0,
                                                    right: rightInset)
        }

        return button
    }

    /// Updates the bar button items.
    /// 
    /// In general, this should be called as late as possible when receiving a new navigation item
    /// because it will replace a client-provided left bar button item with a back button if needed.
    private func updateBarButtonItems(with navigationItem: UINavigationItem) {
        // only one left bar button item is support for large title view
        if navigationItem != items?.first {
            // Back button takes priority over client-provided leftBarButtonItem
            // navigationItem != items?.first is sufficient for knowing we won't be at the
            // root element of our navigation controller. This is because UINavigationItems
            // are unique to their view controllers, and you can't push the same view controller
            // onto a navigation stack more than once.
            leftBarButtonItemsStackView.isHidden = false

            // This gets called before the navigation stack gets updated
            if let items = items, let navigationItemIndex = items.firstIndex(of: navigationItem), navigationItemIndex > 0 {
                let upcomingBackItem = items[navigationItemIndex - 1]
                backButtonItem.title = upcomingBackItem.backButtonTitle
            } else {
                // Assume that this item is getting pushed onto the stack
                backButtonItem.title = topItem?.backButtonTitle
            }

            if !navigationItem.usesLargeTitle {
                let button = createBarButtonItemButton(with: backButtonItem, isLeftItem: true)
                // The OS already gives us the leading margin we want, so no need for additional insets
                if #available(iOS 15.0, *) {
                    button.configuration?.contentInsets.leading = 0
                } else if effectiveUserInterfaceLayoutDirection == .rightToLeft {
                    button.contentEdgeInsets.right = 0
                } else {
                    button.contentEdgeInsets.left = 0
                }
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            }

            refresh(barButtonStack: leftBarButtonItemsStackView, with: [backButtonItem], isLeftItem: true)
        } else if let leftBarButtonItem = navigationItem.leftBarButtonItem {
            leftBarButtonItemsStackView.isHidden = false
            refresh(barButtonStack: leftBarButtonItemsStackView, with: [leftBarButtonItem], isLeftItem: true)
        } else {
            leftBarButtonItemsStackView.isHidden = true
        }
        refresh(barButtonStack: rightBarButtonItemsStackView, with: navigationItem.rightBarButtonItems?.reversed(), isLeftItem: false)
    }

    private func refresh(barButtonStack: UIStackView, with items: [UIBarButtonItem]?, isLeftItem: Bool) {
        barButtonStack.removeAllSubviews()
        items?.forEach { item in
            barButtonStack.addArrangedSubview(createBarButtonItemButton(with: item, isLeftItem: isLeftItem))
        }
    }

    private func navigationItemDidUpdate(_ navigationItem: UINavigationItem) {
        if navigationItem == topItem {
            update(with: navigationItem)
        }
    }

    // MARK: Obscurant handling

    func obscureContent(animated: Bool) {
        if contentStackView.alpha == 1 {
            if animated {
                UIView.animate(withDuration: Constants.obscuringAnimationDuration) {
                    self.contentStackView.alpha = 0
                }
            } else {
                contentStackView.alpha = 0
            }
        }
    }

    func revealContent(animated: Bool) {
        if contentStackView.alpha == 0 {
            if animated {
                UIView.animate(withDuration: Constants.revealingAnimationDuration) {
                    self.contentStackView.alpha = 1
                }
            } else {
                contentStackView.alpha = 1
            }
        }
    }

    // MARK: Large/Normal Title handling

    /// Cache for the system shadow color, since the default value is private.
    private var systemShadowColor: UIColor?

    private func updateViewsForLargeTitlePresentation(for navigationItem: UINavigationItem?) {
        // UIView.isHidden has a bug where a series of repeated calls with the same parameter can "glitch" the view into a permanent shown/hidden state
        // i.e. repeatedly trying to hide a UIView that is already in the hidden state
        // by adding a check to the isHidden property prior to setting, we avoid such problematic scenarios
        if showsLargeTitle {
            if backgroundView.isHidden {
                backgroundView.isHidden = false
            }

            if contentStackView.isHidden {
                contentStackView.isHidden = false
            }

        } else {
            if !backgroundView.isHidden {
                backgroundView.isHidden = true
            }

            if !contentStackView.isHidden {
                contentStackView.isHidden = true
            }
        }
        updateShadow(for: navigationItem)
    }

    private func updateShadow(for navigationItem: UINavigationItem?) {
        if needsShadow(for: navigationItem) {
            standardAppearance.shadowColor = systemShadowColor
        } else {
            standardAppearance.shadowColor = nil
        }

        // Update the scroll edge shadow to match standard
        scrollEdgeAppearance = standardAppearance
    }

    private func needsShadow(for navigationItem: UINavigationItem?) -> Bool {
        switch navigationItem?.navigationBarShadow ?? .automatic {
        case .automatic:
            return !showsLargeTitle && style == .system && navigationItem?.accessoryView == nil
        case .alwaysHidden:
            return false
        }
    }

    private func updateSubtitleView(for navigationItem: UINavigationItem?) {
        guard let navigationItem = navigationItem else {
            // Use the default title view
            navigationItem?.titleView = nil
            return
        }

        let customTitleView = TwoLineTitleView(style: style == .primary ? .primary : .system)
        customTitleView.tokenSet.setOverrides(from: tokenSet, mapping: [
            .titleColor: .titleColor,
            .titleFont: .titleFont,
            .subtitleColor: .subtitleColor,
            .subtitleFont: .subtitleFont
        ])
        customTitleView.setup(navigationItem: navigationItem)
        if navigationItem.titleAccessory == nil {
            // Use default behavior of requesting an accessory expansion
            customTitleView.delegate = self
        }
        // For some strange reason, embedding the TwoLineTitleView inside a UIStackView
        // makes its labels resize properly according to content size changes.
        navigationItem.titleView = UIStackView(arrangedSubviews: [customTitleView])
    }

    // MARK: Content expansion/contraction

    private var isExpanded: Bool = true

    func expand(_ animated: Bool) {
        isExpanded = true

        titleView.expand(animated: animated)

        guard barHeight != .contracted else {
            return
        }
        let updateLayout = {
            self.updateContentStackViewMargins(forExpandedContent: true)
        }
        if animated {
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration) {
                updateLayout()
                self.contentStackView.layoutIfNeeded()
            }
        } else {
            updateLayout()
        }
    }

    func contract(_ animated: Bool) {
        isExpanded = false

        titleView.contract(animated: animated)

        guard barHeight != .expanded else {
            return
        }
        let updateLayout = {
            self.updateContentStackViewMargins(forExpandedContent: false)
        }
        if animated {
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration) {
                updateLayout()
                self.contentStackView.layoutIfNeeded()
            }
        } else {
            updateLayout()
        }
    }

    // MARK: Accessibility

    private func updateAccessibilityElements() {
        if showsLargeTitle {
            accessibilityElements = contentStackView.arrangedSubviews
        } else {
            accessibilityElements = nil
        }
    }

    // MARK: TwoLineTitleViewDelegate

    /// Tapping the regular two-line title view asks the accessory to expand.
    public func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView) {
        NotificationCenter.default.post(name: .accessoryExpansionRequested, object: self)
    }
}

// MARK: - ContentStackView

/// UIStackView subclass that extends its touch area outside of its bounds to cover content that is laid out outside of stack view bounds due to negative content margins.
private class ContentStackView: UIStackView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) {
            return true
        }
        let contentBounds = bounds.inset(by: layoutMargins)
        return contentBounds.contains(point)
    }
}

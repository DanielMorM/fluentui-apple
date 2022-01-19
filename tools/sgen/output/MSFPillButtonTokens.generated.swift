// swiftlint:disable all
/// Autogenerated file
import UIKit

/// Entry point for the app stylesheet
extension FluentUIStyle {

	// MARK: - MSFOnBrandPillButtonTokens
	open var MSFOnBrandPillButtonTokens: MSFOnBrandPillButtonTokensAppearanceProxy {
		return MSFOnBrandPillButtonTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFOnBrandPillButtonTokensAppearanceProxy: MSFPillButtonTokensAppearanceProxy {

		// MARK: - MSFOnBrandPillButtonTokensbackgroundColor
		open override var backgroundColor: MSFOnBrandPillButtonTokensbackgroundColorAppearanceProxy {
			return MSFOnBrandPillButtonTokensbackgroundColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFOnBrandPillButtonTokensbackgroundColorAppearanceProxy: MSFPillButtonTokensAppearanceProxy.backgroundColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.shade20, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - highlighted 
			open override var highlighted: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.shade10, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - hover 
			open override var hover: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.shade10, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.shade10, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey32", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedDisabled 
			open override var selectedDisabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey30", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedHighlighted 
			open override var selectedHighlighted: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey38", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey84", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}
		}


		// MARK: - MSFOnBrandPillButtonTokenstitleColor
		open override var titleColor: MSFOnBrandPillButtonTokenstitleColorAppearanceProxy {
			return MSFOnBrandPillButtonTokenstitleColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFOnBrandPillButtonTokenstitleColorAppearanceProxy: MSFPillButtonTokensAppearanceProxy.titleColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.shade10, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey26", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - highlighted 
			open override var highlighted: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey84", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey84", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.primary, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedDisabled 
			open override var selectedDisabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey74", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey44", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedHighlighted 
			open override var selectedHighlighted: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/black", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}
		}


		// MARK: - MSFOnBrandPillButtonTokensunreadDotColor
		open override var unreadDotColor: MSFOnBrandPillButtonTokensunreadDotColorAppearanceProxy {
			return MSFOnBrandPillButtonTokensunreadDotColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFOnBrandPillButtonTokensunreadDotColorAppearanceProxy: MSFPillButtonTokensAppearanceProxy.unreadDotColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return UIColor(light: mainProxy().Colors.Brand.shade10, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey26", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey84", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}
		}

	}
	// MARK: - MSFPillButtonTokens
	open var MSFPillButtonTokens: MSFPillButtonTokensAppearanceProxy {
		return MSFPillButtonTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFPillButtonTokensAppearanceProxy {
		public let mainProxy: () -> FluentUIStyle
		public init(proxy: @escaping () -> FluentUIStyle) {
			self.mainProxy = proxy
		}

		// MARK: - backgroundColor
		open var backgroundColor: backgroundColorAppearanceProxy {
			return backgroundColorAppearanceProxy(proxy: mainProxy)
		}
		open class backgroundColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey94", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - highlighted 
			open var highlighted: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey94", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - hover 
			open var hover: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey94", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - rest 
			open var rest: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey94", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey8", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selected 
			open var selected: UIColor {
				return mainProxy().Colors.Brand.primary
			}

			// MARK: - selectedDisabled 
			open var selectedDisabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey80", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey30", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedHighlighted 
			open var selectedHighlighted: UIColor {
				return mainProxy().Colors.Brand.primary
			}
		}


		// MARK: - bottomInset 
		open var bottomInset: CGFloat {
			return CGFloat(6.0)
		}

		// MARK: - font 
		open var font: UIFont {
			return UIFont.font(name: nil, size: 15.0, textStyle: nil, weight: UIFont.Weight.regular, traits: [], isScalable: false)
		}

		// MARK: - horizontalInset 
		open var horizontalInset: CGFloat {
			return mainProxy().Spacing.medium
		}

		// MARK: - titleColor
		open var titleColor: titleColorAppearanceProxy {
			return titleColorAppearanceProxy(proxy: mainProxy)
		}
		open class titleColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey70", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey26", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - highlighted 
			open var highlighted: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey38", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey84", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - rest 
			open var rest: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey38", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey84", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selected 
			open var selected: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/black", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedDisabled 
			open var selectedDisabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey94", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey44", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - selectedHighlighted 
			open var selectedHighlighted: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/black", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}
		}


		// MARK: - topInset 
		open var topInset: CGFloat {
			return CGFloat(6.0)
		}

		// MARK: - unreadDotColor
		open var unreadDotColor: unreadDotColorAppearanceProxy {
			return unreadDotColorAppearanceProxy(proxy: mainProxy)
		}
		open class unreadDotColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return UIColor(light: UIColor(named: "FluentColors/grey70", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey26", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
			}

			// MARK: - rest 
			open var rest: UIColor {
				return mainProxy().Colors.Brand.primary
			}
		}


		// MARK: - unreadDotOffsetX 
		open var unreadDotOffsetX: CGFloat {
			return CGFloat(6.0)
		}

		// MARK: - unreadDotOffsetY 
		open var unreadDotOffsetY: CGFloat {
			return CGFloat(3.0)
		}

		// MARK: - unreadDotSize 
		open var unreadDotSize: CGFloat {
			return CGFloat(6.0)
		}
	}

}
fileprivate var __AppearanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

extension MSFPillButtonTokens: AppearaceProxyComponent {

	public typealias AppearanceProxyType = FluentUIStyle.MSFPillButtonTokensAppearanceProxy
	public var appearanceProxy: AppearanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__AppearanceProxyHandle) as? AppearanceProxyType {
				if !themeAware { return proxy }

				if let proxyString = Optional(String(reflecting: type(of: proxy))), proxyString.hasPrefix("FluentUI") == false {
					return proxy
				}

				if proxy is FluentUIStyle.MSFOnBrandPillButtonTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFOnBrandPillButtonTokens
				}
				return proxy
			}

			return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFPillButtonTokens
		}
		set {
			objc_setAssociatedObject(self, &__AppearanceProxyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			didChangeAppearanceProxy()
		}
	}

	public var themeAware: Bool {
		get {
			guard let proxy = objc_getAssociatedObject(self, &__ThemeAwareHandle) as? Bool else { return true }
			return proxy
		}
		set {
			objc_setAssociatedObject(self, &__ThemeAwareHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			isObservingDidChangeTheme = newValue
		}
	}

	fileprivate var isObservingDidChangeTheme: Bool {
		get {
			guard let observing = objc_getAssociatedObject(self, &__ObservingDidChangeThemeHandle) as? Bool else { return false }
			return observing
		}
		set {
			if newValue == isObservingDidChangeTheme { return }
			if newValue {
				NotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceProxy), name: Notification.Name.didChangeTheme, object: nil)
			} else {
				NotificationCenter.default.removeObserver(self, name: Notification.Name.didChangeTheme, object: nil)
			}
			objc_setAssociatedObject(self, &__ObservingDidChangeThemeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
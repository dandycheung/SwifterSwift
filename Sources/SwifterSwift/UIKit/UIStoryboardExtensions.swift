// UIStoryboardExtensions.swift - Copyright 2025 SwifterSwift

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods

public extension UIStoryboard {
    /// SwifterSwift: Get main storyboard for application.
    static var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }

    /// SwifterSwift: Instantiate a UIViewController using its class name.
    ///
    /// - Parameter name: UIViewController type.
    /// - Returns: The view controller corresponding to specified class name.
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}

#endif

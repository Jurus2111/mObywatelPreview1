import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle {
        return Bundle.main
    }
}
#endif

public let bundle: Bundle = .module


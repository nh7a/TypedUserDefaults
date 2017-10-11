import Foundation

public extension UserDefaults {
    public class Key {
        public let string: String
        public init(_ key: String) { string = key }
    }
    
    public class OptionalKey<T>: Key {}
    public class DefaultKey<T>: Key {
        public let defaultValue: T
        public init(_ key: String, default value: T) { defaultValue = value; super.init(key) }
    }
}

public extension UserDefaults {
    // MARK: - Remove by Key
    public func removeObject(forKey key: Key) {
        removeObject(forKey: key.string)
    }
    
    // MARK: - Access with Key
    public subscript<T>(key: DefaultKey<T>) -> T {
        set { set(newValue, forKey: key.string) }
        get {
            return object(forKey: key.string) as? T ?? key.defaultValue
        }
    }
    
    public subscript<T>(key: OptionalKey<T>) -> T? {
        set { set(newValue, forKey: key.string) }
        get {
            return object(forKey: key.string) as? T
        }
    }
}

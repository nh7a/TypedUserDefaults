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

// MARK: - Special treatment for Bool, Int, Float, Double, and URL
public extension UserDefaults {
    
    public subscript(key: DefaultKey<Bool>) -> Bool {
        set { set(newValue, forKey: key.string) }
        get {
            return object(forKey: key.string) == nil ?
                key.defaultValue : bool(forKey: key.string)
        }
    }
    
    public subscript(key: DefaultKey<Int>) -> Int {
        set { set(newValue, forKey: key.string) }
        get {
            return object(forKey: key.string) == nil ?
                key.defaultValue : integer(forKey: key.string)
        }
    }
    
    public subscript(key: DefaultKey<Float>) -> Float {
        set { set(newValue, forKey: key.string) }
        get {
            return object(forKey: key.string) == nil ?
                key.defaultValue : float(forKey: key.string)
        }
    }
    
    public subscript(key: DefaultKey<Double>) -> Double {
        set { set(newValue, forKey: key.string) }
        get {
            return object(forKey: key.string) == nil ?
                key.defaultValue : double(forKey: key.string)
        }
    }

    public subscript(key: DefaultKey<URL>) -> URL {
        set { set(newValue, forKey: key.string) }
        get {
            return url(forKey: key.string) ?? key.defaultValue
        }
    }

    public subscript(key: OptionalKey<URL>) -> URL? {
        set { set(newValue, forKey: key.string) }
        get {
            return url(forKey: key.string)
        }
    }
}

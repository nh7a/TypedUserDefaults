import XCTest
@testable import TypedUserDefaults

extension UserDefaults.Key {
    static let custom = UserDefaults.OptionalKey<Custom>("custom")
}

struct Custom {
    var int8: Int8
    var int16: Int16
    var int32: Int32
    var int64: Int64
}

extension UserDefaults {
    subscript(key: OptionalKey<Custom>) -> Custom? {
        set {
            if let newValue = newValue {
                set([newValue.int8, newValue.int16, newValue.int32, newValue.int64], forKey: key.string)
            } else {
                set(nil, forKey: key.string)
            }
        }
        get {
            if let arr = object(forKey: key.string) as? [Int64], arr.count == 4 {
                return Custom(int8: Int8(arr[0]), int16: Int16(arr[1]), int32: Int32(arr[2]), int64: arr[3])
            } else {
                return nil
            }
        }
    }
}

class TypedUserDefaultsTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - OptionalKey
    
    func testOptionalBool() {
        let key = UserDefaults.OptionalKey<Bool>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        UserDefaults.standard[key] = false
        XCTAssertFalse(UserDefaults.standard[key]!)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "key"))
        
        UserDefaults.standard[key] = true
        XCTAssertTrue(UserDefaults.standard[key]!)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set(false, forKey: "key")
        XCTAssertFalse(UserDefaults.standard[key]!)

        UserDefaults.standard.set("true", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalInteger() {
        let key = UserDefaults.OptionalKey<Int>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        UserDefaults.standard[key] = 67890
        XCTAssertEqual(67890, UserDefaults.standard[key]!)
        XCTAssertEqual(67890, UserDefaults.standard.integer(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set(13579, forKey: "key")
        XCTAssertEqual(13579, UserDefaults.standard[key]!)
        UserDefaults.standard.set("24680", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }

    func testOptionalFloat() {
        let key = UserDefaults.OptionalKey<Float>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        UserDefaults.standard[key] = 9.8765
        XCTAssertEqual(9.8765, UserDefaults.standard[key])
        XCTAssertEqual(9.8765, UserDefaults.standard.float(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set(3.141592, forKey: "key")
        XCTAssertEqual(3.141592, UserDefaults.standard[key]!)
        UserDefaults.standard.set("2.718281828", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalDouble() {
        let key = UserDefaults.OptionalKey<Double>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        UserDefaults.standard[key] = 9.8765
        XCTAssertEqual(9.8765, UserDefaults.standard[key])
        XCTAssertEqual(9.8765, UserDefaults.standard.double(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set(3.141592, forKey: "key")
        XCTAssertEqual(3.141592, UserDefaults.standard[key]!)
        UserDefaults.standard.set("2.718281828", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalString() {
        let key = UserDefaults.OptionalKey<String>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        UserDefaults.standard[key] = "bar"
        XCTAssertEqual("bar", UserDefaults.standard[key])
        XCTAssertEqual("bar", UserDefaults.standard.string(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set("baz", forKey: "key")
        XCTAssertEqual("baz", UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set(Date(), forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalData() {
        let key = UserDefaults.OptionalKey<Data>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let deadbeef = Data(bytes: [0xde, 0xad, 0xbe, 0xef])
        UserDefaults.standard[key] = deadbeef
        XCTAssertEqual(deadbeef, UserDefaults.standard[key])
        XCTAssertEqual(deadbeef, UserDefaults.standard.object(forKey: "key") as! Data)
        
        // set without key
        let fee1dead = Data(bytes: [0xfe, 0xe1, 0xde, 0xad])
        UserDefaults.standard.set(fee1dead, forKey: "key")
        XCTAssertEqual(fee1dead, UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalArray() {
        let key = UserDefaults.OptionalKey<[Int]>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let deadbeef = [0xde, 0xad, 0xbe, 0xef]
        UserDefaults.standard[key] = deadbeef
        XCTAssertEqual(deadbeef, UserDefaults.standard[key]!)
        XCTAssertEqual(deadbeef, UserDefaults.standard.object(forKey: "key") as! [Int])
        
        // set without key
        let fee1dead = [0xfe, 0xe1, 0xde, 0xad]
        UserDefaults.standard.set(fee1dead, forKey: "key")
        XCTAssertEqual(fee1dead, UserDefaults.standard[key]!)
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalDictionary() {
        let key = UserDefaults.OptionalKey<[String: Int]>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let baz = ["baz": 3]
        UserDefaults.standard[key] = baz
        XCTAssertEqual(baz, UserDefaults.standard[key]!)
        XCTAssertEqual(baz, UserDefaults.standard.object(forKey: "key") as! [String: Int])
        
        // set without key
        let dang = ["dang": 4]
        UserDefaults.standard.set(dang, forKey: "key")
        XCTAssertEqual(dang, UserDefaults.standard[key]!)
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalURL() {
        let key = UserDefaults.OptionalKey<URL>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let ddg = URL(string: "https://duckduckgo.com")!
        UserDefaults.standard[key] = ddg
        XCTAssertEqual(ddg, UserDefaults.standard[key]!)
        XCTAssertEqual(ddg, UserDefaults.standard.url(forKey: "key"))
        
        // set without key
        let twitter = URL(string: "https://twitter.com")!
        UserDefaults.standard.set(twitter, forKey: "key")
        XCTAssertEqual(twitter, UserDefaults.standard[key]!)
        
        // invalid data
        UserDefaults.standard.set(Date(), forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalDate() {
        let key = UserDefaults.OptionalKey<Date>("key")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertNil(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let future = Date().addingTimeInterval(12345)
        UserDefaults.standard[key] = future
        XCTAssertEqual(future, UserDefaults.standard[key]!)
        XCTAssertEqual(future, UserDefaults.standard.object(forKey: "key") as! Date)
        
        // set without key
        let past = Date().addingTimeInterval(-12345)
        UserDefaults.standard.set(past, forKey: "key")
        XCTAssertEqual(past, UserDefaults.standard[key]!)
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertNil(UserDefaults.standard[key])
    }
    
    func testOptionalCustom() {
        // default value
        UserDefaults.standard.removeObject(forKey: .custom)
        XCTAssertNil(UserDefaults.standard[.custom])
        XCTAssertNil(UserDefaults.standard.object(forKey: "custom"))

        // set by key
        UserDefaults.standard[.custom] = Custom(int8: 12, int16: 34, int32: 56, int64: 78)
        let custom = UserDefaults.standard[.custom]
        XCTAssertEqual(custom?.int8, 12)
        XCTAssertEqual(custom?.int16, 34)
        XCTAssertEqual(custom?.int32, 56)
        XCTAssertEqual(custom?.int64, 78)
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "custom")
        XCTAssertNil(UserDefaults.standard[.custom])
    }

    // MARK: - DefaultKey

    func testDefaultBool() {
        let key = UserDefaults.DefaultKey<Bool>("key", default: true)

        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertTrue(UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))

        // set by key
        UserDefaults.standard[key] = false
        XCTAssertFalse(UserDefaults.standard[key])
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "key"))

        UserDefaults.standard[key] = true
        XCTAssertTrue(UserDefaults.standard[key])
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "key"))

        // set without key
        UserDefaults.standard.set(false, forKey: "key")
        XCTAssertFalse(UserDefaults.standard[key])
        
        UserDefaults.standard.set("true", forKey: "key")
        XCTAssertTrue(UserDefaults.standard[key])


        UserDefaults.standard.set("0", forKey: "key")
        XCTAssertFalse(UserDefaults.standard[key])

        UserDefaults.standard.set("1", forKey: "key")
        XCTAssertTrue(UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertFalse(UserDefaults.standard[key])  // false by Foundation
    }

    func testDefaultInteger() {
        let key = UserDefaults.DefaultKey<Int>("key", default: 12345)

        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(12345, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        UserDefaults.standard[key] = 67890
        XCTAssertEqual(67890, UserDefaults.standard[key])
        XCTAssertEqual(67890, UserDefaults.standard.integer(forKey: "key"))

        // set without key
        UserDefaults.standard.set(13579, forKey: "key")
        XCTAssertEqual(13579, UserDefaults.standard[key])
        UserDefaults.standard.set("24680", forKey: "key")
        XCTAssertEqual(24680, UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(0, UserDefaults.standard[key])  // 0 by Foundation
    }

    func testDefaultFloat() {
        let key = UserDefaults.DefaultKey<Float>("key", default: -0.12345)
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(-0.12345, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))

        // set by key
        UserDefaults.standard[key] = 9.8765
        XCTAssertEqual(9.8765, UserDefaults.standard[key])
        XCTAssertEqual(9.8765, UserDefaults.standard.float(forKey: "key"))

        // set without key
        UserDefaults.standard.set(3.141592, forKey: "key")
        XCTAssertEqual(3.141592, UserDefaults.standard[key])
        UserDefaults.standard.set("2.718281828", forKey: "key")
        XCTAssertEqual(2.718281828, UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(0, UserDefaults.standard[key])  // 0 by Foundation
    }

    func testDefaultDouble() {
        let key = UserDefaults.DefaultKey<Double>("key", default: -0.12345)
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(-0.12345, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))

        // set by key
        UserDefaults.standard[key] = 9.8765
        XCTAssertEqual(9.8765, UserDefaults.standard[key])
        XCTAssertEqual(9.8765, UserDefaults.standard.double(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set(3.141592, forKey: "key")
        XCTAssertEqual(3.141592, UserDefaults.standard[key])
        UserDefaults.standard.set("2.718281828", forKey: "key")
        XCTAssertEqual(2.718281828, UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(0, UserDefaults.standard[key])  // 0 by Foundation
    }
    
    func testDefaultString() {
        let key = UserDefaults.DefaultKey<String>("key", default: "foo")
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual("foo", UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))

        // set by key
        UserDefaults.standard[key] = "bar"
        XCTAssertEqual("bar", UserDefaults.standard[key])
        XCTAssertEqual("bar", UserDefaults.standard.string(forKey: "key"))
        
        // set without key
        UserDefaults.standard.set("baz", forKey: "key")
        XCTAssertEqual("baz", UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set(Date(), forKey: "key")
        XCTAssertEqual("foo", UserDefaults.standard[key])
    }

    func testDefaultData() {
        let a5a5a5a5 = Data(bytes: [0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5])
        let key = UserDefaults.DefaultKey<Data>("key", default: a5a5a5a5)
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(a5a5a5a5, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))

        // set by key
        let deadbeef = Data(bytes: [0xde, 0xad, 0xbe, 0xef])
        UserDefaults.standard[key] = deadbeef
        XCTAssertEqual(deadbeef, UserDefaults.standard[key])
        XCTAssertEqual(deadbeef, UserDefaults.standard.object(forKey: "key") as! Data)
        
        // set without key
        let fee1dead = Data(bytes: [0xfe, 0xe1, 0xde, 0xad])
        UserDefaults.standard.set(fee1dead, forKey: "key")
        XCTAssertEqual(fee1dead, UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(a5a5a5a5, UserDefaults.standard[key])
    }

    func testDefaultArray() {
        let a5a5a5a5 = [0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5]
        let key = UserDefaults.DefaultKey<[Int]>("key", default: a5a5a5a5)
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(a5a5a5a5, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let deadbeef = [0xde, 0xad, 0xbe, 0xef]
        UserDefaults.standard[key] = deadbeef
        XCTAssertEqual(deadbeef, UserDefaults.standard[key])
        XCTAssertEqual(deadbeef, UserDefaults.standard.object(forKey: "key") as! [Int])
        
        // set without key
        let fee1dead = [0xfe, 0xe1, 0xde, 0xad]
        UserDefaults.standard.set(fee1dead, forKey: "key")
        XCTAssertEqual(fee1dead, UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(a5a5a5a5, UserDefaults.standard[key])
    }

    func testDefaultDictionary() {
        let dict = ["foo": 1, "bar": 2]
        let key = UserDefaults.DefaultKey<[String: Int]>("key", default: dict)
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(dict, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let baz = ["baz": 3]
        UserDefaults.standard[key] = baz
        XCTAssertEqual(baz, UserDefaults.standard[key])
        XCTAssertEqual(baz, UserDefaults.standard.object(forKey: "key") as! [String: Int])
        
        // set without key
        let dang = ["dang": 4]
        UserDefaults.standard.set(dang, forKey: "key")
        XCTAssertEqual(dang, UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(dict, UserDefaults.standard[key])
    }

    func testDefaultURL() {
        let url = URL(string: "https://example.com")!
        let key = UserDefaults.DefaultKey<URL>("key", default: url)

        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(url, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))

        // set by key
        let ddg = URL(string: "https://duckduckgo.com")!
        UserDefaults.standard[key] = ddg
        XCTAssertEqual(ddg, UserDefaults.standard[key])
        XCTAssertEqual(ddg, UserDefaults.standard.url(forKey: "key"))

        // set without key
        let twitter = URL(string: "https://twitter.com")!
        UserDefaults.standard.set(twitter, forKey: "key")
        XCTAssertEqual(twitter, UserDefaults.standard[key])

        // invalid data
        UserDefaults.standard.set(Date(), forKey: "key")
        XCTAssertEqual(url, UserDefaults.standard[key])
    }

    func testDefaultDate() {
        let now = Date()
        let key = UserDefaults.DefaultKey<Date>("key", default: now)
        
        // default value
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(now, UserDefaults.standard[key])
        XCTAssertNil(UserDefaults.standard.object(forKey: "key"))
        
        // set by key
        let future = now.addingTimeInterval(12345)
        UserDefaults.standard[key] = future
        XCTAssertEqual(future, UserDefaults.standard[key])
        XCTAssertEqual(future, UserDefaults.standard.object(forKey: "key") as! Date)
        
        // set without key
        let past = now.addingTimeInterval(-12345)
        UserDefaults.standard.set(past, forKey: "key")
        XCTAssertEqual(past, UserDefaults.standard[key])
        
        // invalid data
        UserDefaults.standard.set("foo", forKey: "key")
        XCTAssertEqual(now, UserDefaults.standard[key])
    }
    
    // MARK: -
    
    static var allTests = [
        ("testOptionalBool", testOptionalBool),
        ("testOptionalInteger", testOptionalInteger),
        ("testOptionalFloat", testOptionalFloat),
        ("testOptionalDouble", testOptionalDouble),
        ("testOptionalString", testOptionalString),
        ("testOptionalArray", testOptionalArray),
        ("testOptionalDictionary", testOptionalDictionary),
        ("testOptionalURL", testOptionalURL),
        ("testOptionalDate", testOptionalDate),
        ("testOptionalCustom", testOptionalCustom),
        ("testDefaultBool", testDefaultBool),
        ("testDefaultInteger", testDefaultInteger),
        ("testDefaultFloat", testDefaultFloat),
        ("testDefaultDouble", testDefaultDouble),
        ("testDefaultString", testDefaultString),
        ("testDefaultArray", testDefaultArray),
        ("testDefaultDictionary", testDefaultDictionary),
        ("testDefaultURL", testDefaultURL),
        ("testDefaultDate", testDefaultDate),
    ]
}

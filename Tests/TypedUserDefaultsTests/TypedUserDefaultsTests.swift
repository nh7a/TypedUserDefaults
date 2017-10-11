import XCTest
@testable import TypedUserDefaults

extension UserDefaults.Key {
    static let foo = UserDefaults.DefaultKey<Bool>("foo", default: false)
    static let bar = UserDefaults.OptionalKey<String>("bar")
    static let baz = UserDefaults.OptionalKey<Custom>("baz")
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
    
    func testDefaultKey() {
        XCTAssertFalse(UserDefaults.standard[.foo])
        UserDefaults.standard[.foo] = true
        XCTAssertTrue(UserDefaults.standard[.foo])
    }

    func testOptionalKey() {
        XCTAssertNil(UserDefaults.standard[.bar])
        UserDefaults.standard[.bar] = "blah blah"
        XCTAssertEqual(UserDefaults.standard[.bar], "blah blah")
        UserDefaults.standard.synchronize()
    }

    func testCustomKey() {
        XCTAssertNil(UserDefaults.standard[.baz])
        UserDefaults.standard[.baz] = Custom(int8: 12, int16: 34, int32: 56, int64: 78)
        let baz = UserDefaults.standard[.baz]
        XCTAssertEqual(baz?.int8, 12)
        XCTAssertEqual(baz?.int16, 34)
        XCTAssertEqual(baz?.int32, 56)
        XCTAssertEqual(baz?.int64, 78)
        UserDefaults.standard.synchronize()
    }

    static var allTests = [
        ("testDefaultKey", testDefaultKey),
        ("testOptionalKey", testOptionalKey),
        ("testCustomKey", testCustomKey)
    ]
}

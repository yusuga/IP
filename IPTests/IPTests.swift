//
//  IPTests.swift
//  IPTests
//
//  Created by Yu Sugawara on 2/4/17.
//  Copyright © 2017 Yu Sugawara. All rights reserved.
//

import XCTest
import IP

class IPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIPv4Address() {
        let regex = try! NSRegularExpression(pattern: "^\(IP.Version.IPv4AddressRegexPattern)$")
        
        /*
         ABNF:
         dec-octet =
         DIGIT                   ; 0-9
         / %x31-39 DIGIT         ; 10-99
         / "1" 2DIGIT            ; 100-199
         / "2" %x30-34 DIGIT     ; 200-249
         / "25" %x30-35          ; 250-255
         
         IPv4address = dec-octet "." dec-octet "." dec-octet "." dec-octet
         */
        
        let successes = [
            "0.0.0.0",
            "9.9.9.9",
            "10.10.10.10",
            "99.99.99.99",
            "100.100.100.100",
            "255.255.255.255",
            "00.0.0.0", // 2桁の0を許容
            "000.0.0.0", // 3桁の0を許容
        ]
        
        for source in successes {
            print("\(#function) > source: \(source)")
            let range = NSRange(location: 0, length: source.characters.count)
            XCTAssertNotNil(regex.firstMatch(in: source, range: range), "`\(source)`")
        }
        
        let failures = [
            "0", "0.0", "0.0.0", // 4グループない
            "0000.0.0.0", // 3桁を超える
            "256.0.0.0", // 255を超える
        ]
        
        for source in failures {
            print("\(#function) > source: \(source)")
            let range = NSRange(location: 0, length: source.characters.count)
            XCTAssertNil(regex.firstMatch(in: source, range: range), "`\(source)`")
        }
    }
    
    func testIPv6Address() {
        let regex = try! NSRegularExpression(pattern: "^\(IP.Version.IPv6AddressRegexPattern)$")
        
        let successes = [
            "0000:0000:0000:0000:0000:0000:0000:0000",
            "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff",
            "FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF", // 大文字
            "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
            "2001:db8:85a3:0:0:8a2e:370:7334", // 各区切りの先頭の連続する0は省略可能
            "2001:db8:85a3::8a2e:370:7334", // 1つ以上の0だけのグループは、"::"で表記可能
            "0:0:0:0:0:0:0:1",
            "::1", // localhost（ループバック）アドレス`0:0:0:0:0:0:0:1 `の別表記
            "::", // IPv6未指定アドレス`0:0:0:0:0:0:0:0`の別表記
        ]
        
        for source in successes {
            print("\(#function) > source: \(source)")
            let range = NSRange(location: 0, length: source.characters.count)
            XCTAssertNotNil(regex.firstMatch(in: source, range: range), "`\(source)`")
        }
        
        let failures = [
            "0", "0:0", "0:0:0", "0:0:0:0", "0:0:0:0:0", "0:0:0:0:0:0", // 8グループない
            "00000:0:0:0:0:0:0:1", // 4桁を超える
            "g:0:0:0:0:0:0:1", // `[0-9A-Fa-f]`以外を含む
        ]
        
        for source in failures {
            print("\(#function) > source: \(source)")
            let range = NSRange(location: 0, length: source.characters.count)
            XCTAssertNil(regex.firstMatch(in: source, range: range), "`\(source)`")
        }
    }
    
    func testInitIP() {
        XCTAssertNotNil(try IP(address: "192.168.1.1", port: 0))
        XCTAssertThrowsError(try IP(address: "xxx", port: 0))
    }
    
    func testNetworkAddress() {
        XCTAssertEqual(try! IP(address: "192.168.125.130").networkAddress("255.255.255.192"),
                       "192.168.125.128")
        XCTAssertEqual(try! IP(address: "192.168.125.130").networkAddress(26),
                       "192.168.125.128")
    }
    
    func testBroadcastAddress() {
        XCTAssertEqual(try! IP(address: "192.168.125.130").broadcastAddress("255.255.255.192"),
                       "192.168.125.191")
        XCTAssertEqual(try! IP(address: "192.168.125.130").broadcastAddress(26),
                       "192.168.125.191")
    }
    
}

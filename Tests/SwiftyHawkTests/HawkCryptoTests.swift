//
//  HawkCryptoTests.swift
//  SwiftyHawkTests
//
//  Created by Christoph Pageler on 20.11.17.
//

import XCTest
@testable import SwiftyHawk

class HawkCryptoTests: XCTestCase {
    
    /// https://github.com/hueniverse/hawk/blob/master/test/crypto.js#L25
    func testGenerateNormalizedStringShouldReturnAValidNormalizedString() {
        let string = Hawk.Crypto.generateNormalizedString(type: "header",
                                                          resource: "/resource/something",
                                                          timestamp: 1357747017,
                                                          nonce: "k3k4j5",
                                                          method: "GET",
                                                          host: "example.com",
                                                          port: 8080)
        XCTAssertEqual(string, "hawk.1.header\n1357747017\nk3k4j5\nGET\n/resource/something\nexample.com\n8080\n\n\n")
    }
    
    
    /// https://github.com/hueniverse/hawk/blob/master/test/crypto.js#L37
    func testGenerateNormalizedStringShouldReturnAValidNormalizedStringExt() {
        let string = Hawk.Crypto.generateNormalizedString(type: "header",
                                                          resource: "/resource/something",
                                                          timestamp: 1357747017,
                                                          nonce: "k3k4j5",
                                                          method: "GET",
                                                          host: "example.com",
                                                          port: 8080,
                                                          ext: "this is some app data")
        XCTAssertEqual(string, "hawk.1.header\n1357747017\nk3k4j5\nGET\n/resource/something\nexample.com\n8080\n\nthis is some app data\n")
    }
    
    
    /// https://github.com/hueniverse/hawk/blob/master/test/crypto.js#L50
    func testGenerateNormalizedStringShouldReturnAValidNormalizedStringPayloadExt() {
        let string = Hawk.Crypto.generateNormalizedString(type: "header",
                                                          resource: "/resource/something",
                                                          timestamp: 1357747017,
                                                          nonce: "k3k4j5",
                                                          method: "GET",
                                                          host: "example.com",
                                                          port: 8080,
                                                          hash: "U4MKKSmiVxk37JCCrAVIjV/OhB3y+NdwoCr6RShbVkE=",
                                                          ext: "this is some app data")
        XCTAssertEqual(string, "hawk.1.header\n1357747017\nk3k4j5\nGET\n/resource/something\nexample.com\n8080\nU4MKKSmiVxk37JCCrAVIjV/OhB3y+NdwoCr6RShbVkE=\nthis is some app data\n")
    }
}

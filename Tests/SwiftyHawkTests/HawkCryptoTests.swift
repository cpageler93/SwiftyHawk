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
    
    /// https://github.com/tent/hawk-objc/blob/master/HawkTests/HawkTests.m#L42
    func testCalculatePayloadHashShouldReturnAValidHash() {
        
        guard let hash = try? Hawk.Crypto.calculatePayloadHash(payload: "{\"type\":\"https://tent.io/types/status/v0#\"}",
                                                               algorith: .sha256,
                                                               contentType: "application/vnd.tent.post.v0+json")
        else {
            XCTFail("Failed to calculate payload")
            return
        }
                
        XCTAssertEqual(hash, "neQFHgYKl/jFqDINrC21uLS0gkFglTz789rzcSr7HYU=")
        
    }
    
    /// https://github.com/tent/hawk-objc/blob/master/HawkTests/HawkTests.m#L51
    func testCalculateMacShouldReturnAValidMac() {
        let credentials = Hawk.Credentials(id: "exqbZWtykFZIh2D7cXi9dA", key: "HX9QcbD-r3ItFEnRcAuOSg", algoritm: .sha256)
        guard let hash = try? Hawk.Crypto.calculatePayloadHash(payload: "{\"type\":\"https://tent.io/types/status/v0#\"}",
                                                               algorith: .sha256,
                                                               contentType: "application/vnd.tent.post.v0+json")
        else {
            XCTFail("failed to calculate hash")
            return
        }
        guard let mac = try? Hawk.Crypto.calculateMac(type: "header",
                                                      credentials: credentials,
                                                      resource: "/posts",
                                                      timestamp: 1368996800,
                                                      nonce: "3yuYCD4Z",
                                                      method: "POST",
                                                      host: "example.com",
                                                      port: 443,
                                                      hash: hash,
                                                      app: "wn6yzHGe5TLaT-fvOPbAyQ")
        else {
            XCTFail("Failed to calculate Mac")
            return
        }
        
        XCTAssertEqual(mac, "2sttHCQJG9ejj1x7eCi35FP23Miu9VtlaUgwk68DTpM=")
    }
}

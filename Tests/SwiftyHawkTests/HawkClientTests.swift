//
//  HawkClientTests.swift
//  SwiftyHawkTests
//
//  Created by Christoph Pageler on 18.11.17.
//

import XCTest
@testable import SwiftyHawk

class HawkClientTests: XCTestCase {
    
    /// Hawk Test
    /// https://github.com/hueniverse/hawk/blob/master/test/client.js#L25
    func testReturnsAValidAuthorizationHeaderSha1() {
        let credentials = Hawk.Credentials(id: "123456", key: "2983d45yun89q", algoritm: .sha1)
        let (header, _) = Hawk.Client.header(uri: "http://example.net/somewhere/over/the/rainbow", method: "POST")
        XCTFail()
    }
    
}

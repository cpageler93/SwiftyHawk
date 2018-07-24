//
//  HawkClientTests.swift
//  SwiftyHawkTests
//
//  Created by Christoph Pageler on 18.11.17.
//

import XCTest
@testable import SwiftyHawk

class HawkClientTests: XCTestCase {
    
    /// https://github.com/hueniverse/hawk/blob/master/test/client.js#L25
    func testHeaderSha1ReturnsAValidAuthorizationHeader() {
        
        let credentials = Hawk.Credentials(id: "123456", key: "2983d45yun89q", algoritm: .sha1)
        
        guard let payloadHash = try? Hawk.Crypto.calculatePayloadHash(payload: "something to write about",
                                                                      algorith: credentials.algoritm)
        else {
            XCTFail("Failed to hash payload")
            return
        }
        
        guard let headerResult = try? Hawk.Client.header(uri: "http://example.net/somewhere/over/the/rainbow",
                                                         method: "POST",
                                                         credentials: credentials,
                                                         timestamp: 1353809207,
                                                         nonce: "Ygvqdz",
                                                         hash: payloadHash,
                                                         ext: "Bazinga!")
        else {
            XCTFail("Failed to create header")
            return
        }
        
        XCTAssertEqual(headerResult?.headerValue, "Hawk id=\"123456\", ts=\"1353809207\", nonce=\"Ygvqdz\", hash=\"bsvY3IfUllw6V5rvk4tStEvpBhE=\", ext=\"Bazinga!\", mac=\"qbf1ZPG/r/e06F4ht+T77LXi5vw=\"")
    }
    
    /// https://github.com/hueniverse/hawk/blob/master/test/client.js#L37
    func testHeaderSha256WithContentTypeReturnsAValidAuthorizationHeader() {
        let credentials = Hawk.Credentials(id: "123456", key: "2983d45yun89q", algoritm: .sha256)
        
        guard let payloadHash = try? Hawk.Crypto.calculatePayloadHash(payload: "something to write about",
                                                                      algorith: credentials.algoritm,
                                                                      contentType: "text/plain")
        else {
            XCTFail("Failed to hash payload")
            return
        }
        
        guard let headerResult = try? Hawk.Client.header(uri: "https://example.net/somewhere/over/the/rainbow",
                                                         method: "POST",
                                                         credentials: credentials,
                                                         timestamp: 1353809207,
                                                         nonce: "Ygvqdz",
                                                         hash: payloadHash,
                                                         ext: "Bazinga!")
            else {
                XCTFail("Failed to create header")
                return
        }
        
        XCTAssertEqual(headerResult?.headerValue, "Hawk id=\"123456\", ts=\"1353809207\", nonce=\"Ygvqdz\", hash=\"2QfCt3GuY9HQnHWyWD3wX68ZOKbynqlfYmuO2ZBRqtY=\", ext=\"Bazinga!\", mac=\"q1CwFoSHzPZSkbIvl0oYlD+91rBUEvFk763nMjMndj8=\"")
    }
    
    /// https://github.com/tent/hawk-objc/blob/master/HawkTests/HawkTests.m#L157
    func testAuthorizationHeaderObjcCloneShouldReturnValidAuthorizationHeader() {
        let credentials = Hawk.Credentials(id: "exqbZWtykFZIh2D7cXi9dA", key: "HX9QcbD-r3ItFEnRcAuOSg", algoritm: .sha256)
        
        guard let payloadHash = try? Hawk.Crypto.calculatePayloadHash(payload: "{\"type\":\"https://tent.io/types/status/v0#\"}",
                                                                      algorith: credentials.algoritm,
                                                                      contentType: "application/vnd.tent.post.v0+json")
            else {
                XCTFail("Failed to hash payload")
                return
        }
        
        guard let headerResult = try? Hawk.Client.header(uri: "https://example.com/posts",
                                                         method: "POST",
                                                         credentials: credentials,
                                                         timestamp: 1368996800,
                                                         nonce: "3yuYCD4Z",
                                                         hash: payloadHash,
                                                         app: "wn6yzHGe5TLaT-fvOPbAyQ")
            else {
                XCTFail("Failed to create header")
                return
        }
        
        XCTAssertEqual(headerResult?.headerValue, "Hawk id=\"exqbZWtykFZIh2D7cXi9dA\", ts=\"1368996800\", nonce=\"3yuYCD4Z\", hash=\"neQFHgYKl/jFqDINrC21uLS0gkFglTz789rzcSr7HYU=\", mac=\"2sttHCQJG9ejj1x7eCi35FP23Miu9VtlaUgwk68DTpM=\", app=\"wn6yzHGe5TLaT-fvOPbAyQ\"")
    }

    func testGetRequestWithURLParametersShouldReturnValidAuthorizationHeader() {
        let credentials = Hawk.Credentials(id: "dh37fgj492je",
                                           key: "werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn",
                                           algoritm: .sha256)

        guard let headerResult = try? Hawk.Client.header(uri: "http://example.com:8000/resource/1?b=1&a=2",
                                                         method: "GET",
                                                         credentials: credentials,
                                                         timestamp: 1353832234,
                                                         nonce: "j4h3g2",
                                                         ext: "some-app-ext-data")
        else {
            XCTFail("Failed to create header")
            return
        }

        XCTAssertEqual(headerResult?.headerValue, "Hawk id=\"dh37fgj492je\", ts=\"1353832234\", nonce=\"j4h3g2\", ext=\"some-app-ext-data\", mac=\"6R4rV5iE+NPoym+WwjeHzjAGXUtLNIxmo1vpMofpLAE=\"")
    }
    
}

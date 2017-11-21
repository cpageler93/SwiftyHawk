//
//  HawkClient.swift
//  SwiftyHawk
//
//  Created by Christoph Pageler on 18.11.17.
//

import Foundation


extension Hawk {

    public class Client {
        
        public enum Error: Swift.Error {
            case couldNotParseURI
            case couldNotParseHostFromURI
            case couldNotParsePortFromURI
            case couldNotCalculateMac
        }
        
        public struct HeaderResult {
            public let headerValue: String
            public let artifacts: [String: String]
        }
        
        /// - Returns: (Header, Artifacts)
        public static func header(uri: String,
                                  method: String,
                                  credentials: Credentials,
                                  timestamp: TimeInterval? = nil,
                                  nonce: String,
                                  hash: String? = nil,
                                  ext: String? = nil,
                                  app: String? = nil,
                                  dlg: String? = nil) throws -> HeaderResult? {
            guard let uri = URL(string: uri) else { throw Error.couldNotParseURI }
            guard let host = uri.host else { throw Error.couldNotParseHostFromURI }
            guard let port: Int = {
                // explicit port
                if let port = uri.port {
                    return port
                }
                
                // use default port for http and https
                if let scheme = uri.scheme {
                    switch scheme {
                    case "http": return 80
                    case "https": return 443
                    default: return nil
                    }
                }
                
                return nil
            }() else {
                throw Error.couldNotParsePortFromURI
            }
            let timestamp = timestamp ?? Date().timeIntervalSince1970
            let resource = uri.path + (uri.query ?? "")
            guard let mac = try Hawk.Crypto.calculateMac(type: "header",
                                                         credentials: credentials,
                                                         resource: resource,
                                                         timestamp: timestamp,
                                                         nonce: nonce,
                                                         method: method,
                                                         host: host,
                                                         port: port,
                                                         hash: hash,
                                                         ext: ext,
                                                         app: app,
                                                         dlg: dlg)
            else {
                throw Error.couldNotCalculateMac
            }
            
            let headerValues: [[String: String?]] = [
                [ "id": credentials.id ],
                [ "ts": String(format: "%.0f", timestamp) ],
                [ "nonce": nonce ],
                [ "hash": hash ],
                [ "ext": ext ],
                [ "mac": mac ],
                [ "app": app ],
                [ "dlg": dlg ]
            ]
            
            let headerValuesString = headerValues
                .filter{ $0.first?.value != nil }
                .map {
                    let key = $0.first?.key ?? ""
                    let value = $0.first?.value ?? ""
                    return "\(key)=\"\(value)\""
                }
                .joined(separator: ", ")
            
            let headerValue = "Hawk \(headerValuesString)"
            
            return HeaderResult(headerValue: headerValue,
                                artifacts: [:])
        }
        
    }
    
}

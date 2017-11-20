//
//  HawkCrypto.swift
//  SwiftyHawk
//
//  Created by Christoph Pageler on 20.11.17.
//

import Foundation
import CryptoSwift


extension Hawk {
    
    public class Crypto {
        
        public static let headerVersion = "1"
        
        public static func calculateMac(type: String,
                                        credentials: Credentials,
                                        resource: String? = nil,
                                        timestamp: TimeInterval,
                                        nonce: String,
                                        method: String,
                                        host: String,
                                        port: Int,
                                        hash: String? = nil,
                                        ext: String? = nil,
                                        app: String? = nil,
                                        dlg: String? = nil) throws -> String? {
            let normalized = generateNormalizedString(type: type,
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
            
            let hmac = try HMAC(key: credentials.key, variant: hmacVariantForAlgorithm(credentials.algoritm))
            let encodedNormalizedData = try hmac.authenticate(normalized.bytes)
            return encodedNormalizedData.toBase64()
        }
        
        public static func generateNormalizedString(type: String,
                                                    resource: String? = nil,
                                                    timestamp: TimeInterval,
                                                    nonce: String,
                                                    method: String,
                                                    host: String,
                                                    port: Int,
                                                    hash: String? = nil,
                                                    ext: String? = nil,
                                                    app: String? = nil,
                                                    dlg: String? = nil) -> String {
            let resource = resource ?? ""
            let method = method.uppercased()
            let host = host.lowercased()
            let hash = hash ?? ""
            
            var normalized = "hawk.\(headerVersion).\(type)\n"
            normalized.append("\(String(format: "%.0f", timestamp))\n")
            normalized.append("\(nonce)\n")
            normalized.append("\(method)\n")
            normalized.append("\(resource)\n")
            normalized.append("\(host)\n")
            normalized.append("\(port)\n")
            normalized.append("\(hash)\n")
            
            if let ext = ext {
                normalized = normalized + ext.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\n", with: "\\n")
            }
            
            normalized.append("\n")
            
            if let app = app {
                let dlg = dlg ?? ""
                normalized.append("\(app)\n\(dlg)\n")
            }
            
            return normalized;
        }
        
        public static func calculatePayloadHash(payload: String?, algorith: Algoritm, contentType: String) throws -> String? {
            var payloadToHash = "hawk.\(headerVersion).payload\n"
            payloadToHash.append("\(Utils.parseContentType(contentType))\n")
            payloadToHash.append((payload ?? ""))
            payloadToHash.append("\n")
            
            switch algorith {
            case .sha1: return payloadToHash.data(using: .utf8)?.sha1().base64EncodedString()
            case .sha256: return payloadToHash.data(using: .utf8)?.sha256().base64EncodedString()
            }
        }
        
        private static func hmacVariantForAlgorithm(_ algorithm: Algoritm) -> HMAC.Variant {
            switch algorithm {
            case .sha1: return .sha1
            case .sha256: return .sha256
            }
        }
        
    }
    
}

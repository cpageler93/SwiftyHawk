//
//  HawkCrypto.swift
//  SwiftyHawk
//
//  Created by Christoph Pageler on 20.11.17.
//

import Foundation


extension Hawk {
    
    public class Crypto {
        
        public static let headerVersion = "1"
        
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
            
            var normalized = "hawk." + headerVersion + "." + type + "\n"
            normalized.append(String(format: "%.0f", timestamp) + "\n")
            normalized.append(nonce + "\n")
            normalized.append(method + "\n")
            normalized.append(resource + "\n")
            normalized.append(host + "\n")
            normalized.append("\(port)\n")
            normalized.append(hash + "\n")
            
            if let ext = ext {
                normalized = normalized + ext.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\n", with: "\\n")
            }
            
            normalized = normalized + "\n"
            
            if let app = app {
                let dlg = dlg ?? ""
                normalized = normalized + app + "\n" + dlg + "\n";
            }
            
            return normalized;
        }
        
    }
    
}

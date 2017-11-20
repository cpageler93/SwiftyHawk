//
//  HawkUtils.swift
//  SwiftyHawk
//
//  Created by Christoph Pageler on 20.11.17.
//

import Foundation


extension Hawk {
    
    public class Utils {
        
        public static func parseContentType(_ contentType: String) -> String {
            return contentType.split(separator: ";").first?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        }
        
    }
    
}

//
//  HawkCredentials.swift
//  SwiftyHawk
//
//  Created by Christoph Pageler on 18.11.17.
//

import Foundation


public extension Hawk {
    
    public struct Credentials {
        
        public var id: String
        public var key: String
        public var algoritm: Algoritm
        
        public init(id: String, key: String, algoritm: Algoritm) {
            self.id = id
            self.key = key
            self.algoritm = algoritm
        }
        
    }
    
}

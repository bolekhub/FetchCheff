//
//  Categories.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/15/25.
//

import Foundation

struct Category: Identifiable {
    typealias Element = String
    
    let id = UUID()
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
    }
}

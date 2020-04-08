//
//  LinkHeader.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

struct LinkHeader {
    private(set) var next: URL?
    private(set) var last: URL?
    private(set) var first: URL?
    private(set) var prev: URL?
    
    init?(link: String?) {
        guard let linkStrings = link else {
            return nil
        }
        
        let links = linkStrings.components(separatedBy: ",")
        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:";")
            let value = components[0].trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            let key = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            dictionary[key] = value
        })

        if let value = dictionary["rel=\"next\""],
            let nextLink = URL(string: value) {
            self.next = nextLink
        }
        
        if let value = dictionary["rel=\"last\""],
            let lastLink = URL(string: value) {
            self.last = lastLink
        }
        
        if let value = dictionary["rel=\"first\""],
            let firstLink = URL(string: value) {
            self.first = firstLink
        }
        
        if let value = dictionary["rel=\"prev\""],
            let prevLink = URL(string: value) {
            self.prev = prevLink
        }
    }
}

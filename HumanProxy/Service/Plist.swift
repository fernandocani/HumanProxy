//
//  Plist.swift
//  HumanProxy
//
//  Created by Fernando Cani on 22/02/24.
//

import Foundation

struct Plist {
    
    private init() { }
    
    static var shared = Plist()
    
    private func getPlist(with name: String) -> [String:Any]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path) {
           let plistData = try? PropertyListSerialization.propertyList(
                from: xml,
                options: .mutableContainersAndLeaves,
                format: nil
           )
           return (plistData) as? [String:Any]
        }
        return nil
    }
    
    func APIKey() -> String? {
        guard let contantsPlist = self.getPlist(with: "Constants"),
              let result = contantsPlist["APIKey"] as? String else {
            return nil
        }
        return result
    }
    
    func baseURL() -> String? {
        guard let contantsPlist = self.getPlist(with: "Constants"),
              let result = contantsPlist["BaseURL"] as? String else {
            return nil
        }
        return result
    }
    
}

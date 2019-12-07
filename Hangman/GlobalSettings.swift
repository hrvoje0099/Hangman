//
//  GlobalSettings.swift
//  Hangman
//
//  Created by Hrvoje Vuković on 05/12/2019.
//  Copyright © 2019 Hrvoje Vuković. All rights reserved.
//

import Foundation

enum GlobalSettings {
    @Persist(key: "useShowHint", defaultValue: false)
    static var useShowHint: Bool
    
    @Persist(key: "wordLanguage", defaultValue: WordLanguages.english.description)
    static var wordLanguage: String
    
    @Persist(key: "bestScore", defaultValue: 0)
    static var bestScore: Int
}


@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


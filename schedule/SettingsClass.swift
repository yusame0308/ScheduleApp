//
//  SettingsClass.swift
//  schedule
//
//  Created by 小原 宙 on 2020/11/08.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

class User: ObservableObject {
    @Published var startWday: Int {
        didSet {
            UserDefaults.standard.set(startWday, forKey: "startWday")
        }
    }
    @Published var offDays: [Int] {
        didSet {
            UserDefaults.standard.set(offDays, forKey: "offDays")
        }
    }
    @Published var textSize: Int {
        didSet {
            UserDefaults.standard.set(textSize, forKey: "textSize")
        }
    }
    
    @Published var themeColor: Int {
        didSet {
            UserDefaults.standard.set(themeColor, forKey: "themeColor")
        }
    }
    
    init() {
        self.startWday = UserDefaults.standard.object(forKey: "startWday") as? Int ?? 6
        self.offDays = UserDefaults.standard.object(forKey: "offDays") as? [Int] ?? [5, 6]
        self.textSize = UserDefaults.standard.object(forKey: "textSize") as? Int ?? 1
        self.themeColor = UserDefaults.standard.object(forKey: "themeColor") as? Int ?? 1
    }
}

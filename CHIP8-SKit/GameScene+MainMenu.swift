//
//  GameScene+RomLoading.swift
//  CHIP8-SKit
//
//  Created by Alin Baciu on 30/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa

extension GameScene {
    func setupMenu() {
        if let mainMenu = NSApplication.shared.menu {
            if let fileMenu = mainMenu.item(withTag: 1000)?.submenu {
                fileMenu.autoenablesItems = false
                if let openItem = fileMenu.item(withTag: 1001) {
                    openItem.isEnabled = true
                    openItem.target = self
                    openItem.action = #selector(openRom(_:))
                }
                if let resetItem = fileMenu.item(withTag: 1000) {
                    resetItem.isEnabled = false
                    resetItem.target = self
                    resetItem.action = #selector(resetRom(_:))
                }
            }
        }
    }
    
    func enableResetRomMenuItem(enabled: Bool) {
        if let mainMenu = NSApplication.shared.menu {
            if let fileMenu = mainMenu.item(withTag: 1000)?.submenu {
                if let resetItem = fileMenu.item(withTag: 1000) {
                    resetItem.isEnabled = enabled
                }
            }
        }
    }
    
    func openRomFile() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "Choose Chip8 Rom"
        panel.begin { (result)  in
            if let url = panel.urls.first {
                if self.interpreter.start(file: url) {
                    self.enableResetRomMenuItem(enabled: true)
                    NSApplication.shared.mainWindow?.title = url.lastPathComponent
                }
            }
        }
    }
    
    @objc func resetRom(_ sender: Any) {
        self.interpreter.resetRom()
    }
    
    @objc func openRom(_ sender: Any) {
        self.openRomFile()
    }
}

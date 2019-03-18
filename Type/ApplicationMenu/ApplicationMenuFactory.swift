//
//  ApplicationMenuFactory.swift
//  Type
//
//  Created by charles johnston on 3/6/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit
import Panels

class ApplicationMenuFactory {
    
    func createApplicationMenu(menuItemNotificationPoster: Selector?) -> NSMenu {
        
        // MARK: - Type
        let mainMenu = NSMenu(title: "Main Menu")
        
        let typeMenuItem = NSMenuItem(title: "Type", action: nil, keyEquivalent: "")
        let typeSubmenu = NSMenu(title: "Type menu")
        
        let aboutTypeMenuItem = TypeMenuItem(title: "About Type", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: aboutTypeNotification)
        typeSubmenu.addItem(aboutTypeMenuItem)
        
        typeSubmenu.addItem(NSMenuItem.separator())
        
        let settingsMenuItem = TypeMenuItem(title: "Settings", action: menuItemNotificationPoster, keyEquivalent: ",", keyEquivalentModifierMask: [.command], notification: settingsNotification)
        typeSubmenu.addItem(settingsMenuItem)
        let checkForUpdatesMenuItem = TypeMenuItem(title: "Check For Updates", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: checkForUpdatesNotification)
        typeSubmenu.addItem(checkForUpdatesMenuItem)
        
        typeSubmenu.addItem(NSMenuItem.separator())
        
        // TODO: Services
        let servicesMenuItem = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        typeSubmenu.addItem(servicesMenuItem)
        
        typeSubmenu.addItem(NSMenuItem.separator())
        
        let hideTypeMenuItem = TypeMenuItem(title: "Hide Type", action: menuItemNotificationPoster, keyEquivalent: "h", keyEquivalentModifierMask: [.command], notification: hideTypeNotification)
        typeSubmenu.addItem(hideTypeMenuItem)
        let hideOthersMenuItem = TypeMenuItem(title: "Hide Others", action: menuItemNotificationPoster, keyEquivalent: "h", keyEquivalentModifierMask: [.command, .option], notification: hideOthersNotification)
        typeSubmenu.addItem(hideOthersMenuItem)
        let closeWindowMenuItem = TypeMenuItem(title: "Close Window", action: menuItemNotificationPoster, keyEquivalent: "w", keyEquivalentModifierMask: [.command], notification: closeWindowNotification)
        typeSubmenu.addItem(closeWindowMenuItem)
        
        typeSubmenu.addItem(NSMenuItem.separator())
        
        let quitTypeMenuItem = TypeMenuItem(title: "Quit Type", action: menuItemNotificationPoster, keyEquivalent: "q", keyEquivalentModifierMask: [.command], notification: quitTypeNotification)
        typeSubmenu.addItem(quitTypeMenuItem)
        
        typeMenuItem.submenu = typeSubmenu
        mainMenu.addItem(typeMenuItem)

        // MARK: - File
        let fileMenuItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        let fileSubmenu = NSMenu(title: "File")
        
        let newDocumentMenuItem = TypeMenuItem(title: "New Document", action: menuItemNotificationPoster, keyEquivalent: "n", keyEquivalentModifierMask: [.command], notification: newDocumentNotification)
        fileSubmenu.addItem(newDocumentMenuItem)
        let newGroupMenuItem = TypeMenuItem(title: "New Group", action: menuItemNotificationPoster, keyEquivalent: "n", keyEquivalentModifierMask: [.command, .shift], notification: newGroupNotification)
        fileSubmenu.addItem(newGroupMenuItem)
        
        fileSubmenu.addItem(NSMenuItem.separator())
        
        let openMenuItem = TypeMenuItem(title: "Open", action: menuItemNotificationPoster, keyEquivalent: "o", keyEquivalentModifierMask: [.command], notification: openDocumentNotification)
        fileSubmenu.addItem(openMenuItem)
        //TODO: Open Recent
        
        fileSubmenu.addItem(NSMenuItem.separator())
        
        let publishMenuItem = TypeMenuItem(title: "Publish", action: menuItemNotificationPoster, keyEquivalent: "p", keyEquivalentModifierMask: [.command, .shift], notification: publishNotification)
        fileSubmenu.addItem(publishMenuItem)
        let printMenuItem = TypeMenuItem(title: "Print", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: printNotification)
        fileSubmenu.addItem(printMenuItem)
        
        fileSubmenu.addItem(NSMenuItem.separator())
        
        let presentMenuItem = TypeMenuItem(title: "Present", action: menuItemNotificationPoster, keyEquivalent: "p", keyEquivalentModifierMask: [.option], notification: presentNotification)
        fileSubmenu.addItem(presentMenuItem)
        let previewMenuItem = TypeMenuItem(title: "Preview", action: menuItemNotificationPoster, keyEquivalent: "p", keyEquivalentModifierMask: [.command], notification: previewNotification)
        fileSubmenu.addItem(previewMenuItem)
        
        fileMenuItem.submenu = fileSubmenu
        mainMenu.addItem(fileMenuItem)
        
        // MARK: - Edit
        let editMenuItem = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        let editSubmenu = NSMenu(title: "Edit")
        
        let groupMenuItem = TypeMenuItem(title: "Group", action: menuItemNotificationPoster, keyEquivalent: "g", keyEquivalentModifierMask: [.command], notification: groupNotification)
        editSubmenu.addItem(groupMenuItem)
        let ungroupMenuItem = TypeMenuItem(title: "Ungroup", action: menuItemNotificationPoster, keyEquivalent: "g", keyEquivalentModifierMask: [.command, .shift], notification: ungroupNotification)
        editSubmenu.addItem(ungroupMenuItem)
        
        let mergeMenuItem = TypeMenuItem(title: "Merge", action: menuItemNotificationPoster, keyEquivalent: "m", keyEquivalentModifierMask: [.command], notification: mergeNotification)
        editSubmenu.addItem(mergeMenuItem)
        
        editSubmenu.addItem(NSMenuItem.separator())
        
        // TODO: test if backspace works here - i dont think its right
        let deleteMenuItem = TypeMenuItem(title: "Delete", action: menuItemNotificationPoster, keyEquivalent: String(NSBackspaceCharacter), keyEquivalentModifierMask: [], notification: deleteNotification)
        editSubmenu.addItem(deleteMenuItem)
        let dissolveMenuItem = TypeMenuItem(title: "Dissolve", action: menuItemNotificationPoster, keyEquivalent: String(NSBackspaceCharacter), keyEquivalentModifierMask: [.command], notification: dissolveNotification)
        editSubmenu.addItem(dissolveMenuItem)
        
        editSubmenu.addItem(NSMenuItem.separator())
        
        let foldUnfoldMenuItem = TypeMenuItem(title: "Fold/Unfold", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: foldUnfoldNotification)
        editSubmenu.addItem(foldUnfoldMenuItem)
        let promoteMenuItem = TypeMenuItem(title: "Promote", action: menuItemNotificationPoster, keyEquivalent: "]", keyEquivalentModifierMask: [.command], notification: promoteNotification)
        editSubmenu.addItem(promoteMenuItem)
        let demoteMenuItem = TypeMenuItem(title: "Demote", action: menuItemNotificationPoster, keyEquivalent: "[", keyEquivalentModifierMask: [.command], notification: demoteNotification)
        editSubmenu.addItem(demoteMenuItem)
        // TODO: test if arrows works here - i dont think its right
        let moveToTopMenuItem = TypeMenuItem(title: "Move to Top", action: menuItemNotificationPoster, keyEquivalent: String(NSUpArrowFunctionKey), keyEquivalentModifierMask: [.command, .option], notification: moveToTopNotification)
        editSubmenu.addItem(moveToTopMenuItem)
        let moveUpMenuItem = TypeMenuItem(title: "Move Up", action: menuItemNotificationPoster, keyEquivalent: String(NSUpArrowFunctionKey), keyEquivalentModifierMask: [.command], notification: moveUpNotification)
        editSubmenu.addItem(moveUpMenuItem)
        let moveDownMenuItem = TypeMenuItem(title: "Move Down", action: menuItemNotificationPoster, keyEquivalent: String(NSDownArrowFunctionKey), keyEquivalentModifierMask: [.command], notification: moveDownNotification)
        editSubmenu.addItem(moveDownMenuItem)
        let moveToBottomMenuItem = TypeMenuItem(title: "Move to Bottom", action: menuItemNotificationPoster, keyEquivalent: String(NSDownArrowFunctionKey), keyEquivalentModifierMask: [.command, .option], notification: moveToBottomNotification)
        editSubmenu.addItem(moveToBottomMenuItem)
        
        editSubmenu.addItem(NSMenuItem.separator())
        
        let lockMenuItem = TypeMenuItem(title: "Lock", action: menuItemNotificationPoster, keyEquivalent: "l", keyEquivalentModifierMask: [.command], notification: lockNotification)
        editSubmenu.addItem(lockMenuItem)
        let unlockMenuItem = TypeMenuItem(title: "Unlock", action: menuItemNotificationPoster, keyEquivalent: "l", keyEquivalentModifierMask: [.command], notification: unlockNotification)
        editSubmenu.addItem(unlockMenuItem)
        
        editSubmenu.addItem(NSMenuItem.separator())
        
        let findMenuItem = TypeMenuItem(title: "Find", action: menuItemNotificationPoster, keyEquivalent: "f", keyEquivalentModifierMask: [.command], notification: findNotification)
        editSubmenu.addItem(findMenuItem)
        let findAndReplaceMenuItem = TypeMenuItem(title: "Find & Replace", action: menuItemNotificationPoster, keyEquivalent: "f", keyEquivalentModifierMask: [.shift, .command], notification: findAndReplaceNotification)
        editSubmenu.addItem(findAndReplaceMenuItem)
        let addTargetMenuItem = TypeMenuItem(title: "Add Target", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: addTargetNotification)
        editSubmenu.addItem(addTargetMenuItem)
        //TODO: change layout
        let checkSpellingMenuItem = TypeMenuItem(title: "Check Spelling", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: checkSpellingNotification)
        editSubmenu.addItem(checkSpellingMenuItem)
        
        editMenuItem.submenu = editSubmenu
        mainMenu.addItem(editMenuItem)
        
        //MARK: - Insert
        let insertMenuItem = NSMenuItem(title: "Insert", action: nil, keyEquivalent: "")
        let insertSubmenu = NSMenu(title: "Insert")
        
        let tableMenuItem = TypeMenuItem(title: "Table", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: tableNotification)
        insertSubmenu.addItem(tableMenuItem)
        let imageMenuItem = TypeMenuItem(title: "Image", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: imageNotification)
        insertSubmenu.addItem(imageMenuItem)
        let linkMenuItem = TypeMenuItem(title: "Link", action: menuItemNotificationPoster, keyEquivalent: "k", keyEquivalentModifierMask: [.command], notification: linkNotification)
        insertSubmenu.addItem(linkMenuItem)
        let citationReferenceMenuItem = TypeMenuItem(title: "Citation/Reference", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: citationReferenceNotification)
        insertSubmenu.addItem(citationReferenceMenuItem)
        
        insertSubmenu.addItem(NSMenuItem.separator())
        
        // TODO: see if multiple keys are possible
        let dividerMenuItem = TypeMenuItem(title: "Divider", action: menuItemNotificationPoster, keyEquivalent: "----", keyEquivalentModifierMask: [], notification: dividerNotification)
        insertSubmenu.addItem(dividerMenuItem)
        
        insertSubmenu.addItem(NSMenuItem.separator())
        
        let orderedListMenuItem = TypeMenuItem(title: "Ordered List", action: menuItemNotificationPoster, keyEquivalent: "----", keyEquivalentModifierMask: [], notification: orderedListNotification)
        insertSubmenu.addItem(orderedListMenuItem)
        let bulletListMenuItem = TypeMenuItem(title: "Bullet List", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: bulletListNotification)
        insertSubmenu.addItem(bulletListMenuItem)
        
        insertMenuItem.submenu = insertSubmenu
        mainMenu.addItem(insertMenuItem)
        
        //MARK: - Format
        
        
//        // view
//        let viewMenuItem = NSMenuItem(title: "View", action: nil, keyEquivalent: "")
//        let viewMenu = NSMenu(title: "View ") // "View" (without space) will cause a default enter fullscreen menu item (bug: https://github.com/nwjs/nw.js/issues/6332)
//        let viewFullscreenMenuItem = NSMenuItem(title: "Fullscreen", action: nil, keyEquivalent: "")
//        viewMenu.addItem(viewFullscreenMenuItem)
//        let viewToggleFolioMenuItem = TypeMenuItem(title: "Toggle Folio", action: menuItemNotificationPoster, keyEquivalent: "1", keyEquivalentModifierMask: [.command], notification: showLeftPanel)
//        viewMenu.addItem(viewToggleFolioMenuItem)
//        let viewToggleSideboardMenuItem = TypeMenuItem(title: "Toggle Sideboard", action: menuItemNotificationPoster, keyEquivalent: "2", keyEquivalentModifierMask: [.command], notification: showRightPanel)
//        viewMenu.addItem(viewToggleSideboardMenuItem)
//        mainMenu.addItem(viewMenuItem)
//        mainMenu.setSubmenu(viewMenu, for: viewMenuItem)
//
//        // help
//        let helpMenuItem = NSMenuItem(title: "Help", action: nil, keyEquivalent: "")
//        let helpMenu = NSMenu(title: "Help")
//        mainMenu.addItem(helpMenuItem)
//        mainMenu.setSubmenu(helpMenu, for: helpMenuItem)
        
        return mainMenu
    }
}

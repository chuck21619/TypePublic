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
    
    //TODO: view and edit menus are using "view " and "edit " to remove system wide menu items - investigate if this should be done. perhaps it even violates apple user interface guidelines?
    
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
        let editMenuItem = NSMenuItem(title: "Edit ", action: nil, keyEquivalent: "")
        let editSubmenu = NSMenu(title: "Edit ")
        
        let groupMenuItem = TypeMenuItem(title: "Group", action: menuItemNotificationPoster, keyEquivalent: "g", keyEquivalentModifierMask: [.command], notification: groupNotification)
        editSubmenu.addItem(groupMenuItem)
        let ungroupMenuItem = TypeMenuItem(title: "Ungroup", action: menuItemNotificationPoster, keyEquivalent: "g", keyEquivalentModifierMask: [.command, .shift], notification: ungroupNotification)
        editSubmenu.addItem(ungroupMenuItem)
        
        let mergeMenuItem = TypeMenuItem(title: "Merge", action: menuItemNotificationPoster, keyEquivalent: "m", keyEquivalentModifierMask: [.command], notification: mergeNotification)
        editSubmenu.addItem(mergeMenuItem)
        
        editSubmenu.addItem(NSMenuItem.separator())
        
        let deleteMenuItem = TypeMenuItem(title: "Delete", action: menuItemNotificationPoster, keyEquivalent: "\u{0008}", keyEquivalentModifierMask: [], notification: deleteNotification)
        editSubmenu.addItem(deleteMenuItem)
        let dissolveMenuItem = TypeMenuItem(title: "Dissolve", action: menuItemNotificationPoster, keyEquivalent: "\u{0008}", keyEquivalentModifierMask: [.command], notification: dissolveNotification)
        editSubmenu.addItem(dissolveMenuItem)
        
        editSubmenu.addItem(NSMenuItem.separator())
        
        let foldUnfoldMenuItem = TypeMenuItem(title: "Fold/Unfold", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: foldUnfoldNotification)
        editSubmenu.addItem(foldUnfoldMenuItem)
        let promoteMenuItem = TypeMenuItem(title: "Promote", action: menuItemNotificationPoster, keyEquivalent: "]", keyEquivalentModifierMask: [.command], notification: promoteNotification)
        editSubmenu.addItem(promoteMenuItem)
        let demoteMenuItem = TypeMenuItem(title: "Demote", action: menuItemNotificationPoster, keyEquivalent: "[", keyEquivalentModifierMask: [.command], notification: demoteNotification)
        editSubmenu.addItem(demoteMenuItem)
        let moveToTopMenuItem = TypeMenuItem(title: "Move to Top", action: menuItemNotificationPoster, keyEquivalent: "\u{001e}", keyEquivalentModifierMask: [.command, .option], notification: moveToTopNotification)
        editSubmenu.addItem(moveToTopMenuItem)
        let moveUpMenuItem = TypeMenuItem(title: "Move Up", action: menuItemNotificationPoster, keyEquivalent: "\u{001e}", keyEquivalentModifierMask: [.command], notification: moveUpNotification)
        editSubmenu.addItem(moveUpMenuItem)
        let moveDownMenuItem = TypeMenuItem(title: "Move Down", action: menuItemNotificationPoster, keyEquivalent: "\u{001f}", keyEquivalentModifierMask: [.command], notification: moveDownNotification)
        editSubmenu.addItem(moveDownMenuItem)
        let moveToBottomMenuItem = TypeMenuItem(title: "Move to Bottom", action: menuItemNotificationPoster, keyEquivalent: "\u{001f}", keyEquivalentModifierMask: [.command, .option], notification: moveToBottomNotification)
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
        let changeLayoutMenuItem = NSMenuItem(title: "Change Layout", action: nil, keyEquivalent: "")
        let changeLayoutSubmenu = NSMenu(title: "Change Layout")
        let changeLayoutLayoutAMenuItem = TypeMenuItem(title: "Layout A", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: changeLayoutLayoutANotification)
        changeLayoutSubmenu.addItem(changeLayoutLayoutAMenuItem)
        let changeLayoutLayoutBMenuItem = TypeMenuItem(title: "Layout B", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: changeLayoutLayoutBNotification)
        changeLayoutSubmenu.addItem(changeLayoutLayoutBMenuItem)
        let changeLayoutLayoutCMenuItem = TypeMenuItem(title: "Layout C", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: changeLayoutLayoutCNotification)
        changeLayoutSubmenu.addItem(changeLayoutLayoutCMenuItem)
        let changeLayoutElipsesMenuItem = TypeMenuItem(title: "...", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: changeLayoutElipsesNotification)
        changeLayoutSubmenu.addItem(changeLayoutElipsesMenuItem)
        changeLayoutMenuItem.submenu = changeLayoutSubmenu
        editSubmenu.addItem(changeLayoutMenuItem)
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
        let formatMenuItem = NSMenuItem(title: "Format", action: nil, keyEquivalent: "")
        let formatSubmenu = NSMenu(title: "Format")

        // TODO: if we want to overide the shift+3 shortcut image with the # image, we will need to configure the view ourselves
        let headlineMenuItem = TypeMenuItem(title: "Headline", action: menuItemNotificationPoster, keyEquivalent: "3", keyEquivalentModifierMask: [.shift], notification: headlineNotification)
//        let someView = NSView(frame: NSRect(x: 0, y: 0, width: 50, height: 50))
//        someView.wantsLayer = true
//        someView.layer?.backgroundColor = NSColor.blue.cgColor
//        headlineMenuItem.view = someView
        formatSubmenu.addItem(headlineMenuItem)
        let headlineMenuItem2 = TypeMenuItem(title: "Headline 2", action: menuItemNotificationPoster, keyEquivalent: "33", keyEquivalentModifierMask: [.shift], notification: headlineNotification)
        formatSubmenu.addItem(headlineMenuItem2)
        let headlineMenuItem3 = TypeMenuItem(title: "Headline 3", action: menuItemNotificationPoster, keyEquivalent: "333", keyEquivalentModifierMask: [.shift], notification: headlineNotification)
        formatSubmenu.addItem(headlineMenuItem3)
        let headlineMenuItem4 = TypeMenuItem(title: "Headline 4", action: menuItemNotificationPoster, keyEquivalent: "3333", keyEquivalentModifierMask: [.shift], notification: headlineNotification)
        formatSubmenu.addItem(headlineMenuItem4)
        
        formatSubmenu.addItem(NSMenuItem.separator())
        
        let boldMenuItem = TypeMenuItem(title: "Bold", action: menuItemNotificationPoster, keyEquivalent: "8", keyEquivalentModifierMask: [.shift], notification: boldNotification)
        formatSubmenu.addItem(boldMenuItem)
        let italicMenuItem = TypeMenuItem(title: "Italic", action: menuItemNotificationPoster, keyEquivalent: "88", keyEquivalentModifierMask: [.shift], notification: italicNotification)
        formatSubmenu.addItem(italicMenuItem)
        let underlineMenuItem = TypeMenuItem(title: "Underline", action: menuItemNotificationPoster, keyEquivalent: "-", keyEquivalentModifierMask: [.shift], notification: underlineNotification)
        formatSubmenu.addItem(underlineMenuItem)
        let strikeThruMenuItem = TypeMenuItem(title: "Strikethru", action: menuItemNotificationPoster, keyEquivalent: "`", keyEquivalentModifierMask: [.shift], notification: strikethruNotification)
        formatSubmenu.addItem(strikeThruMenuItem)
        let superscriptMenuItem = TypeMenuItem(title: "Superscript", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: superscriptNotification)
        formatSubmenu.addItem(superscriptMenuItem)
        let subscriptMenuItem = TypeMenuItem(title: "Subscript", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: subscriptNotification)
        formatSubmenu.addItem(subscriptMenuItem)
        
        formatSubmenu.addItem(NSMenuItem.separator())
        
        let blockQuoteMenuItem = TypeMenuItem(title: "Block Quote", action: menuItemNotificationPoster, keyEquivalent: "..", keyEquivalentModifierMask: [.shift], notification: blockQuoteNotification)
        formatSubmenu.addItem(blockQuoteMenuItem)
        let codeMenuItem = TypeMenuItem(title: "Code", action: menuItemNotificationPoster, keyEquivalent: "`", keyEquivalentModifierMask: [], notification: codeNotification)
        formatSubmenu.addItem(codeMenuItem)
        let codeBlockMenuItem = TypeMenuItem(title: "Code Block", action: menuItemNotificationPoster, keyEquivalent: "``", keyEquivalentModifierMask: [], notification: codeBlockNotification)
        formatSubmenu.addItem(codeBlockMenuItem)
        
        formatSubmenu.addItem(NSMenuItem.separator())
        
        let highlightMenuItem = TypeMenuItem(title: "Highlight", action: menuItemNotificationPoster, keyEquivalent: ";;", keyEquivalentModifierMask: [.shift], notification: highlightNotification)
        formatSubmenu.addItem(highlightMenuItem)
        let commentMenuItem = TypeMenuItem(title: "Comment", action: menuItemNotificationPoster, keyEquivalent: "/", keyEquivalentModifierMask: [], notification: commentNotification)
        formatSubmenu.addItem(commentMenuItem)
        
        formatMenuItem.submenu = formatSubmenu
        mainMenu.addItem(formatMenuItem)
        
        // MARK: - View
        let viewMenuItem = NSMenuItem(title: "View ", action: nil, keyEquivalent: "")
        let viewSubmenu = NSMenu(title: "View ")
        
        let folioMenuItem = TypeMenuItem(title: "Folio", action: menuItemNotificationPoster, keyEquivalent: "1", keyEquivalentModifierMask: [.command], notification: showLeftPanel)
        viewSubmenu.addItem(folioMenuItem)
        let workspaceMenuItem = TypeMenuItem(title: "Workspace", action: menuItemNotificationPoster, keyEquivalent: "2", keyEquivalentModifierMask: [.command], notification: workspaceNotification)
        viewSubmenu.addItem(workspaceMenuItem)
        let sideboardMenuItem = TypeMenuItem(title: "Sideboard", action: menuItemNotificationPoster, keyEquivalent: "3", keyEquivalentModifierMask: [.command], notification: showRightPanel)
        viewSubmenu.addItem(sideboardMenuItem)
        let tagsMenuItem = TypeMenuItem(title: "Tags", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: tagsNotification)
        viewSubmenu.addItem(tagsMenuItem)
        let referencesMenuItem = TypeMenuItem(title: "References", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: referencesNotification)
        viewSubmenu.addItem(referencesMenuItem)
        let archiveMenuItem = TypeMenuItem(title: "Archive", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: archiveNotification)
        viewSubmenu.addItem(archiveMenuItem)
        
        viewSubmenu.addItem(NSMenuItem.separator())
        
        let infoMenuItem = TypeMenuItem(title: "Info", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: infoNotification)
        viewSubmenu.addItem(infoMenuItem)
        let outlineMenuItem = TypeMenuItem(title: "Outline", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: outlineNotification)
        viewSubmenu.addItem(outlineMenuItem)
        let dictionaryMenuItem = TypeMenuItem(title: "Dictionary", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: dictionaryNotification)
        viewSubmenu.addItem(dictionaryMenuItem)
        let thesaurusMenuItem = TypeMenuItem(title: "Thesaurus", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: thesaurusNotification)
        viewSubmenu.addItem(thesaurusMenuItem)
        
        viewSubmenu.addItem(NSMenuItem.separator())
        
        //not implemented yet
        
        viewSubmenu.addItem(NSMenuItem.separator())
        
        // focus
        let focusItemMenu = NSMenuItem(title: "Focus", action: nil, keyEquivalent: "")
        let focusSubmenu = NSMenu(title: "Focus")
        let focusLineMenuItem = TypeMenuItem(title: "Line", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: focusLineNotification)
        focusSubmenu.addItem(focusLineMenuItem)
        let focusSentenceMenuItem = TypeMenuItem(title: "Sentence", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: focusSentenceNotification)
        focusSubmenu.addItem(focusSentenceMenuItem)
        let focusParagraphMenuItem = TypeMenuItem(title: "Paragraph", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: focusParagraphNotification)
        focusSubmenu.addItem(focusParagraphMenuItem)
        focusItemMenu.submenu = focusSubmenu
        viewSubmenu.addItem(focusItemMenu)
        
        // typewriter
        let typewriterItemMenu = NSMenuItem(title: "Typewriter", action: nil, keyEquivalent: "")
        let typewriterSubmenu = NSMenu(title: "Typewriter")
        let typewriterTopMenuItem = TypeMenuItem(title: "Top", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: typewriterTopNotification)
        typewriterSubmenu.addItem(typewriterTopMenuItem)
        let typewriterCenterMenuItem = TypeMenuItem(title: "Center", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: typewriterCenterNotification)
        typewriterSubmenu.addItem(typewriterCenterMenuItem)
        let typewriterBottomMenuItem = TypeMenuItem(title: "Bottom", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: typewriterBottomNotification)
        typewriterSubmenu.addItem(typewriterBottomMenuItem)
        typewriterItemMenu.submenu = typewriterSubmenu
        viewSubmenu.addItem(typewriterItemMenu)
        
        viewSubmenu.addItem(NSMenuItem.separator())
        
        let splitUnsplitMenuItem = TypeMenuItem(title: "Split/Unsplit", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: splitUnsplitNotification)
        viewSubmenu.addItem(splitUnsplitMenuItem)
        
        viewSubmenu.addItem(NSMenuItem.separator())
        
        let hideToolbarMenuItem = TypeMenuItem(title: "Hide Toolbar", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: hideToolbarNotification)
        viewSubmenu.addItem(hideToolbarMenuItem)
        let customizeToolbarMenuItem = TypeMenuItem(title: "Customize Toolbar", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: customizeToolbarNotification)
        viewSubmenu.addItem(customizeToolbarMenuItem)
        
        viewMenuItem.submenu = viewSubmenu
        mainMenu.addItem(viewMenuItem)
        
        //MARK: - Help
        let helpMenuItem = NSMenuItem(title: "Help", action: nil, keyEquivalent: "")
        let helpSubmenu = NSMenu(title: "Help")
        
        //  search menu item is added by default
        let keyboardShortcutsMenuItem = TypeMenuItem(title: "Keyboard Shortcuts", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: keyboardShortcutsNotification)
        helpSubmenu.addItem(keyboardShortcutsMenuItem)
        let keyboardMechanicsMenuItem = TypeMenuItem(title: "Keyboard Mechanics", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: keyboardMechanicsNotification)
        helpSubmenu.addItem(keyboardMechanicsMenuItem)
        
        helpSubmenu.addItem(NSMenuItem.separator())
        
        let whatsNewInTypeMenuItem = TypeMenuItem(title: "Whats new in Type", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: whatsNewInTypeNotification)
        helpSubmenu.addItem(whatsNewInTypeMenuItem)
        
        helpSubmenu.addItem(NSMenuItem.separator())
        
        let reportABugMenuItem = TypeMenuItem(title: "Report a bug", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: reportABugNotification)
        helpSubmenu.addItem(reportABugMenuItem)
        let zinHelpPageMenuItem = TypeMenuItem(title: "Zin Help Page", action: menuItemNotificationPoster, keyEquivalent: "", keyEquivalentModifierMask: [], notification: zinHelpPageNotification)
        helpSubmenu.addItem(zinHelpPageMenuItem)
        
        helpMenuItem.submenu = helpSubmenu
        mainMenu.addItem(helpMenuItem)
        
        return mainMenu
    }
}

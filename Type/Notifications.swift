//
//  Notifications.swift
//  Type
//
//  Created by charles johnston on 3/18/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation

//application menu
//type
public let aboutTypeNotification = Notification(name: Notification.Name(rawValue: "aboutTypeNotification"))
public let settingsNotification = Notification(name: Notification.Name(rawValue: "settingsNotification"))
public let checkForUpdatesNotification = Notification(name: Notification.Name(rawValue: "checkForUpdatesNotification"))
public let hideTypeNotification = Notification(name: Notification.Name(rawValue: "hideTypeNotification"))
public let hideOthersNotification = Notification(name: Notification.Name(rawValue: "hideOthersNotification"))
public let closeWindowNotification = Notification(name: Notification.Name(rawValue: "closeWindowNotification"))
public let quitTypeNotification = Notification(name: Notification.Name(rawValue: "quitTypeNotification"))


//file
public let newDocumentNotification = Notification(name: Notification.Name(rawValue: "newDocumentNotification"))
public let newGroupNotification = Notification(name: Notification.Name(rawValue: "newGroupNotification"))
public let openDocumentNotification = Notification(name: Notification.Name(rawValue: "openDocumentNotification"))
public let publishNotification = Notification(name: Notification.Name(rawValue: "publishNotification"))
public let printNotification = Notification(name: Notification.Name(rawValue: "printNotification"))
public let presentNotification = Notification(name: Notification.Name(rawValue: "presentNotification"))
public let previewNotification = Notification(name: Notification.Name(rawValue: "previewNotification"))

//edit
public let groupNotification = Notification(name: Notification.Name(rawValue: "groupNotification"))
public let ungroupNotification = Notification(name: Notification.Name(rawValue: "ungroupNotification"))
public let mergeNotification = Notification(name: Notification.Name(rawValue: "mergeNotification"))
public let deleteNotification = Notification(name: Notification.Name(rawValue: "deleteNotification"))
public let dissolveNotification = Notification(name: Notification.Name(rawValue: "dissolveNotification"))
public let foldUnfoldNotification = Notification(name: Notification.Name(rawValue: "foldUnfoldNotification"))
public let promoteNotification = Notification(name: Notification.Name(rawValue: "promoteNotification"))
public let demoteNotification = Notification(name: Notification.Name(rawValue: "demoteNotification"))
public let moveToTopNotification = Notification(name: Notification.Name(rawValue: "moveToTopNotification"))
public let moveUpNotification = Notification(name: Notification.Name(rawValue: "moveUpNotification"))
public let moveDownNotification = Notification(name: Notification.Name(rawValue: "moveDownNotification"))
public let moveToBottomNotification = Notification(name: Notification.Name(rawValue: "moveToBottomNotification"))
public let lockNotification = Notification(name: Notification.Name(rawValue: "lockNotification"))
public let unlockNotification = Notification(name: Notification.Name(rawValue: "unlockNotification"))
public let findNotification = Notification(name: Notification.Name(rawValue: "findNotification"))
public let findAndReplaceNotification = Notification(name: Notification.Name(rawValue: "findAndReplaceNotification"))
public let addTargetNotification = Notification(name: Notification.Name(rawValue: "addTargetNotification"))
public let checkSpellingNotification = Notification(name: Notification.Name(rawValue: "checkSpellingNotification"))

//insert
public let tableNotification = Notification(name: Notification.Name(rawValue: "tableNotification"))
public let imageNotification = Notification(name: Notification.Name(rawValue: "imageNotification"))
public let linkNotification = Notification(name: Notification.Name(rawValue: "linkNotification"))
public let citationReferenceNotification = Notification(name: Notification.Name(rawValue: "citationReferenceNotification"))
public let dividerNotification = Notification(name: Notification.Name(rawValue: "dividerNotification"))
public let orderedListNotification = Notification(name: Notification.Name(rawValue: "orderedListNotification"))
public let bulletListNotification = Notification(name: Notification.Name(rawValue: "bulletListNotification"))


//format
public let headlineNotification = Notification(name: Notification.Name(rawValue: "headlineNotification"))
public let headline2Notification = Notification(name: Notification.Name(rawValue: "headline2Notification"))
public let headline3Notification = Notification(name: Notification.Name(rawValue: "headline3Notification"))
public let headline4Notification = Notification(name: Notification.Name(rawValue: "headline4Notification"))
public let boldNotification = Notification(name: Notification.Name(rawValue: "boldNotification"))
public let italicNotification = Notification(name: Notification.Name(rawValue: "italicNotification"))
public let underlineNotification = Notification(name: Notification.Name(rawValue: "underlineNotification"))
public let strikethruNotification = Notification(name: Notification.Name(rawValue: "strikethruNotification"))
public let superscriptNotification = Notification(name: Notification.Name(rawValue: "superscriptNotification"))
public let subscriptNotification = Notification(name: Notification.Name(rawValue: "subscriptNotification"))
public let blockQuoteNotification = Notification(name: Notification.Name(rawValue: "blockQuoteNotification"))
public let codeNotification = Notification(name: Notification.Name(rawValue: "codeNotification"))
public let codeBlockNotification = Notification(name: Notification.Name(rawValue: "codeBlockNotification"))
public let highlightNotification = Notification(name: Notification.Name(rawValue: "highlightNotification"))
public let commentNotification = Notification(name: Notification.Name(rawValue: "commentNotification"))

//view
public let folioNotification = Notification(name: Notification.Name(rawValue: "folioNotification"))
public let workspaceNotification = Notification(name: Notification.Name(rawValue: "workspaceNotification"))
public let sideboardNotification = Notification(name: Notification.Name(rawValue: "sideboardNotification"))
public let tagsNotification = Notification(name: Notification.Name(rawValue: "tagsNotification"))
public let referencesNotification = Notification(name: Notification.Name(rawValue: "referencesNotification"))
public let archiveNotification = Notification(name: Notification.Name(rawValue: "archiveNotification"))
public let infoNotification = Notification(name: Notification.Name(rawValue: "infoNotification"))
public let outlineNotification = Notification(name: Notification.Name(rawValue: "outlineNotification"))
public let dictionaryNotification = Notification(name: Notification.Name(rawValue: "dictionaryNotification"))
public let thesaurusNotification = Notification(name: Notification.Name(rawValue: "thesaurusNotification"))
public let splitUnsplitNotification = Notification(name: Notification.Name(rawValue: "splitUnsplitNotification"))
public let hideToolbarNotification = Notification(name: Notification.Name(rawValue: "hideToolbarNotification"))
public let customizeToolbarNotification = Notification(name: Notification.Name(rawValue: "customizeToolbarNotification"))

//help
public let searchNotification = Notification(name: Notification.Name(rawValue: "searchNotification"))
public let keyboardShortcutsNotification = Notification(name: Notification.Name(rawValue: "keyboardShortcutsNotification"))
public let keyboardMechanicsNotification = Notification(name: Notification.Name(rawValue: "keyboardMechanicsNotification"))
public let whatsNewInTypeNotification = Notification(name: Notification.Name(rawValue: "whatsNewInTypeNotification"))
public let reportABugNotification = Notification(name: Notification.Name(rawValue: "reportABugNotification"))
public let zinHelpPageNotification = Notification(name: Notification.Name(rawValue: "zinHelpPageNotification"))

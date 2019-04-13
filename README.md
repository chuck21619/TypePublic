# Abstract
Type is a markdown editor designed as a “soup-to-nuts” solution for writers of various disciplines. It features unique mechanics built around typing, a smarter system for organizing documents and text, and an interface which encourages better writing by design.

# Wireframe
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2504%3A59)

# Folio
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2502%3A42)

The **Folio** is the left panel where Files are managed. All files are stored locally in the user's documents folder (by default) with the option to change and add locations. The folio can be hidden, sliding into the workspace. When it is revealed it **pushes** the workspace to the right. If the app window is narrow enough, the folio will hide automatically.

### Folio Tab Views
The top of the folio contains the tabs:**Folio**, **Tags**, And the **Archive**. Each of these tabs present a different view of the documents contained within TYPE. 
- **Folio** displays all documents not archived
- **Tags** displays documents with tags, organized by the tag name(s) in **Tag folders**.
- **Archive** displays documents which have been published or sent to the archive manually by the writer.

### Filter
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2505%3A4906)
Located at the bottom of the folio, typing in this field will fuzzy filter the files & folders of the tab you are currently in.

Filtering with markdown syntax and text will return documents which have tagged text. For example, entering "#Pineapple" would filter for documents that contained   headlines with the word pineapple.

Selecting a result will open it in the workspace. 

To close/end the filtered view:
- Double click on a result.
- click the “x” in the search field
- hit the escape key
- Write in the workspace of a selected result.

### Categories
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2504%3A59)
Folders and Documents can be linked within categories if they fit the criteria. Categories always appear before the list of documents & Folders in the folio.

Examples of categories are:
- **Recent** shows recently edited documents
- **Due Soon** if documents have a due date that is approaching (within a week or so)
- **Embargoed** documents which have a timed publish schedule that is approaching
- **New Comments** (future release) When collaborating with an editor or another writer and they’ve left a new comment on the document, New comments appears with the related docs.
- **Whatever else we can come up with**

### Document and Folder list
Documents and folders are displayed as a list with an icon denoting the Layout of the document or folder. Document names long enough to reach the right boundary of the folio panel will append an ellipsis at the point of overflow/break.

**Expanded Folders are stick to the top of the folio when scrolling**
If there is enough content in the folio to scroll, the position of an open folder will stick to the top of the folio and everything will scroll beneath it. Once all the contents of the folder have scrolled past the top, The folder will become unstuck and will be pushed up. collapsed folders will not become fixed to the top.

#### Order of Appearance
The visual order of files in the folio determines the order the text appears in the workspace. The order flows from top to bottom, the top most document is first, and the bottom most document is last.

## Rearrangement
Documents and folders can be moved up and down the list with keyboard shortcuts or by clicking + dragging. If a file is contained within a folder, then that file’s movement up or down is restricted to the top or bottom of the folder.

## Renaming
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2568%3A3)
Rename a file in the folio by selecting it and using the Shortcut **⌘R**, clicking the name at the top of the Tool bar (with the document open in the workspace), or in the context menu (edit > Rename)

## Sorting
**Sorting the folio is a temporary action that only effects the top level folders or orphaned documents (w/o a folder) in the Folio.** Folders and Subfolders can be sorted individually through the context menu (ctrl+clicking on the desired folder/subfolder).

## Security
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2567%3A4015)
Encrypting and protecting writing with passwords should be a feature in Type. Writers should have the option of securing their documents by locking the app behind a password.

Additional Options:
1. auto-lock on app close
2. auto-lock on sleep
3. auto-lock after inactivity.
4. Apple Keychain or 1Password integration
5. Emergency key, that unlocks any document if you forget the one you set

## Deleted Files
Deleted files go to the MacOS trashcan if deleted from the Folio. When a new document is created, you get the option of naming it immediately. If don't name it, or add text to it- then it automatically removes itself from the folio and does not enter the trashcan. **No reason to clutter the trashcan with a bunch of accidentally created documents.**

### Selecting documents and Folders
If a document is selected from the folio, then it appears in the workspace. However, if a folder is selected, then all of the documents it contains are displayed in the workspace in the same order they appear in the folder. The document names are centered above the start of each document. 

[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2626%3A9)

# Documents
[figure](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2502%3A42)
Documents are plain-text markdown (.md) files. These files store additional meta/compositional data that can be viewed in the app. Additionally, documents can be styled by applying a layout

## Creating Documents
Create a new document with the shortcut **⌘N**, by clicking on the Plus button at the bottom of the folio, in the context menu of the folio, or menu bar (File > New Document). 

When a new document is created…
1. The first option you have is to name it.
2. If you’re working on a document, and a new one is created, then it is created below the one you’re working on (in the folio).

## Merging Documents
Documents can be merged together by selecting them in the folio and choosing "merge" from either the context menu, or Menubar (edit > merge) or with the shortcut **⌘E**. Documents merge in order of appearance (top to bottom) in the folio. When documents are merged, the **Top document** becomes the name and layout of the document after the merge

# Folders
Folders are groups of files (documents and other folders).

**Create a new folder: **
- with the shortcut: **⌘⇧N**
- selecting “New Folder” from the context menu in the folio
- Selecting the menubar option (edit > New Folder) or (edit > Group)
- selecting multiple files and using the shortcut: **⌘G** 

**Deleting or Ungrouping A Folder**
Folders can be deleted, sending it and all it’s contents to the Trashcan, or they can be “ungrouped” which frees all of its contents to the folio. Alternatively, if a single document in a folder is selected and *ungrouped* it alone will be removed from the folder.
- Ungroup with the keyboard shortcut: **⇧⌘G**
- Selecting “Ungroup” from the context menu in the folio
- Selecting the menubar option (edit > New folder) or (edit > Group)

## Prev/Next Document
When documents are in a folder, you can jump to the next/previous document with the arrow keys. If the beginning or end of a document is displayed in the workspace, arrow up to go to the document that preceedes it, and arrow down to move to the next document.

# Folder Focus
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2519%3A8015)
Folder focus is a more elegant way of decluttering the folio and zero-in on a project. 

**To focus on a folder:**
- click the arrow that appears on the right when a folder is selected
- Use the shortcut **⌘+Return** 

Unfocus a folder by hitting escape or clicking the back arrow at the top of the folio.

When a folder is in focus…
- Only the files it contains are displayed.
- The Name of the folder appears at the top of the folio.
- Document icons & text become larger and display additional information (The layout of the folder/documents determine how the documents are displayed)
- Subfolders are presented as collapsable sections

    (`/\
    `=\/\
     `=\/\
      `=\/
         \

# Layouts

> "In microsoft word, I move an image 2 pixels left- suddenly all text is capitalized and translated to French, three new pages appear, and in the distance...sirens."

Layouts were created as a solution against the need to format a page while writing. A Layout is a set of styles which determine how a document will look once it is published/printed. Documents can only have **one** layout at a time, but can have any layout applied.

**When a document or folder has a layout applied its icon will change according to said layout.** Icons for folders are “collective” whereas icons for documents are “parts.” i.e. documents have “page” layouts where the folder would be “book.”

## Applying a layout
Layouts are assigned to documents and folders from:

- The sideboard (Info, Publish and Print), 
- Context menu
- Menu bar (edit > layout > name).

## Folder Layouts
Assigning a layout to a folder applies the same layout to every file it contains. (overriding any layouts previously assigned to individual docs/folders).

## Additional Features
Certain layouts offer unique components and functionality related to the type of layout.  These components are displayed once the document is published.

1. Table of Contents (auto-generated by the outline or document names)
2. Clickable Table of Contents (Technical documents & Wikis)
3. “Presentation View” for slides and presentations.
4. Unique Targets, for something like NanoWriMo could get a target of 10k words a day built in.
5. Index/Glossary of Terms - created by a note

##Examples
| Layout | Icon | Folder | Description |
|-----|------|------|-----|
| Page | i | Book |the default layout option |
| Poem | i | Book | - |
| Slide | i | Presentation | - |
| PDF | i | - | - |
| PlainText | i | - | - |
| Note | i | Notebook | notes can be generated and edited |
| Technical Document | i | Wiki | - |
| Recipe | i | Recipe Box | - |
| Newsletter | i | Campaign | - |
| Interview | i | Tape Deck | collected from audio transcriptions |

# Tags
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2505%3A2359)

**Documents can be tagged in type, folders cannot be tagged.** When collapsed, Folders can display the tags of the documents it contains. Tags are displayed as dots after the document name in the folio by default. Tags can also be displayed as [tokens](https://developer.apple.com/design/human-interface-guidelines/macos/fields-and-labels/token-fields/)- displaying their tag color and tag name. When in **token** form, tags can be renamed and recolored.

## MacOS color Panel (NSColorPanel) to change tag colors.
To change a tags color, Right click on either a **Tag Token** or **Tag Folder** doing so will display the Mac Color panel. 

Investigate: *There’s a way to add a tab to the color panel, I’ve seen other apps do it.*

## Tagging Documents
Tagging documents works a lot like it does in MacOS with a range of tag dots to select from the context or menu bar. A document can also have a tag added from its **info sideboard** under the tags section.

When renaming a document from the toolbar, the dropdown also provides a dialogue box to add/remove tags.

## Editing Names & Colors
To edit a tags name, the tag needs to be displayed as a **token** (or a folder if you are in the Tags View). Tag dots next to documents can become tag tokens by clicking on any of the dots. doing so will open a **token field** below the document where tags can be renamed.

Alternatively, a document’s tags can be found as tokens in the **Info Sideboard.**

## Tag Tab & Tag Folders
The Tag Tab at the top of the folio displays all tagged documents organized by their tag name(s) as **Tag folders**. These folders can become Focused, but cannot be Published. Since a document can have multiple tags, it can also appear in multiple **Tag folders**.

Deleting a tag folder will remove that tag from every document in Type.

## Deleting Tags
- Deleting a tag token In the Info Sideboard under the Tags section.
- Selecting a filled in tag dot from the Context Menu. (Exactly like how it works in MacOS)
- **In the Tag Tab/View** deleting a document from a tag folder, removes the tag from the document.

# Archive
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2505%3A2240)
The Archive Tab is a collection of documents that have either been published or moved there by the writer. The archive is a way to de-clutter the folio and also catalogue completed work. Documents which enter the Archive receive an "Archived date" in their Info **sideboard**.

Archived documents can be retrieved/copied from the archive and re-enter the Folio. *I am debating if this retrieval is just making a copy of the archived doc, and keeping the original in the folio- if that would create clutter. it depends on if the archive is better for storage only, or storing documents in a manner that keeps a history.*

## Date Sections
The Archive is sorted chronologically and groups documents by the month and year they entered.

# Workspace
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2519%3A9570)
The workspace is the center panel and is never hidden (unlike the Folio & Sideboard). The workspace contains the **outline**, a **text column**, **line numbers**, and the **action bar** (when called).

## Typography
Type has its own font which comes in: Serif, Sans-Serif, & Monospaced typefaces. This font has special ligatures designed for markdown syntax. The size of the font can be changed at will with the shortcuts ⌘+ and ⌘-. The default size for type is **16**.

### Golden Ratio Sizing
The **Font Size**, **Line Height**, and **Text Column** all relate to one another using the golden ratio. Since the font size can be changed at will, its value determines the relative values for both the line height and text column.

Luckily This work has already been done:
**Golden Ratio Type Calculator [GRCALC](https://grtcalculator.com/)**
Here’s the math: [Math](https://grtcalculator.com/math/)

### Line Numbers
Line numbers appear in the right margin of the workspace and indicate lines, which is a series of text unbroken by a return. lines without text do not have numbers assigned to them.

# Views & Modes
text in the workspace can be displayed in different views and modes. A **view** determines how the workspace appears, where **modes** determine how the text appears when writing.

## Preview
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2525%3A77)
Preview mode displays how the document will appear according to its **Layout**.
The preview can be toggled or peeked by tapping or holding **⌘P.**

**Q:should writers be able to edit the document while in preview mode?**

## Split
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2522%3A1056)
The workspace can be split in half vertically, displaying two documents at the same time (or the same document extended to both views). In split view, The **outline** is only displayed in the active document containing the cursor.

### Split Preview
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2522%3A1133)
Split view and preview can be combined to show markdown on one side, and the layout preview on the other. The windows can scroll in sync with one another, and the preview updates in real time.

### Split (Continuous)
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2522%3A1173)
The same document is displayed in both views, it begins on the left and continues on the right.

## Typewriter (MODE)
Typewriter mode fixes the cursor to either the top, middle, or bottom of the workspace. Text then scrolls into or out-of the chosen position.

Note: Top and Bottom positions are not the absolute top and absolute bottom. It is more like 30% from the top, and 30% from the bottom of the workspace. [EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2525%3A193)

## Text Focus (MODE)

This mode highlights the chosen amount of text which the cursor touches and dims all other text. Text can be focused by:
1.	[Line](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2525%3A154)
2.	[Sentence](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2525%3A232)
3.	[Paragraph](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2525%3A271)

> **Text focus and typewriter can be used at the same time.**

## Changing documents with arrow keys
if the workspace view is at the beginning or end of a document, hitting arrow up (if at the beginning) or Down (if at the end) will move to the next or Previous Document in order.

## New docs start in the middle
The first lines of text in a document starts around the middle of the workspace. The more text that is entered will push the first lines of text up toward the top of the workspace. This keeps the text at eye level in the beginning and is good visual ergonomics.

# Outline
The outline is a list of links to every H1, H2 and, H3 tag in the document. It is positioned (horizontally centered) in either the left margin of the workspace or in its own Sideboard.

## Features of the outline
The outline serves as a quick reference to the structure of the document and allows the writer to jump around the document and arrange writing from a top level view. Features of the outline include:
- Builds in real time as you write.
- Folds according to Headline Hierarchy
- Moves the view to any headline selected
- Rearranges text in the workspace
- Bolds/highlights the headline containing the cursor.

*Having the option of customizing the level of headline you can view? If you only want to look at the H1’s or H1’s and H2s?*

*Outline collapses when window is narrow*

## Rules of Arrangement
Headline tags ( #, ##, ### ) act in a nested hierarchy with H1 being at the highest, followed by H2, and then H3. Each Headline groups all the text (and child headlines) that follow until the next occurrence of itself.

# Sideboard
The sideboard is a panel that reveals itself from the right of the workspace. It displays information and settings related to the selected document/folder in the workspace as well the app itself. The idea behind the sideboard is that you can see important information or tinker with settings while maintaining an unobstructed view of the writing. Sideboards are coupled with related sideboards. The only ones without a pair are “Updates” and “Dictionary.”

> Sideboards are also built with extending functionality in mind. Anything new we need to build or add can be accessed and tinkered with via the sideboard.


## Info & Outline
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2505%3A8)
Information about the document selected in the folio or open in the workspace. Here, you can set the layout, edit tags, set targets, add collaborators, or view data & stats about the writing.

The outline for the document in the workspace. This outline could be displayed differently than the one in the workspace. It could also have a few additional features:
1. Filtering
2. displaying indicator dots for things like: misspellings, comments, or highlighted text as these are areas where you’d want to see from a top-level view.

## Publish & Print
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2514%3A579)

## Dictionary
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2514%3A1203)
Maybe one of the larger time-saving ideas, being able to search for the definition of a word, or find synonyms/antonyms without leaving the app. Highlight a word to get its definition and/or change it to a synonym.
1. Insert words by clicking on the definition, synonyms, and/or antonyms.
2. Replace words by highlighting them and THEN clicking the definitions, synonyms/antonyms.

# Syntax
TYPE uses Markdown based on GitHub Flavored Markdown (GFM) syntax with a few custom tags. Some syntax will receive visual formatting specific to TYPE (like tables and code fences) to make them both easier to read and edit.

## Tag Toggling
Syntax can be toggled on/off with keyboard shortcuts. If a word is highlighted or if the cursor is touching a word the writer can use a shortcut(if one is mapped) to toggle the tag on/off. For example, Bolding a word.

## Mirror Modify Bracketed Syntax & Punctuation
Deleting or highlighting & changing either the opening or closing tag or punctuation automatically deletes/changes the opposite.

## Auto-close
If an opening tag for syntax or punctuation is entered, the closing tag will appear automatically after the cursor. Hitting Return or arrowing up/down from the line will close the tag.

## Auto-Wrap
Entering bracketed punctuation (,[,{,",' and/or syntax on highlighted word(s) will wrap the word(s). **The syntax always goes outside the punctuation.**

# Links
Plain urls like www.google.com will appear as clickable hyperlinks in the document.

Links in markdown syntax [displayName](url) will appear as hyperlinks as the displayName.

Using the shortcut **⌘K** without any text highlighted will add a blank syntax placeholder of: [Name](url).

## Internal Links (custom-ish syntax)
Links can point to headlines within documents- clicking these links will direct the workspace to the headline in the open document or a different document all together. This is incredibly useful for building a database or wiki.

**Syntax ideas:**
[displayName](#headline) link to a headline in the same document
[displayName](DocumentName/#Headline) link to a headline in a different document

## References/Footnotes
Technically links, but their source can be from anywhere. instead of parenthesis, the url is wrapped in curly brackets.

**Future Development**
Adding a reference generates an instance that is stored in the Folio. Here you can edit the formatting details (Author, Date, Title, etc), this info will be linked to when publishing to create a bibliography/works cited page.

**Snytax**
[referenceName]{reference}

#Tables
[EXAMPLES](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2665%3A0)

Tables are rendered in the workspace to make them easier to edit and read.	

**Move Handles**

Click and drag entire rows/columns to different parts of the table.

Rows can be moved up and down with keyboard shortcut: *Shift-command-up* and 
*Shift-Command-Down*.

clicking on a move handle will select the entire row or column and provide additional options. Columns will have **Alignment** options

**Align** - Move - additional dropdown (add rows/columns or delete row/column).

## Images
Image tags have an additional **Alignment** options when they are created and/or selected in the workspace. Using the **Promote**/**Demote** Shortcuts or clicking on the alignment icons, the alignment of the image changes in the preview/publish.

Dragging an image to the workspace, or Pasting it automatically generates the proper syntax.

**Alignment Options:**
- left
- Center
- Full Width
- Right

## Nice looking Code Fences for Documents
Text wrapped in the code tag will be wrapped in a code fence. The writer can declare the syntax by clicking the syntax button at the top right of the fence and the code inside will highlight accordingly. Code fences can have their own line numbers.

## LaTeX formulas
Though it is niche, generating mathematical formulas through LaTeX syntax is a good feature to have.

This is smart:
[`https://mathpix.com/`](https://mathpix.com/)

## Syntax (GitHub Flavored Markdown)
| Name | Shortcut | Syntax |
|----|----|----|
|Headline | | # |
|Headline 2 | | ## |
|Headline 3 | | ### |
|headline 4 | | #### |
|Unordered list | - or `*` | |
|Ordered list |
|Bold | ⌘B | ** ** |
|Italic | ⌘I | * * |
|Strikethrough | |   |
|Divider | | ---- |
|Link | ⌘K | `[name](url)` |
|Image | | `![imageTxt](url)` |
|Blockquote | > | |
|Code | | |
|Code Block | | |
|Checkbox Item | | `[]` |
|Checkbox Item (checked) | | `[x]` |
 
## Syntax (Custom)
| Name | Shortcut | Syntax |
|----|----|----|
|Underline  | ⌘U  | `_` |
|Comment    | ⌘/  | `//` |
|Highlight  | ⇧⌘H | `::` or `!!` |
|Mentions   |      | @username |
|Inner-link | ⌘K | `[linkName](#Headline)`|
|Reference | |`{referenceName}(link)` |
|HTML Button | | `!<button>(link`)|
|Box form | for print, signature box, etc | `[_]` |
|SuperScript | This is from LaTeX | `^{x}` |
|SubScript | This is from LaTeX | `_{x}`  |

# Themes
Themes define the colors of the UI and Markdown Syntax highlighting. Every theme has a light and dark version. The default theme also has color blind options

**Color Blind Options**
These would be based on a contrast palette for the different variations of color blindness.
- Protanomaly Red/Green
- Protanopia Red/Green
- Deuteranomaly Red/Green
- Deuteranopia Red/Green
- Tritanomaly Blue/Yellow
- Tritanopia Blue/Yellow
- Achromatopsia Totally Color blind

# Toolbar
The toolbar is important for new users to markdown. It can be customized with a variety of buttons used for formatting and viewing different parts of the application.

*The toolbar auto-hides after ‘x’ amount of characters have been entered in the workspace.*

# Touch Bar
Not entirely sure what should go here outside of replicating the Toolbar. But this is 

# Actions
Actions are a way to automate repetitive and 	manual tasks that come with writing through text commands.

You can think of **“Find/Find & Replace”** as an action. As it is a string of repetitive actions that have been automated to diminish the task of finding every instance of a word and manually replacing it.

So instead of just “Find and replace” you could say, “Bold every ##Headline”, “Create a 2x2 table”, or “Unfold all lines.” Commands like these would take time to complete manually, but by using an action, they’d be instantaneous.

## Action Bar
[EXAMPLE](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2518%3A7384)

*Similar to the command palette in Sublime Text*

Action queries occur in the Action bar. This pop up at the top of the workspace and contains a text field(s) and buttons. This is where **Find/Find & Replace** input would appear if you used ⌘F or ⌘⇧F (or if you opened the action bar and typed “Find” and hit enter)

## Fuzzy Queries
When the action bar is called, it has a single text field where you can type whatever you want. However, only specific commands will do anything. When you start writing, the action bar will expand a bit and Fuzzy search from the list of appropriate commands.

When fuzzy searching for an action, it is context aware of if text is highlighted or not.

### Open
Opening documents in an action works like **notational velocity**. 

### Action Examples
- "Bold every X."
- Create a table
- show a preview of the tables dimensions
- Move selected text to (line),(Beginning),(end),(Document Name)
- Add an Image
- Open, Delete, Archive, Tag, and/or move documents
- Change the Layout, mode, or view.
- Change an app setting.
- “Delete all strikethrough text”
- Check for updates.
- Jump the cursor to any #, ##, ###, or Line Number
- Change a list’s format (ordered or unordered)
- Sort a selected list.
- Batch Process edits or functions
	1. ex. Expand or collapse all folders
	2. ex. Demote/Change Every H1 to H2.
	3. ex. Split the document into Pages (8.5x11 or A4 size)
- Send highlighted text to another part of the document or another document entirely.
- Create a table with specific dimensions.
- Add an Image
- Add a markdown tag by name (if you forget the symbol but remember the name)
- Fold/Unfold Headlines, Lists, Tables

If pulled off, it’ll make everything that came before it look obsolete, and everything that comes after it seem like a rip off.

----

# Mechanics
Along with Actions, keyboard and writing mechanics are a significant feature of TYPE. A lot of the inspiration comes from the idea that, “The longer your hands are at the keys, the better chance you have of writing.” 

## Rearranging
Type allows writers to change the position of text in the workspace, as well as documents/folders within the folio using keyboard shortcuts or clicking & dragging.

Table rows can also be reordered, the only ones that cannot move are the header row and the following "alignment" row for Markdown syntax tables.

## Promote & Demote
Rearranging deals with "Up and Down" Promotion deals with the directions "Left and Right." Along with indentation, the shortcut would promote/demote other elements like “headlines”- which would add or remove ‘#’ from them. Image alignment could also be promoted/demoted-changing it from (left, center, Full, And right).

- indenting/Deintenting paragraphs and lists
- Image alignment selection
- moving table columns left/right
- Adding/removing '#' to a headline

## Folding
Collapse multiple lines of text into a single line, which shrinks the vertical height of the whole document, making it faster to navigate.

## Slice & Merge
While editing a document, it can be divided into multiple individual documents by adding a slice at the cursor. Doing so will create two new documents, one containing all the text above the slice and the other with all the text below the slice.

## Shift Selecting
tapping right or left shift by itself highlights word the cursor is touching. Rapidly hitting shift will highlight the sentence, and Three times rapidly highlights the whole line.

### Directional Shift Selecting
Left shift selects words/sentences/lines behind the cursor, where right shift selects words/sentences/lines after the cursor.

## Linear Copy & Paste
This is lifted directly from text editors, If the cursor is on a line, using the Copy shortcut will copy the entire line **you don’t have to highlight the text**, and pasting that line will place it below the current line.

### Context Sensitive Pasting
If compatible syntax is pasted from the clipboard it will be formatted for Type.
- Or - If the last thing you copied was a url and you create a new link in a document, that url will be automatically pasted in the ().
- convert from Markdown or HTML code,
- convert from Rich Text formatted text,
- strip out all tags by pasting as Plain Text,
- add code examples by pasting as Code Block

## Human Error Spelling and Grammar check
A spell check which targets common typos that a normal spell check would otherwise miss since nothing is spelled incorrectly.

- complemented vs complimented
- Principal vs principle
- hoard vs horde
- every day vs everyday
- ass vs add
- A dress vs address
- bowel vs bowl
- Untied States vs United States
- whore vs where
- stalking vs talking
- satan when you mean satin
- pubic when you mean public

#Settings
[WIREFRAME](https://www.figma.com/file/SYqD5LWkzhuOmtJCYjvOkMTz/Type?node-id=2495%3A139)

Popup to comply with apple's HIG.

# Shortcuts

## Application

| Name | Shortcut | Description |
|----|----|----|
|Settings | ⌘, | - |
|Action | ⌘. | Toggles Action Bar in workspace |
|Folio | ⌘1 | |
|Workspace | ⌘2 | |
|Sideboard | ⌘3 | |
|Info Sideboard | ⌘4 | |
|Preview | ⌘P | |
|Publish | ⇧⌘P | |
|Print | ⌥⌘P | |
|Toggle Find | ⌘F | context sensitive to where cursor is or if somethings selected |

## Folio

| Name | Shortcut | Description |
|----|----|----|
|Focus Folder | ⌘Enter | - |
|Unfocus Folder | Esc | - |
|Delete File | ⌘DEL | - |
|Group File(s) | ⌘G | - |
|Ungroup File(s) | ⇧⌘G | - | 
|Rename File(s) | ⌘R | - |
|Merge documents | ⌘E | - |
|Duplicate documents | ⌘D |-  |

## Workspace

| Name | Shortcut | Description |
|----|----|----|
|Split Workspace | ⌘T |
|Toggle between split | ⌥⌘T | moves cursor between split docs|
|Slice Document | ``⌘\\`` |
|Next Document | ⌘PGDN |
|Previous Document | ⌘PGUP |
|Focus | ⌥⌘F | Toggles text focus |
|Typewriter | ⌥⌘T | Toggles Typewriter scrolling |
|Increase Font Size | ⌘+ |
|Decrease Font Size | ⌘- |
|Toggle Fold | ⌘’ | Folds/unfolds line(s) |
|Find Next | ⌘D | Finds next instance of selected word |
|Toggle Find & Replace | ⇧⌘F |

## Writing Mechanics
| Name | Shortcut | Description |
|----|----|----|
|Shift Select (Word) | ⇧ | Tap shift to select a word nearest/touching the cursor (Left shift selects previous word, right shift selects the next word) |
|Shift Select (Sentence) | ⇧⇧ | double tap shift rapidly to select the next/prev sentence)
|Shift Select (Line) | ⇧⇧⇧ | - |
|Move Selected | ⇧⌘M | - |
|Move up| ⇧⌘↑ | |
|Move Down| ⇧⌘↓ | |
|Move to top | ⇧⌥⌘↑ | |
|Move to bottom | ⇧⌥⌘↓ |
|Promote | `⌘]` | |
|Demote | `⌘[` | |


----

# Concepts
*Napkin Sketches & Ideas for future updates & Development. Some of this are half-baked ideas.*

## Layout Styles
Additional styling set to a layout (created with PFD layout in mind-) if you want to differentiate between a standard PDF and something like a CV or resume.

### Building a Database
Using the references as a character bible for developing a story. example: Character Name(Description of the character). These pronouns are avoided by Spell Check.
References & Citation Rearrangement
Rearranging a reference in the sideboard will change the reference numbers in the document
Moving referenced text above/below other referenced text in the workspace will update the sequence number in the sideboard. If the referenced text is an IBID and moves above the initial reference, then the Ibid becomes the reference, and the initial reference becomes the ibid.

### ”Symbols", Libraries, or Passages (some other clever name)
Like design tools which reuse elements, writing can use a similar feature. With writing symbols, one would create a source file for the symbol, then that same text can be added to other documents, editing the source would update every instance in every document.
This would be good for something like legal documentation or even character bibles. If the main character's name needs to change, instead of doing find&replace, you'd edit the source.
•	When a passage is used in a document, there is an asterisk next to the line number of the containing passage, click on the line number to go to the original passage
•	if you edit an instance, it detaches itself from the source, so it wont be updated automatically since it differs from the original.
•	writers can detach instances from the source w/o with the context menu
Quick Note, when you just want to jot something down without going through the process of creating a new doc or opening a document
The Assistant can be opened from outside the application to edit/add notes from the Folio. When called, the window works similar to notational velocity where the initial keystrokes perform a fuzzy search of all notes, and if no note contains what you've typed, then you can create a new note from whatever it is you entered.
being able to quickly capture them I think is invaluable.**
Notes are saved in a special "notebook" folder
Download Notational Velocity for an example.

In the sideboard, moving a reference below an Ibid, the ibid data (like page number) should swap places with the reference data. i.e. if the reference has "page 10" and the ibid is "page 44" if the sentence(s) in the workspace move ABOVE the initial reference, the sideboard would display the page number for the reference as "page 44" and the ibid becomes "page 10"

## Batch Renaming documents (ACTION BAR?)
Selecting multiple documents and initiating a rename ⌘R allows for a batch rename in the order they are presented. If writers wanted to Number their documents this would be really helpful.

## Auto-Number
Set a folder to prepend a number or phrase (like Chapter one, two, three...) to the documents it holds.

## Q&A Interview style Q:_
transcribing an interview, the list items can alternate between Q: and A: Q&A lists might be the only ones impervious to relabeling when rearranged

## Notes
I like the idea of the notes being used for more than just holding text, it should have more functions than that commented text in a document can be sent to a new or existing note. Some writers might want to make notes in the document as they're writing, and later reference them This declutters the document and still available to view. Like shaking an etch-a-sketch

## Apple Notes Onboard new users by linking Apple notes to Type.
A lot of writers use the Apple notes app on their phone, and would be good to allow them to access those notes from within type.

Maybe they can link to the system folder?
/Library/Group Containers/group.com.apple.notes/

## Collecting Commented ToDo's
if you begin a comment with "todo", then those comments can be collected in a sideboard creating a checklist, or maybe even used in another app like Reminders.

## A way to "check done" documents, Turn to "Document Tasks"
working on a multi-document project non-linearly could use a visual cue to indicate, "this doc is done, and others still need work." Could be a feature of "Focused" folders.

## Pinning lines/Rubber banding
Set a temporary pin on a line, then you can scroll around the doc, or go to other documents entirely, and when you hit a shortcut you automatically go right back to that line, the pin disappears after returning. It's the equivilent of putting your finger on a page and flipping through a book.

### Auto Pinning
If you use the mouse wheel/scroll manually up or down the document, there is an option to pin the row of the line the cursor resides to either the top or bottom of the viewport (depending on which way you scroll). If you scroll up the line sticks to the bottom, if you scroll down the line sticks to the top. (this suggests the relative location of the line where you left the cursor, its either above or below where you are now)
- mouse clicking the pinned line or typing will snap you back to the line
- are you able to write in the pinned location while viewing the new one? would anyone want to do that?
- If you move the cursor outside the line, or if some time has passed, the sticky/pinned line dissapears
- This also doesnt work when you’re focusing or in typewriter mode


# Plugin API for Actions and Sideboards
Programs like [sketch](#), Sublime Text, and Framer thrive on a community of designers and developers who build functionality into the application. This was only possible because the devs opened up the API and made it easy to create plugins and allow the creators to profit from their contributions (if they desire). It democratizes the feature-set for the application and only strengthens the user-base.

# Git Integration
- changes indicated graphically, probably by the line numbers.

# Where the cursor was last
jumping around a document with something like *FIND* can leave you in a place within the document that you don’t want to be, maybe you just wanted to check something from earlier in the document, there should be a way to return to the last known position of the cursor AFTER an action that travels around the doc.

# Serial to List
the ability to highlight a list of text in a series separated by commas (something, something, something, and something) and turning it into an ordered/unordered list, and vice versa.

# Unsplash Integration
in the sideboard, you can search for images to use as placeholders or even for the final doc. We should also pull in the contributors credits as a reference for the bibliography.

# Indie Publishers
build integrations with independent publishing or print houses. Empower individuals before getting in bed with a huge publisher.

### Whiteboard/Storyboard
The option of viewing documents as a thumbnail gallery either in the folio, or in the workspace. The thumbnails would be sized according to standard 8.5x11 paper. (or their layout?)

## Collaboration with strangers, Social Engineering better writing.
sending your writing to be edited or audio to be transcribed. Since the app tracks time spent on a document you can pay freelancers well.

## Self Publishing Content Management System.
I think with compilers like Jeckyll, and services like blot or Small Victories which use a dropbox folder to host markdown files as web content, I think it'd be a big sell if someone could manage/publish a website (be it a blog, portfolio, or presentation) directly from the app without ever needing to open a browser.
Type should allow for people to publish their writing on their own. If they have built a website or some other outlet then they should be accommodated
I think I just want for people to be able to publish and manage their writing within the app. Would be interesting to make this apart of type, and to make the experience more understandable for non-programmers.

## Vendor Layouts
The ultimate goal for TYPE is to be a headquarters for writing. Someone should be able to start and end their work from within the app and never need to leave and sign-in to another service or copy+paste their markdown somewhere else. Integrations with Online services like *Wordpress, Medium, Small Victories, and Mailchimp* would be extremely valuable to users.

#### Newsletter Services
letterfuel
Font Foundries
Partnering with Indie foundries to have print layouts use their unique font faces and font pairings (also for self-published websites?)
Fatype
Klim
GrilliType

### Email Marketing
A sleeper feature would be to generate newsletters from within Type, Email marketing is a big business and both allowing users to generate their own campaigns or integrate with their company of choice mailchimp, tinyletter would be worth developing. It would be a matter of establishing a layout for them
Publishing Sideboard
This sideboard pops-out whenever the writer wishes to publish. (submit to a platform) or export (create a copy outside of Type in a particular format)

It’d be cool to establish a skunkworks platform, something similar to Small Victories & Tiny Letter where everything is self hosted and all the data can be found in the app.

### Slash commands
simple commands
- /date - enters the current date
- /time - current time
- /tomorrow - date after current date

# Technical
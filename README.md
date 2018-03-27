# README.md
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/ui.png">

# Abstract
TYPE is a modern markdown editor built to be the origin of every writer’s process. The idea being, to create a space where the simple act of putting text to pixels is at the forefront, and once that’s finished to provide writers a way to publish their work to various platforms/services within the app.

<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/concept.png">

Whether someone is crafting their dissertation, running a marking campaign, curing cancer, or writing a novel. They should be empowered by the tool they use. Writing is fucking hard at the most atomic level, I wanted to design something that would make everything else easy.

## Better writing by design
Type is driven by the markdown plain text language. It is the best choice as it is all about forward momentum. Writers fluent in the simple language can write and style text with in the same gesture. Paired with an interoperability in print and digital formats, markdown is the best fit for the app. paired with syntax highlighting, the experience of writing in markdown becomes wholly different writing experience, words and colors work in unison and give writing a new dimension.

Along with a language that promotes efficiency, The core user experience is centered on the keyboard. As the sole input device for text, I find that the more ones’ hands are at the keys, the better chance they have at writing.” This is accomplished with a simple interface and clever new word processing mechanics.

## The  Audience
This application and it’s features are made to serve three categories of writers:

### Creative Writers
* Books/Novels/Short Stories
* Poetry
* Scripts/Screenplays
* et al

### Modern Writers
* Journalists
* Web Publications/blogs/Forums
* Static HTML Pages
* Social Media Posts
* Email  & Newsletters 
* Wiki pages
* et al

### Academic Writers
* Research papers 
* Presentations
* Documentation
* Journals
* Grants
* Notes
* et al.

# The Structure of Type
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/structure.png">
The application is composed of:

### Library
 Contains the Inbox, Filters, and Folders

### Documents
 List of collected pages.

### Workspace
 Area where all the writing is performed.

### Sidebar
 Hosts the /Runner functionality, which is the engine of productivity for TYPE

### Toolbar
 displays buttons of functionality, designed to onboard writers new to markdown.

# Library
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/library.png">
The library is the organizational structure for writing. It displays all the folders and subfolders which contain documents, references, and attachments.

## Inbox & Smart Folders
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/smartfolders.png">
The inbox is a folder which gathers all orphaned documents (those which do not have a designated folder). The inbox is the “First Folder” and cannot be deleted.

## Smart Folders
Smart folders organize documents based on circumstantial criteria. The three permanent smart folders are: All, Bookmarks, and Recent. 

**Eventually** users should have the ability to define a custom smart folder.
They can be divided into three categories:
* **Location based** - “Documents edited at work vs home.”
* **Time based** - “Recent”, “Past ‘x’ days”, “most/least worked on”
* **Status based** - “Shared, Bookmarked, and Archived (published)”

## Folders
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/folders.png">
Folders organize documents into a two tier file structure. Folders can have custom icons but subfolders cannot (this makes for a much cleaner look).

### Vendor Folders
Folders which link to an integrated service (Blog platform, Cloud storage, Github repo, independent publishing, newsletter automation service, etc) are considered Vendor Folders. They could have unique layouts and settings associated with the documents contained within them.

 A good example of this is a folder/subfolder that always posts to the same source and needs to be formatted accordingly.

Folders can have export and publishing presets assigned to them.
* if there is markdown that the publishing destination does not accept.
Vendor Folders - have preset publish criteria.

## References
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/references.png">

This was originally designed for researchers and academics, but it dawned on me that most writing that isn’t creative tends to have numerous references associated with them.

References are documents with citation data associated with them. They can be cited in a document and listed in the footnotes/endnotes. The reference itself contains all of the literature/information of the reference, so those documents can be appended to the final print.

## Source  & Citation
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/selectedref.png">
The Abstract and Full Text (or image if the reference is a picture) of the reference can be viewed or edited.

### Source Data
This is technical information about the reference. This data populates the citation in the footnote according to the proper format.

### Location Links
The reference data also contains links to the documents that it is being used in. Clicking on the document name, line, or page number will open the document and place the cursor on the line of the reference.

## The Archive
The library needs to reflect the present work of the writer. Projects which come to a close or documents that have been published are sent to this folder. These documents earn a “First edition” stamp (somewhere) indicating that they made it to the finish line.

People like checking things off a list, it feels productive and garners a sense of accomplishment. This could not only be a great way to produce that feeling but also encourage more writing.

## Attachments
Writing often contains additional content. Any time you attach an image, video, notes, or some other piece of media to a document it will be stored and filed in the Attachments folder. 

Similar to References, you can see the media, where it came from, and a list of documents it can be found in.

# Documents
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/docs.png">
Documents are the pages of text contained within folders. They can contain infinite (8.5x11”) pages within them. they can be filtered, sorted, and merged. 

<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/docanatomy.png">
Documents are files that contain text, images, tables, references, links, etc. they can span multiple (physical) page lengths and be exported to any printable file type, and published to any platform (that accepts Markdown and has an available API)

Documents are named either by the first **\#title** and **\##subtitle** in the document, or manually in the /info panel. (See sidebar)
 
# Workspace
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/workspace.png">
The workspace is where all the writing occurs. The text displayed from a document is formatted in two ways: Standard and Syntax and viewed in three different ways: Focus, Split, and Paged.

<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/format.png">

### Syntax
Syntax is the raw form of writing in TYPE. The writer sees all of the markdown tags  and has the ability to decorate the text and tags with color and highlighting. Programmers have used this feature for a while, and it is just as helpful when writing prose.

 [Ulysses Style Exchange][1] and [IDE themes][2] have good examples of syntax highlighting.

### Standard
Standard format displays text as it would appear in it’s final form (a proof). It displays variable font sizes, weights, and line heights depending on the **Layout** chosen for the document.

Text is still written with markdown, but the syntax disappears after it’s entered and transforms the font accordingly. (i.e. if something is  **bolded** the writer would only see the word **Bolded** without the asterisks.

## Views
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/views.png">
The default view is a simple text editing window. One centered column of text in the window. However, the writer has the option of three additional ways to view the workspace. These views are not discrete as they can be combined to offer a tailored writing environment.

## Focus
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/focus.gif">
More commonly known as “typewriter” mode. The scrolling position is fixed to the top, center, or bottom of the window. The user has the option of highlighting just a single horizontal line, sentence or paragraph. The writer also has the option of “Variable” which fixes the position wherever they place the cursor on the page.

## Split
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/split.png">
In split view you can load two documents side-by-side. They can be two different documents, or the same document (perhaps one in markdown and the other in standard as to be a preview of how the final text could appear.) 

## Paged
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/paged.png">
This view has two different options. The first option defines the left and right boundaries of the page (A4 or 8.5x11 by default). The other provides a rectangle delineating a piece of paper (this is a lot like MS word would display documents). This view displays page breaks as separate pages.

# Sidebar /Runner 
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/sidebar.png">

Runner is the **Swiss-army knife** of **TYPE**. It is contained on the right-hand side of the window in the **Sidebar**. From here the writer to access and execute complex functionality with just a few keywords. Activate runner with the shortcut **( ⌘+/ )**.  

Everything is arranged in a vertical orientation, this allows arrowing up and down to be the fastest way to navigate a category.

<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/runner.gif">

## Running inline
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/inlinerunning.png">
Runner can be activated while you are writing in the **workspace** as well. typing **‘/‘** opens up a runner dialogue box (similar to Slack)

Some examples of inline running:
* **/add**, **/make**, **/insert**  a table or an image. You can also pass dimensions to the table (i.e. ‘/add table 3x5’).
* **/indent** every #title.
* **/#purple** jump to the first title with the name ‘purple’
* **/shortcuts** opens a list of shortcuts in the sidebar
* **/clipboard** opens the clipboard manager in the sidebar

The runner is an advanced practice in user interaction. New users will have at their disposal, a button they can place in the toolbar for every runner category as well as markdown functionality.
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/beginnerbuttons.png">

### By Default
Opening the sidebar for the first time, the writer is faced a list of the categories in Alpha order. After they have selected or entered into a category, that one will appear at the top as the most “recent” used. _The top result is always highlighted_
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_blank.png">

### Categories vs Commands
Runner allows you to navigate different **categories** of functionality and information as well as run simple commands that automate processes that would normally take numerous keystrokes and steps. Building a table in markdown is a perfect example how the use of commands would work.

Commands are broken down into categories and subcategories. Each is accessible by typing them into the input field that is activated by the shortcut or clicking on the button at the top right. To make this selection faster and easier it uses **Fuzzy search** results while you type.

## Categories

#### Filtering
(These can be accessed by adding a colon “:” after the initial word i.e. /Category:subcategory)

### Combo Run
The writer can also view a mix of different categories/subcategories in the same sidebar window by using ‘+’ in the query. 

Some categories come with an multiple categories by default. **/Publish** for instance, presents the publishing options as well as **/Layout** options. 

_Writers can bookmark combos they like (somehow)_

## /Clipboard
Access and recall the history of your clipboard.
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_clipboard.png">


## /Comments
Comments within a document can be toggled visible/hidden and stored in the sidebar or displayed in the document.
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/notesAndcomments.gif">


## /Export
Exporting  creating files on your hard drive. In the export category you have the option to choose and adjust the layout and typography as well as selecting the file formats you want to create from the document.
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_export.png">

### Auto-Update
Instead of continually saving and re-saving your work after you’ve exported it (to make changes or if you spot a spelling error) you can check “Auto-update” before you export. By doing this the file you export will reflect any changes you make to the document AFTER you’ve exported it. This lasts until you
* export the same document again
* Move the document from the destination folder

## /Goals
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_goals.png">
The ability to set writing goals is an important tool that writers really appreciate. It instills incentive in the writing process
Goals can be:
* **word** : at least, more than, and/or Less than (x) words, pages, minutes, adverbs
* **Time** : Publish by (mm.dd.yyyy)

Goals can also be combined like rules, I.e.
“I want to write _at most 1000 words_ using _less than 2 pages_ by _next week_.
Goals that deal with time can be added to your calendar.

## /Info
Information about the folder or document selected.
The #title is determined by the first #title tag in the document, if its changed in the sidebar
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_info.png">

### Citation
Set the type of reference format here (MLA, APA, Chicago, etc) and the citation will reformat accordingly in the document.

### Counts & Grammar
selecting a part of speech will highlight every instance in the document.

### Complexity
is the reading level of your writing [Hemingway editor][3] does this.

### Aloud and Stopwatch
Speech gives an estimated time it would take to orate the writing. If you want to time it yourself you can activate the stopwatch

## /Layout
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_layouts.png">
This is where the merit of markdown shines- Since its in a plain text format the writing can fit into the definitions of page layouts. The writing can reconfigure its appearance without painfully reformatting anything. 

Layouts can be found in the **sidebar** when you’re in **Publish/Proof** mode. You can create your own with simple parameters, anything more specific you’re going to need another piece of software like “Adobe Indesign” NOTE: it’d be rad if TYPE could prepare a document that could be imported into publishing/layout apps.

## /Notes
manually add text to the sidebar as notes. It’s associated with the document and has a section in the “Attachments” folder.

## /Settings
General settings for TYPE.

## /Themes
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/r_themses.png">
Writers have an ability to customize the workspace theme. **Themes** determine how the writing appears in the app. Arrowing up and down the themes sidebar updates the workspace in real time.

Some of the customizations include:
 * Font, font size & spacing
* Syntax color/highlighting, font color/highlighting
* Line numbers: left side, right side, or Off.
* Line height (points), Line width (characters), Paragraph spacing(Points), First Line indent (points).
* Ordered and Unordered list alternate colors

	## Lite & Dark
	<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/litedark.png">
	Every theme has a lite and dark version that you can switch between them. The UI will match the background (in contrast &or color). So the theme “Solarized” would contain color styles for both “Solarized Lite” and “solarized Dark.”

## /Typography
Writers can change the typography of their theme with fonts on their system. Eventually I think this should be an integration with [font foundries][4]

## /Developer custom
Runner categories should be treated like plugins/extensions that other developers can create and share. I think this kind of openness is vital to growing a user base and also strengthening the utility of the application. It allows for a larger degree of innovation and investment, especially if it helps devs turn a coin.

A good example of a runner extension would be something like ‘/Hemingway’. Based on the web app [Hemingway editor][5], it deconstructs and evaluates writing based on its complexity and structure.

# Toolbar

The toolbar is mainly for those who are new to markdown. Markdown is intuitive once you get over the initial hump of learning the syntax, but people are used to the “MS word” school of word processing, where the only formatting done with a keyboard is **Bold** and _italic_ 

<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/toolbarex.png">

The toolbar is a set of training wheels, that require a mouse cursor. To nudge users away from it and for visual convenance _The toolbar fades away when you start typing_. (It can also be hidden entirely)

# Mechanics
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/mechanics.png">
The sidebar and runner is a unique angle to a writing environment. However, there are ways to improve the simple act of inputing text on a screen with a keyboard. 

I remember learning functionalities of text editors, all of the small nuances seemed really arbitrary, but to programmers, shaving off a few repetitive keystrokes accumulated to vast time and efficiency gains. I wanted to apply similar principals to writing to simultaneously benefit the writer and improve their experience.

## Autocomplete Shift
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/shiftautocomplete.gif">

This idea is inspired by the [space cadet shift][6]. In short, a programmer built a keyboard firmware which used left and right shift keys as open and close parenthesis. Holding shift and keying in another character would still return capital alphas and shifted punctuation, but tapping it once would return an open ’(‘. After that you would be able to add any amount of code and hit right shift for the ‘)’. This is ingenious, because the shift keys are typically the second largest key on the board and the right-shift might be one of the least used. 

TYPE uses half of this mechanic. Instead of assigning the left and right shift keys one character, it only uses the right shift to close any open tag or punctuation. The **Left shift** alone is used as a way to highlight text (seen below: [Shift Select][7])

When you enter syntax and then enter characters, you don’t need to repeat the syntax at the end, you can hit **right shift** to complete the closing syntax. Closing syntax in this manner also automatically adds a _space_ right after, saving you an extra keystroke and furthering the momentum of writing.

## Outline
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/outline.gif">
The outline is (technically) a list of anchor tags built from “#Titles, ##Subtitles, and ###headlines ” automatically. It provides a birds-eye view of your writing that you can interact with. It more-or-less treats text like groups and layers in photoshop.

### Rearranging & Relocate
Clicking on a title, subtitle, or headline will move the cursor and viewport to that part of the document. The writer can also rearrange the outline and the document will adjust accordingly. This follows the same hierarchy for rearranging text within the document itself. This allows a “broad strokes” approach to writing composition.

## Rearrange
Text editors have done this for a while, and its a really fast way to compose writing once its on paper. 

Rearranging follows a hierarchy. **\#Titles \> ##Subtitles \> ###Headings \> lines \> lists**

Titles, subtitles, and headings become “groups” in this way. Moving a #Title will never move another #Title (same with subtitles and headlines) They can only move what is below them on the hierarchy.

So, by moving a #Title, you also move all the content below it together (until the next #Title occurs.) ##Subtitles and ###headlines operate in the same manner, anything below a ##subtitle or ###headline will all move together if the cursor is in said subtitle or headline once it’s moved. Lines of text only move themselves as well as ordered/unordered list items

## Reference Renumbering
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/renumber.gif">
References in the footnotes/endnotes section will reorder/renumber automatically if the reference has changed positions up or down the document or if another reference was added in between, before, or after another reference.

 Auto-renumbering is a godsend to any writer who uses multiple references.

## Folding
<img src="https://github.com/JEFLBROWN/Type/blob/master/Img/folding.gif">
Collapse multiple lines to one, hiding the text. Folding follows the same hierarchy as Rearranging. If you fold a #Title, everything below it (until the next title/subtitle) collapses into it. Collapsed text can still be rearranged in the document.

## Smart Cursor
Simply placing a cursor inside of a word or at the beginning of a word allows you to **Bold** or italicize it with a keyboard shortcut.

### Line movement
 if you want to rearrange lines, you only need to place the cursor anywhere inside that line.

### Shift Selection
you can select a word by pressing _Left_ shift once. Rapidly pressing it twice selects the sentence (or last words typed after a sentence). Three times and you select the line that the cursor occupies.

### Text Decoration
Bold/italicize a word by placing the cursor next to or anywhere within the word and use ⌘B or ⌘I. 

### Quote Wrapping
If you want to add quotes to a line, you can highlight the whole line and use shift + ‘, and it will auto wrap the highlighted with quotes. (This also might need to be a shortcut)

### Copying
if nothing is selected/highlighted using ⌘C copies the line where the cursor rests.

### Earmarking
mark a place where you want your cursor to jump to, its like bookmarking a line within a document. So if you want to go back and forth between two places you can earmark them and toggle back and forth. Or maybe you started on a paragraph but had an idea for something else somewhere else in the doc, you can earmark and then go off to do that. Earmarking is also kind of like a “reminder” to come back to something.

### Inline Find
( ⌘ + D ) This is stolen from Sublime text, you can select a word or character and find every instance of that word/character that comes AFTER the one selected.

# Extended Roadmap
### Ideas that could be interesting if development continues.

### PDF editing
An ability to edit PDFs:
* sign and date it
* Fill in any form fields
* add/remove pages.

### Font Foundry integration
It’d be cool to champion good typography and allow typographers to expose others to their work and get paid for it.

### Slide deck layout
Export a static html page which uses CSS transitions to create a slide deck.

### Collaboration
A way to share and collaborate on a document.

### Mobile apps
Iphone and Ipad apps.

### Portrait pencil edits
Edit writing on an iPad with the Apple Pencil in portrait mode. you can highlight, make notes and mark for deletion using pen gestures.

[1]:	https://styles.ulyssesapp.com/tagged/Theme
[2]:	http://color-themes.com/?view=index
[3]:	http://www.hemingwayapp.com/
[4]:	https://github.com/JEFLBROWN/Type#font-foundry-integration
[5]:	http://www.hemingwayapp.com/
[6]:	http://stevelosh.com/blog/2012/10/a-modern-space-cadet/
[7]:	https://github.com/JEFLBROWN/Type#smart-cursor
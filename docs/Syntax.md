Type uses Markdown syntax based on GitHub Flavored Markdown [(GFM)](https://guides.github.com/features/mastering-markdown/) with a few additions. Markdown promotes forward momentum when formatting through a simplified syntactical and visual language. Markdown in the workspace is emphasized/de-emphasized through color based on the selected [**Theme**](https://github.com/JEFLBROWN/Type/wiki/Themes).

![Syntax Highlightng](https://github.com/JEFLBROWN/Type/blob/master/Img/syntax_highlighting.png)


**Spacing between the tag and the first character doesn't matter.** For example, This `#_Headline` or this `#Headline` both render text as a headline. This might seem minor, but makes a huge difference while writing.

>**Note:** Because the app's selling points is that it can publish anywhere, certain layouts will need the space, because some platforms only recognize markdown tags with a space between it and the word.

#### Features

**Syntax can be toggled on/off with shortcuts.** If the cursor is touching a word/tag the writer can use a shortcut(if one is mapped) to remove the tag. For example, Bolding a word.

**Syntax will auto-close with after hitting Return (or Right Shift).** Hitting Shift Return will close the tag _and_ move the cursor to a new line.

**Brackets, Quotations, and Syntax automatically wrap highlighted text when the punctuation/syntax is entered.** Highlighting text and then adding a markdown tag or punctuation encloses the text with said syntax/punctuation.

- [ ] task
- [ ] www.google.com

## Links
links are created through syntax or keyboard shortcuts (**⌘K**). If no text is highlighted when the shortcut is used, a placeholder `[Link](url.com)` will be entered instead.

Naked links like `www.google.com` will appear as styled hyperlinks in the document and in the final document.

**Links can be removed from text by toggling with the keyboard**
Place the cursor in or next to the link tag and use **⌘K** to toggle the link off, this will leave you with the display text.

After a link has been created and the cursor leaves the link tag, the tag will collapse to the display text (the word(s) in brackets) and become styled as a link which becomes underlined and a different color (blue by default- but can change with different themes). if the link is clicked on or the cursor touches it, then it reveals the whole tag.

![Clean Link](https://via.placeholder.com/1000x280)

#### Image Links
An image link is represented as a placeholder pill with the image name, and takes up one line.

#### Image Alignment
Clicking on/moving the cursor on the same line and pressing enter as the image will reveal the Image alignment options.

![Image Pill & Alignment](https://via.placeholder.com/1000x280)

with the image pill selected/cursor touching it:
**⌘]**, **⌘[** to changes the alignment (left, center, right)
Hit return, up arrow, or down arrow to confirm the selection.

#### Copying Images to the workspace
Dragging an image to the workspace, or Pasting it automatically generates the proper syntax for an image.

## Lists
Lists are created through markdown with the syntax: `1._`, `A._`,`Q:_` for ordered lists,`*_` , `-_` and `+_` for unordered lists.

**Lists can be rearranged.** Ordered lists automatically update their numerical order and retain their indentation when they are rearranged. The **entire** list must be selected to rearrange it in the document.

#### Q&A Interview style `Q:_`
transcribing an interview, the list items can alternate between **Q:** and **A:** Q&A lists might be the only ones impervious to relabeling when rearranged

## Tables
Writing tables sucks in markdown, this is the only attribute where the raw text is a worse substitute for its rendered counterpart. In Type, Tables will be rendered, making them easier to edit, and read.

![Nice Table](https://via.placeholder.com/1000x480)

#### Editing Tables
When editing a table and hitting return will add a new row to the table, adding the correct number of columns. This functions like a list editing, where when you hit return the new line beings a new list item.

1. option of alignment
2. Shift Return = Add Row
3. ⌘Del = Delete Row

**Table rows can be rearranged just like lines and lists.** The exception being the header row- If the cursor rests in the **first row** of a table, the **entire** table will move up and down the document.

![Folded Table](https://via.placeholder.com/1000x280)
Folded Tables display on one line as an icon.

## Custom Syntax
There are a few examples of extended markdown which are very useful for writing.

Highlighting
`::A::`

Reference

`{Reference Name}(link)`

`{Term}(Definition)`

Strikethru

`||Strikethru||`

List Checkbox
`- [_] Item`

Checkbox ` [_]`

Similar to tables, Checkboxes will auto format to a clickable checkbox once the cursor has left the syntax.

----
**[← Publishing](https://github.com/JEFLBROWN/Type/wiki/Publishing) | [Themes →](https://github.com/JEFLBROWN/Type/wiki/Themes)**

#### Folding
Collapse lines of text into a single line, which shrinks the vertical height of the whole document, making it faster to navigate.

![Folding](https://via.placeholder.com/1000x280)

> folded text becomes a single line at the first line of the entire folded section. lists and tables can also be folded. (Perhaps tables fold into a line that says "Show Table" with a little table icon.)

#### Rearranging
**Type allows writers to change the position of text in the workspace, and documents/folders within the folio using keyboard shortcuts, Dragging, or via the Outline**
The structure of (most) writing is often, “groups of text which either express or support a thesis (or main idea) of the document.” Main ideas are usually titled with a Headline Tag (**\#, ###, ####, …**) in markdown. Type supports this organization of written thought by moving these groups according to their Headline.

![HeadlineRearrange](https://via.placeholder.com/1000x480)

Lines, lists, and table rows can all be moved up/down one line or sent to the top/bottom of the containing element (the page for text, the top of the list for lists, and the first row of a table)

![List Rearrange](https://via.placeholder.com/1000x280)

**Note:** When you rearrange ordered list items, the items renumber and retain their indentation.

Pargraph Text is rearranged within the workspace according to the same [**Rules of Rearrangement**](https://github.com/JEFLBROWN/Type/wiki/Outline#rules-of-arrangement) the [**Outline**](https://github.com/JEFLBROWN/Type/wiki/Outline). follows

**Rows in a table**
Table rows can also be reordered, the only ones that cannot move are the header row and the following "alignment" row for Markdown syntax tables.

**References**
if a reference changes position on the page, the footnotes reflect this change automatically with renumbering and/or reordering.

Rearranging a reference in the sideboard will change the reference numbers in the document

Moving referenced text above/below other referenced text in the workspace will update the sequence number in the sideboard. If the referenced text is an IBID and moves above the initial reference, then the Ibid becomes the reference, and the initial reference becomes the ibid.

In the sideboard, moving a reference below an Ibid, the ibid data (like page number) should swap places with the reference data. i.e. if the reference has "page 10" and the ibid is "page 44" if the sentence(s) in the workspace move ABOVE the initial reference, the sideboard would display the page number for the reference as "page 44" and the ibid becomes "page 10"

#### Linear Copy & Paste
This is lifted directly from text editors, If the cursor is on a line, using the **Copy** shortcut will copy the entire line. Pasting will paste the content below the current line.

**Context Sensitive Pasting from outside the app**
If compatable syntax is pasted from the clipboard it will be formatted for TYPE.

 - Or - If the last thing you copied was a url and you create a new link in a document, that url will be automatically pasted in the `()`.

> **Example**: Copying Code will automatically put it in a Fence

#### Slicing
When editing a document, it can be divided into mutliple inidividual documents by adding a **slice** at the cursor. Doing so will create two new documents, one containing all the text above the slice and the other with all the text below the slice.

----
**[← Themes](https://github.com/JEFLBROWN/Type/wiki/Themes) | [Shortcuts →](https://github.com/JEFLBROWN/Type/wiki/Shortcuts)**

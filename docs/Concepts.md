Unproven ideas.

### Shift Selecting
tapping right or left shift by itself highlights word the cursor is touching. Rapidly hitting shift will highlight the sentence, and Three times rapidly highlights the whole line.

- **Shift** selects the word the cursor touches. (If it does not touch a word then it selects the blank space). Once a word is selected you can hit Left Shift again to highlight the next word, if you do it rapidly then it selects the sentence.
- **Shift - Shift** - selects a sentence
- **Shift  - Shift - Shift**  selects the whole line.

**NOTE** I’m of two minds as to how this would work. The other idea for this would be that left and right shift designate which direction text is highlighted. This would mean that you can select things before or after what you initially highlighted depending on which shift you hit. **Left** Shift being _before_ and **Right** being _after_.

This would be the cadence of tapping
(-) = rapid
(. . .) = Slow

- `L⇧ . . . L⇧ . . . L⇧`
Select the word … Select the word before the first word … Select the word before that.

- `L⇧-L⇧ . . . R⇧-R⇧`
Select the Sentence … Select the next Sentence after the one selected

- `L⇧-L⇧-L⇧ . . . L⇧-L⇧-L⇧`
Select the whole line … Then select the Line before the one selected

### Directional Shift Selecting
Left shift selects words/sentences/lines behind the cursor, where right shift selects words/sentences/lines after the cursor.

### Human Error Spelling and Grammar check
A spell check which targets common typos that a normal spell check would otherwise miss because nothing is spelled incorrectly

Example:

common grammar
- **complemented** vs **complimented**
- **Principal** vs **principle**
- **hoard** vs **horde**
- **every day** vs **everyday**

common typos & Homonyms
- **ass** when you mean **add**
- **A dress** vs **address**
- **bowel** when you mean **bowl**
- **Untied States** when you mean **United States**
- **whore** when you mean **where**
- **stalking** when you mean **talking**
- **satan** when you mean **satin**
- **pubic** when you mean **public**

### Self Publishing & CMS Soup-to-Nuts
I think with compilers like Jeckyll, and services like blot or Small Victories which use a dropbox folder to host markdown files as web content, I think it'd be a big sell if someone could manage/publish a website (be it a blog, portfolio, or presentation) directly from the app without ever needing to open a browser.

Type should allow for people to publish their writing on their own. If they have built a website or some other outlet then they should be accomidated

I think I just want for people to be able to publish and manage their writing within the app. Would be interesting to make this apart of type, and to make the experience more understandable for non-programmers.

**Static Websites & Slide Presentations w/CSS3 animations**
create documents that generate to a slideshow or static HTML page. I can see people using things like this for product pages or About pages

### Plugin API for the Assistant and Sideboards
Programs like [sketch], Sublime Text, and Framer thrive on a community of designers and developers who build functionality into the application. This was only possible because the devs opened up the API and made it easy to create plugins and allow the creators to profit from their contributions (if they desire). It democratizes the featureset for the application and only strengthens the userbase.

#### Colorway Dimmer Switch (Gamma Dimmer)
Increases/Decreases the luminosity of the Theme in steps, adjusting the value of the UI for different light conditions.

Often with lite and dark themes they are too far to one extreme, often the most comfortable color scheme to stare at on a monitor is in the middle values.

This would be a keyboard shortcut you can use to increase and decrease the contrast of the theme.

#### Auto-Color
For macbooks, using the cameras light meter to detect the amount of light in the room and adjusting the color theme based on that.

### Experimental Colorways
I'd be interesting for a colorway to change over time or according to a specific lighting condition. Apple kind-of does this with iPad's "True Tone" but the aim is color accuracy rather than viewer comfort.

**Indoor/Outdoor**
Theme that is suitable for lighting conditions, i.e a theme that works really well for bright sunlight vs one that is conducive to look at when under flourescence

**Auto-Tune**
Themes that change color depending on the time of day and the weather (report) so the theme used for 12 noon on a rainy day is different from 12 noon on a sunny day.

## Syntax

**Deleting or changing one half of a tag or punctuation deletes/changes the other.** If a writer deletes the closing `**` of a word, the opening `**` will be removed. Likewise, if they change the opening `_` of a word to `#` it will not add a `#` to the end, since it's not necessary for headlines.

**Cleaning Up Tags** spaces between a character and the closing tag are automatically deleted.

`**Delete The Space between_**`

#### Live preview images in the workspace?
The ability to show the image rather than just the syntax/placeholder.

## Notes

_I like the idea of the notes being used for more than just holding text, it should have more functions than that_

**Notes look slightly different than docs when edited in the workspace.**
- different background color?
- Larger line height?
- unique font?

**The /commented text in a document can be sent to a new or existing note.** Some writers might want to make notes in the document as they're writing, and later reference them This declutters the document and still available to view.

**Onboarding trick by linking Apple notes to Type Notes.** A lot of writers use the Apple notes app on their phone, and would be good to allow them to access those notes from within type.

Maybe they can link to the system folder?

`/Library/Group Containers/group.com.apple.notes/`

### Notebook
default folder which collects the notes you make in documents, or from the desktop assistant

## References
Using the references as a character bible for developing a story.
example: {Character Name}(Description of the character)

## Navigation

### Pinning lines/Rubber banding
Set a temporary pin on a line, then you can scroll around the doc, or go to other documents entirely, and when you hit a shortcut you automatically go right back to that line, the pin disappears after returning. It's the equivilent of putting your finger on a page and flipping through a book.

### Auto Pinning
If you use the mouse wheel/scroll manually up or down the document, there is an option to pin the row of the line the cursor resides to either the top or bottom of the viewport (depending on which way you scroll). If you scroll up the line sticks to the bottom, if you scroll down the line sticks to the top. (this suggests the relative location of the line where you left the cursor, its either above or below where you are now)

- mouse clicking the pinned line or typing will snap you back to the line
- are you able to write in the pinned location while viewing the new one? would anyone want to do that?
- If you move the cursor outside the line, or if some time has passed, the sticky/pinned line dissapears
- This also doesnt work when you’re focusing or in typewriter mode

### Send text to ("texting")
The ability to highlight text and send it to another unopened document.
1. append it to a specified #Headline Tag
2. Append it to the end of the document
3. Send it to a specific line number, moving whatever currently occupies that space down one line.

----

----

### Newletter Services
[letterfuel](https://letterfuel.com/)

### Font Foundries
Partnering with Indie foundries to have print layouts use their unique font faces and font pairings (also for self-published websites?)

[Fatype](https://www.fatype.com/typefaces)
[Klim](https://klim.co.nz/)
[GrilliType](https://www.grillitype.com/)

----
**[← Menus](https://github.com/JEFLBROWN/Type/wiki/Menus)

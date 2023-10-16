URLLabel

This class lets you create a label that when clicked will open the url given to it.

![Screenshot of URL Label emo app](screenshots/URLLabel_example.png?raw=true "A screenshot of URL Labels render in the example project")

#Known Issues

- Title Flashing
The title text when the cursor first enters the label's bounding box, flashes (renders), then stops rendering until the delay time to show the title text is done.

- Hand cursor
The hand cursor is only shown on the first label to have a "tick", I supsect that this is a problem with how the cursor is determined and that it's a shared "system" property. Essentially a bug in my code.
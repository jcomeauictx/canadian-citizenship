# canadian-citizenship
Since "saving" the form doesn't actually save your modifications in any
meaningful sense---only in the browser window, and is lost if closed---this
little project will allow you to save your changes in plain text files, which
you can modify as new information comes to light, and rebuild the completed
application form with a single `make` command.

## bugs
Starting from scratch, a browser will be launched for you to download the
cit0001e.pdf file from the Canadian government website, but it will take two
more `make` commands to build the completed application form, because I still
suck at Makefiles after all these years.

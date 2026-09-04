# canadian-citizenship
**Note**: After re-reading the instructions, the PDF form must either be filled
in directly (e.g. using Adobe products or a compliant browser) or by hand.
Doing it using this software will be unlikely to be accepted.

To download census, birth, immigration, and other records from NARA, visit <https://catalog.archives.gov/> and enter the name into the search bar. I had best luck with last name first, in quotes, e.g. "comeau fidele": the quotes serve to "AND" the terms, whereas unquoted the terms are ORed.

Original README follows.

Since "saving" the form doesn't actually save your modifications in any
meaningful sense---only in the browser window, and is lost if closed---this
little project will allow you to save your changes in plain text files, which
you can modify as new information comes to light, and rebuild the completed
application form with a single `make` command.

It may also serve as a useful starting point for people who are confused by
the whole process. But maybe not, it depends on how successful I am after
submitting it.

Copy the text files (`mkdir ~/canada; cp page0*.txt ~/canada/`) to the `canada`
folder in your home directory, and edit the names, dates, and other fields
with the correct values, then, in this directory, `make`.

If the pre-made text files aren't close enough to what you need, you may need
to print up the test pages I used as guides. If you already filled out the
form using a browser, and saved the PDF, copy that to
`~/Downloads/cit0001e_filled.pdf` and `make testpages`. Or you could just copy
the empty form to that same location and name and run the same command.

## quickstart
in all the following steps, replace `myusername` with your actual desired
username.

* launch a new Ubuntu or Debian droplet at digitalocean.com,
  Basic / 1 vCPU / 512 MB RAM / 10 GB Disk, $4/month.
  make sure to select at least one ssh key, the one for your current machine
* ssh in to the IP address, e.g. `ssh root@1.2.3.4`
* `apt update; apt install make sudo xauth git`
* `adduser myusername`, and fill in all the requested information
* `usermod -a -G sudo myusername`
* `cp -r .ssh ~myusername/ && chown -R myusername:myusername ~myusername/.ssh`
* logout, and log back in as myusername: `ssh -Y myusername@1.2.3.4`,
  the `-Y` meaning to tunnel X-windows
* `mkdir -p src/jcomeauictx && cd src/jcomeauictx`
* `git clone https://github.com/jcomeauictx/canadian-citizenship`
* `cd canadian-citizenship`
* `make`
* scroll down to Paper Applications, Application for a citizenship certificate,
  and select (click or hit ENTER)
* download the form. It should prompt you to save cit0001e.pdf, then say
  "Download complete"
  * if you see the error
    `Syntax Error: Could not extract page(s) from damaged file ('/home/myusername/src/jcomeauictx/canadian-citizenship/cit0001e.pdf')`,
    then it wasn't decompressed on download.
    `mv cit0001e.pdf cit0001e.pdf.gz`, then `gunzip cit0001e.pdf.gz`, and run
    `make` again.
* you may be prompted to download several development packages. assent to all.

# canadian-citizenship
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
* launch a new Ubuntu or Debian droplet at digitalocean.com,
  Basic / 1 vCPU / 1 GB RAM / 25 GB Disk, $6/month
* ssh in to the IP address, e.g. `ssh root@1.2.3.4`
* `apt install make sudo xauth git`
* `adduser myusername`, and fill in all the requested information
* `cp -r .ssh ~myusername/ && chown -R myusername:myusername ~myusername/.ssh`
* logout, and log back in as myusername: `ssh -Y myusername@1.2.3.4`,
  the `-Y` meaning to tunnel X-windows
* `mkdir -p src/jcomeauictx && cd src/jcomeauictx`
* `git clone https://github.com/jcomeauictx/canadian-citizenship`
* `cd canadian-citizenship`
* `make`

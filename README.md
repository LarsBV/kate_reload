Kate_Reload
===========

Adds an option in the 'View' menu to auto-reload the current file.

Installation
=================================================
If you don't have the headers for your kate version retrieve them like

    git clone git://anongit.kde.org/kate kate_headers -b v4.12.1

and change the first variable in the Makefile.

First build support object KateDocument.so by running 

    make

This object makes setModifiedOnDiskWarning() available to the plugin.

Symlink this directory, and the .desktop, into the right places using 

    make install

or

    ln -s $(pwd) ~/.kde4/share/apps/kate/pate/okular_plugin
    ln -s $(pwd)/katepate_okular_plugin.desktop ~/.kde4/share/kde4/services/

Requirements
=================================================
You'll need build-essentials and python-sip. 

If you can't find kate includes in your distribution, you will also need 
git. 

Debian does not seem to have a package for the includes.


Default Shortcuts
=================================================
- Alt + R Toggle Auto-Reload

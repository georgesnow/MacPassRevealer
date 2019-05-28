# MacPassRevealer
MacPass Plugin - Global Keyboard shortcut to hide/unhide MacPass

In order to use this plugin you have to check off "Load unsecure plugins" and "Force loading of incompatiable Plugins"
This is due to the signing of the mplugin, which you should build localling on your machine. 
I do recommend testing it out before making part of your production use. 

Important Notes:
Global Autotype - if you are using GAutotpye as word of caution. Do not use the Control as a modifier key while using
this plugin.
There are instances where it triggers Global Autotype. I narrowed down part of the issue to way hotkeys get registered.
The part seems to be related to making MacPass the "active" application. This is issue I am still working on.

The keyboard shortcut is hard configured for Control+Option+`


Other Notes:
Hopefully, I will later add custmizating the keyboard shortcut. 
I am also looking at adding a menubar icon for quick access.


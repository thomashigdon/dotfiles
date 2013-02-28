#!/usr/bin/python

import keyring
import re

my_folders = [ 'INBOX', r"l\/.*", "Drafts", "Sent Items", "Deleted Items$" ]

if keyring.backends.Gnome.Keyring().supported() != -1:
    keyring.set_keyring(keyring.backends.Gnome.Keyring())

def set_password(server, user, password):
    keyring.set_password("offlineimap:%s" % server, user, password)

def get_password(server, user):
    return keyring.get_password("offlineimap:%s" % server, user)

def myfilter(name):
    for folder in my_folders:
        if re.match(folder, name):
            return True
    return False

def mysort(x, y):
    x_match = y_match = len(my_folders)
    for i, item in enumerate(my_folders):
        if re.match(str(item), str(x)):
            x_match = i
        if re.match(str(item), str(y)):
            y_match = i

    if x_match == y_match:
        return cmp(x,y)
    else:
        return x_match - y_match

#!/usr/bin/python

import keyring

if keyring.backends.Gnome.Keyring().supported() != -1:
    keyring.set_keyring(keyring.backends.Gnome.Keyring())

def set_password(server, user, password):
    keyring.set_password("offlineimap:%s" % server, user, password)

def get_password(server, user):
    return keyring.get_password("offlineimap:%s" % server, user)

def mysort(x, y):
    import re
    enforce = [ 'INBOX', r"l\.*", "Drafts", "Sent Items", "Deleted Items" ]
    x_match = len(enforce)
    y_match = len(enforce)
    for i, item in enumerate(enforce):
        if re.match(str(item), str(x)):
            x_match = i
        if re.match(str(item), str(y)):
            y_match = i

    if x_match == y_match:
        return cmp(x,y)
    else:
        return x_match - y_match

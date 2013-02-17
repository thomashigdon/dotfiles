# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# secos
if [ -f /etc/debian_chroot ]; then
    chroot_string=`cat /etc/debian_chroot`
    if [[ "$chroot_string" = " SecOS CHROOT " ]]; then
       ### Inside SecOS chroot
       export PS1="(secos)$PS1"
    else
       ### Inside alsi6 chroot
       export PS1="($chroot_string)$PS1"
    fi
else
    ### Real OS
    export BASE_PATH=NOT_IN_CHROOT_DONT_BUILD
    unset BASE_PATH
fi

#!/usr/bin/env bash

set -ex

echo "Original reference: https://support.yubico.com/support/solutions/articles/15000006420-using-your-yubikey-with-openpgp#generateopenpgp"
echo "Remove any other security keys first, just in case."
gpg --card-edit

echo 'You can view your key identifier in the output of: gpg --list-keys'
echo 'You can view your public ssh key info with: ssh-add -L'
echo 'You can view your public GPG key info with: gpg --export -a KEY_IDENTIFIER'
echo 'More detailed setup instructions can be found at https://github.com/drduh/YubiKey-Guide'


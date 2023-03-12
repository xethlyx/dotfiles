# dotfiles

**Usage**:
1. Fork this repository
2. Clone this repository into your home using `git clone <repository here> --depth=1 --branch=main`
3. Run `dotfiles/bin/dfctl install`.  
4. RECOMMENDED: Add `$HOME/dotfiles/bin` to path

**Command**:
`dfctl [install|uninstall|update] [-v] [-h] [-a]`

**Hooks**:
Hooks can be run by creating files with the following names:

 * `hooks/install.sh` Run before installing
 * `hooks/post-install.sh` Run after installing
 * `hooks/uninstall.sh` Run after installing
 * `hooks/update.sh` Run before updating
 * `hooks/post-update.sh` Run after updating

 The hooks folder does not exist by default and needs to be created.

# File Structure

`~/dotfiles`
 * `etc` The files to be hard linked
 * `bin` The scripts to be added to the path
 * `backup` The old copies of the replaced files
 * `data.lock` Data related to the replaced files
 * `README.md`

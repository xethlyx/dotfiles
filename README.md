# dotfiles

**Usage**:
1. Fork this repository
2. Clone this repository into your home using `git clone <repository here> --depth=1 --branch=master`
3. Run `dotfiles/bin/dfctl install`.  
4. RECOMMENDED: Add `$HOME/dotfiles/bin` to path

Optionally, add a `setup.sh` in the root to automatically run scripts on install, or an `update.sh` to be run on updates.

**Command**:
`dfctl [install|uninstall|update] [-v] [-h] [-a]`

# File Structure

`~/dotfiles`
 * `etc` The files to be hard linked
 * `bin` The scripts to be added to the path
 * `backup` The old copies of the replaced files
 * `data.lock` Data related to the replaced files
 * `README.md`

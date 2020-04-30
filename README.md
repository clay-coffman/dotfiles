# dotfiles
personal dotfiles, configs, setup scripts, etc

using dotbot for remote management
TODO - link to dotbot readme

_*must have install.conf.json or .yaml file_

### to update symlinks
`dotbot -c install.conf.json`

### working with Python
- need to create a venv for [nvim](https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim)
- once that is done, in nvim need to run `:CocCommand python.setInterpreter` _with python file open_ on first time project is opened.
- make sure to set the interpreter to the python installed for *that* project.
- install any dependencies (black, pylint, pynvim, etc) in that env

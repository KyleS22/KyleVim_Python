# KyleVim_Python
A Python Plugin for vim, in the style of Kyle

# Features

## Settings for Python development
Automatically sets the proper indentation settings for development with PEP8 style

## Auto Docstrings
Automatically generate partial docstrings for functions and classes.  Just fill in the details!

## PEP8 and Syntax Error Checking
Highlight syntax errors and PEP8 style warnings in the current buffer when it is opened and written to.  Error messages are stored in the quickfix window for easy access and reading.

NOTE: Requires `pycodestyle` and `pycodeflakes` to be installed.  See `:help KyleVimPythonSyntaxConfig` for configuration setting.

# Installation
This plugin can be installed using [Vundle](https://github.com/VundleVim/Vundle.vim).  Simply add the following line to your vimrc

```
Other Vundle Plugins

" KyleVim_Python
Plugin 'KyleS22/KyleVim_Python'

```

Then start up vim and run `:PluginInstall`

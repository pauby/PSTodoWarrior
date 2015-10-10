# PoshTodo

This is a powershell CLI to the [Todo.txt](http://todotxt.com/) todo file format with some PowerShell like features and alson taking inspiration from Taskwarrior.

Based originally on [PsTodoTxt](https://github.com/derantell/PsTodoTxt) it has been completely rewritten. 

## Goal

The goal of this project is to create a command line interface to Todo.txt and add in some important Taskwarrior features such as prioritisation and ease of editing tasks.

## Todo.txt Components

Each task is split into Todo.txt components. These components are detailed in New-TodoObject.ps1

## Configuration format

PoshTodo's configuration format is stored in Get-TodoDefaultConfig.ps1
	
# TODO

Nothing yet - not released version 1 yet! 

# References

* The [Todo.txt Format](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format)
* [SimpleTask](https://github.com/mpcjanssen/simpletask-android/blob/master/src/main/assets/listsandtags.en.md) - took the idea for some of the addons from here (recurring tasks, hidden tasks etc.)
* [How to GTD with SimpleTask](https://gist.github.com/alehandrof/9941620)
* [How TaskWarrior handles Urgency](http://taskwarrior.org/docs/urgency.html)
* [How topydo handles urgency](https://github.com/bram85/topydo/wiki/Importance)t m 15,106,104,11,116,117
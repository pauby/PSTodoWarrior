# PSTodoWarrior
## about_PSTodoWarrior

# SHORT DESCRIPTION
PSTodoWarrior is a PowerShell module for working with TodoTxt format files with inspiration from Taskwarrior.

# LONG DESCRIPTION
PSTodoWarrior is a PowerShell module for working with TodoTxt format files with inspiration from Taskwarrior. It extends the traditional Todo.txt format while still staying compatible with it.

Todo.txt format properties that are used:

- DoneDate      = [string] todo completion date in yyyy-MM-dd format
- CreatedDate   = [string] todo creation date in yyyy-MM-dd format
- Priority      = [string] todo priority (A - Z)
- Task          = [string] todo task / description text
- Context       = [string[]] todo context (ie. @computer)
- Project       = [string[]] todo project (ie. +housebuild)
- Addon         = [hashtable] key:value pairs extending Todo.txt format

## Settings File
The module requires a settings file called `PSTodoWarrior.psd1` which is searched for at the following locations, in order: 

1. TWSettingsPath variable (can be specified in your PowerShell profile)
2. TW_SETTINGS_PATH environment variable
3. HOME environment variable

Note that the variables only specify the path to the `PSTodoWarriorSettings.psd1` file so they should not include the filename.

### Settings Configuration
The settings file can contain the following configuration names:

- TodoTaskPath      : Full pathname of the todo.txt task file
- TodoDonePath      : Full pathname of the dont.txt for completed todos
- NameContext       : Context todo property name (ie. 'Context' or 'List')
- NameProject       : Project todo property name (ie. 'Project' or 'Tag')
- AutoArchive       : Automatically moves completed todos to the TodoDonePath
- BackupPath        : Full pathname of the todo backup folder
- BackupDaysToKeep  : Number of days backup to keep in BackupPath

# EXAMPLES
{{ Code or descriptive examples of how to leverage the functions described. }}

# NOTE

## PowerShell Cmpatibility
PowerShell v3.

## Feedback
https://github.com/pauby/pstodowarrior

## Contributing 
https://github.com/pauby/pstodowarrior

# TROUBLESHOOTING NOTE
No known issues.

# SEE ALSO
    Todo.txt project - http://todotxt.com/
    TaskWarrior - https://taskwarrior.org/

# KEYWORDS
- Todo
- Todo.txt
- TaskWarrior

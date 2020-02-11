---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: https://www.github.com/pauby/pstodowarrior/tree/master/docs/add-twtodo.md
schema: 2.0.0
---

# Add-TWTodo

## SYNOPSIS
Adds a new todo to the list.

## SYNTAX

```
Add-TWTodo [-Todo] <String> [-TodoList] <ArrayList> [<CommonParameters>]
```

## DESCRIPTION
Adds a new todo to the list and then adds a line number to the todo object.

## EXAMPLES

### EXAMPLE 1
```
Add-TWTodo -Todo "A new todo"
```

Adds "A new todo" to the todo list and gives it the next line number

## PARAMETERS

### -Todo
The todo to add

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -TodoList
Path to the todo file.
Default is TodoTaskFile from the module configuration.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.ArrayList
## NOTES
Author:  Paul Broadwith (https://pauby.com)
Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
History: 1.0 - 16/07/18 - Initial

## RELATED LINKS

[https://www.github.com/pauby/pstodowarrior/tree/master/docs/add-twtodo.md](https://www.github.com/pauby/pstodowarrior/tree/master/docs/add-twtodo.md)


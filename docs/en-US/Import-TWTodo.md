---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
schema: 2.0.0
---

# Import-TWTodo

## SYNOPSIS
Imports todos from the todo file.

## SYNTAX

```
Import-TWTodo [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Imports the todos from the todo file and then adds a line number to the todo object.

## EXAMPLES

### EXAMPLE 1
```
Import-TWTodo c:\todo.txt
```

Read and outputs the todos from c:\todo.txt

## PARAMETERS

### -Path
Path to the todo file.
Default is TodoTaskFile from the module configuration.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ((Get-TWConfiguration).TodoTaskPath)
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.ArrayList
## NOTES
Author:  Paul Broadwith (https://pauby.com)

## RELATED LINKS

[https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md](https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md)


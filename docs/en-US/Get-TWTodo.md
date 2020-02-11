---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
schema: 2.0.0
---

# Get-TWTodo

## SYNOPSIS
Imports todos from the todo file.

## SYNTAX

```
Get-TWTodo [[-ID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Imports the todos from the todo file and then adds a line number to the todo object.

## EXAMPLES

### EXAMPLE 1
```
Export-TWTodo c:\todo.txt
```

Read and outputs the todos from c:\todo.txt

## PARAMETERS

### -ID
{{ Fill ID Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.ArrayList
## NOTES
Author:  Paul Broadwith (https://pauby.com)
Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
History: 1.0 - 16/07/18 - Initial

## RELATED LINKS

[https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md](https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md)


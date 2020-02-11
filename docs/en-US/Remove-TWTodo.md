---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: https://www.github.com/pauby/pstodowarrior/tree/master/docs/add-twtodo.md
schema: 2.0.0
---

# Remove-TWTodo

## SYNOPSIS
Removes a todo from the list.

## SYNTAX

```
Remove-TWTodo [-Todo] <ArrayList> [-ID] <Int32[]> [<CommonParameters>]
```

## DESCRIPTION
Removes a todo from the list specified by it's ID number.

## EXAMPLES

### EXAMPLE 1
```
Remove-TWTodo -ID 15
```

Removes the todo with ID 15 from the list.

## PARAMETERS

### -Todo
{{ Fill Todo Description }}

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The todo ID number to remove.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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


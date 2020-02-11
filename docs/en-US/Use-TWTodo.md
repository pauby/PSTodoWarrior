---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: http://www.github.com/pauby/pstodowarrior/tree/master/docs/use-twtodo.md
schema: 2.0.0
---

# Use-TWTodo

## SYNOPSIS
One overall function to work with todos.

## SYNTAX

### List (Default)
```
Use-TWTodo [-List] [-Filter <Array>] [<CommonParameters>]
```

### Add
```
Use-TWTodo [-Add <String>] [<CommonParameters>]
```

### Remove
```
Use-TWTodo [-Remove] [-Filter <Array>] [<CommonParameters>]
```

### Complete
```
Use-TWTodo [-Complete] [-Filter <Array>] [<CommonParameters>]
```

### View
```
Use-TWTodo [-View <String>] [<CommonParameters>]
```

### Filter
```
Use-TWTodo [-Filter <Array>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet is a wrapper for the other cmdlets and allows you to work with todos..

## EXAMPLES

### EXAMPLE 1
```
Use-TWTodo -Add 'Take car to the garage' -project 'care-maintenance' -context 'car'
```

Adds a new todo.

### EXAMPLE 2
```
Use-TWTodo -Remove 15
```

Removes the todo at line 15.

## PARAMETERS

### -List
List / show the todos on the host.
This is also the default when no other command switch is provided.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Add
{{ Fill Add Description }}

```yaml
Type: String
Parameter Sets: Add
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
TODO allow an array or raneg to be used here

```yaml
Type: SwitchParameter
Parameter Sets: Remove
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Complete
{{ Fill Complete Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Complete
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
{{ Fill View Description }}

```yaml
Type: String
Parameter Sets: View
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
if this default vaue is removed, adjust the 'List' code below

```yaml
Type: Array
Parameter Sets: List, Remove, Complete, Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Paul Broadwith (https://pauby.com)
Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)

## RELATED LINKS

[http://www.github.com/pauby/pstodowarrior/tree/master/docs/use-twtodo.md](http://www.github.com/pauby/pstodowarrior/tree/master/docs/use-twtodo.md)


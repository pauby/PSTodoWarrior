---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: https://www.guthub.com/pauby/PSTodoWarrior
schema: 2.0.0
---

# Import-Todo

## SYNOPSIS
Imports todos from the todo file.

## SYNTAX

```
Import-Todo [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Imports the todos from the todo file and then adds a line number to the todo object..

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Import-Todo c:\todo.txt
```

Read and outputs the todos from c:\todo.txt

## PARAMETERS

### -Path
Path to the todo file.
Default is TodoTaskFile from the mofule configuration.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: $todoConfig.TodoTaskFile
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Output is [array]

## NOTES

## RELATED LINKS

[https://www.guthub.com/pauby/PSTodoWarrior](https://www.guthub.com/pauby/PSTodoWarrior)


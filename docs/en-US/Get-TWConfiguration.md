---
external help file: PSTodoWarrior-help.xml
Module Name: PSTodoWarrior
online version: https://github.com/pauby/pstodowarrior/tree/master/docs/Get-TWConfiguration.md
schema: 2.0.0
---

# Get-TWConfiguration

## SYNOPSIS
Imports and returns the settings.

## SYNTAX

```
Get-TWConfiguration [[-Configuration] <PSObject>] [-Force]
```

## DESCRIPTION
Imports and returns the settings from the $TWSettings session variable by default, however you can pass a
settings custom object to the function.

If the session variable does not exist or is empty, it will throw an error.

## EXAMPLES

### EXAMPLE 1
```
Get-TWConfiguration
```

Checks the $TWSettings session variable (effectively the global variable) is not empty and exists.
If not, it will throw an error.

## PARAMETERS

### -Configuration
Pass in a configuration to use.
By default ie uses the $TWConfiguration variable in the user session.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $global:TWConfiguration
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{ Fill Force Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author  : Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[https://github.com/pauby/pstodowarrior/tree/master/docs/Get-TWConfiguration.md](https://github.com/pauby/pstodowarrior/tree/master/docs/Get-TWConfiguration.md)


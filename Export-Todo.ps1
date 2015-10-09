<# .SYNOPSIS    Exports todos to a file.
.DESCRIPTIONE
    Exports todos to a file.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 24/09/15 - Initial version
.LINK 
    http://www.github.com/pauby
.PARAMETER TodoObject    Todo object to export.
.PARAMETER TodoString    Todo string to export.
.PARAMETER Path
    Path to the todo file to export to.
.PARAMETER BackupPath
    Path to the backup folder.
.PARAMETER DaysToKeep
    Number of days backups to keep.
.PARAMETER Force
    Force overwriting read-only files.
.PARAMETER Append
    Appends todos to the file rather than overwriting the todo with them.
.EXAMPLE    Export-Todo -TodoObject $Todo -Path 'c:\todo.txt' -BackupPath 'c:\todo-backups' -DaysToKeep 7

    Backup the todo file c:\todo.txt to c:\todo-backups\ only keeping 7 days worth of backups. Export the object(s) in $Todo to the todo file at c:\todo.txt. 
#>

function Export-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName="Objects")]
        [AllowEmptyCollection()]
        [object[]]$TodoObject,

        [Parameter(Mandatory, ParameterSetName="Strings")]
        [AllowEmptyCollection()]
        [string[]]$TodoString,

        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [string]$BackupPath,

        [int]$DaysToKeep,

        [switch]$Force, #forces overwriting readonly files

        [switch]$Append
    )

    Write-Verbose "Taking a backup of the todo file before we export."
    Backup-Todo -Path $Path -BackupPath $BackupPath -DaysToKeep $DaysToKeep -Force:$($Force.IsPresent)

    $toBeWritten = @() # will hold the todos to be written after converting the objects to string or from the strings passed
    if ($TodoObject)
    {
        if (($TodoObject -ne $null) -and ($TodoObject.Count -gt 0))
        {
            Write-Verbose "We have $($TodoObject.Count) todo objects to export."
            [array]$toBeWritten = $TodoObject | ConvertTo-TodoString -Verbose:$VerbosePreference
#            foreach ($todo in $TodoObject)
#            {
#                Write-Verbose "Converting todo object to a string so we can write it to the todo file."
#                $toBeWritten += $todo | ConvertTo-TodoString -TodoObject $todo -Verbose:$VerbosePreference
#            }
        }
        else
        {
            Write-Verbose "We have 0 todo objects to export."
        }
    }
    else
    {
        if (($TodoString -ne $null) -and ($TodoString.Count -gt 0))
        {
            Write-Verbose "We have $($TodoString.Count) todo strings to export."
            # when appending text to an existing todo the text is added to the end of the last todo line
            # as Add-Content adds a newline after every line, this will simply add a newline after writing the empty element
            # if we make this a newline then Add-COntent writes it and then another newline resulting in a blank line between the 
            # existing todos and the new todo
            $tobeWritten = @("")
            $toBeWritten += @($TodoString)
        }
        else
        {
            Write-Verbose "We have 0 todo strings to export."
        }
    }

    if ($toBeWritten.Count -gt 0)
    {
        if (-not $Append)
        {
            Write-Verbose "Exporting all todos to the todo file at $Path so need to clear it first."
            Clear-Content -Path $Path -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
            if ($?)
            {
                Write-Verbose "File $Path cleared."
            }
            else
            {
                throw "Could not clear contents of todo file $Path prior to writing new todos."
            }
        }

        Write-Verbose "Writing the todos to the todo file at $Path"
        $toBeWritten | Add-Content -Path $Path -Encoding UTF8 -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
        if ($?)
        {
            Write-Verbose "Todos written"
        }
        else
        {
            throw "Could not write todo(s) to the todo file at $Path."
        }
    }
}


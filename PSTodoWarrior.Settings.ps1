@{
    TodoTaskPath        = 'todo.txt';
    TodoDonePath        = 'done.txt';

    # Context and project name
    # name text of the Context property of the todo - usually 'Context' or 'List'  
    NameContext         = 'Context';
    # name text of the Project property of the todo - usually 'Project' or 'Tag' 
    NameProject         = 'Project';

    # Archives
    # if $true automatically archives completed todos to the TodoDoneFile, if $false they remain in the TodoTaskFile
    AutoArchive         = $false; # not implemented yet - DO NOT USE

    # Backups
    # backups are stored in the same folder as the TodoTaskFile
    BackupFolder        = 'backups';
    # Number of backups to keep in the BackupFolder
    BackupDaysToKeep    = 7;

    # Colours
    # Colours for each weights - any weight at or above the level will be that colour (up to the previous value). 
    # This MUST be an ordered hashtable for it to work.
    # it's in the format 'weight number' = 'valid PowerShell colour'
    WeightForegroundColour = [ordered]@{	    
        20 	= 'yellow';                     
        15 	= 'red';                        
        1 	= 'darkgreen';
    };

    
    # Colour for information messages
    InfoMsgsColour         = 'DarkCyan';


    # Weights
    # TODO: These needs explained 
    WeightPriority    = 6.0;
    WeightDueDate     = 12.0;
    WeightHasProject  = 1.0;
    WeightAge         = 2.0;
    WeightProject     = @{                    # all projects / tags must be in lowercase
        next    = 15.0;
        waiting = -3.0;
        today   = 20.0;
        someday = -15.0;
    };

    # Views
    # TODO: These need explained
    TodoLimit   = 25;
    Filter = @{
#            'default' = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if (($todo.Project -contains $config['ProjectDefault']) -or ($todo.Priority) -or ($todo.Project -contains $config['ProjectNextAction'])) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property @{e="Weight"; Descending=$true}, @{e="Line"; Descending=$False} | Select-Object -First $config['TodoLimit'] } };
        default = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if (($todo.Context.Count -gt 0) -and ([string]::IsNullOrWhiteSpace($todo.DoneDate))) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property @{e="Weight"; Descending=$true}, @{e="Line"; Descending=$False} | Select-Object -First $config['TodoLimit'] } };            
        all     = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { $output += $todo } } end { $output | sort Weight -Descending } };
        inbox   = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if ($todo.Context.Count -eq 0) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } };
    };
}
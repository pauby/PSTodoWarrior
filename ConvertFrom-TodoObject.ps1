function ConvertFrom-TodoObject
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [object]$TodoObj
    )

    ConvertTo-TodoString `
        -DoneDate $TodoObj.DoneDate `
        -Priority $TodoObj.Priority `
        -CreatedDate $TodoObnj.CreatedDate `
        -Task $TodoObj.Task `
        -Context $TodoObj.Context `
        -Project $TodoObj.Project `
        -DueDate $TodoObj.DueDate `
        -Addon $TodoObj.Addon
}
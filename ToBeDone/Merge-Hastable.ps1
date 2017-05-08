<# 
.SYNOPSIS 
    Merges two hashtables together.
.DESCRIPTION 
    Merges two hashtables together returning a new combined hastable and leaving both originals intact.
.NOTES 
    File Name	: Marge-Hastables.ps1  
    Author		: Paul Broadwith (paul@pauby.com) (Original author Sonjz (http://stackoverflow.com/users/740575/sonjz))
	History		: 1.0 - 15/09/15 - Initial version
.LINK 
    Originally posted by Sonjz (http://stackoverflow.com/users/740575/sonjz) at 
    http://stackoverflow.com/questions/8800375/merging-hashtables-in-powershell-how
    Changes made by Paul Broadwith.
.PARAMETER default
    First hashtable to merge.
.PARAMETER uppend
    Second hastable to merge.
.OUPUTS
    New hastable after merging $default and $uppend.
.EXAMPLE 
    .\Merge-Hashtable.ps1 $htable1 $htable2

    Merges the hastables $htable1 and $htable2.
#>  

function Merge-HashTable {
    param(
        [Parameter(Mandatory,Position=0)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$default, # your original set

        [Parameter(Mandatory,Position=1)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$uppend # the set you want to update/append to the original set
    )

    # clone for idempotence
    $default1 = $default.Clone() ;

    # remove any keys that exists in original set
    foreach ($key in $uppend.Keys) {
        if ($default1.ContainsKey($key)) {
            $default1.Remove($key) ;
        }
    }

    # union both sets
    return $default1 + $uppend ;
}
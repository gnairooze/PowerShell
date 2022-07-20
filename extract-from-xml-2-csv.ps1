function Read-Data {
    [cmdletbinding()]            
    param(            
    [Parameter(Mandatory=$true)]            
    [string[]]$sourcePath,            
    [Parameter(Mandatory=$true)]            
    [string]$outputFile            
    )  

    # start input
    #$sourcePath = "c:\Users\George\Downloads\1\"
    #$outputFile = "c:\Users\George\Downloads\1\exracted-data.csv"
    # end input

    $extractedData = [System.Collections.ArrayList]@()

    # add xml files to array
    $xmlFiles = [System.Collections.ArrayList]@()

    (Get-ChildItem -Path $sourcePath -Include *.xml -Recurse).FullName | Foreach-Object{
        # null variable used to hide output to host
        $xmlFiles.Add($_) >$null
    }


    # loop over xml files
    foreach ($xmlFile in $xmlFiles){
        # read xml file
        [xml]$data=Get-Content $xmlFile

        # read the required fields from xml
        $var =  [PSCustomObject]@{CreatededDate = $data.InspectionResultUpdated.InspectionResult.CreatededDate; EndorsementRequestNumber = $data.InspectionResultUpdated.InspectionResult.EndorsementRequestNumber; InspectionRequestNumber = $data.InspectionResultUpdated.InspectionResult.InspectionRequestNumber}
        
        # null variable used to hide output to host
        $extractedData.Add($var) >$null
    }

    $extractedData | Select-Object CreatededDate, EndorsementRequestNumber, InspectionRequestNumber | export-csv -LiteralPath $outputFile -NoTypeInformation
}
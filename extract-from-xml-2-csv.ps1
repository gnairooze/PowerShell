function Extract-Data {
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
        $xmlFiles.Add($_)
    }


    # loop over xml files
    foreach ($xmlFile in $xmlFiles){
        # Write-Host $xmlFile

        # read xml file
        [xml]$data=Get-Content $xmlFile

        # read the required fields from xml
        $var =  [PSCustomObject]@{CreatededDate = $data.InspectionResultUpdated.InspectionResult.CreatededDate; EndorsementRequestNumber = $data.InspectionResultUpdated.InspectionResult.EndorsementRequestNumber; InspectionRequestNumber = $data.InspectionResultUpdated.InspectionResult.InspectionRequestNumber}
        
        $extractedData.Add($var)

    }

    $extractedData | select CreatededDate, EndorsementRequestNumber, InspectionRequestNumber | export-csv -LiteralPath $outputFile -NoTypeInformation
}
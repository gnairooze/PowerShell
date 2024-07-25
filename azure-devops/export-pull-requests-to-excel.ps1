# Set your Azure DevOps organization and project details
$organization = "YourOrganization"
$project = "YourProject"
$repository = "YourRepository"

# Personal access token (PAT) with appropriate permissions
$pat = "YourPAT"

# API endpoint for pull requests
$apiUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories/$repository/pullrequests?api-version=6.0"

# Invoke the REST API and retrieve pull request data
$pullRequests = Invoke-RestMethod -Uri $apiUrl -Headers @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))
}

# Create an empty Excel workbook
$excelPath = "PullRequests.xlsx"
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Add()
$worksheet = $workbook.Worksheets.Item(1)

# Write headers
$worksheet.Cells.Item(1, 1) = "Pull Request ID"
$worksheet.Cells.Item(1, 2) = "Title"
$worksheet.Cells.Item(1, 3) = "Description"
# Add more columns as needed

# Populate data
$row = 2
foreach ($pr in $pullRequests.value) {
    $worksheet.Cells.Item($row, 1) = $pr.pullRequestId
    $worksheet.Cells.Item($row, 2) = $pr.title
    $worksheet.Cells.Item($row, 3) = $pr.description
    # Add more data as needed
    $row++
}

# Save and close the workbook
$workbook.SaveAs($excelPath)
$workbook.Close($false)
$excel.Quit()

Write-Host "Pull request data exported to $excelPath"
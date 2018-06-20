$list = Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
SELECT s.FileName
	, e.ShortCode
	, a.MatterNo
	,CONCAT (
		'\\kslfs01\ptrdata\docs\'
		,substring(convert(VARCHAR(15), e.shortcode, 103), 1, 1)
		,'\'
		,substring(convert(VARCHAR(15), e.shortcode, 103), 2, 1)
		,'\'
		,substring(convert(VARCHAR(15), e.shortcode, 103), 3, 1)
		,'\'
		,e.shortcode
		,'\'
		,a.matterno
		,s.filename
		) AS NewPath
FROM Cm_Steps s
INNER JOIN Cm_CaseItems c ON s.itemid = c.itemid
INNER JOIN Cm_Agendas a 
INNER JOIN Entities e ON a.EntityRef = e.code ON c.ParentID = a.itemid 
WHERE s.FileName not like '\\kslf%'
AND s.FileName not like 'U:%'
AND s.FileName > ''
AND s.FileName not like '__ks%'
ORDER BY s.FileName
"@


    foreach ($file in $list)
    {
    $filename = ($file.filename).tostring()
    $filename = $filename.TrimStart("\")
    $test = Get-ChildItem -Path \\kslnas01\FolderRedirection$ -Filter "$filename" -ErrorAction silentlycontinue

        if ($test)
        {
        $newpath = $file.NewPath
        $oldpath = "\\kslnas01\FolderRedirection$" + "\" + "$filename"
        Move-Item $oldpath $newpath
        sleep -m 200


        Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
        UPDATE Cm_Steps
        SET FileName = $newpath
        WHERE Filename = $oldpath
"@

        }

    }



Sub Highlighting()
    
    Dim data_end_col As Integer
    Dim cluster_group_col As Long
    Dim cluster_count As Integer
    Dim i As Integer
    Dim j As Integer
    Dim group_end_row As Integer
    
    ' Dim chr As String
    ' get col of cluster groups
    ' chr = InputBox("ColName of cluster groupings", "Text Input", "n_Cluster")
    ' cluster_group_col = Application.WorksheetFunction.Match(chr, Range(Cells(1, 1), Cells(1, data_end_col)), 0)
    
    i = 2
    j = 2
    data_end_col = Cells(1, Columns.Count).End(xlToLeft).Column
    cluster_group_col = Application.WorksheetFunction.Match("n_Cluster", Range(Cells(1, 1), Cells(1, data_end_col)), 0)
    
    ' loop through the number of clusters
    Do While i <= ActiveSheet.UsedRange.Rows.Count
        cluster_count = Cells(i, cluster_group_col)
        group_end_row = i + cluster_count - 1
        
        ' loop through dimensions
        For j = 2 To data_end_col - 2
            Range(Cells(i, j), Cells(group_end_row, j)).Select
            
            ' add highlighting
            Selection.FormatConditions.AddColorScale ColorScaleType:=3
            Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
            Selection.FormatConditions(1).ColorScaleCriteria(1).Type = _
                xlConditionValueLowestValue
            With Selection.FormatConditions(1).ColorScaleCriteria(1).FormatColor
                .Color = 13011546
                .TintAndShade = 0
            End With
            Selection.FormatConditions(1).ColorScaleCriteria(2).Type = _
                xlConditionValuePercentile
            Selection.FormatConditions(1).ColorScaleCriteria(2).Value = 50
            With Selection.FormatConditions(1).ColorScaleCriteria(2).FormatColor
                .Color = 16776444
                .TintAndShade = 0
            End With
            Selection.FormatConditions(1).ColorScaleCriteria(3).Type = _
                xlConditionValueHighestValue
            With Selection.FormatConditions(1).ColorScaleCriteria(3).FormatColor
                .Color = 7039480
                .TintAndShade = 0
            End With
            
        Next j
        i = group_end_row + 2
        
    Loop
End Sub

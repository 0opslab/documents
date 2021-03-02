''@func{excel常用vbs}alt+f11编辑vbs


'' @func{高亮搜索单元格}
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
Cells.Interior.ColorIndex = xlNone
Target.Interior.ColorIndex = 8
End Sub

'' @func{高亮搜索搜索单元格所在的行和列}
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
Cells.Interior.ColorIndex = xlNone
Rows(Selection.Row & ":" & Selection.Row + Selection.Rows.Count - 1).Interior.ColorIndex = 35
Columns(Selection.Column).Resize(, Selection.Columns.Count).Interior.ColorIndex = 20
End Sub

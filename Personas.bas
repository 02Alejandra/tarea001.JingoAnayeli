B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=12.8
@EndOfDesignText@
' Clase que maneja una lista de personas con operaciones CRUD
Sub Class_Globals
	Private sql As SQL
End Sub

' Inicializa el objeto. Puedes añadir parámetros a este método si es necesario.
Public Sub Initialize(nombreBdd As String)
	sql.Initialize(File.DirInternal, nombreBdd, True)
	sql.ExecNonQuery("CREATE TABLE IF NOT EXISTS personas (id INTEGER PRIMARY KEY, cedula TEXT, nombres TEXT, salario REAL, cargo TEXT)")
End Sub

Public Sub Create(id As Int, cedula As String, nombres As String, salario As Double, cargo As String) As Persona
	sql.ExecNonQuery2("INSERT INTO personas (id, cedula, nombres, salario, cargo) VALUES (?, ?, ?, ?, ?)", Array As Object(id, cedula, nombres, salario, cargo))

	Dim p As Persona
	p.Initialize()
	p.Cedula = cedula
	p.Nombres = nombres
	p.Salario = salario
	p.Cargo = cargo

	Return p
End Sub

Public Sub Read_All() As List
	Dim resultado As List
	resultado.Initialize
    
	Dim cursor As Cursor
	cursor = sql.ExecQuery("SELECT cedula, nombres, salario, cargo FROM personas ORDER BY nombres")
	For i = 0 To cursor.RowCount - 1
		cursor.Position = i
        
		Dim d As Map
		d.Initialize
		d.Put("cedula",cursor.GetString("cedula"))
		d.Put("nombres",cursor.GetString("nombres"))
		d.Put("salario",cursor.GetDouble("salario"))
		d.Put("cargo",cursor.GetString("cargo"))
        
		resultado.Add(d)
	Next
    
	Return resultado
End Sub

Public Sub Read_ById(id As Int) As Persona
	Dim p As Persona
	p.Initialize()

	Dim cursor As Cursor
	cursor = sql.ExecQuery("SELECT id, cedula, nombres, salario, cargo FROM personas WHERE id = " & id)
	If cursor.RowCount > 0 Then
		cursor.Position = 0

		p.Cedula = cursor.GetString("cedula")
		p.Nombres = cursor.GetString("nombres")
		p.Salario = cursor.GetDouble("salario")
		p.Cargo = cursor.GetString("cargo")
	End If
	Return p
End Sub

Public Sub Update(id As Int, cedula As String, nombres As String, salario As Double, cargo As String) As Boolean
	sql.ExecNonQuery2("UPDATE personas SET cedula = ?, nombres = ?, salario = ?, cargo = ? WHERE id = ?", Array As Object(cedula, nombres, salario, cargo, id))
	Return True
End Sub

Public Sub Delete(id As Int) As Boolean
	sql.ExecNonQuery("DELETE FROM personas WHERE id = " & id)
	Return True
End Sub

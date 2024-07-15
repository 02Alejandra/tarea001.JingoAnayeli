B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=12.8
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private txtId As EditText
	Private txtNombreTrabajo As EditText
	Private apiClas As Trabajos
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	'load the layout to Root
	Root.LoadLayout("PageTrabajos")
	apiClas.Initialize("https://utncloudcomputingapiclientes.azurewebsites.net/api/Trabajos")
	
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Private Sub cmdLeer_Click
	Wait For (apiClas.Read_ById(txtId.Text)) Complete (r As Trabajo)
	If r.Id > 0 Then
		txtId.Text=r.Id
		txtNombreTrabajo.Text = r.NombreTrabajo
		Msgbox("Registro leido con éxito", "OK")
	Else
		Msgbox("No hay datos","Error")
	End If
End Sub

Private Sub cmdCrear_Click
	Wait For (apiClas.Create(0,txtNombreTrabajo.Text)) Complete (c As Trabajo)
	If c.Id> 0 Then
		txtId.Text = c.Id
		Msgbox("Insertado el registro", "OK")
	Else
		Msgbox("No se pudo insertar el registro","OK")
	End If
End Sub

Private Sub cmdActualizar_Click
	Wait For (apiClas.Update(txtId.Text, txtNombreTrabajo.Text)) Complete (r As Boolean)
	If r = True Then
		Msgbox("Registro Actualizado", "OK")
	Else
		Msgbox("No hay datos","Error")
	End If
End Sub

Private Sub cmdEliminar_Click
	Wait For (apiClas.Delete(txtId.Text)) Complete (r As Boolean)
	If r = True Then
		Msgbox("Registro Borrado", "OK")
		txtId.Text = ""
		txtNombreTrabajo.Text = ""
	Else
		Msgbox("No hay datos","Error")
	End If
End Sub

Private Sub cmdMenu_Click
	B4XPages.ShowPage("MainPage")
End Sub
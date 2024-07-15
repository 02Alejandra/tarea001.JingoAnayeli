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
	Private txtNombreProducto As EditText
	Private apiClas As Productos
End Sub

'You can add more parameters here.
'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageProductos")
	apiClas.Initialize("https://clase-cloud-api.azurewebsites.net/api/Products")
End Sub

Private Sub cmdLeer_Click
	Wait For (apiClas.Read_ById(txtId.Text)) Complete (r As Producto)
	If r.Id > 0 Then
		txtId.Text = r.Id
		txtNombreProducto.Text = r.NombreProducto 
		Msgbox("Registro leído con éxito", "OK")
	Else
		Msgbox("No hay datos para el ID proporcionado", "Error")
	End If
End Sub

Private Sub cmdCrear_Click
	Wait For (apiClas.Create(0, txtNombreProducto.Text)) Complete (c As Producto)
	If c.Id > 0 Then
		txtId.Text = c.Id
		Msgbox("Registro insertado con éxito", "OK")
	Else
		Msgbox("No se pudo insertar el registro", "Error")
	End If
End Sub

Private Sub cmdActualizar_Click
	Wait For (apiClas.Update(txtId.Text, txtNombreProducto.Text)) Complete (r As Boolean)
	If r = True Then
		Msgbox("Registro actualizado con éxito", "OK")
	Else
		Msgbox("No se pudo actualizar el registro", "Error")
	End If
End Sub

Private Sub cmdEliminar_Click
	Wait For (apiClas.Delete(txtId.Text)) Complete (r As Boolean)
	If r = True Then
		Msgbox("Registro eliminado con éxito", "OK")
		txtId.Text = ""
		txtNombreProducto.Text = ""
	Else
		Msgbox("No se pudo eliminar el registro", "Error")
	End If
End Sub

Private Sub cmdMenu_Click
	B4XPages.ShowPage("MainPage")
End Sub
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
	Private txtNombre As EditText
	Private txtProductoId As EditText
	Private apiClas As Categorias
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	'load the layout to Root
	
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Private Sub cmdLeer_Click
	Wait For (apiClas.Read_ById(txtId.Text)) Complete (r As Categoria)
	If r.Id > 0 Then
		txtId.Text = r.Id
		txtNombre.Text = r.nombre ' Asegúrate de usar 'nombre' (en minúscula) según la definición de la clase Categoria
		txtProductoId.Text = r.ProductoId
		Msgbox("Registro leído con éxito", "OK")
	Else
		Msgbox("No se encontraron datos para el ID proporcionado", "Error")
	End If
End Sub

Private Sub cmdCrear_Click
	Wait For (apiClas.Create(0, txtNombre.Text, txtProductoId.Text)) Complete (c As Categoria)
	If c.Id > 0 Then
		txtId.Text = c.Id
		Msgbox("Registro insertado con éxito", "OK")
	Else
		Msgbox("No se pudo insertar el registro", "Error")
	End If
End Sub

Private Sub cmdActualizar_Click
	Wait For (apiClas.Update(txtId.Text, txtNombre.Text, txtProductoId.Text)) Complete (r As Boolean)
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
		txtNombre.Text = ""
		txtProductoId.Text = ""
	Else
		Msgbox("No hay datos","Error")
	End If
End Sub

Private Sub cmdMenu_Click
	B4XPages.ShowPage("MainPage")
End Sub
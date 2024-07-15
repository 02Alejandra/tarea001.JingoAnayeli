B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=12.8
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Private Sub Button1_Click
	xui.MsgboxAsync("Hello world!", "B4X")
End Sub

Private Sub cmdTrabajos_Click
	Dim PageProductos As Productos
	PageProductos.Initialize
	
	B4XPages.AddPageAndCreate("PageProductos", PageProductos)
	
	B4XPages.ShowPage("PageProductos")
End Sub

Private Sub cmdClientes_Click
	Dim PageCategorias As Categorias
	PageCategorias.Initialize
	
	B4XPages.AddPageAndCreate("PageCategorias", PageCategorias)
	
	B4XPages.ShowPage("PageCategorias")
End Sub
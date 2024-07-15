B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=12.8
@EndOfDesignText@
Sub Class_Globals
	Private jsonParser As JSONParser
	Private apiJob As HttpJob
	Public apiURL As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize (url As String)
	apiURL = url
End Sub

Public Sub Create(id As Int, nombreProducto As String) As ResumableSub
	Dim clas As Producto
	Dim json As String
	Dim data As Map
	
	clas.Initialize()
	json = "{'id': 0, 'nombreProducto': '"& nombreProducto &"'}"
	
	apiJob.Initialize("",Me)
	apiJob.PostString(apiURL, json)
	apiJob.GetRequest.SetContentType("application/json")
	Wait For(apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize( resultado.GetString)
		data = jsonParser.NextObject
		clas.Id = data.Get("id")
		clas.NombreProducto = data.Get("nombreProducto")
	End If
	Return clas
End Sub

Public Sub Read_All() As ResumableSub
	Dim clas As List
	Dim cla As Producto
	Dim map As Map
	Dim lst As List
	
	clas.Initialize
	cla.Initialize
	
	apiJob.Initialize("",Me)
	apiJob.Download(apiURL)
	Wait For(apiJob) JobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		lst = jsonParser.NextArray
		For i = 0 To lst.Size - 1
			map = lst.Get(i)
			Dim cla As Producto
			cla.Initialize
			cla.Id = map.Get("id")
			cla.NombreProducto = map.Get("nombreProducto")
			clas.Add(cla)
		Next
	End If
	
	Return clas
End Sub


Public Sub Read_ById(id As Int) As ResumableSub
	Dim cla As Producto
	cla.Initialize
	
	apiJob.Initialize("",Me)
	apiJob.Download(apiURL &"/"& id)
	Wait For (apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		Dim map As Map = jsonParser.NextObject
		cla.Id = map.Get("id")
		cla.NombreProducto = map.Get("nombreProducto")
	End If
	Return cla
End Sub

Public Sub Update (id As Int, nombreProducto As String) As ResumableSub
	Dim clas As Producto
	Dim json As String
	
	clas.Initialize()
	json = "{'id': '"& id &"', 'nombreProducto': '"& nombreProducto &"'}"
	
	apiJob.Initialize("",Me)
	apiJob.PutString(apiURL & "/" & id, json)
	apiJob.GetRequest.SetContentType("application/json")
	
	Wait For(apiJob) jobDone(resultado As HttpJob)
	Return resultado.Success
End Sub

Public Sub Delete (id As Int) As ResumableSub
	
	apiJob.Initialize("",Me)
	apiJob.Delete(apiURL & "/" & id)
	
	Wait For(apiJob) jobDone(resultado As HttpJob)
	Return resultado.Success
End Sub
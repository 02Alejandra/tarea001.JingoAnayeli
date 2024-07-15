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
Public Sub Initialize(url As String)
	apiURL = url
End Sub

Public Sub Create(id As Int, nombre As String, productoId As Int) As ResumableSub
	Dim cat As Categoria
	Dim json As String
	Dim data As Map
    
	cat.Initialize()
	json = "{'id': " & id & ", 'nombre': '" & nombre & "', 'productoId': '" & productoId & "'}"
    
	apiJob.Initialize("", Me)
	apiJob.PostString(apiURL, json)
	apiJob.GetRequest.SetContentType("application/json")
	Wait For(apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		data = jsonParser.NextObject
		cat.Id = data.Get("id")
		cat.nombre = data.Get("nombre")
		cat.ProductoId = data.Get("productoId")
	End If
	Return cat
End Sub


Public Sub Read_All() As ResumableSub
	Dim clien As List
	Dim cat As Categoria
	Dim map As Map
	Dim lst As List
    
	clien.Initialize
    
	apiJob.Initialize("", Me)
	apiJob.Download(apiURL)
	Wait For(apiJob) JobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		lst = jsonParser.NextArray
		For i = 0 To lst.Size - 1
			map = lst.Get(i)
			cat.Initialize
			cat.Id = map.Get("id")
			cat.Nombre = map.Get("nombre")
			cat.ProductoId = map.Get("productoId")
            
			clien.Add(cat)
		Next
	End If
    
	Return clien
End Sub



Public Sub Read_ById(id As Int) As ResumableSub
	Dim cat As Categoria
	cat.Initialize
    
	apiJob.Initialize("", Me)
	apiJob.Download(apiURL & "/" & id)
	Wait For (apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		Dim map As Map = jsonParser.NextObject
		cat.Id = map.Get("id")
		cat.Nombre = map.Get("nombre")
		cat.ProductoId = map.Get("productoId")
	End If
	Return cat
End Sub

Public Sub Update(id As Int, nombre As String, productoId As Int) As ResumableSub
	Dim cat As Categoria
	Dim json As String
    
	cat.Initialize()
	json = $"{
        "id": ${id},
        "nombre": "${nombre}",
        "productoId": ${productoId}
    }"$
	
	apiJob.Initialize("", Me)
	apiJob.PutString(apiURL & "/" & id, json)
	apiJob.GetRequest.SetContentType("application/json")
    
	Wait For(apiJob) jobDone(resultado As HttpJob)
	Return resultado.Success
End Sub


Public Sub Delete(id As Int) As ResumableSub
	apiJob.Initialize("", Me)
	apiJob.Delete(apiURL & "/" & id)
    
	Wait For(apiJob) jobDone(resultado As HttpJob)
	Return resultado.Success
End Sub

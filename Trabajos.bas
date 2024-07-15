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

Public Sub Create(id As Int, nombreTrabajo As String) As ResumableSub
	Dim clas As Trabajo
	Dim json As String
	Dim data As Map
	
	clas.Initialize()
	json = "{'id': 0, 'nombreTrabajo': '"& nombreTrabajo &"'}"
	
	apiJob.Initialize("",Me)
	apiJob.PostString(apiURL, json)
	apiJob.GetRequest.SetContentType("application/json")
	Wait For(apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize( resultado.GetString)
		data = jsonParser.NextObject
		clas.Id = data.Get("id")
		clas.NombreTrabajo = data.Get("nombreTrabajo")
	End If
	Return clas
End Sub

Public Sub Read_All() As ResumableSub
	Dim clas As List
	Dim cla As Trabajo
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
			Dim cla As Trabajo
			cla.Initialize
			cla.Id = map.Get("id")
			cla.NombreTrabajo = map.Get("nombreTrabajo")
			clas.Add(cla)
		Next
	End If
	
	Return clas
End Sub


Public Sub Read_ById(id As Int) As ResumableSub
	Dim cla As Trabajo
	cla.Initialize
	
	apiJob.Initialize("",Me)
	apiJob.Download(apiURL &"/"& id)
	Wait For (apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		Dim map As Map = jsonParser.NextObject
		cla.Id = map.Get("id")
		cla.NombreTrabajo = map.Get("nombreTrabajo")
	End If
	Return cla
End Sub

Public Sub Update (id As Int, nombreTrabajo As String) As ResumableSub
	Dim clas As Trabajo
	Dim json As String
	
	clas.Initialize()
	json = "{'id': '"& id &"', 'nombreTrabajo': '"& nombreTrabajo &"'}"
	
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
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

Public Sub Create(id As Int, nombre As String, apellido As String, direccion As String, correoElectronico As String, telefono As String, trabajoId As Int) As ResumableSub
	Dim clie As Cliente
	Dim json As String
	Dim data As Map
    
	clie.Initialize()
	json = "{'id': " & id & ", 'nombre': '" & nombre & "', 'apellido': '" & apellido & "', 'direccion': '" & direccion & "', 'correoElectronico': '" & correoElectronico & "', 'telefono': '" & telefono & "', 'trabajoId': '" & trabajoId & "'}"
    
	apiJob.Initialize("", Me)
	apiJob.PostString(apiURL, json)
	apiJob.GetRequest.SetContentType("application/json")
	Wait For(apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		data = jsonParser.NextObject
		clie.Id = data.Get("id")
		clie.Nombre = data.Get("nombre")
		clie.Apellido = data.Get("apellido")
		clie.Direccion = data.Get("direccion")
		clie.CorreoElectronico = data.Get("correoElectronico")
		clie.Telefono = data.Get("telefono")
		clie.TrabajoId = data.Get("trabajoId")
	End If
	Return clie
End Sub


Public Sub Read_All() As ResumableSub
	Dim clien As List
	Dim cli As Cliente
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
			cli.Initialize
			cli.Id = map.Get("id")
			cli.Nombre = map.Get("nombre")
			cli.Apellido = map.Get("apellido")
			cli.Direccion = map.Get("direccion")
			cli.CorreoElectronico = map.Get("correoElectronico")
			cli.Telefono = map.Get("telefono")
			cli.TrabajoId = map.Get("trabajoId")
            
			clien.Add(cli)
		Next
	End If
    
	Return clien
End Sub



Public Sub Read_ById(id As Int) As ResumableSub
	Dim cli As Cliente
	cli.Initialize
    
	apiJob.Initialize("", Me)
	apiJob.Download(apiURL & "/" & id)
	Wait For (apiJob) jobDone(resultado As HttpJob)
	If resultado.Success Then
		jsonParser.Initialize(resultado.GetString)
		Dim map As Map = jsonParser.NextObject
		cli.Id = map.Get("id")
		cli.Nombre = map.Get("nombre")
		cli.Apellido = map.Get("apellido")
		cli.Direccion = map.Get("direccion")
		cli.CorreoElectronico = map.Get("correoElectronico")
		cli.Telefono = map.Get("telefono")
		cli.TrabajoId = map.Get("trabajoId")
	End If
	Return cli
End Sub

Public Sub Update(id As Int, nombre As String, apellido As String, direccion As String, correoElectronico As String, telefono As String, trabajoId As Int) As ResumableSub
	Dim cli As Cliente
	Dim json As String
    
	cli.Initialize()
	json = $"{
        "id": ${id},
        "nombre": "${nombre}",
        "apellido": "${apellido}",
        "direccion": "${direccion}",
        "correoElectronico": "${correoElectronico}",
        "telefono": "${telefono}",
        "trabajoId": ${trabajoId}
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

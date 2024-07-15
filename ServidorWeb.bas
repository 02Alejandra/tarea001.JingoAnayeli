B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=9.9
@EndOfDesignText@
#Region  Service Attributes 
    #StartAtBoot: False
    #ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	' Estas variables globales se declararán una vez al iniciar la aplicación.
	' Son accesibles desde todos los módulos.
	Private webSocket As HttpServer
	Private users As Map
	Private sqliteDB As SQL
	Private personas As Personas
End Sub

Sub Globals
	' Aquí se declaran las variables globales específicas de este módulo.
	' No parece haber ninguna en tu ejemplo, así que este podría quedar vacío.
End Sub

Sub Service_Create
	' Punto de entrada del servicio.
	' Aquí se cargan recursos que no son específicos de una sola actividad.
	webSocket.Initialize("webSocket")
	personas.Initialize("servidores.data")
End Sub

Sub Service_Start (StartingIntent As Intent)
	' Detener el servicio en primer plano automáticamente si se inició así.
	webSocket.Start(8080)
	users.Initialize
End Sub

Sub Service_TaskRemoved
	' Se levanta este evento cuando el usuario elimina la aplicación de la lista de aplicaciones recientes.
	webSocket.Stop
End Sub

' Retornar verdadero para permitir al manejador de excepciones predeterminado del sistema operativo manejar la excepción no capturada.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy
	' Este evento se levanta cuando el servicio se destruye.
End Sub


Private Sub webSocket_HandleRequest (Request As ServletRequest, Response As ServletResponse)
	Select Request.RequestURI
		Case "/home"
			Response.Status = 200
			Response.SendString("Bienvenido a este servidor")
        
		Case "/login"
			Dim user As String = Request.GetParameter("user")
			Dim pwd As String = Request.GetParameter("pwd")
			Dim ip As String = Request.RemoteAddress

			If Request.Method <> "POST" Then
				Response.Status = 405
				Response.SendString("Método no permitido")
			Else
				If user = "yo" And pwd = "12345" Then
					VerificacionDatos.autenticado = True
					Response.Status = 200
					Response.SendString("Bienvenido!! Su IP es: " & ip)
				Else
					VerificacionDatos.autenticado = False ' Asegurar que esté desautenticado si las credenciales son incorrectas
					Response.Status = 401
					Response.SendString("Ingresar las credenciales correctas")
				End If
			End If
        
		Case "/datainput"
			If VerificacionDatos.autenticado=True Then
				Dim Id As String = Request.GetParameter("id")
				Dim cedula As String =Request.GetParameter("cedula")
				Dim nombres As String =Request.GetParameter("nombres")
				Dim cargo As String =Request.GetParameter("cargo")
				Dim salario As String =Request.GetParameter("salario")
				If cedula <> "" Or nombres <> "" Or salario <> "" Or cargo <> "" Then
					personas.Create(Id, cedula, nombres, salario, cargo)
					Response.Status = 200
					Response.SendString("Empleado guardado")
				Else
					Response.Status = 400
					Response.SendString("Parámetros incompletos")
				End If
			Else
				Response.Status = 401
				Response.SendString("Desautorizado")
				Return
			End If

        
		Case "/dataoutput"
			If VerificacionDatos.autenticado = True Then
				Dim resultado As List
				resultado = personas.Read_All() ' Asumiendo que Read_All() devuelve una lista de empleados
                
				Dim jsonGenerator As JSONGenerator
				jsonGenerator.Initialize2(resultado)
                
				Dim json As String = jsonGenerator.ToPrettyString(5)
                
				Response.Status = 200
				Response.SetHeader("Content-Type", "application/json")
				Response.SendString(json)
			Else
				Response.Status = 401
				Response.SendString("No tiene los permisos necesarios")
			End If
        
		Case Else
			Response.Status = 404
			Response.SendString("Página no encontrada")
	End Select
End Sub

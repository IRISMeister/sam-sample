Class MyApp.Sensor Extends %SYS.Monitor.SAM.Abstract
{

Parameter PRODUCT = "sco";

Method GetSensors() As %Status
{
	Set tSC='$$$OK
	Try {
		D ..SetSensor("sensor1", ..Sensor1(),"LOC-123")
		D ..SetSensor("sensor1", ..Sensor1(),"LOC-456")
		D ..SetSensor("sensor2", ..Sensor2(),"LOC-123")
		D ..SetSensor("sensor2", ..Sensor2(),"LOC-456")
		Set tSC=$$$OK
	}
	Catch(e) {
		Set tSC=e.AsStatus()
		Do BACK^%ETN
	}
	Return tSC
}

ClassMethod Sensor1() As %Integer
{
	Return $R(100)+1
}

ClassMethod Sensor2() As %Integer
{
	Return $R(100)+1
}

}

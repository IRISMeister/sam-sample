Class MyApp.Sensor Extends %SYS.Monitor.SAM.Abstract
{

Parameter PRODUCT = "sco";

Method GetSensors() As %Status
{
	Set tSC='$$$OK
	Try {
		D ..SetSensor("sensor1", ..Sensor1(),"LOC-123")
		D ..SetSensor("sensor1", ..Sensor1(),"LOC-456")

		Set value=1
		Set labels("id")="LOC-123"
		Set labels("latitude")=51.509865
		Set labels("longitude")=-0.118092
		Set labels("city")="London"
		Set labels("size")=50  // どうにかして1-100の範囲に正規化するのがベター
		D ..SetSensorLabels("stock", value,.labels)

		Set value=1
		Set labels("id")="LOC-456"
		Set labels("latitude")=35.652832
		Set labels("longitude")=139.839478
		Set labels("city")="Tokyo"
		Set labels("size")=30  // どうにかして1-100の範囲に正規化するのがベター
		D ..SetSensorLabels("stock", value,.labels)

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

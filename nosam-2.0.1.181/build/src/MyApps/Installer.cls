Class MyApps.Installer
{

ClassMethod setup(ByRef tVars) As %Status
{
  Set tSC='$$$OK
  Try {
    New $NAMESPACE
    Set Namespace="USER"

    Set $NAMESPACE="%SYS"
    // Force remove production classes
    Set tSC=##class(Config.MapPackages).Delete(Namespace,"Ens")
    Set tSC=##class(Config.MapPackages).Delete(Namespace,"EnsLib")
    Set tSC=##class(Config.MapPackages).Delete(Namespace,"EnsPortal")
    Set tSC=##class(Config.MapPackages).Delete(Namespace,"CSPX.Dashboard")


    Set $NAMESPACE=Namespace
    Set tSC=$SYSTEM.OBJ.LoadDir("/home/irisowner/src","ck",,1)
    $$$ThrowOnError(tSC)
    Do ##class(MyApp.Utils).Init()

    Set $NAMESPACE="%SYS"

    #; カスタムセンサーの追加先のNSにアクセス権が無いと/api/monitor/metricsアクセス時に<PROTECT>で落ちる。
    #; ここでは/api/monitor/metricsに%DB_USERを付与することで対処。
    Set webapp="/api/monitor"
    Set tSC = ##Class(Security.Applications).Get(webapp,.props)
    $$$ThrowOnError(tSC)
    Set props("MatchRoles")=":%DB_IRISSYS:%DB_USER"
    Set tSC = ##Class(Security.Applications).Modify(webapp,.props)
    $$$ThrowOnError(tSC)

    Set tSC = ##class(SYS.Monitor.SAM.Config).AddApplicationClass("MyApp.Sensor", Namespace)
    $$$ThrowOnError(tSC)

    Set tSC=$$$OK
  } Catch(e) {
	  Set tSC=e.AsStatus()
    zw tSC
  }
  Return tSC
}

ClassMethod ConfigCSP() As %Status
{
  New $NAMESPACE
	Set tSC='$$$OK
	Try {
    Set $NAMESPACE="%SYS"
    Do $System.CSP.SetConfig("CSPConfigName",$SYSTEM.INetInfo.LocalHostName())
    Set tSC=$$$OK
	} Catch(e) {
		Set tSC=e.AsStatus()
	}
  Return tSC
}

}

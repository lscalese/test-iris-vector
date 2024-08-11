# Description: This script is executed after the IRIS instance has been started.
# It installs the swagger-ui package and starts the careia production.
# Add your own commands to this file to customize the startup of your IRIS instance.
iris session $ISC_PACKAGE_INSTANCENAME -U IRISAPP <<- END
zpm "install swagger-ui"
Do \$SYSTEM.OBJ.LoadDir("/home/irisowner/dev/src/","ck", , 1)
Set sc = ##class(Ens.Director).StartProduction("careia.production.careia")
Write !,"Production Start Status: ", \$SYSTEM.Status.GetOneErrorText(sc), !
Halt
END

exit 0
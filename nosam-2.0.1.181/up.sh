#!/bin/bash
docker compose up -d
# wait unitl IRIS is ready
docker compose exec -T iris1 bash -c "\$ISC_PACKAGE_INSTALLDIR/dev/Cloud/ICM/waitISC.sh '' 60"
docker compose exec -T iris2 bash -c "\$ISC_PACKAGE_INSTALLDIR/dev/Cloud/ICM/waitISC.sh '' 60"

docker compose exec iris1 iris session iris -U USER "##class(MyApps.Installer).ConfigCSP()"
docker compose exec iris2 iris session iris -U USER "##class(MyApps.Installer).ConfigCSP()"

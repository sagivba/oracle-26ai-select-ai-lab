# Oracle AI Database 26ai Docker Setup (Hands-on)

## מטרת המסמך

הקמה מהירה של סביבת Oracle AI Database 26ai Free על Docker לצורך
Hands-on עם Select AI.

------------------------------------------------------------------------

## 1. prerequisites

-   Docker Desktop מותקן ורץ
-   מינימום 8GB RAM (מומלץ 12GB)
-   לפחות 20GB פנוי בדיסק
-   חשבון Oracle + Auth Token ל-OCR

------------------------------------------------------------------------

## 2. login ל-Oracle Container Registry

``` bash
docker login container-registry.oracle.com
```

Username: האימייל שלך\
Password: Auth Token (לא סיסמת SSO)

------------------------------------------------------------------------

## 3. pull image

``` bash
docker pull container-registry.oracle.com/database/free:latest
```

------------------------------------------------------------------------

## 4. יצירת volume (persistent)

``` bash
docker volume create oradata
```

------------------------------------------------------------------------

## 5. הרצת container

``` bash
docker run -d \
  --name oracle-free \
  -p 1521:1521 \
  -p 5500:5500 \
  -e ORACLE_PWD='Oracle123#' \
  -v oradata:/opt/oracle/oradata \
  container-registry.oracle.com/database/free:latest
```

------------------------------------------------------------------------

## 6. בדיקת עלייה

``` bash
docker logs -f oracle-free
```

לחפש:

    DATABASE IS READY TO USE!

בדיקות נוספות:

``` bash
docker ps
ss -lnt | grep 1521
```

------------------------------------------------------------------------

## 7. פרטי חיבור

-   Host: localhost
-   Port: 1521
-   Service: FREEPDB1
-   User: system
-   Password: Oracle123#

------------------------------------------------------------------------

## 8. חיבור עם SQLcl (מומלץ)

### בעיה ידועה

SQLcl עובר ל-OCI בגלל Oracle Client 19c.

### פתרון (Thin בלבד)

``` powershell
$env:ORACLE_HOME=$null
$env:TNS_ADMIN=$null
$env:PATH=(($env:PATH -split ';' | Where-Object { $_ -notmatch 'clienthome_1\\bin' }) -join ';')
& "C:\oracle\SQLcl\sqlcl-25.2.2\sqlcl\bin\sql.exe" "system/Oracle123#@//localhost:1521/FREEPDB1"
```

------------------------------------------------------------------------

## 9. בדיקות DB

``` sql
select banner_full from v$version;
show pdbs;
select sysdate from dual;
```

------------------------------------------------------------------------

## 10. tnsnames.ora (אופציונלי)

``` text
# Oracle AI Database 26ai Free (Docker)
ORA26AI = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = FREEPDB1)))
```

חיבור:

``` bash
sql system/"Oracle123#"@ORA26AI
```

(דורש Thin environment)

------------------------------------------------------------------------

## 11. סיכום

-   DB רץ מקומית על Docker
-   חיבור עובד דרך SQLcl
-   מוכן לשלב הבא: Select AI

------------------------------------------------------------------------

## Next Step

בניית schema Budget והכנת נתונים ל-NL2SQL

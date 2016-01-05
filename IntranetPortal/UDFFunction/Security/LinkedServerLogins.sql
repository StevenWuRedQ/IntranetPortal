EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'207.97.206.29,4436', @useself = N'FALSE', @rmtuser = N'Chris';


GO
EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'SQLSERVERNODE1,4436', @useself = N'FALSE', @rmtuser = N'George';


GO
EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'SQLSERVERNODE3,4436', @useself = N'FALSE', @rmtuser = N'George';


EXECUTE sp_addlinkedserver @server = N'207.97.206.29,4436', @srvproduct = N'SQL Server';


GO
EXECUTE sp_addlinkedserver @server = N'SQLSERVERNODE1,4436', @srvproduct = N'SQL Server';


GO
EXECUTE sp_addlinkedserver @server = N'SQLSERVERNODE3,4436', @srvproduct = N'', @provider = N'SQLNCLI';




Data Source=ESTA-PC\SQLEXPRESS;Initial Catalog=ControlHorasExtras;Integrated Security=True;Encrypt=False

-------- appsettings -------
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "STRING CONNECTION DEL SERVER"
  }
}

-------- Nuggets ----------
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Design

-------- Scaffolding ----------
Scaffold-Dbcontext "STRING CONNECTION DEL SERVER" Microsoft.EntityFrameworkCore.SqlServer -ContextDir Data -OutputDir Models -DataAnnotation

dotnet ef dbcontext scaffold 'Server=ESTA-PC\SQLEXPRESS;Database=OvertimeControl;Trusted_Connection=True;Encrypt=False;' Microsoft.EntityFrameworkCore.SqlServer -o Models --force

dotnet ef dbcontext scaffold 'Server=ESTA-PC\SQLEXPRESS;Database=OvertimeControl;Trusted_Connection=True;TrustServerCertificate=True;Encrypt=False;' Microsoft.EntityFrameworkCore.SqlServer --output-dir Models --force 
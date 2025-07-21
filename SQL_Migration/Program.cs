using Microsoft.EntityFrameworkCore;
using SQL_Migration.Data;

namespace SQL_Migration
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("SQL Migration Tool - Database Scaffolding");
            Console.WriteLine("=========================================");
            Console.WriteLine("此工具用於 scaffold 資料庫模型");
            Console.WriteLine();
            Console.WriteLine("使用 Entity Framework Core 指令來 scaffold 資料庫:");
            Console.WriteLine();
            Console.WriteLine("源資料庫 (EcoCampus_Maria3):");
            Console.WriteLine("dotnet ef dbcontext scaffold \"Server=VM-MSSQL-2022;Database=EcoCampus_Maria3;User ID=ecocampus;Password=42949337;TrustServerCertificate=True;\" Microsoft.EntityFrameworkCore.SqlServer --output-dir Models/Source --context-dir Data --context SourceDbContext --force");
            Console.WriteLine();
            Console.WriteLine("目標資料庫 (EcoCampus):");
            Console.WriteLine("dotnet ef dbcontext scaffold \"Server=VM-MSSQL-2022;Database=EcoCampus_PreProduction;User ID=ecocampus;Password=42949337;TrustServerCertificate=True;\" Microsoft.EntityFrameworkCore.SqlServer --output-dir Models/Target --context-dir Data --context TargetDbContext --force");
            Console.WriteLine();
            Console.WriteLine("模型已準備完成，可以開始撰寫 SQL 腳本。");
            Console.WriteLine();
            Console.WriteLine("按任意鍵退出...");
            Console.ReadKey();
        }
    }
}

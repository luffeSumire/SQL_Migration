using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class ExceptionLog
{
    public long LogId { get; set; }

    public DateTime ExceptionTime { get; set; }

    public string? RequestUrl { get; set; }

    public string? ExceptionType { get; set; }

    public string? ExceptionMessage { get; set; }

    public string? ExceptionStack { get; set; }

    public string? SourceContext { get; set; }

    public long? UserId { get; set; }

    public string? UserName { get; set; }

    public string? ClientIp { get; set; }

    public string? ServerName { get; set; }

    public string? AdditionalData { get; set; }
}

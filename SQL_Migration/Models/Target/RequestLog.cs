using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class RequestLog
{
    public long LogId { get; set; }

    public DateTime RequestTime { get; set; }

    public DateTime? ResponseTime { get; set; }

    public int? DurationMs { get; set; }

    public string RequestUrl { get; set; } = null!;

    public string RequestPath { get; set; } = null!;

    public string RequestMethod { get; set; } = null!;

    public string? RequestPayload { get; set; }

    public string? ResponsePayload { get; set; }

    public int? StatusCode { get; set; }

    public long? UserId { get; set; }

    public string? UserName { get; set; }

    public string? ClientIp { get; set; }

    public string? UserAgent { get; set; }

    public string? ControllerName { get; set; }

    public string? ActionName { get; set; }

    public bool IsSuccessful { get; set; }
}

using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysLanguageDatum
{
    public long Sid { get; set; }

    public string? CreateUrlPath { get; set; }

    public string? CreatePostParam { get; set; }

    public string? PointPath { get; set; }

    public string? KeyWord { get; set; }

    public string? ZhTw { get; set; }

    public string? Cn { get; set; }

    public string? En { get; set; }
}

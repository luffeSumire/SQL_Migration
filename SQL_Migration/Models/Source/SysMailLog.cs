using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 寄信log
/// </summary>
public partial class SysMailLog
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public string? LogInfo { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

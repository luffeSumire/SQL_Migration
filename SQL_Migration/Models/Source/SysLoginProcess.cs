using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 登錄驗證
/// </summary>
public partial class SysLoginProcess
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// ip
    /// </summary>
    public string Ip { get; set; } = null!;

    /// <summary>
    /// 次數
    /// </summary>
    public byte Times { get; set; }

    /// <summary>
    /// 連結
    /// </summary>
    public string Url { get; set; } = null!;

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

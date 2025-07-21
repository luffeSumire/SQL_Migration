using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 相關關鍵字，對應哪些function
/// </summary>
public partial class LineAction
{
    /// <summary>
    /// 接收到的line訊息是什麼關鍵字
    /// </summary>
    public string Keyword { get; set; } = null!;

    /// <summary>
    /// 接收來源,對應line API的 user,room,group
    /// </summary>
    public string SourceType { get; set; } = null!;

    /// <summary>
    /// 對應要執行的php function
    /// </summary>
    public string FunctionName { get; set; } = null!;

    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int? Sequence { get; set; }

    public virtual ICollection<LineActionReg> LineActionRegs { get; set; } = new List<LineActionReg>();
}

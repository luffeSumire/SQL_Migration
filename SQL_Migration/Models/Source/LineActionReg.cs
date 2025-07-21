using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 哪些使用者被登記相對應的action
/// </summary>
public partial class LineActionReg
{
    /// <summary>
    /// 登記從line傳過來的source_id
    /// </summary>
    public string SourceId { get; set; } = null!;

    /// <summary>
    /// 對應line_action資料表的sid
    /// </summary>
    public int ActionSid { get; set; }

    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int? Sequence { get; set; }

    public virtual LineAction ActionS { get; set; } = null!;
}

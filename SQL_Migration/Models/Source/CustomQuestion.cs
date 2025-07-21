using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 題目；用於建立題目跟子題目
/// </summary>
public partial class CustomQuestion
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int Sequence { get; set; }

    /// <summary>
    /// 子題目sid；如：生態團隊下的學生名單
    /// </summary>
    public int? ParentSid { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 題目敘述
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 七大步驟中的第幾步驟
    /// </summary>
    public int? Step { get; set; }

    /// <summary>
    /// 是否啟用；1:使用、0:不使用
    /// </summary>
    public byte? IsUse { get; set; }

    public byte? QuestionTpl { get; set; }

    /// <summary>
    /// 臨時欄位，對應原 is_renew，用於資料遷移
    /// </summary>
    public short? IsRenewTemp { get; set; }
}

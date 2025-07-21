using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysAccountGroup
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    public string? Startdate { get; set; }

    public string? Enddate { get; set; }

    /// <summary>
    /// 授權目標
    /// </summary>
    public int? TargetSid { get; set; }

    /// <summary>
    /// 授權方式：P=Person個人授權，U＝Unit單位授權(僅此單位)，D＝Department部門授權(此單位與向下單位都授權)
    /// </summary>
    public string? Type { get; set; }

    /// <summary>
    /// 對應的角色群組
    /// </summary>
    public int? GroupSid { get; set; }

    /// <summary>
    /// 原始的單位 (當個人移動到不同單位時，例如調職，用此欄位判斷原始單位，可用來判斷是否移除此權限)
    /// </summary>
    public int? OriginalCompanySid { get; set; }
}

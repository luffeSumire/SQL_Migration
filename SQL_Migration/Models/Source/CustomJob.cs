using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者的職稱
/// </summary>
public partial class CustomJob
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// school:生態學校,epa:環保人員,tutor:輔導人員
    /// </summary>
    public string Type { get; set; } = null!;

    /// <summary>
    /// 名稱
    /// </summary>
    public string? JobCname { get; set; }

    /// <summary>
    /// 單位sid
    /// </summary>
    public int? PlaceSid { get; set; }

    /// <summary>
    /// 上架時間
    /// </summary>
    public string? Startdate { get; set; }

    /// <summary>
    /// 下架時間
    /// </summary>
    public string? Enddate { get; set; }
}

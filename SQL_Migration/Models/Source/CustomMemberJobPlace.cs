using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者的服務單位及職稱關聯
/// </summary>
public partial class CustomMemberJobPlace
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
    /// 使用者sid
    /// </summary>
    public int? MemberSid { get; set; }

    /// <summary>
    /// 單位sid
    /// </summary>
    public int? PlaceSid { get; set; }

    /// <summary>
    /// 職稱sid
    /// </summary>
    public string? JobSid { get; set; }

    /// <summary>
    /// 上架時間
    /// </summary>
    public string? Startdate { get; set; }

    /// <summary>
    /// 下架時間
    /// </summary>
    public string? Enddate { get; set; }
}

using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者認證等級
/// </summary>
public partial class CustomMemberLevel
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 使用者編號
    /// </summary>
    public long? MemberSid { get; set; }

    /// <summary>
    /// 認證編號
    /// </summary>
    public int? CertificationSid { get; set; }

    /// <summary>
    /// 等級
    /// </summary>
    public byte? Level { get; set; }

    /// <summary>
    /// 有效性
    /// </summary>
    public byte? Effectiveness { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual CustomMember? MemberS { get; set; }
}

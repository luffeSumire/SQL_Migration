using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 學校校長基本資料
/// </summary>
public partial class CustomSchoolPrincipal
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 使用者sid
    /// </summary>
    public long? MemberSid { get; set; }

    /// <summary>
    /// 校長名稱(中文)
    /// </summary>
    public string? PrincipalCname { get; set; }

    /// <summary>
    /// 校長名稱(英文)
    /// </summary>
    public string? PrincipalCnameEn { get; set; }

    /// <summary>
    /// 校長電話
    /// </summary>
    public string? PrincipalTel { get; set; }

    /// <summary>
    /// 校長手機
    /// </summary>
    public string? PrincipalPhone { get; set; }

    /// <summary>
    /// 校長信箱
    /// </summary>
    public string? PrincipalEmail { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual CustomMember? MemberS { get; set; }
}

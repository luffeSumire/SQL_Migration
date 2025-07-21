using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 聯絡人基本資料
/// </summary>
public partial class CustomContact
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
    /// 聯絡人名稱(中文)
    /// </summary>
    public string? ContactCname { get; set; }

    /// <summary>
    /// 聯絡人名稱(英文)
    /// </summary>
    public string? ContactCnameEn { get; set; }

    /// <summary>
    /// 電話
    /// </summary>
    public string? ContactTel { get; set; }

    /// <summary>
    /// 手機
    /// </summary>
    public string? ContactPhone { get; set; }

    /// <summary>
    /// 信箱
    /// </summary>
    public string? ContactEmail { get; set; }

    /// <summary>
    /// 傳真
    /// </summary>
    public string? ContactFax { get; set; }

    /// <summary>
    /// 職稱sid
    /// </summary>
    public int? ContactJobSid { get; set; }

    /// <summary>
    /// 聯絡人職稱
    /// </summary>
    public string? ContactJobCname { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual CustomMember? MemberS { get; set; }
}

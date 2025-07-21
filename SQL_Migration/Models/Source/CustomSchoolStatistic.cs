using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 紀錄學校的員工數量及各年級學生數量
/// </summary>
public partial class CustomSchoolStatistic
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
    /// 校內員工總數
    /// </summary>
    public int StaffTotal { get; set; }

    /// <summary>
    /// 國小1年級
    /// </summary>
    public int Elementary1 { get; set; }

    /// <summary>
    /// 國小2年級
    /// </summary>
    public int Elementary2 { get; set; }

    /// <summary>
    /// 國小3年級
    /// </summary>
    public int Elementary3 { get; set; }

    /// <summary>
    /// 國小4年級
    /// </summary>
    public int Elementary4 { get; set; }

    /// <summary>
    /// 國小5年級
    /// </summary>
    public int Elementary5 { get; set; }

    /// <summary>
    /// 國小6年級
    /// </summary>
    public int Elementary6 { get; set; }

    /// <summary>
    /// 國中1年級
    /// </summary>
    public int Middle7 { get; set; }

    /// <summary>
    /// 國中2年級
    /// </summary>
    public int Middle8 { get; set; }

    /// <summary>
    /// 國中3年級
    /// </summary>
    public int Middle9 { get; set; }

    /// <summary>
    /// 高中1年級
    /// </summary>
    public int Hight10 { get; set; }

    /// <summary>
    /// 高中2年級
    /// </summary>
    public int Hight11 { get; set; }

    /// <summary>
    /// 高中3年級
    /// </summary>
    public int Hight12 { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public string? WriteDate { get; set; }

    public virtual CustomMember? MemberS { get; set; }
}

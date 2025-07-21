using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 投稿 中英關聯表
/// </summary>
public partial class CustomReleaseEnTw
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 英文投稿sid
    /// </summary>
    public long? ReleaseEnSid { get; set; }

    /// <summary>
    /// 英文投稿內容
    /// </summary>
    public string? ReleaseEnContent { get; set; }

    /// <summary>
    /// 中文投稿sid
    /// </summary>
    public long? ReleaseTwSid { get; set; }

    /// <summary>
    /// 中文投稿內容
    /// </summary>
    public string? ReleaseTwContent { get; set; }

    /// <summary>
    /// 投稿審核意見
    /// </summary>
    public string? ReleaseOpinion { get; set; }

    /// <summary>
    /// 審核狀態
    /// </summary>
    public string? Review { get; set; }

    /// <summary>
    /// 送審日期(yyyy-mm-dd)
    /// </summary>
    public string? Reviewdate { get; set; }

    /// <summary>
    /// 通過日期(yyyy-mm-dd)
    /// </summary>
    public string? Passdate { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual CustomNews? ReleaseEnS { get; set; }

    public virtual CustomNews? ReleaseTwS { get; set; }
}

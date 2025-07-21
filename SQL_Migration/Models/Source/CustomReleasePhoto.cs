using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 投稿 中英關聯表
/// </summary>
public partial class CustomReleasePhoto
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long? ReleaseSid { get; set; }

    /// <summary>
    /// 投稿照片
    /// </summary>
    public string? Photo { get; set; }

    /// <summary>
    /// 照片說明
    /// </summary>
    public string? Description { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual CustomNews? ReleaseS { get; set; }
}

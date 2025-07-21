using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomEditer
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public string? Cname { get; set; }

    public string? ClassificationSid { get; set; }

    /// <summary>
    /// 是否為系統開發者帳號 0:否 1:是
    /// </summary>
    public int? IsAdmin { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

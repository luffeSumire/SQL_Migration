using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 紀錄學校的員工數量及各年級學生數量
/// </summary>
public partial class CustomSchoolImport
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public string? Code { get; set; }

    public string? Cname { get; set; }

    public int? CitySid { get; set; }

    public int? AreaSid { get; set; }

    public string? Address { get; set; }

    public string? Tel { get; set; }

    public string? Url { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }
}

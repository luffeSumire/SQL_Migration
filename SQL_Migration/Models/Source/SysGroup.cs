using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysGroup
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long? CompanySid { get; set; }

    public string? Cname { get; set; }

    public string? Remark { get; set; }

    public int Sequence { get; set; }

    public string? Lan { get; set; }
}

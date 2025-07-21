using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysCompanyJobTitle
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public string? Startdate { get; set; }

    public string? Enddate { get; set; }

    public long Sid { get; set; }

    public long? ParentSid { get; set; }

    public string? Cname { get; set; }

    public string? Remark { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysRule
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long? ParentSid { get; set; }

    public string? RuleName { get; set; }

    public string? Url { get; set; }

    public long? ModuleSid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

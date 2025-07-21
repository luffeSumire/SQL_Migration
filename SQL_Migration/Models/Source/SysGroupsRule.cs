using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysGroupsRule
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long? GroupsSid { get; set; }

    public long? RuleSid { get; set; }

    public int C { get; set; }

    public int U { get; set; }

    public int R { get; set; }

    public int D { get; set; }

    public int Sequence { get; set; }

    public string? Lan { get; set; }
}

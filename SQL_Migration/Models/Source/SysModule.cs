using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysModule
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public string? ModuleName { get; set; }

    public string? ModuleIcons { get; set; }

    public int? ModuleType { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

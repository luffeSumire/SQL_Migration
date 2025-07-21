using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysBannerpic
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public string? Startdate { get; set; }

    public string? Enddate { get; set; }

    public long? ParentSid { get; set; }

    public string? Fileinfo { get; set; }

    public string? Filename { get; set; }

    public string? Siteurl { get; set; }

    public int? Isblank { get; set; }

    public string? Msg { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

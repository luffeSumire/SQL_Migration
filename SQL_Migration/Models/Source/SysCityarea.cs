using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysCityarea
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int? ParentSid { get; set; }

    public string? PostCode { get; set; }

    public string? AreaName { get; set; }

    public string? AreaNameEn { get; set; }

    public string? Remark { get; set; }

    public int? Sequence { get; set; }

    public string? Language { get; set; }
}

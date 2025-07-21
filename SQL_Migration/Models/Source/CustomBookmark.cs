using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomBookmark
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public string? TableCname { get; set; }

    public int? TableSid { get; set; }

    public string? Cname { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}

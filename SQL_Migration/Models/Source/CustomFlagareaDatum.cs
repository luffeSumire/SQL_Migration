using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomFlagareaDatum
{
    public long Sid { get; set; }

    public long FlagSid { get; set; }

    public string Type { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string Link { get; set; } = null!;

    public string Content { get; set; } = null!;

    public int Sequence { get; set; }

    public long Createdate { get; set; }

    public string Createuser { get; set; } = null!;

    public string Createip { get; set; } = null!;

    public long Updatedate { get; set; }

    public string Updateuser { get; set; } = null!;

    public string Updateip { get; set; } = null!;
}

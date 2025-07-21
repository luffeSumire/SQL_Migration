using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomFlagarea
{
    public long Sid { get; set; }

    public string School { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string Image { get; set; } = null!;

    public byte Status { get; set; }

    public string Intro { get; set; } = null!;

    public string Feature { get; set; } = null!;

    public string Course { get; set; } = null!;

    public string DeclarationTitle { get; set; } = null!;

    public string Declaration { get; set; } = null!;

    public long Createdate { get; set; }

    public string Createuser { get; set; } = null!;

    public string Createip { get; set; } = null!;

    public long Updatedate { get; set; }

    public string Updateuser { get; set; } = null!;

    public string Updateip { get; set; } = null!;
}

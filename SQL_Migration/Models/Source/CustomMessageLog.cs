using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomMessageLog
{
    public long Sid { get; set; }

    public long MessageSid { get; set; }

    public string School { get; set; } = null!;

    public string Role { get; set; } = null!;

    public byte Level { get; set; }

    public string Email { get; set; } = null!;

    public byte Status { get; set; }

    public DateTime Updatedate { get; set; }

    public DateTime Createdate { get; set; }
}

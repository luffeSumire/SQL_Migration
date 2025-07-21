using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomMessage
{
    public long Sid { get; set; }

    public byte Target { get; set; }

    public byte TargetUser { get; set; }

    public string TargetCustom { get; set; } = null!;

    public string Sender { get; set; } = null!;

    public string Subject { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateOnly? ScheduleDate { get; set; }

    public TimeOnly? ScheduleTime { get; set; }

    public byte Status { get; set; }

    public long Createdate { get; set; }

    public string Createuser { get; set; } = null!;

    public string Createip { get; set; } = null!;

    public long Updatedate { get; set; }

    public string Updateuser { get; set; } = null!;

    public string Updateip { get; set; } = null!;
}

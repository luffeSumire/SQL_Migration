using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SchoolStatistic
{
    public long Id { get; set; }

    public int SchoolId { get; set; }

    public int? StaffTotal { get; set; }

    public int? Elementary1 { get; set; }

    public int? Elementary2 { get; set; }

    public int? Elementary3 { get; set; }

    public int? Elementary4 { get; set; }

    public int? Elementary5 { get; set; }

    public int? Elementary6 { get; set; }

    public int? Middle7 { get; set; }

    public int? Middle8 { get; set; }

    public int? Middle9 { get; set; }

    public int? High10 { get; set; }

    public int? High11 { get; set; }

    public int? High12 { get; set; }

    public DateOnly? WriteDate { get; set; }

    public DateTime CreatedTime { get; set; }

    public long? CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public virtual School School { get; set; } = null!;
}

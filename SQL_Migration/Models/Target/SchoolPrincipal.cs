using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SchoolPrincipal
{
    public long Id { get; set; }

    public int SchoolId { get; set; }

    public string PrincipalName { get; set; } = null!;

    public string? PrincipalPhone { get; set; }

    public string? PrincipalMobile { get; set; }

    public string? PrincipalEmail { get; set; }

    public DateTime CreatedTime { get; set; }

    public long? CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public virtual School School { get; set; } = null!;
}

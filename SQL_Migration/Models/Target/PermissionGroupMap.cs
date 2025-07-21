using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class PermissionGroupMap
{
    public long GroupSid { get; set; }

    public long PermissionSid { get; set; }

    public bool Allow { get; set; }

    public DateTime CreateTime { get; set; }

    public long? CreateUser { get; set; }

    public DateTime UpdateTime { get; set; }

    public long? UpdateUser { get; set; }

    public byte DataStatus { get; set; }

    public DateTime? DeleteTime { get; set; }

    public long? DeleteUser { get; set; }

    public virtual PermissionGroup GroupS { get; set; } = null!;

    public virtual Permission PermissionS { get; set; } = null!;
}

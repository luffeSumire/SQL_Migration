using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class PermissionGroup
{
    public long Sid { get; set; }

    public string GroupCode { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Remark { get; set; }

    public int? Sequence { get; set; }

    public DateTime CreateTime { get; set; }

    public long? CreateUser { get; set; }

    public DateTime UpdateTime { get; set; }

    public long? UpdateUser { get; set; }

    public byte DataStatus { get; set; }

    public DateTime? DeleteTime { get; set; }

    public long? DeleteUser { get; set; }

    public virtual ICollection<AccountPermissionGroup> AccountPermissionGroups { get; set; } = new List<AccountPermissionGroup>();

    public virtual ICollection<PermissionGroupMap> PermissionGroupMaps { get; set; } = new List<PermissionGroupMap>();
}

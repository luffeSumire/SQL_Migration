using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SchoolContact
{
    public long Id { get; set; }

    public int SchoolId { get; set; }

    public string ContactName { get; set; } = null!;

    public string? JobTitle { get; set; }

    public string? ContactPhone { get; set; }

    public string? ContactMobile { get; set; }

    public string? ContactEmail { get; set; }

    public int? SortOrder { get; set; }

    public DateTime CreatedTime { get; set; }

    public long? CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public virtual School School { get; set; } = null!;
}

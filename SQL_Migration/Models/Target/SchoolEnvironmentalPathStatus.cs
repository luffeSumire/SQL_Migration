using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SchoolEnvironmentalPathStatus
{
    public int Id { get; set; }

    public int SchoolId { get; set; }

    public int EnvironmentalPathId { get; set; }

    public bool IsCompliant { get; set; }

    public DateTime? EvaluationDate { get; set; }

    public string? Notes { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual EnvironmentalPath EnvironmentalPath { get; set; } = null!;

    public virtual School School { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

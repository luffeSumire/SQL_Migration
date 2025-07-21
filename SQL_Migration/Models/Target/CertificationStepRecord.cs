using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

/// <summary>
/// Step-by-step records of certification review process
/// </summary>
public partial class CertificationStepRecord
{
    public long CertificationStepRecordId { get; set; }

    public long CertificationId { get; set; }

    public int? StepNumber { get; set; }

    public string? StepOpinion { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual Certification Certification { get; set; } = null!;

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

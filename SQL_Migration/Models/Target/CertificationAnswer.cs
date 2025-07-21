using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

/// <summary>
/// Unified table for certification question answers with workflow tracking (consolidates answers and records, action logs moved to request_log)
/// </summary>
public partial class CertificationAnswer
{
    public long CertificationAnswerId { get; set; }

    public long CertificationId { get; set; }

    public int QuestionId { get; set; }

    public string? AnswerText { get; set; }

    public byte AnswerStatus { get; set; }

    public DateTime? SubmittedDate { get; set; }

    public DateTime? ReviewedDate { get; set; }

    public long? ReviewedUserId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual Certification Certification { get; set; } = null!;

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Question Question { get; set; } = null!;

    public virtual Account? ReviewedUser { get; set; }

    public virtual Account? UpdatedUser { get; set; }
}

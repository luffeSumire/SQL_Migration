using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CampusSubmissionContent
{
    public int CampusSubmissionContentId { get; set; }

    public int CampusSubmissionId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public bool IsDefault { get; set; }

    public string? Title { get; set; }

    public string? Description { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual CampusSubmission CampusSubmission { get; set; } = null!;

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

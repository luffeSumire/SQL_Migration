using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CampusSubmission
{
    public int CampusSubmissionId { get; set; }

    public DateTime SubmissionDate { get; set; }

    public byte BadgeType { get; set; }

    public byte FeaturedStatus { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    public int SchoolId { get; set; }

    public virtual ICollection<CampusSubmissionContent> CampusSubmissionContents { get; set; } = new List<CampusSubmissionContent>();

    public virtual ICollection<CampusSubmissionReview> CampusSubmissionReviews { get; set; } = new List<CampusSubmissionReview>();

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual School School { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

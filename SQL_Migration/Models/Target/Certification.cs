using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

/// <summary>
/// User certification records with approval workflow
/// </summary>
public partial class Certification
{
    public long CertificationId { get; set; }

    public int SchoolId { get; set; }

    public byte? Level { get; set; }

    public byte ReviewStatus { get; set; }

    public DateTime? ReviewDate { get; set; }

    public DateTime? ApprovedDate { get; set; }

    public DateTime? RejectedDate { get; set; }

    public DateTime? SupplementationDate { get; set; }

    public int? CertificateId { get; set; }

    public string? RewardHistory { get; set; }

    public Guid? PdfFileId { get; set; }

    public string AddType { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<CertificationAnswer> CertificationAnswers { get; set; } = new List<CertificationAnswer>();

    public virtual ICollection<CertificationStepRecord> CertificationStepRecords { get; set; } = new List<CertificationStepRecord>();

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual FileEntry? PdfFile { get; set; }

    public virtual School School { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

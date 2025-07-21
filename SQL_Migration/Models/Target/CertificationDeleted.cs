using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CertificationDeleted
{
    public long Id { get; set; }

    public long? SchoolId { get; set; }

    public long AccountId { get; set; }

    public string CertificationType { get; set; } = null!;

    public int? Level { get; set; }

    public string Status { get; set; } = null!;

    public DateTime ApplyDate { get; set; }

    public DateTime? ReviewDate { get; set; }

    public DateTime? PassDate { get; set; }

    public DateTime? ExpiredDate { get; set; }

    public long? ReviewerId { get; set; }

    public string? ReviewComment { get; set; }

    public string? CertificateNumber { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedTime { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? CreatedUserId { get; set; }

    public long? UpdatedUserId { get; set; }

    public string? Remark { get; set; }
}

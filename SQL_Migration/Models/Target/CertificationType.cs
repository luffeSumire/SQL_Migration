using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CertificationType
{
    public int Id { get; set; }

    public string CertificationCode { get; set; } = null!;

    public string? Level { get; set; }

    public int SortOrder { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual ICollection<CertificationTypeTranslation> CertificationTypeTranslations { get; set; } = new List<CertificationTypeTranslation>();
}

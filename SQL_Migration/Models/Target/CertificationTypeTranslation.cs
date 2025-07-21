using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CertificationTypeTranslation
{
    public int CertificationTypeTranslationId { get; set; }

    public int CertificationTypeId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public bool IsDefault { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual CertificationType CertificationType { get; set; } = null!;
}

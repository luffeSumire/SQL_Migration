using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class EnvironmentalPath
{
    public int Id { get; set; }

    public string PathCode { get; set; } = null!;

    public string? CategoryCode { get; set; }

    public int SortOrder { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual ICollection<EnvironmentalPathTranslation> EnvironmentalPathTranslations { get; set; } = new List<EnvironmentalPathTranslation>();

    public virtual ICollection<SchoolEnvironmentalPathStatus> SchoolEnvironmentalPathStatuses { get; set; } = new List<SchoolEnvironmentalPathStatus>();
}

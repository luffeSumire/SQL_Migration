using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SchoolType
{
    public int Id { get; set; }

    public string SchoolTypeCode { get; set; } = null!;

    public int SortOrder { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual ICollection<SchoolTypeTranslation> SchoolTypeTranslations { get; set; } = new List<SchoolTypeTranslation>();

    public virtual ICollection<School> Schools { get; set; } = new List<School>();
}

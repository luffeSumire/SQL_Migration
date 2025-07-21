using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class District
{
    public int DistrictId { get; set; }

    public int CountyId { get; set; }

    public int PostalCode { get; set; }

    public byte DistrictType { get; set; }

    public int SortOrder { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public byte Status { get; set; }

    public virtual County County { get; set; } = null!;

    public virtual ICollection<DistrictTranslation> DistrictTranslations { get; set; } = new List<DistrictTranslation>();

    public virtual ICollection<SchoolImport> SchoolImports { get; set; } = new List<SchoolImport>();

    public virtual ICollection<School> Schools { get; set; } = new List<School>();
}

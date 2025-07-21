using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class County
{
    public int CountyId { get; set; }

    public string CountyCode { get; set; } = null!;

    public byte RegionType { get; set; }

    public int SortOrder { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public byte Status { get; set; }

    public virtual ICollection<Account> Accounts { get; set; } = new List<Account>();

    public virtual ICollection<CountyTranslation> CountyTranslations { get; set; } = new List<CountyTranslation>();

    public virtual ICollection<District> Districts { get; set; } = new List<District>();

    public virtual ICollection<SchoolImport> SchoolImports { get; set; } = new List<SchoolImport>();

    public virtual ICollection<School> Schools { get; set; } = new List<School>();
}

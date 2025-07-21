using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class DistrictTranslation
{
    public int DistrictTranslationId { get; set; }

    public int DistrictId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public bool IsDefault { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public virtual District District { get; set; } = null!;
}

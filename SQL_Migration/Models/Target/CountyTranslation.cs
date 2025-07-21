using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CountyTranslation
{
    public int CountyTranslationId { get; set; }

    public int CountyId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public bool IsDefault { get; set; }

    public string Name { get; set; } = null!;

    public virtual County County { get; set; } = null!;
}

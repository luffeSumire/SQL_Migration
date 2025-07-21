using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class BadgeType
{
    public int Id { get; set; }

    public string BadgeCode { get; set; } = null!;

    public string LabelZhTw { get; set; } = null!;

    public string LabelEn { get; set; } = null!;

    public int SortOrder { get; set; }

    public bool IsActive { get; set; }
}

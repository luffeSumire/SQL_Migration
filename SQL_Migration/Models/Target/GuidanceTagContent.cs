using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class GuidanceTagContent
{
    public int GuidanceTagContentId { get; set; }

    public int GuidanceTagId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Label { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual GuidanceTag GuidanceTag { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

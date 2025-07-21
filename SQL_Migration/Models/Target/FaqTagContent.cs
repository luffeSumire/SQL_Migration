using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class FaqTagContent
{
    public int FaqTagContentId { get; set; }

    public int FaqTagId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string FaqTagName { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual FaqTag FaqTag { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class FaqContent
{
    public int FaqContentId { get; set; }

    public int FaqId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Question { get; set; } = null!;

    public string Answer { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Faq Faq { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

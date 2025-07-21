using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class ArticleTagTranslation
{
    public int ArticleTagTranslationId { get; set; }

    public int ArticleTagId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public bool IsDefault { get; set; }

    public string Label { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual ArticleTag ArticleTag { get; set; } = null!;
}

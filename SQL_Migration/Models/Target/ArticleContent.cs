using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class ArticleContent
{
    public int ArticleContentId { get; set; }

    public int ArticleId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string? CmsHtml { get; set; }

    public Guid? BannerFileId { get; set; }

    public string? BannerAltText { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Article Article { get; set; } = null!;

    public virtual FileEntry? BannerFile { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

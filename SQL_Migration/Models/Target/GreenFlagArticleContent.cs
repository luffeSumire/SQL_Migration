using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class GreenFlagArticleContent
{
    public int GreenFlagArticleContentId { get; set; }

    public int GreenFlagArticleId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string SchoolName { get; set; } = null!;

    public string? TextContent { get; set; }

    public Guid? BannerFileId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual FileEntry? BannerFile { get; set; }

    public virtual GreenFlagArticle GreenFlagArticle { get; set; } = null!;

    public virtual ICollection<GreenFlagArticleAttachment> GreenFlagArticleAttachments { get; set; } = new List<GreenFlagArticleAttachment>();
}

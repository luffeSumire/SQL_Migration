using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class GreenFlagArticle
{
    public int GreenFlagArticleId { get; set; }

    public DateTime PublishDate { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual ICollection<GreenFlagArticleContent> GreenFlagArticleContents { get; set; } = new List<GreenFlagArticleContent>();
}

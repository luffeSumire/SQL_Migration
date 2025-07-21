using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class GreenFlagArticleAttachment
{
    public int GreenFlagArticleAttachmentId { get; set; }

    public int GreenFlagArticleContentId { get; set; }

    public Guid? FileEntryId { get; set; }

    public string ContentTypeCode { get; set; } = null!;

    public int SortOrder { get; set; }

    public string? AltText { get; set; }

    public string? Caption { get; set; }

    public string? Title { get; set; }

    public string? AltUrl { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual FileEntry? FileEntry { get; set; }

    public virtual GreenFlagArticleContent GreenFlagArticleContent { get; set; } = null!;
}

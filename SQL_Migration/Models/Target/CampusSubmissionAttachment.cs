using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class CampusSubmissionAttachment
{
    public int CampusSubmissionAttachmentId { get; set; }

    public int CampusSubmissionContentId { get; set; }

    public Guid? FileEntryId { get; set; }

    public string ContentTypeCode { get; set; } = null!;

    public int SortOrder { get; set; }

    public string? AltUrl { get; set; }

    public string? Title { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual FileEntry? FileEntry { get; set; }

    public virtual Account? UpdatedUser { get; set; }
}

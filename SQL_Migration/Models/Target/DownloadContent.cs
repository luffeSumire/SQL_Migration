using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class DownloadContent
{
    public int DownloadContentId { get; set; }

    public int DownloadId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string? Description { get; set; }

    public Guid? BannerFileId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual FileEntry? BannerFile { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Download Download { get; set; } = null!;

    public virtual ICollection<DownloadAttachment> DownloadAttachments { get; set; } = new List<DownloadAttachment>();

    public virtual Account? UpdatedUser { get; set; }
}

using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class Download
{
    public int DownloadId { get; set; }

    public DateTime PublishDate { get; set; }

    public string? TagCode { get; set; }

    public string? ExternalLink { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<DownloadContent> DownloadContents { get; set; } = new List<DownloadContent>();

    public virtual Account? UpdatedUser { get; set; }
}

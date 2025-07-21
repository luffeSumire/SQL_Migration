using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class DownloadTag
{
    public int DownloadTagId { get; set; }

    public string TagCode { get; set; } = null!;

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

    public virtual ICollection<DownloadTagTranslation> DownloadTagTranslations { get; set; } = new List<DownloadTagTranslation>();

    public virtual Account? UpdatedUser { get; set; }
}

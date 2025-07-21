using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class VideoTranslation
{
    public int VideoTranslationId { get; set; }

    public int VideoId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Url { get; set; } = null!;

    public string Title { get; set; } = null!;

    public Guid? CoverFileId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual FileEntry? CoverFile { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }

    public virtual Video Video { get; set; } = null!;
}

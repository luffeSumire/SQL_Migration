using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class HomeBannerContent
{
    public int HomeBannerContentId { get; set; }

    public int HomeBannerId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public Guid? BannerFileId { get; set; }

    public string? BannerAltText { get; set; }

    public string? LinkUrl { get; set; }

    public string LinkTarget { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual FileEntry? BannerFile { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual HomeBanner HomeBanner { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

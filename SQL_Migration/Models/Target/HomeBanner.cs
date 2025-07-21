using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class HomeBanner
{
    public int HomeBannerId { get; set; }

    public bool IsActive { get; set; }

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

    public virtual ICollection<HomeBannerContent> HomeBannerContents { get; set; } = new List<HomeBannerContent>();

    public virtual Account? UpdatedUser { get; set; }
}

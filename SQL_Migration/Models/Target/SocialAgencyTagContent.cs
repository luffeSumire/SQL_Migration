using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SocialAgencyTagContent
{
    public int SocialAgencyTagContentId { get; set; }

    public int SocialAgencyTagId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Label { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual SocialAgencyTag SocialAgencyTag { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

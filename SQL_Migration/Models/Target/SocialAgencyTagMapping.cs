using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SocialAgencyTagMapping
{
    public int SocialAgencyTagMappingId { get; set; }

    public int SocialAgencyId { get; set; }

    public int SocialAgencyTagId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual SocialAgency SocialAgency { get; set; } = null!;

    public virtual SocialAgencyTag SocialAgencyTag { get; set; } = null!;
}

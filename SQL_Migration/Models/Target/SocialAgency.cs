using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SocialAgency
{
    public int SocialAgencyId { get; set; }

    public bool IsActive { get; set; }

    public int SortOrder { get; set; }

    public byte Status { get; set; }

    public string? ContactPerson { get; set; }

    public string? ContactPhone { get; set; }

    public string? ContactEmail { get; set; }

    public string? ContactWebsite { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<SocialAgencyContent> SocialAgencyContents { get; set; } = new List<SocialAgencyContent>();

    public virtual ICollection<SocialAgencyTagMapping> SocialAgencyTagMappings { get; set; } = new List<SocialAgencyTagMapping>();

    public virtual Account? UpdatedUser { get; set; }
}

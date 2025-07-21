using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SocialAgencyTag
{
    public int SocialAgencyTagId { get; set; }

    public string TagCode { get; set; } = null!;

    public bool IsActive { get; set; }

    public int SortOrder { get; set; }

    public byte Status { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<SocialAgencyTagContent> SocialAgencyTagContents { get; set; } = new List<SocialAgencyTagContent>();

    public virtual ICollection<SocialAgencyTagMapping> SocialAgencyTagMappings { get; set; } = new List<SocialAgencyTagMapping>();

    public virtual Account? UpdatedUser { get; set; }
}

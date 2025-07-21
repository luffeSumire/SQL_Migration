using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class FriendlyLinkTag
{
    public int FriendlyLinkTagId { get; set; }

    public string TagCode { get; set; } = null!;

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

    public virtual ICollection<FriendlyLinkTagTranslation> FriendlyLinkTagTranslations { get; set; } = new List<FriendlyLinkTagTranslation>();

    public virtual ICollection<FriendlyLink> FriendlyLinks { get; set; } = new List<FriendlyLink>();

    public virtual Account? UpdatedUser { get; set; }
}

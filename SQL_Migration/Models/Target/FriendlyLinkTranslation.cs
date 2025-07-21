using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class FriendlyLinkTranslation
{
    public int FriendlyLinkTranslationId { get; set; }

    public int FriendlyLinkId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public bool IsDefault { get; set; }

    public string Title { get; set; } = null!;

    public string Url { get; set; } = null!;

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual FriendlyLink FriendlyLink { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

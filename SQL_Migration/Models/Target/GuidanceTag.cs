using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class GuidanceTag
{
    public int GuidanceTagId { get; set; }

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

    public virtual ICollection<Account> Accounts { get; set; } = new List<Account>();

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<GuidanceTagContent> GuidanceTagContents { get; set; } = new List<GuidanceTagContent>();

    public virtual Account? UpdatedUser { get; set; }
}

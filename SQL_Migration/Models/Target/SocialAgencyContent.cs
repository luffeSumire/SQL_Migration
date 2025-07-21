using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SocialAgencyContent
{
    public int SocialAgencyContentId { get; set; }

    public int SocialAgencyId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string? Introduction { get; set; }

    public string? Assistance { get; set; }

    public Guid? ImageFileId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual FileEntry? ImageFile { get; set; }

    public virtual SocialAgency SocialAgency { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}

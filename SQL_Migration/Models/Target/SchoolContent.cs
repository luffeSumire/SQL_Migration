using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class SchoolContent
{
    public int SchoolContentId { get; set; }

    public int SchoolId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Address { get; set; }

    public string? DepartmentName { get; set; }

    public string? JobTitle { get; set; }

    public string? Introduction { get; set; }

    public string? WebsiteUrl { get; set; }

    public Guid? LogoFileId { get; set; }

    public Guid? BannerFileId { get; set; }

    public Guid? PhotoFileId { get; set; }

    public Guid? CertificateFileId { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual FileEntry? BannerFile { get; set; }

    public virtual FileEntry? CertificateFile { get; set; }

    public virtual FileEntry? LogoFile { get; set; }

    public virtual FileEntry? PhotoFile { get; set; }

    public virtual School School { get; set; } = null!;
}

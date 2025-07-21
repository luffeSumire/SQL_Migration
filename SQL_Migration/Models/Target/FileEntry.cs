using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class FileEntry
{
    public Guid Id { get; set; }

    public string Type { get; set; } = null!;

    public string Path { get; set; } = null!;

    public string OriginalFileName { get; set; } = null!;

    public string OriginalExtension { get; set; } = null!;

    public string FileName { get; set; } = null!;

    public string Extension { get; set; } = null!;

    public virtual ICollection<ArticleAttachment> ArticleAttachments { get; set; } = new List<ArticleAttachment>();

    public virtual ICollection<ArticleContent> ArticleContents { get; set; } = new List<ArticleContent>();

    public virtual ICollection<CampusSubmissionAttachment> CampusSubmissionAttachments { get; set; } = new List<CampusSubmissionAttachment>();

    public virtual ICollection<Certification> Certifications { get; set; } = new List<Certification>();

    public virtual ICollection<DownloadAttachment> DownloadAttachments { get; set; } = new List<DownloadAttachment>();

    public virtual ICollection<DownloadContent> DownloadContents { get; set; } = new List<DownloadContent>();

    public virtual ICollection<GreenFlagArticleAttachment> GreenFlagArticleAttachments { get; set; } = new List<GreenFlagArticleAttachment>();

    public virtual ICollection<GreenFlagArticleContent> GreenFlagArticleContents { get; set; } = new List<GreenFlagArticleContent>();

    public virtual ICollection<HomeBannerContent> HomeBannerContents { get; set; } = new List<HomeBannerContent>();

    public virtual ICollection<SchoolContent> SchoolContentBannerFiles { get; set; } = new List<SchoolContent>();

    public virtual ICollection<SchoolContent> SchoolContentCertificateFiles { get; set; } = new List<SchoolContent>();

    public virtual ICollection<SchoolContent> SchoolContentLogoFiles { get; set; } = new List<SchoolContent>();

    public virtual ICollection<SchoolContent> SchoolContentPhotoFiles { get; set; } = new List<SchoolContent>();

    public virtual ICollection<SocialAgencyContent> SocialAgencyContents { get; set; } = new List<SocialAgencyContent>();

    public virtual ICollection<VideoTranslation> VideoTranslations { get; set; } = new List<VideoTranslation>();
}

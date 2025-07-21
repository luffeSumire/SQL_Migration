using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using SQL_Migration.Models.Target;

namespace SQL_Migration.Data;

public partial class TargetDbContext : DbContext
{
    public TargetDbContext()
    {
    }

    public TargetDbContext(DbContextOptions<TargetDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<AccountPermissionGroup> AccountPermissionGroups { get; set; }

    public virtual DbSet<AdminActionLog> AdminActionLogs { get; set; }

    public virtual DbSet<Article> Articles { get; set; }

    public virtual DbSet<ArticleAttachment> ArticleAttachments { get; set; }

    public virtual DbSet<ArticleContent> ArticleContents { get; set; }

    public virtual DbSet<ArticleTag> ArticleTags { get; set; }

    public virtual DbSet<ArticleTagTranslation> ArticleTagTranslations { get; set; }

    public virtual DbSet<BadgeType> BadgeTypes { get; set; }

    public virtual DbSet<CampusSubmission> CampusSubmissions { get; set; }

    public virtual DbSet<CampusSubmissionAttachment> CampusSubmissionAttachments { get; set; }

    public virtual DbSet<CampusSubmissionContent> CampusSubmissionContents { get; set; }

    public virtual DbSet<CampusSubmissionReview> CampusSubmissionReviews { get; set; }

    public virtual DbSet<Certification> Certifications { get; set; }

    public virtual DbSet<CertificationAnswer> CertificationAnswers { get; set; }

    public virtual DbSet<CertificationDeleted> CertificationDeleteds { get; set; }

    public virtual DbSet<CertificationStepRecord> CertificationStepRecords { get; set; }

    public virtual DbSet<CertificationType> CertificationTypes { get; set; }

    public virtual DbSet<CertificationTypeTranslation> CertificationTypeTranslations { get; set; }

    public virtual DbSet<County> Counties { get; set; }

    public virtual DbSet<CountyTranslation> CountyTranslations { get; set; }

    public virtual DbSet<District> Districts { get; set; }

    public virtual DbSet<DistrictTranslation> DistrictTranslations { get; set; }

    public virtual DbSet<Download> Downloads { get; set; }

    public virtual DbSet<DownloadAttachment> DownloadAttachments { get; set; }

    public virtual DbSet<DownloadContent> DownloadContents { get; set; }

    public virtual DbSet<DownloadTag> DownloadTags { get; set; }

    public virtual DbSet<DownloadTagTranslation> DownloadTagTranslations { get; set; }

    public virtual DbSet<EnvironmentalPath> EnvironmentalPaths { get; set; }

    public virtual DbSet<EnvironmentalPathTranslation> EnvironmentalPathTranslations { get; set; }

    public virtual DbSet<ExceptionLog> ExceptionLogs { get; set; }

    public virtual DbSet<Faq> Faqs { get; set; }

    public virtual DbSet<FaqContent> FaqContents { get; set; }

    public virtual DbSet<FaqTag> FaqTags { get; set; }

    public virtual DbSet<FaqTagContent> FaqTagContents { get; set; }

    public virtual DbSet<FileEntry> FileEntries { get; set; }

    public virtual DbSet<FriendlyLink> FriendlyLinks { get; set; }

    public virtual DbSet<FriendlyLinkTag> FriendlyLinkTags { get; set; }

    public virtual DbSet<FriendlyLinkTagTranslation> FriendlyLinkTagTranslations { get; set; }

    public virtual DbSet<FriendlyLinkTranslation> FriendlyLinkTranslations { get; set; }

    public virtual DbSet<GovernmentUnit> GovernmentUnits { get; set; }

    public virtual DbSet<GovernmentUnitTranslation> GovernmentUnitTranslations { get; set; }

    public virtual DbSet<GreenFlagArticle> GreenFlagArticles { get; set; }

    public virtual DbSet<GreenFlagArticleAttachment> GreenFlagArticleAttachments { get; set; }

    public virtual DbSet<GreenFlagArticleContent> GreenFlagArticleContents { get; set; }

    public virtual DbSet<GuidanceTag> GuidanceTags { get; set; }

    public virtual DbSet<GuidanceTagContent> GuidanceTagContents { get; set; }

    public virtual DbSet<HomeBanner> HomeBanners { get; set; }

    public virtual DbSet<HomeBannerContent> HomeBannerContents { get; set; }

    public virtual DbSet<MemberProfile> MemberProfiles { get; set; }

    public virtual DbSet<MenuItem> MenuItems { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<PermissionGroup> PermissionGroups { get; set; }

    public virtual DbSet<PermissionGroupMap> PermissionGroupMaps { get; set; }

    public virtual DbSet<Question> Questions { get; set; }

    public virtual DbSet<RequestLog> RequestLogs { get; set; }

    public virtual DbSet<School> Schools { get; set; }

    public virtual DbSet<SchoolContact> SchoolContacts { get; set; }

    public virtual DbSet<SchoolContent> SchoolContents { get; set; }

    public virtual DbSet<SchoolEnvironmentalPathStatus> SchoolEnvironmentalPathStatuses { get; set; }

    public virtual DbSet<SchoolImport> SchoolImports { get; set; }

    public virtual DbSet<SchoolPrincipal> SchoolPrincipals { get; set; }

    public virtual DbSet<SchoolStatistic> SchoolStatistics { get; set; }

    public virtual DbSet<SchoolType> SchoolTypes { get; set; }

    public virtual DbSet<SchoolTypeTranslation> SchoolTypeTranslations { get; set; }

    public virtual DbSet<SocialAgency> SocialAgencies { get; set; }

    public virtual DbSet<SocialAgencyContent> SocialAgencyContents { get; set; }

    public virtual DbSet<SocialAgencyTag> SocialAgencyTags { get; set; }

    public virtual DbSet<SocialAgencyTagContent> SocialAgencyTagContents { get; set; }

    public virtual DbSet<SocialAgencyTagMapping> SocialAgencyTagMappings { get; set; }

    public virtual DbSet<UserToken> UserTokens { get; set; }

    public virtual DbSet<Video> Videos { get; set; }

    public virtual DbSet<VideoTranslation> VideoTranslations { get; set; }

    public virtual DbSet<VisitLog> VisitLogs { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=VM-MSSQL-2022;Database=EcoCampus;User ID=ecocampus;Password=42949337;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.AccountId).HasName("PK__Account__DDDFDD364F08E187");

            entity.HasIndex(e => new { e.IsGuidanceTeam, e.GuidanceTagId }, "IX_Account_IsGuidanceTeam_GuidanceTag");

            entity.HasIndex(e => e.CountyId, "IX_Accounts_CountyId");

            entity.HasIndex(e => new { e.IsGuidanceTeam, e.GuidanceTagId }, "IX_Accounts_IsGuidanceTeam_GuidanceTag");

            entity.HasIndex(e => e.ReviewStatus, "IX_Accounts_ReviewStatus");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_Accounts_Status_DeletedTime_SortOrder");

            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.Birthday)
                .HasMaxLength(50)
                .HasColumnName("birthday");
            entity.Property(e => e.ContactName).HasMaxLength(50);
            entity.Property(e => e.ContactPhone).HasMaxLength(50);
            entity.Property(e => e.ContactRelationship).HasMaxLength(50);
            entity.Property(e => e.DepartureDate).HasMaxLength(50);
            entity.Property(e => e.DutyDate).HasMaxLength(50);
            entity.Property(e => e.Email).HasColumnName("email");
            entity.Property(e => e.Language).HasMaxLength(50);
            entity.Property(e => e.Password).HasColumnName("password");
            entity.Property(e => e.PasswordSalt).HasMaxLength(50);
            entity.Property(e => e.Phone)
                .HasMaxLength(50)
                .HasColumnName("phone");
            entity.Property(e => e.PostCode).HasMaxLength(50);
            entity.Property(e => e.ReviewStatus).HasComment("帳號審核狀態：0=尚未審核, 1=已通過, 2=未通過");
            entity.Property(e => e.SchoolId).HasComment("學校資料編號");
            entity.Property(e => e.Telephone).HasMaxLength(50);
            entity.Property(e => e.Username).HasMaxLength(50);

            entity.HasOne(d => d.County).WithMany(p => p.Accounts)
                .HasForeignKey(d => d.CountyId)
                .HasConstraintName("FK_Account_County");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.InverseCreatedUser)
                .HasForeignKey(d => d.CreatedUserId)
                .HasConstraintName("FK_Accounts_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.InverseDeletedUser)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Accounts_DeletedUser");

            entity.HasOne(d => d.GuidanceTag).WithMany(p => p.Accounts)
                .HasForeignKey(d => d.GuidanceTagId)
                .HasConstraintName("FK_Account_GuidanceTag");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.InverseUpdatedUser)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Accounts_UpdatedUser");
        });

        modelBuilder.Entity<AccountPermissionGroup>(entity =>
        {
            entity.HasKey(e => new { e.AccountSid, e.GroupSid });

            entity.ToTable("account_permission_group");

            entity.Property(e => e.AccountSid).HasColumnName("accountSid");
            entity.Property(e => e.GroupSid).HasColumnName("groupSid");
            entity.Property(e => e.CreateTime).HasColumnName("createTime");
            entity.Property(e => e.CreateUser).HasColumnName("createUser");
            entity.Property(e => e.DataStatus).HasColumnName("dataStatus");
            entity.Property(e => e.DeleteTime).HasColumnName("deleteTime");
            entity.Property(e => e.DeleteUser).HasColumnName("deleteUser");
            entity.Property(e => e.UpdateTime).HasColumnName("updateTime");
            entity.Property(e => e.UpdateUser).HasColumnName("updateUser");

            entity.HasOne(d => d.AccountS).WithMany(p => p.AccountPermissionGroups)
                .HasForeignKey(d => d.AccountSid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__account_p__accou__719CDDE7");

            entity.HasOne(d => d.GroupS).WithMany(p => p.AccountPermissionGroups)
                .HasForeignKey(d => d.GroupSid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__account_p__group__72910220");
        });

        modelBuilder.Entity<AdminActionLog>(entity =>
        {
            entity.HasKey(e => e.ActionLogId).HasName("PK__AdminAct__428D61827FE43B3F");

            entity.Property(e => e.Action).HasMaxLength(50);
            entity.Property(e => e.Notes).HasMaxLength(500);
        });

        modelBuilder.Entity<Article>(entity =>
        {
            entity.HasKey(e => e.ArticleId).HasName("PK__Articles__9C6270E8C5D99471");

            entity.HasIndex(e => new { e.PublishDate, e.Status }, "IX_Articles_PublishDate_Status").IsDescending(true, false);

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_Articles_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => new { e.TagCode, e.PublishDate }, "IX_Articles_TagCode_PublishDate").IsDescending(false, true);

            entity.Property(e => e.Author).HasMaxLength(100);
            entity.Property(e => e.TagCode)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.ArticleCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articles_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.ArticleDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Articles_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.ArticleUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Articles_UpdatedUser");
        });

        modelBuilder.Entity<ArticleAttachment>(entity =>
        {
            entity.HasKey(e => e.ArticleAttachmentId).HasName("PK__ArticleA__57803E5AB8C5B64C");

            entity.HasIndex(e => e.ContentTypeCode, "IX_ArticleAttachments_ContentType");

            entity.Property(e => e.AltText).HasMaxLength(200);
            entity.Property(e => e.Caption).HasMaxLength(500);
            entity.Property(e => e.ContentTypeCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.LinkName).HasMaxLength(200);
            entity.Property(e => e.LinkUrl).HasMaxLength(500);
            entity.Property(e => e.Title).HasMaxLength(200);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.ArticleAttachmentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticleAttachments_CreatedUser");

            entity.HasOne(d => d.FileEntry).WithMany(p => p.ArticleAttachments)
                .HasForeignKey(d => d.FileEntryId)
                .HasConstraintName("FK_ArticleAttachments_FileEntry");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.ArticleAttachmentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_ArticleAttachments_UpdatedUser");
        });

        modelBuilder.Entity<ArticleContent>(entity =>
        {
            entity.HasKey(e => e.ArticleContentId).HasName("PK__ArticleC__B8A38D3D2591AC2C");

            entity.HasIndex(e => e.LocaleCode, "IX_ArticleContents_LocaleCode");

            entity.HasIndex(e => new { e.ArticleId, e.LocaleCode }, "UQ_ArticleContents_Article_Locale").IsUnique();

            entity.Property(e => e.BannerAltText).HasMaxLength(200);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);

            entity.HasOne(d => d.Article).WithMany(p => p.ArticleContents)
                .HasForeignKey(d => d.ArticleId)
                .HasConstraintName("FK_ArticleContents_Articles");

            entity.HasOne(d => d.BannerFile).WithMany(p => p.ArticleContents)
                .HasForeignKey(d => d.BannerFileId)
                .HasConstraintName("FK_ArticleContents_BannerFile");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.ArticleContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticleContents_CreatedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.ArticleContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_ArticleContents_UpdatedUser");
        });

        modelBuilder.Entity<ArticleTag>(entity =>
        {
            entity.HasKey(e => e.ArticleTagId).HasName("PK__ArticleT__9E5858728C5709EC");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_ArticleTags_Status_DeletedTime_SortOrder");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.ArticleTagCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticleTags_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.ArticleTagDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_ArticleTags_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.ArticleTagUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_ArticleTags_UpdatedUser");
        });

        modelBuilder.Entity<ArticleTagTranslation>(entity =>
        {
            entity.HasIndex(e => e.LocaleCode, "IX_ArticleTagTranslations_LocaleCode");

            entity.HasIndex(e => new { e.ArticleTagId, e.LocaleCode }, "UQ_ArticleTagTranslations_Tag_Locale").IsUnique();

            entity.Property(e => e.Label).HasMaxLength(100);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);

            entity.HasOne(d => d.ArticleTag).WithMany(p => p.ArticleTagTranslations)
                .HasForeignKey(d => d.ArticleTagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticleTagTranslations_ArticleTag");
        });

        modelBuilder.Entity<BadgeType>(entity =>
        {
            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_BadgeTypes_IsActive_SortOrder");

            entity.HasIndex(e => e.BadgeCode, "UQ_BadgeTypes_BadgeCode").IsUnique();

            entity.Property(e => e.BadgeCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LabelEn).HasMaxLength(100);
            entity.Property(e => e.LabelZhTw).HasMaxLength(100);
        });

        modelBuilder.Entity<CampusSubmission>(entity =>
        {
            entity.HasKey(e => e.CampusSubmissionId).HasName("PK__CampusSu__D37C96C20BF76C7F");

            entity.HasIndex(e => new { e.BadgeType, e.FeaturedStatus }, "IX_CampusSubmissions_BadgeType_FeaturedStatus");

            entity.HasIndex(e => e.SchoolId, "IX_CampusSubmissions_SchoolId");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_CampusSubmissions_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.SubmissionDate, "IX_CampusSubmissions_SubmissionDate");

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.SubmissionDate).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CampusSubmissionCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CampusSubmissions_Accounts");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.CampusSubmissionDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_CampusSubmissions_Accounts1");

            entity.HasOne(d => d.School).WithMany(p => p.CampusSubmissions)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CampusSubmissions_Schools");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CampusSubmissionUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_CampusSubmissions_Accounts2");
        });

        modelBuilder.Entity<CampusSubmissionAttachment>(entity =>
        {
            entity.HasKey(e => e.CampusSubmissionAttachmentId).HasName("PK__CampusSu__1F093969D4232235");

            entity.HasIndex(e => e.ContentTypeCode, "IX_CampusSubmissionAttachments_ContentType");

            entity.Property(e => e.AltUrl).HasMaxLength(200);
            entity.Property(e => e.ContentTypeCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CampusSubmissionAttachmentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CampusSubmissionAttachments_CreatedUser");

            entity.HasOne(d => d.FileEntry).WithMany(p => p.CampusSubmissionAttachments)
                .HasForeignKey(d => d.FileEntryId)
                .HasConstraintName("FK_CampusSubmissionAttachments_FileEntry");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CampusSubmissionAttachmentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_CampusSubmissionAttachments_UpdatedUser");
        });

        modelBuilder.Entity<CampusSubmissionContent>(entity =>
        {
            entity.HasKey(e => e.CampusSubmissionContentId).HasName("PK__CampusSu__B0BC6D13DAA59E25");

            entity.HasIndex(e => new { e.CampusSubmissionId, e.LocaleCode }, "UQ_CampusSubmissionContents_Submission_Locale").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CampusSubmission).WithMany(p => p.CampusSubmissionContents)
                .HasForeignKey(d => d.CampusSubmissionId)
                .HasConstraintName("FK_CampusSubmissionContents_Submission");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CampusSubmissionContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CampusSubmissionContents_CreatedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CampusSubmissionContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_CampusSubmissionContents_UpdatedUser");
        });

        modelBuilder.Entity<CampusSubmissionReview>(entity =>
        {
            entity.ToTable(tb => tb.HasComment("校園投稿審核狀態表 - 記錄校園投稿的審核流程和狀態變更"));

            entity.HasIndex(e => e.CampusSubmissionId, "IX_CampusSubmissionReviews_CampusSubmissionId");

            entity.HasIndex(e => e.ReviewDate, "IX_CampusSubmissionReviews_ReviewDate");

            entity.HasIndex(e => e.ReviewStatus, "IX_CampusSubmissionReviews_ReviewStatus");

            entity.HasIndex(e => e.ReviewerId, "IX_CampusSubmissionReviews_ReviewerId");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_CampusSubmissionReviews_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => new { e.CampusSubmissionId, e.ReviewStatus }, "IX_CampusSubmissionReviews_SubmissionId_ReviewStatus");

            entity.Property(e => e.CampusSubmissionReviewId).HasComment("審核記錄主鍵");
            entity.Property(e => e.ApprovedDate)
                .HasPrecision(3)
                .HasComment("通過日期");
            entity.Property(e => e.CampusSubmissionId).HasComment("校園投稿ID (外鍵)");
            entity.Property(e => e.CreatedTime)
                .HasPrecision(3)
                .HasComment("建立時間");
            entity.Property(e => e.CreatedUserId).HasComment("建立者ID");
            entity.Property(e => e.DeletedTime)
                .HasPrecision(3)
                .HasComment("軟刪時間");
            entity.Property(e => e.DeletedUserId).HasComment("刪除者ID");
            entity.Property(e => e.ReviewComment)
                .HasMaxLength(500)
                .HasComment("審核意見");
            entity.Property(e => e.ReviewDate)
                .HasPrecision(3)
                .HasComment("送審日期");
            entity.Property(e => e.ReviewStatus).HasComment("審核狀態 (0=審核中, 1=審核通過, 2=審核不通過)");
            entity.Property(e => e.ReviewerId).HasComment("審核人員ID");
            entity.Property(e => e.SortOrder).HasComment("顯示排序 (值越小越前面)");
            entity.Property(e => e.Status).HasComment("狀態 (0=軟刪除, 1=啟用, 2=停用)");
            entity.Property(e => e.UpdatedTime)
                .HasPrecision(3)
                .HasComment("更新時間");
            entity.Property(e => e.UpdatedUserId).HasComment("更新者ID");

            entity.HasOne(d => d.CampusSubmission).WithMany(p => p.CampusSubmissionReviews)
                .HasForeignKey(d => d.CampusSubmissionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CampusSubmissionReviews_CampusSubmissions");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CampusSubmissionReviewCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CampusSubmissionReviews_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.CampusSubmissionReviewDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_CampusSubmissionReviews_DeletedUser");

            entity.HasOne(d => d.Reviewer).WithMany(p => p.CampusSubmissionReviewReviewers)
                .HasForeignKey(d => d.ReviewerId)
                .HasConstraintName("FK_CampusSubmissionReviews_Reviewer");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CampusSubmissionReviewUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_CampusSubmissionReviews_UpdatedUser");
        });

        modelBuilder.Entity<Certification>(entity =>
        {
            entity.ToTable(tb => tb.HasComment("User certification records with approval workflow"));

            entity.HasIndex(e => new { e.ReviewStatus, e.CreatedTime }, "IX_Certifications_ReviewStatus_CreatedTime");

            entity.HasIndex(e => new { e.SchoolId, e.Status }, "IX_Certifications_SchoolId_Status");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_Certifications_Status_DeletedTime_SortOrder");

            entity.Property(e => e.AddType)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ApprovedDate).HasPrecision(3);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.RejectedDate).HasPrecision(3);
            entity.Property(e => e.ReviewDate).HasPrecision(3);
            entity.Property(e => e.SupplementationDate).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CertificationCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Certifications_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.CertificationDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Certifications_DeletedUser");

            entity.HasOne(d => d.PdfFile).WithMany(p => p.Certifications)
                .HasForeignKey(d => d.PdfFileId)
                .HasConstraintName("FK_Certifications_PdfFile");

            entity.HasOne(d => d.School).WithMany(p => p.Certifications)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Certifications_Schools");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CertificationUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Certifications_UpdatedUser");
        });

        modelBuilder.Entity<CertificationAnswer>(entity =>
        {
            entity.ToTable(tb => tb.HasComment("Unified table for certification question answers with workflow tracking (consolidates answers and records, action logs moved to request_log)"));

            entity.HasIndex(e => new { e.AnswerStatus, e.SubmittedDate }, "IX_CertificationAnswers_AnswerStatus_SubmittedDate");

            entity.HasIndex(e => new { e.CertificationId, e.SortOrder }, "IX_CertificationAnswers_CertificationId_SortOrder");

            entity.HasIndex(e => new { e.QuestionId, e.AnswerStatus }, "IX_CertificationAnswers_QuestionId_AnswerStatus");

            entity.HasIndex(e => new { e.CertificationId, e.QuestionId }, "UQ_CertificationAnswers_Certification_Question").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.ReviewedDate).HasPrecision(3);
            entity.Property(e => e.SubmittedDate).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.Certification).WithMany(p => p.CertificationAnswers)
                .HasForeignKey(d => d.CertificationId)
                .HasConstraintName("FK_CertificationAnswers_Certifications");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CertificationAnswerCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CertificationAnswers_CreatedUser");

            entity.HasOne(d => d.Question).WithMany(p => p.CertificationAnswers)
                .HasForeignKey(d => d.QuestionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CertificationAnswers_Question");

            entity.HasOne(d => d.ReviewedUser).WithMany(p => p.CertificationAnswerReviewedUsers)
                .HasForeignKey(d => d.ReviewedUserId)
                .HasConstraintName("FK_CertificationAnswers_ReviewedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CertificationAnswerUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_CertificationAnswers_UpdatedUser");
        });

        modelBuilder.Entity<CertificationDeleted>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Certific__3214EC07ABD41A91");

            entity.ToTable("_Certification-DELETED");

            entity.Property(e => e.CertificateNumber).HasMaxLength(100);
            entity.Property(e => e.CertificationType).HasMaxLength(50);
            entity.Property(e => e.Remark).HasMaxLength(500);
            entity.Property(e => e.Status).HasMaxLength(50);
        });

        modelBuilder.Entity<CertificationStepRecord>(entity =>
        {
            entity.ToTable(tb => tb.HasComment("Step-by-step records of certification review process"));

            entity.HasIndex(e => new { e.CertificationId, e.StepNumber }, "IX_CertificationStepRecords_CertificationId_StepNumber");

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.Certification).WithMany(p => p.CertificationStepRecords)
                .HasForeignKey(d => d.CertificationId)
                .HasConstraintName("FK_CertificationStepRecords_Certifications");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.CertificationStepRecordCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CertificationStepRecords_CreatedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.CertificationStepRecordUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_CertificationStepRecords_UpdatedUser");
        });

        modelBuilder.Entity<CertificationType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Certific__3214EC07E4F49474");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_CertificationTypes_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_CertificationTypes_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.CertificationCode, "UQ_CertificationTypes_CertificationCode").IsUnique();

            entity.Property(e => e.CertificationCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Level)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<CertificationTypeTranslation>(entity =>
        {
            entity.HasKey(e => e.CertificationTypeTranslationId).HasName("PK__Certific__692C8E3DAC7B0DB7");

            entity.HasIndex(e => e.LocaleCode, "IX_CertificationTypeTranslations_LocaleCode");

            entity.HasIndex(e => new { e.CertificationTypeId, e.LocaleCode }, "UQ_CertificationTypeTranslations_CertificationType_Locale").IsUnique();

            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(100);

            entity.HasOne(d => d.CertificationType).WithMany(p => p.CertificationTypeTranslations)
                .HasForeignKey(d => d.CertificationTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CertificationTypeTranslations_CertificationTypes");
        });

        modelBuilder.Entity<County>(entity =>
        {
            entity.HasKey(e => e.CountyId).HasName("PK__Counties__B68F9D971F62050D");

            entity.HasIndex(e => e.CountyCode, "UQ__Counties__34DC46AD5EBEEEEE").IsUnique();

            entity.Property(e => e.CountyCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
        });

        modelBuilder.Entity<CountyTranslation>(entity =>
        {
            entity.HasKey(e => e.CountyTranslationId).HasName("PK__CountyTr__47144BFC3E361AB7");

            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(50);

            entity.HasOne(d => d.County).WithMany(p => p.CountyTranslations)
                .HasForeignKey(d => d.CountyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CountyTranslations_Counties");
        });

        modelBuilder.Entity<District>(entity =>
        {
            entity.HasKey(e => e.DistrictId).HasName("PK__District__85FDA4C6EAC39E78");

            entity.Property(e => e.DistrictId).ValueGeneratedNever();
            entity.Property(e => e.CreatedTime).HasPrecision(3);

            entity.HasOne(d => d.County).WithMany(p => p.Districts)
                .HasForeignKey(d => d.CountyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Districts_Counties");
        });

        modelBuilder.Entity<DistrictTranslation>(entity =>
        {
            entity.HasKey(e => e.DistrictTranslationId).HasName("PK__District__76E70CA7AECAADA9");

            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(50);

            entity.HasOne(d => d.District).WithMany(p => p.DistrictTranslations)
                .HasForeignKey(d => d.DistrictId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DistrictTranslations_Districts");
        });

        modelBuilder.Entity<Download>(entity =>
        {
            entity.HasIndex(e => new { e.PublishDate, e.Status }, "IX_Downloads_PublishDate_Status").IsDescending(true, false);

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_Downloads_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.TagCode, "IX_Downloads_TagCode");

            entity.Property(e => e.ExternalLink).HasMaxLength(500);
            entity.Property(e => e.TagCode)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.DownloadCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Downloads_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.DownloadDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Downloads_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.DownloadUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Downloads_UpdatedUser");
        });

        modelBuilder.Entity<DownloadAttachment>(entity =>
        {
            entity.HasIndex(e => e.ContentTypeCode, "IX_DownloadAttachments_ContentTypeCode");

            entity.HasIndex(e => new { e.DownloadContentId, e.SortOrder }, "IX_DownloadAttachments_DownloadContentId_SortOrder");

            entity.HasIndex(e => e.FileEntryId, "IX_DownloadAttachments_FileEntryId");

            entity.Property(e => e.ContentTypeCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.LinkName).HasMaxLength(100);
            entity.Property(e => e.LinkUrl).HasMaxLength(500);
            entity.Property(e => e.Title).HasMaxLength(200);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.DownloadAttachmentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DownloadAttachments_CreatedUser");

            entity.HasOne(d => d.DownloadContent).WithMany(p => p.DownloadAttachments)
                .HasForeignKey(d => d.DownloadContentId)
                .HasConstraintName("FK_DownloadAttachments_DownloadContent");

            entity.HasOne(d => d.FileEntry).WithMany(p => p.DownloadAttachments)
                .HasForeignKey(d => d.FileEntryId)
                .HasConstraintName("FK_DownloadAttachments_FileEntry");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.DownloadAttachmentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_DownloadAttachments_UpdatedUser");
        });

        modelBuilder.Entity<DownloadContent>(entity =>
        {
            entity.HasIndex(e => new { e.DownloadId, e.LocaleCode }, "IX_DownloadContents_DownloadId_LocaleCode").IsUnique();

            entity.HasIndex(e => e.LocaleCode, "IX_DownloadContents_LocaleCode");

            entity.Property(e => e.Description).HasMaxLength(1000);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);

            entity.HasOne(d => d.BannerFile).WithMany(p => p.DownloadContents)
                .HasForeignKey(d => d.BannerFileId)
                .HasConstraintName("FK_DownloadContents_BannerFile");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.DownloadContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DownloadContents_CreatedUser");

            entity.HasOne(d => d.Download).WithMany(p => p.DownloadContents)
                .HasForeignKey(d => d.DownloadId)
                .HasConstraintName("FK_DownloadContents_Download");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.DownloadContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_DownloadContents_UpdatedUser");
        });

        modelBuilder.Entity<DownloadTag>(entity =>
        {
            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_DownloadTags_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.TagCode, "IX_DownloadTags_TagCode").IsUnique();

            entity.Property(e => e.TagCode)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.DownloadTagCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DownloadTags_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.DownloadTagDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_DownloadTags_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.DownloadTagUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_DownloadTags_UpdatedUser");
        });

        modelBuilder.Entity<DownloadTagTranslation>(entity =>
        {
            entity.HasIndex(e => new { e.DownloadTagId, e.LocaleCode }, "IX_DownloadTagTranslations_DownloadTagId_LocaleCode").IsUnique();

            entity.HasIndex(e => e.LocaleCode, "IX_DownloadTagTranslations_LocaleCode");

            entity.Property(e => e.Label).HasMaxLength(100);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.DownloadTagTranslationCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DownloadTagTranslations_CreatedUser");

            entity.HasOne(d => d.DownloadTag).WithMany(p => p.DownloadTagTranslations)
                .HasForeignKey(d => d.DownloadTagId)
                .HasConstraintName("FK_DownloadTagTranslations_DownloadTag");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.DownloadTagTranslationUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_DownloadTagTranslations_UpdatedUser");
        });

        modelBuilder.Entity<EnvironmentalPath>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Environm__3214EC0730A99C4A");

            entity.HasIndex(e => e.CategoryCode, "IX_EnvironmentalPaths_CategoryCode");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_EnvironmentalPaths_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_EnvironmentalPaths_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.PathCode, "UQ_EnvironmentalPaths_PathCode").IsUnique();

            entity.Property(e => e.CategoryCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.PathCode)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<EnvironmentalPathTranslation>(entity =>
        {
            entity.HasKey(e => e.EnvironmentalPathTranslationId).HasName("PK__Environm__239DBC31AE424BB8");

            entity.HasIndex(e => e.LocaleCode, "IX_EnvironmentalPathTranslations_LocaleCode");

            entity.HasIndex(e => new { e.EnvironmentalPathId, e.LocaleCode }, "UQ_EnvironmentalPathTranslations_Path_Locale").IsUnique();

            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(100);

            entity.HasOne(d => d.EnvironmentalPath).WithMany(p => p.EnvironmentalPathTranslations)
                .HasForeignKey(d => d.EnvironmentalPathId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EnvironmentalPathTranslations_EnvironmentalPaths");
        });

        modelBuilder.Entity<ExceptionLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__Exceptio__9E2397E094443144");

            entity.ToTable("ExceptionLog");

            entity.HasIndex(e => e.ExceptionTime, "IX_ExceptionLog_exception_time").IsDescending();

            entity.HasIndex(e => e.ExceptionType, "IX_ExceptionLog_exception_type");

            entity.Property(e => e.LogId).HasColumnName("log_id");
            entity.Property(e => e.AdditionalData).HasColumnName("additional_data");
            entity.Property(e => e.ClientIp)
                .HasMaxLength(50)
                .HasColumnName("client_ip");
            entity.Property(e => e.ExceptionMessage).HasColumnName("exception_message");
            entity.Property(e => e.ExceptionStack).HasColumnName("exception_stack");
            entity.Property(e => e.ExceptionTime).HasColumnName("exception_time");
            entity.Property(e => e.ExceptionType)
                .HasMaxLength(255)
                .HasColumnName("exception_type");
            entity.Property(e => e.RequestUrl)
                .HasMaxLength(500)
                .HasColumnName("request_url");
            entity.Property(e => e.ServerName)
                .HasMaxLength(100)
                .HasColumnName("server_name");
            entity.Property(e => e.SourceContext)
                .HasMaxLength(255)
                .HasColumnName("source_context");
            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.UserName)
                .HasMaxLength(100)
                .HasColumnName("user_name");
        });

        modelBuilder.Entity<Faq>(entity =>
        {
            entity.HasKey(e => e.FaqId).HasName("PK__Faqs__9C741C43B567B62E");

            entity.HasIndex(e => new { e.Status, e.TagId, e.SortOrder }, "IX_Faqs_Status_TagId_SortOrder");

            entity.Property(e => e.Author).HasMaxLength(100);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FaqCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Faqs_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.FaqDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Faqs_DeletedUser");

            entity.HasOne(d => d.Tag).WithMany(p => p.Faqs)
                .HasForeignKey(d => d.TagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Faqs_Tags");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FaqUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Faqs_UpdatedUser");
        });

        modelBuilder.Entity<FaqContent>(entity =>
        {
            entity.HasKey(e => e.FaqContentId).HasName("PK__FaqConte__524A5991C223537A");

            entity.HasIndex(e => e.LocaleCode, "IX_FaqContents_LocaleCode");

            entity.HasIndex(e => new { e.FaqId, e.LocaleCode }, "UQ_FaqContents_Faq_Locale").IsUnique();

            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Question).HasMaxLength(500);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FaqContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FaqContents_CreatedUser");

            entity.HasOne(d => d.Faq).WithMany(p => p.FaqContents)
                .HasForeignKey(d => d.FaqId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FaqContents_Faqs");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FaqContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_FaqContents_UpdatedUser");
        });

        modelBuilder.Entity<FaqTag>(entity =>
        {
            entity.HasKey(e => e.FaqTagId).HasName("PK__Tags__657CF9AC26578A4D");

            entity.HasIndex(e => e.SortOrder, "IX_Tags_SortOrder");

            entity.HasIndex(e => e.Status, "IX_Tags_Status");

            entity.HasIndex(e => e.FaqTagCode, "IX_Tags_TagCode").IsUnique();

            entity.HasIndex(e => e.FaqTagCode, "UQ__Tags__3BE4AAACEF3D26F2").IsUnique();

            entity.Property(e => e.FaqTagCode)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FaqTagCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Tags_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.FaqTagDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Tags_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FaqTagUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Tags_UpdatedUser");
        });

        modelBuilder.Entity<FaqTagContent>(entity =>
        {
            entity.HasKey(e => e.FaqTagContentId).HasName("PK__TagConte__C3B13B1A3E5DD6AC");

            entity.HasIndex(e => e.LocaleCode, "IX_TagContents_LocaleCode");

            entity.HasIndex(e => new { e.FaqTagId, e.LocaleCode }, "UQ_TagContents_Tag_Locale").IsUnique();

            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.FaqTagName).HasMaxLength(100);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FaqTagContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TagContents_CreatedUser");

            entity.HasOne(d => d.FaqTag).WithMany(p => p.FaqTagContents)
                .HasForeignKey(d => d.FaqTagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TagContents_Tags");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FaqTagContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_TagContents_UpdatedUser");
        });

        modelBuilder.Entity<FileEntry>(entity =>
        {
            entity.ToTable("FileEntry");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.Extension).HasMaxLength(10);
            entity.Property(e => e.FileName).HasMaxLength(255);
            entity.Property(e => e.OriginalExtension).HasMaxLength(10);
            entity.Property(e => e.OriginalFileName).HasMaxLength(255);
            entity.Property(e => e.Path).HasMaxLength(260);
            entity.Property(e => e.Type).HasMaxLength(50);
        });

        modelBuilder.Entity<FriendlyLink>(entity =>
        {
            entity.HasKey(e => e.FriendlyLinkId).HasName("PK__Friendly__077687E59AECA1A2");

            entity.HasIndex(e => new { e.FriendlyLinkTagId, e.IsActive, e.SortOrder }, "IX_FriendlyLinks_FriendlyLinkTagId_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_FriendlyLinks_Status_DeletedTime_SortOrder");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FriendlyLinkCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FriendlyLinks_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.FriendlyLinkDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_FriendlyLinks_DeletedUser");

            entity.HasOne(d => d.FriendlyLinkTag).WithMany(p => p.FriendlyLinks)
                .HasForeignKey(d => d.FriendlyLinkTagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FriendlyLinks_FriendlyLinkTag");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FriendlyLinkUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_FriendlyLinks_UpdatedUser");
        });

        modelBuilder.Entity<FriendlyLinkTag>(entity =>
        {
            entity.HasKey(e => e.FriendlyLinkTagId).HasName("PK__Friendly__F56EF674726B57FB");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_FriendlyLinkTags_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => new { e.TagCode, e.IsActive }, "IX_FriendlyLinkTags_TagCode_IsActive");

            entity.HasIndex(e => e.TagCode, "UQ__Friendly__3BE4AAACDD76CA8E").IsUnique();

            entity.Property(e => e.TagCode)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FriendlyLinkTagCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FriendlyLinkTags_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.FriendlyLinkTagDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_FriendlyLinkTags_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FriendlyLinkTagUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_FriendlyLinkTags_UpdatedUser");
        });

        modelBuilder.Entity<FriendlyLinkTagTranslation>(entity =>
        {
            entity.HasKey(e => e.FriendlyLinkTagTranslationId).HasName("PK__Friendly__6B2C0591E383F072");

            entity.HasIndex(e => e.LocaleCode, "IX_FriendlyLinkTagTranslations_LocaleCode");

            entity.HasIndex(e => new { e.FriendlyLinkTagId, e.LocaleCode }, "UQ_FriendlyLinkTagTranslations_Tag_Locale").IsUnique();

            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(100);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FriendlyLinkTagTranslationCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FriendlyLinkTagTranslations_CreatedUser");

            entity.HasOne(d => d.FriendlyLinkTag).WithMany(p => p.FriendlyLinkTagTranslations)
                .HasForeignKey(d => d.FriendlyLinkTagId)
                .HasConstraintName("FK_FriendlyLinkTagTranslations_FriendlyLinkTag");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FriendlyLinkTagTranslationUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_FriendlyLinkTagTranslations_UpdatedUser");
        });

        modelBuilder.Entity<FriendlyLinkTranslation>(entity =>
        {
            entity.HasKey(e => e.FriendlyLinkTranslationId).HasName("PK__Friendly__55A331937C26E31E");

            entity.HasIndex(e => e.LocaleCode, "IX_FriendlyLinkTranslations_LocaleCode");

            entity.HasIndex(e => new { e.FriendlyLinkId, e.LocaleCode }, "UQ_FriendlyLinkTranslations_Link_Locale").IsUnique();

            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.Url).HasMaxLength(500);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.FriendlyLinkTranslationCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FriendlyLinkTranslations_CreatedUser");

            entity.HasOne(d => d.FriendlyLink).WithMany(p => p.FriendlyLinkTranslations)
                .HasForeignKey(d => d.FriendlyLinkId)
                .HasConstraintName("FK_FriendlyLinkTranslations_FriendlyLink");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.FriendlyLinkTranslationUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_FriendlyLinkTranslations_UpdatedUser");
        });

        modelBuilder.Entity<GovernmentUnit>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Governme__3214EC074AAB67D9");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_GovernmentUnits_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.UnitCode, "UQ_GovernmentUnits_UnitCode").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.UnitCode).HasMaxLength(20);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.GovernmentUnitCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GovernmentUnits_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.GovernmentUnitDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_GovernmentUnits_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.GovernmentUnitUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_GovernmentUnits_UpdatedUser");
        });

        modelBuilder.Entity<GovernmentUnitTranslation>(entity =>
        {
            entity.HasKey(e => e.GovernmentUnitTranslationId).HasName("PK__Governme__1C4BA9E3FFD686E7");

            entity.HasIndex(e => new { e.IsDefault, e.LocaleCode }, "IX_GovernmentUnitTranslations_IsDefault");

            entity.HasIndex(e => e.LocaleCode, "IX_GovernmentUnitTranslations_LocaleCode");

            entity.HasIndex(e => new { e.GovernmentUnitId, e.LocaleCode }, "UQ_GovernmentUnitTranslations_Unit_Locale").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.UnitName).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.GovernmentUnitTranslationCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GovernmentUnitTranslations_CreatedUser");

            entity.HasOne(d => d.GovernmentUnit).WithMany(p => p.GovernmentUnitTranslations)
                .HasForeignKey(d => d.GovernmentUnitId)
                .HasConstraintName("FK_GovernmentUnitTranslations_GovernmentUnit");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.GovernmentUnitTranslationUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_GovernmentUnitTranslations_UpdatedUser");
        });

        modelBuilder.Entity<GreenFlagArticle>(entity =>
        {
            entity.HasKey(e => e.GreenFlagArticleId).HasName("PK__GreenFla__7F21AA833E436A58");

            entity.HasIndex(e => e.PublishDate, "IX_GreenFlagArticles_PublishDate");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_GreenFlagArticles_Status_DeletedTime_SortOrder");

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.PublishDate).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);
        });

        modelBuilder.Entity<GreenFlagArticleAttachment>(entity =>
        {
            entity.HasKey(e => e.GreenFlagArticleAttachmentId).HasName("PK__GreenFla__4FDCB9A399265954");

            entity.HasIndex(e => new { e.GreenFlagArticleContentId, e.SortOrder }, "IX_GreenFlagArticleAttachments_ContentId_SortOrder");

            entity.HasIndex(e => e.ContentTypeCode, "IX_GreenFlagArticleAttachments_ContentType");

            entity.Property(e => e.AltText).HasMaxLength(200);
            entity.Property(e => e.AltUrl).HasMaxLength(200);
            entity.Property(e => e.Caption).HasMaxLength(500);
            entity.Property(e => e.ContentTypeCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.FileEntry).WithMany(p => p.GreenFlagArticleAttachments)
                .HasForeignKey(d => d.FileEntryId)
                .HasConstraintName("FK_GreenFlagArticleAttachments_FileEntry");

            entity.HasOne(d => d.GreenFlagArticleContent).WithMany(p => p.GreenFlagArticleAttachments)
                .HasForeignKey(d => d.GreenFlagArticleContentId)
                .HasConstraintName("FK_GreenFlagArticleAttachments_Contents");
        });

        modelBuilder.Entity<GreenFlagArticleContent>(entity =>
        {
            entity.HasKey(e => e.GreenFlagArticleContentId).HasName("PK__GreenFla__83736AD765DCC458");

            entity.HasIndex(e => e.LocaleCode, "IX_GreenFlagArticleContents_LocaleCode");

            entity.HasIndex(e => e.SchoolName, "IX_GreenFlagArticleContents_SchoolName");

            entity.HasIndex(e => new { e.GreenFlagArticleId, e.LocaleCode }, "UQ_GreenFlagArticleContents_Article_Locale").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.SchoolName).HasMaxLength(200);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.BannerFile).WithMany(p => p.GreenFlagArticleContents)
                .HasForeignKey(d => d.BannerFileId)
                .HasConstraintName("FK_GreenFlagArticleContents_BannerFile");

            entity.HasOne(d => d.GreenFlagArticle).WithMany(p => p.GreenFlagArticleContents)
                .HasForeignKey(d => d.GreenFlagArticleId)
                .HasConstraintName("FK_GreenFlagArticleContents_Articles");
        });

        modelBuilder.Entity<GuidanceTag>(entity =>
        {
            entity.HasKey(e => e.GuidanceTagId).HasName("PK__Guidance__6CA0C77A6F10F5C8");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_GuidanceTags_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_GuidanceTags_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.TagCode, "UQ_GuidanceTags_TagCode").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.TagCode).HasMaxLength(50);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.GuidanceTagCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GuidanceTags_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.GuidanceTagDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_GuidanceTags_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.GuidanceTagUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_GuidanceTags_UpdatedUser");
        });

        modelBuilder.Entity<GuidanceTagContent>(entity =>
        {
            entity.HasKey(e => e.GuidanceTagContentId).HasName("PK__Guidance__B55EEBCE77624DD9");

            entity.HasIndex(e => e.LocaleCode, "IX_GuidanceTagContents_LocaleCode");

            entity.HasIndex(e => new { e.GuidanceTagId, e.LocaleCode }, "UQ_GuidanceTagContents_Tag_Locale").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.Label).HasMaxLength(100);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.GuidanceTagContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GuidanceTagContents_CreatedUser");

            entity.HasOne(d => d.GuidanceTag).WithMany(p => p.GuidanceTagContents)
                .HasForeignKey(d => d.GuidanceTagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GuidanceTagContents_GuidanceTag");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.GuidanceTagContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_GuidanceTagContents_UpdatedUser");
        });

        modelBuilder.Entity<HomeBanner>(entity =>
        {
            entity.HasKey(e => e.HomeBannerId).HasName("PK__HomeBann__44B6BEC0307BF7B5");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_HomeBanners_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_HomeBanners_Status_DeletedTime_SortOrder");

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.HomeBannerCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HomeBanners_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.HomeBannerDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_HomeBanners_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.HomeBannerUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_HomeBanners_UpdatedUser");
        });

        modelBuilder.Entity<HomeBannerContent>(entity =>
        {
            entity.HasKey(e => e.HomeBannerContentId).HasName("PK__HomeBann__D043850B61159DC2");

            entity.HasIndex(e => new { e.HomeBannerId, e.LocaleCode }, "IX_HomeBannerContents_HomeBanner_Locale");

            entity.HasIndex(e => e.LocaleCode, "IX_HomeBannerContents_LocaleCode");

            entity.HasIndex(e => new { e.HomeBannerId, e.LocaleCode }, "UQ_HomeBannerContents_Banner_Locale").IsUnique();

            entity.Property(e => e.BannerAltText).HasMaxLength(200);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.LinkTarget)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.LinkUrl).HasMaxLength(500);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.BannerFile).WithMany(p => p.HomeBannerContents)
                .HasForeignKey(d => d.BannerFileId)
                .HasConstraintName("FK_HomeBannerContents_BannerFile");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.HomeBannerContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HomeBannerContents_CreatedUser");

            entity.HasOne(d => d.HomeBanner).WithMany(p => p.HomeBannerContents)
                .HasForeignKey(d => d.HomeBannerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HomeBannerContents_HomeBanners");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.HomeBannerContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_HomeBannerContents_UpdatedUser");
        });

        modelBuilder.Entity<MemberProfile>(entity =>
        {
            entity.HasKey(e => e.MemberProfileId).HasName("PK__MemberPr__AEBB701FD6DE48FF");

            entity.HasIndex(e => new { e.AccountId, e.LocaleCode }, "IX_MemberProfiles_AccountId_LocaleCode");

            entity.HasIndex(e => e.LocaleCode, "IX_MemberProfiles_LocaleCode");

            entity.HasIndex(e => new { e.AccountId, e.LocaleCode }, "UQ_MemberProfile_Account_Locale").IsUnique();

            entity.HasIndex(e => new { e.AccountId, e.LocaleCode }, "UQ_MemberProfiles_Account_Locale").IsUnique();

            entity.Property(e => e.AreaAttributes).HasMaxLength(50);
            entity.Property(e => e.Captcha).HasColumnName("captcha");
            entity.Property(e => e.Code)
                .HasMaxLength(50)
                .HasColumnName("code");
            entity.Property(e => e.CreateIp).HasMaxLength(50);
            entity.Property(e => e.CreateUserName).HasMaxLength(50);
            entity.Property(e => e.Isuse).HasColumnName("isuse");
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.MemberExchange).HasMaxLength(50);
            entity.Property(e => e.MemberPhone).HasMaxLength(50);
            entity.Property(e => e.MemberRole).HasMaxLength(50);
            entity.Property(e => e.MemberTelephone).HasMaxLength(50);
            entity.Property(e => e.RegisterReview).HasMaxLength(50);
            entity.Property(e => e.UpdateIp).HasMaxLength(50);
            entity.Property(e => e.UpdateUserName).HasMaxLength(50);

            entity.HasOne(d => d.Account).WithMany(p => p.MemberProfileAccounts)
                .HasForeignKey(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MemberProfiles_Account");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.MemberProfileCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .HasConstraintName("FK_MemberProfiles_CreatedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.MemberProfileUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_MemberProfiles_UpdatedUser");
        });

        modelBuilder.Entity<MenuItem>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__menuItem__3213E83F4C165B3A");

            entity.Property(e => e.Id)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("id");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
            entity.Property(e => e.Icon)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("icon");
            entity.Property(e => e.Link)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("link");
            entity.Property(e => e.ParentId)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("parent_id");
            entity.Property(e => e.SortOrder).HasColumnName("sort_order");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasColumnName("title");
            entity.Property(e => e.UpdatedAt).HasColumnName("updated_at");

            entity.HasOne(d => d.Parent).WithMany(p => p.InverseParent)
                .HasForeignKey(d => d.ParentId)
                .HasConstraintName("FK_menuItems_parent");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__permissi__DDDFDD36AD694A5B");

            entity.ToTable("permission");

            entity.HasIndex(e => new { e.Route, e.Action }, "UQ__permissi__2D9CBA41C2577217").IsUnique();

            entity.Property(e => e.Sid).HasColumnName("sid");
            entity.Property(e => e.Action)
                .HasMaxLength(1)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("action");
            entity.Property(e => e.CreateTime).HasColumnName("createTime");
            entity.Property(e => e.CreateUser).HasColumnName("createUser");
            entity.Property(e => e.DataStatus).HasColumnName("dataStatus");
            entity.Property(e => e.DeleteTime).HasColumnName("deleteTime");
            entity.Property(e => e.DeleteUser).HasColumnName("deleteUser");
            entity.Property(e => e.IsDefault).HasColumnName("isDefault");
            entity.Property(e => e.Route)
                .HasMaxLength(200)
                .IsUnicode(false)
                .HasColumnName("route");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.UpdateTime).HasColumnName("updateTime");
            entity.Property(e => e.UpdateUser).HasColumnName("updateUser");
        });

        modelBuilder.Entity<PermissionGroup>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__permissi__DDDFDD36F8B00A49");

            entity.ToTable("permission_group");

            entity.HasIndex(e => e.GroupCode, "UQ__permissi__1F51566AD195B33F").IsUnique();

            entity.Property(e => e.Sid).HasColumnName("sid");
            entity.Property(e => e.CreateTime).HasColumnName("createTime");
            entity.Property(e => e.CreateUser).HasColumnName("createUser");
            entity.Property(e => e.DataStatus).HasColumnName("dataStatus");
            entity.Property(e => e.DeleteTime).HasColumnName("deleteTime");
            entity.Property(e => e.DeleteUser).HasColumnName("deleteUser");
            entity.Property(e => e.GroupCode)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("groupCode");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.Remark)
                .HasMaxLength(255)
                .HasColumnName("remark");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.UpdateTime).HasColumnName("updateTime");
            entity.Property(e => e.UpdateUser).HasColumnName("updateUser");
        });

        modelBuilder.Entity<PermissionGroupMap>(entity =>
        {
            entity.HasKey(e => new { e.GroupSid, e.PermissionSid });

            entity.ToTable("permission_group_map");

            entity.Property(e => e.GroupSid).HasColumnName("groupSid");
            entity.Property(e => e.PermissionSid).HasColumnName("permissionSid");
            entity.Property(e => e.Allow).HasColumnName("allow");
            entity.Property(e => e.CreateTime).HasColumnName("createTime");
            entity.Property(e => e.CreateUser).HasColumnName("createUser");
            entity.Property(e => e.DataStatus).HasColumnName("dataStatus");
            entity.Property(e => e.DeleteTime).HasColumnName("deleteTime");
            entity.Property(e => e.DeleteUser).HasColumnName("deleteUser");
            entity.Property(e => e.UpdateTime).HasColumnName("updateTime");
            entity.Property(e => e.UpdateUser).HasColumnName("updateUser");

            entity.HasOne(d => d.GroupS).WithMany(p => p.PermissionGroupMaps)
                .HasForeignKey(d => d.GroupSid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__permissio__group__6AEFE058");

            entity.HasOne(d => d.PermissionS).WithMany(p => p.PermissionGroupMaps)
                .HasForeignKey(d => d.PermissionSid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__permissio__permi__6BE40491");
        });

        modelBuilder.Entity<Question>(entity =>
        {
            entity.HasKey(e => e.QuestionId).HasName("PK__Question__0DC06FAC32C63A7F");

            entity.HasIndex(e => new { e.ParentQuestionId, e.SortOrder }, "IX_Questions_ParentQuestionId_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_Questions_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => new { e.StepNumber, e.SortOrder }, "IX_Questions_StepNumber_SortOrder");

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.QuestionTemplate).HasComment("題型版型代號(對應頁面結構代號)");
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.QuestionCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Questions_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.QuestionDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Questions_DeletedUser");

            entity.HasOne(d => d.ParentQuestion).WithMany(p => p.InverseParentQuestion)
                .HasForeignKey(d => d.ParentQuestionId)
                .HasConstraintName("FK_Questions_ParentQuestion");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.QuestionUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Questions_UpdatedUser");
        });

        modelBuilder.Entity<RequestLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__RequestL__9E2397E06C01F251");

            entity.ToTable("RequestLog");

            entity.HasIndex(e => e.RequestTime, "IX_RequestLog_request_time").IsDescending();

            entity.HasIndex(e => e.RequestUrl, "IX_RequestLog_request_url");

            entity.HasIndex(e => e.StatusCode, "IX_RequestLog_status_code");

            entity.HasIndex(e => e.UserId, "IX_RequestLog_user_id");

            entity.Property(e => e.LogId).HasColumnName("log_id");
            entity.Property(e => e.ActionName)
                .HasMaxLength(100)
                .HasColumnName("action_name");
            entity.Property(e => e.ClientIp)
                .HasMaxLength(50)
                .HasColumnName("client_ip");
            entity.Property(e => e.ControllerName)
                .HasMaxLength(100)
                .HasColumnName("controller_name");
            entity.Property(e => e.DurationMs).HasColumnName("duration_ms");
            entity.Property(e => e.IsSuccessful).HasColumnName("is_successful");
            entity.Property(e => e.RequestMethod)
                .HasMaxLength(10)
                .HasColumnName("request_method");
            entity.Property(e => e.RequestPath)
                .HasMaxLength(255)
                .HasColumnName("request_path");
            entity.Property(e => e.RequestPayload).HasColumnName("request_payload");
            entity.Property(e => e.RequestTime).HasColumnName("request_time");
            entity.Property(e => e.RequestUrl)
                .HasMaxLength(500)
                .HasColumnName("request_url");
            entity.Property(e => e.ResponsePayload).HasColumnName("response_payload");
            entity.Property(e => e.ResponseTime).HasColumnName("response_time");
            entity.Property(e => e.StatusCode).HasColumnName("status_code");
            entity.Property(e => e.UserAgent)
                .HasMaxLength(500)
                .HasColumnName("user_agent");
            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.UserName)
                .HasMaxLength(100)
                .HasColumnName("user_name");
        });

        modelBuilder.Entity<School>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Schools__3214EC077E277FFE");

            entity.HasIndex(e => new { e.CountyId, e.DistrictId }, "IX_Schools_County_District");

            entity.HasIndex(e => e.SchoolTypeId, "IX_Schools_SchoolType");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_Schools_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.SchoolCode, "UQ_Schools_SchoolCode").IsUnique();

            entity.Property(e => e.CertifiedDate).HasPrecision(3);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.MobilePhone)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.SchoolCode)
                .HasMaxLength(12)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.County).WithMany(p => p.Schools)
                .HasForeignKey(d => d.CountyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Schools_Counties");

            entity.HasOne(d => d.District).WithMany(p => p.Schools)
                .HasForeignKey(d => d.DistrictId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Schools_Districts");

            entity.HasOne(d => d.SchoolType).WithMany(p => p.Schools)
                .HasForeignKey(d => d.SchoolTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Schools_SchoolTypes");
        });

        modelBuilder.Entity<SchoolContact>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SchoolCo__3214EC072966D5F5");

            entity.Property(e => e.ContactEmail)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.ContactMobile)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.ContactName).HasMaxLength(100);
            entity.Property(e => e.ContactPhone)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.JobTitle).HasMaxLength(100);

            entity.HasOne(d => d.School).WithMany(p => p.SchoolContacts)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SchoolCon__Schoo__218BE82B");
        });

        modelBuilder.Entity<SchoolContent>(entity =>
        {
            entity.HasKey(e => e.SchoolContentId).HasName("PK__SchoolCo__956F24BF9AEF0DA3");

            entity.HasIndex(e => e.LocaleCode, "IX_SchoolContents_LocaleCode");

            entity.HasIndex(e => new { e.SchoolId, e.LocaleCode }, "UQ_SchoolContents_School_Locale").IsUnique();

            entity.Property(e => e.Address).HasMaxLength(200);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DepartmentName).HasMaxLength(100);
            entity.Property(e => e.JobTitle).HasMaxLength(100);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);
            entity.Property(e => e.WebsiteUrl).HasMaxLength(500);

            entity.HasOne(d => d.BannerFile).WithMany(p => p.SchoolContentBannerFiles)
                .HasForeignKey(d => d.BannerFileId)
                .HasConstraintName("FK_SchoolContents_BannerFile");

            entity.HasOne(d => d.CertificateFile).WithMany(p => p.SchoolContentCertificateFiles)
                .HasForeignKey(d => d.CertificateFileId)
                .HasConstraintName("FK_SchoolContents_CertificateFile");

            entity.HasOne(d => d.LogoFile).WithMany(p => p.SchoolContentLogoFiles)
                .HasForeignKey(d => d.LogoFileId)
                .HasConstraintName("FK_SchoolContents_LogoFile");

            entity.HasOne(d => d.PhotoFile).WithMany(p => p.SchoolContentPhotoFiles)
                .HasForeignKey(d => d.PhotoFileId)
                .HasConstraintName("FK_SchoolContents_PhotoFile");

            entity.HasOne(d => d.School).WithMany(p => p.SchoolContents)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SchoolContents_Schools");
        });

        modelBuilder.Entity<SchoolEnvironmentalPathStatus>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SchoolEn__3214EC07A1B2C3D4");

            entity.HasIndex(e => new { e.EnvironmentalPathId, e.IsCompliant }, "IX_SchoolEnvironmentalPathStatus_Path_Compliant");

            entity.HasIndex(e => new { e.SchoolId, e.Status }, "IX_SchoolEnvironmentalPathStatus_School_Status");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.EvaluationDate }, "IX_SchoolEnvironmentalPathStatus_Status_DeletedTime_EvaluationDate");

            entity.HasIndex(e => new { e.SchoolId, e.EnvironmentalPathId }, "UQ_SchoolEnvironmentalPathStatus_School_Path").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.EvaluationDate).HasPrecision(3);
            entity.Property(e => e.Notes).HasMaxLength(500);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.SchoolEnvironmentalPathStatusCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SchoolEnvironmentalPathStatus_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.SchoolEnvironmentalPathStatusDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_SchoolEnvironmentalPathStatus_DeletedUser");

            entity.HasOne(d => d.EnvironmentalPath).WithMany(p => p.SchoolEnvironmentalPathStatuses)
                .HasForeignKey(d => d.EnvironmentalPathId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SchoolEnvironmentalPathStatus_EnvironmentalPaths");

            entity.HasOne(d => d.School).WithMany(p => p.SchoolEnvironmentalPathStatuses)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SchoolEnvironmentalPathStatus_Schools");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.SchoolEnvironmentalPathStatusUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_SchoolEnvironmentalPathStatus_UpdatedUser");
        });

        modelBuilder.Entity<SchoolImport>(entity =>
        {
            entity.ToTable(tb => tb.HasComment("政府管轄學校列表基本資訊匯入表"));

            entity.HasIndex(e => e.CountyId, "IX_SchoolImports_County");

            entity.HasIndex(e => e.DistrictId, "IX_SchoolImports_District");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_SchoolImports_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.Code, "UQ_SchoolImports_Code").IsUnique();

            entity.Property(e => e.Id).HasComment("學校匯入記錄ID (主鍵)");
            entity.Property(e => e.Address)
                .HasMaxLength(200)
                .HasComment("地址 (去除郵遞區號、縣市、地區後的地址)");
            entity.Property(e => e.Code)
                .HasMaxLength(12)
                .IsUnicode(false)
                .HasComment("學校代碼 (CSV中的代碼)");
            entity.Property(e => e.CountyId).HasComment("縣市ID (根據行政區對應)");
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.DistrictId).HasComment("行政區ID (根據郵遞區號對應)");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasComment("學校名稱");
            entity.Property(e => e.OriginalAddress)
                .HasMaxLength(300)
                .HasComment("原始地址 (CSV中的完整地址)");
            entity.Property(e => e.PublicPrivateType)
                .HasMaxLength(10)
                .HasComment("公私立標示 (CSV中的公/私立)");
            entity.Property(e => e.Remarks).HasMaxLength(500);
            entity.Property(e => e.Status).HasComment("狀態 (0=軟刪除, 1=啟用, 2=停用)");
            entity.Property(e => e.Tel)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasComment("電話號碼");
            entity.Property(e => e.UpdatedTime).HasPrecision(3);
            entity.Property(e => e.Url)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasComment("學校網址");

            entity.HasOne(d => d.County).WithMany(p => p.SchoolImports)
                .HasForeignKey(d => d.CountyId)
                .HasConstraintName("FK_SchoolImports_County");

            entity.HasOne(d => d.District).WithMany(p => p.SchoolImports)
                .HasForeignKey(d => d.DistrictId)
                .HasConstraintName("FK_SchoolImports_District");
        });

        modelBuilder.Entity<SchoolPrincipal>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SchoolPr__3214EC07FF1D12D4");

            entity.Property(e => e.PrincipalEmail)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.PrincipalMobile)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.PrincipalName).HasMaxLength(100);
            entity.Property(e => e.PrincipalPhone)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.School).WithMany(p => p.SchoolPrincipals)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SchoolPri__Schoo__1BD30ED5");
        });

        modelBuilder.Entity<SchoolStatistic>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SchoolSt__3214EC07440EB432");

            entity.HasOne(d => d.School).WithMany(p => p.SchoolStatistics)
                .HasForeignKey(d => d.SchoolId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SchoolSta__Schoo__32B6742D");
        });

        modelBuilder.Entity<SchoolType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SchoolTy__3214EC079F3F88D9");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_SchoolTypes_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_SchoolTypes_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.SchoolTypeCode, "UQ_SchoolTypes_SchoolTypeCode").IsUnique();

            entity.Property(e => e.SchoolTypeCode)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<SchoolTypeTranslation>(entity =>
        {
            entity.HasKey(e => e.SchoolTypeTranslationId).HasName("PK__SchoolTy__07680789EDFC773B");

            entity.HasIndex(e => e.LocaleCode, "IX_SchoolTypeTranslations_LocaleCode");

            entity.HasIndex(e => new { e.SchoolTypeId, e.LocaleCode }, "UQ_SchoolTypeTranslations_SchoolType_Locale").IsUnique();

            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Name).HasMaxLength(100);

            entity.HasOne(d => d.SchoolType).WithMany(p => p.SchoolTypeTranslations)
                .HasForeignKey(d => d.SchoolTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SchoolTypeTranslations_SchoolTypes");
        });

        modelBuilder.Entity<SocialAgency>(entity =>
        {
            entity.HasKey(e => e.SocialAgencyId).HasName("PK__SocialAg__893751AEC34A2AE7");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_SocialAgencies_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_SocialAgencies_Status_DeletedTime_SortOrder");

            entity.Property(e => e.ContactEmail).HasMaxLength(100);
            entity.Property(e => e.ContactPerson).HasMaxLength(100);
            entity.Property(e => e.ContactPhone).HasMaxLength(20);
            entity.Property(e => e.ContactWebsite).HasMaxLength(200);
            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.SocialAgencyCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencies_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.SocialAgencyDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_SocialAgencies_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.SocialAgencyUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_SocialAgencies_UpdatedUser");
        });

        modelBuilder.Entity<SocialAgencyContent>(entity =>
        {
            entity.HasKey(e => e.SocialAgencyContentId).HasName("PK__SocialAg__7D15B69B77ECA3C9");

            entity.HasIndex(e => new { e.SocialAgencyId, e.LocaleCode }, "IX_SocialAgencyContents_Agency_Locale");

            entity.HasIndex(e => e.LocaleCode, "IX_SocialAgencyContents_LocaleCode");

            entity.HasIndex(e => new { e.SocialAgencyId, e.LocaleCode }, "UQ_SocialAgencyContents_Agency_Locale").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.Introduction).HasMaxLength(1000);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.SocialAgencyContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyContents_CreatedUser");

            entity.HasOne(d => d.ImageFile).WithMany(p => p.SocialAgencyContents)
                .HasForeignKey(d => d.ImageFileId)
                .HasConstraintName("FK_SocialAgencyContents_ImageFile");

            entity.HasOne(d => d.SocialAgency).WithMany(p => p.SocialAgencyContents)
                .HasForeignKey(d => d.SocialAgencyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyContents_SocialAgency");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.SocialAgencyContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_SocialAgencyContents_UpdatedUser");
        });

        modelBuilder.Entity<SocialAgencyTag>(entity =>
        {
            entity.HasKey(e => e.SocialAgencyTagId).HasName("PK__SocialAg__298E79808E1FAC16");

            entity.HasIndex(e => new { e.IsActive, e.SortOrder }, "IX_SocialAgencyTags_IsActive_SortOrder");

            entity.HasIndex(e => new { e.Status, e.DeletedTime, e.SortOrder }, "IX_SocialAgencyTags_Status_DeletedTime_SortOrder");

            entity.HasIndex(e => e.TagCode, "IX_SocialAgencyTags_TagCode");

            entity.HasIndex(e => e.TagCode, "UQ__SocialAg__3BE4AAAC080C256E").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.DeletedTime).HasPrecision(3);
            entity.Property(e => e.TagCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.SocialAgencyTagCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyTags_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.SocialAgencyTagDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_SocialAgencyTags_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.SocialAgencyTagUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_SocialAgencyTags_UpdatedUser");
        });

        modelBuilder.Entity<SocialAgencyTagContent>(entity =>
        {
            entity.HasKey(e => e.SocialAgencyTagContentId).HasName("PK__SocialAg__8ED4E33DD6357A77");

            entity.HasIndex(e => e.LocaleCode, "IX_SocialAgencyTagContents_LocaleCode");

            entity.HasIndex(e => new { e.SocialAgencyTagId, e.LocaleCode }, "IX_SocialAgencyTagContents_Tag_Locale");

            entity.HasIndex(e => new { e.SocialAgencyTagId, e.LocaleCode }, "UQ_SocialAgencyTagContents_Tag_Locale").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);
            entity.Property(e => e.Label).HasMaxLength(100);
            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.SocialAgencyTagContentCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyTagContents_CreatedUser");

            entity.HasOne(d => d.SocialAgencyTag).WithMany(p => p.SocialAgencyTagContents)
                .HasForeignKey(d => d.SocialAgencyTagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyTagContents_Tag");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.SocialAgencyTagContentUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_SocialAgencyTagContents_UpdatedUser");
        });

        modelBuilder.Entity<SocialAgencyTagMapping>(entity =>
        {
            entity.HasKey(e => e.SocialAgencyTagMappingId).HasName("PK__SocialAg__CF048D0F98D85604");

            entity.HasIndex(e => e.SocialAgencyId, "IX_SocialAgencyTagMappings_Agency");

            entity.HasIndex(e => e.SocialAgencyTagId, "IX_SocialAgencyTagMappings_Tag");

            entity.HasIndex(e => new { e.SocialAgencyId, e.SocialAgencyTagId }, "UQ_SocialAgencyTagMappings_Agency_Tag").IsUnique();

            entity.Property(e => e.CreatedTime).HasPrecision(3);

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.SocialAgencyTagMappings)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyTagMappings_CreatedUser");

            entity.HasOne(d => d.SocialAgency).WithMany(p => p.SocialAgencyTagMappings)
                .HasForeignKey(d => d.SocialAgencyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyTagMappings_Agency");

            entity.HasOne(d => d.SocialAgencyTag).WithMany(p => p.SocialAgencyTagMappings)
                .HasForeignKey(d => d.SocialAgencyTagId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SocialAgencyTagMappings_Tag");
        });

        modelBuilder.Entity<UserToken>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserToke__3214EC07749F0DF3");

            entity.ToTable("UserToken");

            entity.HasIndex(e => new { e.AccountSid, e.TokenType }, "IX_UserToken_AccountSid_TokenType");

            entity.HasIndex(e => e.Token, "IX_UserToken_Token");

            entity.Property(e => e.ClientInfo).HasMaxLength(255);
            entity.Property(e => e.TokenType).HasMaxLength(50);

            entity.HasOne(d => d.AccountS).WithMany(p => p.UserTokens)
                .HasForeignKey(d => d.AccountSid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserToken_Account");
        });

        modelBuilder.Entity<Video>(entity =>
        {
            entity.HasKey(e => e.VideoId).HasName("PK__Videos__BAE5126AA4B24794");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.VideoCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Videos_CreatedUser");

            entity.HasOne(d => d.DeletedUser).WithMany(p => p.VideoDeletedUsers)
                .HasForeignKey(d => d.DeletedUserId)
                .HasConstraintName("FK_Videos_DeletedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.VideoUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_Videos_UpdatedUser");
        });

        modelBuilder.Entity<VideoTranslation>(entity =>
        {
            entity.HasKey(e => e.VideoTranslationId).HasName("PK__VideoTra__2A47BC87C12B6692");

            entity.HasIndex(e => new { e.VideoId, e.LocaleCode }, "UQ_VideoTranslations_Video_Locale").IsUnique();

            entity.Property(e => e.LocaleCode)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.Url).HasMaxLength(500);

            entity.HasOne(d => d.CoverFile).WithMany(p => p.VideoTranslations)
                .HasForeignKey(d => d.CoverFileId)
                .HasConstraintName("FK_VideoTranslations_CoverFile");

            entity.HasOne(d => d.CreatedUser).WithMany(p => p.VideoTranslationCreatedUsers)
                .HasForeignKey(d => d.CreatedUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VideoTranslations_CreatedUser");

            entity.HasOne(d => d.UpdatedUser).WithMany(p => p.VideoTranslationUpdatedUsers)
                .HasForeignKey(d => d.UpdatedUserId)
                .HasConstraintName("FK_VideoTranslations_UpdatedUser");

            entity.HasOne(d => d.Video).WithMany(p => p.VideoTranslations)
                .HasForeignKey(d => d.VideoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VideoTranslations_Videos");
        });

        modelBuilder.Entity<VisitLog>(entity =>
        {
            entity.HasKey(e => e.VisitLogId).HasName("PK__VisitLog__BB1AAB1FF61BB92A");

            entity.ToTable(tb => tb.HasComment("使用者頁面瀏覽記錄表，用於統計網站訪問量和使用者行為分析"));

            entity.HasIndex(e => e.ClientIp, "IX_VisitLogs_ClientIp");

            entity.HasIndex(e => new { e.ClientIp, e.VisitTime }, "IX_VisitLogs_ClientIp_VisitTime").IsDescending(false, true);

            entity.HasIndex(e => e.Pathname, "IX_VisitLogs_Pathname");

            entity.HasIndex(e => new { e.Pathname, e.VisitTime }, "IX_VisitLogs_Pathname_VisitTime").IsDescending(false, true);

            entity.HasIndex(e => e.VisitTime, "IX_VisitLogs_VisitTime").IsDescending();

            entity.Property(e => e.VisitLogId).HasComment("瀏覽記錄唯一識別碼");
            entity.Property(e => e.ClientIp)
                .HasMaxLength(50)
                .HasComment("客戶端 IP 位址");
            entity.Property(e => e.Device)
                .HasMaxLength(1000)
                .HasComment("使用者裝置資訊 (User Agent)");
            entity.Property(e => e.Pathname)
                .HasMaxLength(500)
                .HasComment("頁面路徑 (例：/about, /products)");
            entity.Property(e => e.VisitTime).HasComment("瀏覽時間");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class Account
{
    public long AccountId { get; set; }

    /// <summary>
    /// 學校資料編號
    /// </summary>
    public int? SchoolId { get; set; }

    public string? Username { get; set; }

    public string? Password { get; set; }

    public string? PasswordSalt { get; set; }

    public string? Email { get; set; }

    public string? Telephone { get; set; }

    public string? Phone { get; set; }

    public string? Birthday { get; set; }

    public int? CityId { get; set; }

    public int? AreaId { get; set; }

    public string? PostCode { get; set; }

    public string? Address { get; set; }

    public string? DutyDate { get; set; }

    public string? DepartureDate { get; set; }

    public string? ContactName { get; set; }

    public string? ContactPhone { get; set; }

    public string? ContactRelationship { get; set; }

    public Guid? ProfilePhotoFileId { get; set; }

    public int? SortOrder { get; set; }

    public string? Language { get; set; }

    public long? CreatedUserId { get; set; }

    public long? UpdatedUserId { get; set; }

    public int IsSystemAdmin { get; set; }

    public int IsSchoolPartner { get; set; }

    public int IsEpaUser { get; set; }

    public int IsGuidanceTeam { get; set; }

    public int? GuidanceTagId { get; set; }

    public int? CountyId { get; set; }

    public int? GovernmentUnitId { get; set; }

    public DateTime? CreatedTime { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    /// <summary>
    /// 帳號審核狀態：0=尚未審核, 1=已通過, 2=未通過
    /// </summary>
    public byte ReviewStatus { get; set; }

    public virtual ICollection<AccountPermissionGroup> AccountPermissionGroups { get; set; } = new List<AccountPermissionGroup>();

    public virtual ICollection<ArticleAttachment> ArticleAttachmentCreatedUsers { get; set; } = new List<ArticleAttachment>();

    public virtual ICollection<ArticleAttachment> ArticleAttachmentUpdatedUsers { get; set; } = new List<ArticleAttachment>();

    public virtual ICollection<ArticleContent> ArticleContentCreatedUsers { get; set; } = new List<ArticleContent>();

    public virtual ICollection<ArticleContent> ArticleContentUpdatedUsers { get; set; } = new List<ArticleContent>();

    public virtual ICollection<Article> ArticleCreatedUsers { get; set; } = new List<Article>();

    public virtual ICollection<Article> ArticleDeletedUsers { get; set; } = new List<Article>();

    public virtual ICollection<ArticleTag> ArticleTagCreatedUsers { get; set; } = new List<ArticleTag>();

    public virtual ICollection<ArticleTag> ArticleTagDeletedUsers { get; set; } = new List<ArticleTag>();

    public virtual ICollection<ArticleTag> ArticleTagUpdatedUsers { get; set; } = new List<ArticleTag>();

    public virtual ICollection<Article> ArticleUpdatedUsers { get; set; } = new List<Article>();

    public virtual ICollection<CampusSubmissionAttachment> CampusSubmissionAttachmentCreatedUsers { get; set; } = new List<CampusSubmissionAttachment>();

    public virtual ICollection<CampusSubmissionAttachment> CampusSubmissionAttachmentUpdatedUsers { get; set; } = new List<CampusSubmissionAttachment>();

    public virtual ICollection<CampusSubmissionContent> CampusSubmissionContentCreatedUsers { get; set; } = new List<CampusSubmissionContent>();

    public virtual ICollection<CampusSubmissionContent> CampusSubmissionContentUpdatedUsers { get; set; } = new List<CampusSubmissionContent>();

    public virtual ICollection<CampusSubmission> CampusSubmissionCreatedUsers { get; set; } = new List<CampusSubmission>();

    public virtual ICollection<CampusSubmission> CampusSubmissionDeletedUsers { get; set; } = new List<CampusSubmission>();

    public virtual ICollection<CampusSubmissionReview> CampusSubmissionReviewCreatedUsers { get; set; } = new List<CampusSubmissionReview>();

    public virtual ICollection<CampusSubmissionReview> CampusSubmissionReviewDeletedUsers { get; set; } = new List<CampusSubmissionReview>();

    public virtual ICollection<CampusSubmissionReview> CampusSubmissionReviewReviewers { get; set; } = new List<CampusSubmissionReview>();

    public virtual ICollection<CampusSubmissionReview> CampusSubmissionReviewUpdatedUsers { get; set; } = new List<CampusSubmissionReview>();

    public virtual ICollection<CampusSubmission> CampusSubmissionUpdatedUsers { get; set; } = new List<CampusSubmission>();

    public virtual ICollection<CertificationAnswer> CertificationAnswerCreatedUsers { get; set; } = new List<CertificationAnswer>();

    public virtual ICollection<CertificationAnswer> CertificationAnswerReviewedUsers { get; set; } = new List<CertificationAnswer>();

    public virtual ICollection<CertificationAnswer> CertificationAnswerUpdatedUsers { get; set; } = new List<CertificationAnswer>();

    public virtual ICollection<Certification> CertificationCreatedUsers { get; set; } = new List<Certification>();

    public virtual ICollection<Certification> CertificationDeletedUsers { get; set; } = new List<Certification>();

    public virtual ICollection<CertificationStepRecord> CertificationStepRecordCreatedUsers { get; set; } = new List<CertificationStepRecord>();

    public virtual ICollection<CertificationStepRecord> CertificationStepRecordUpdatedUsers { get; set; } = new List<CertificationStepRecord>();

    public virtual ICollection<Certification> CertificationUpdatedUsers { get; set; } = new List<Certification>();

    public virtual County? County { get; set; }

    public virtual Account? CreatedUser { get; set; }

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<DownloadAttachment> DownloadAttachmentCreatedUsers { get; set; } = new List<DownloadAttachment>();

    public virtual ICollection<DownloadAttachment> DownloadAttachmentUpdatedUsers { get; set; } = new List<DownloadAttachment>();

    public virtual ICollection<DownloadContent> DownloadContentCreatedUsers { get; set; } = new List<DownloadContent>();

    public virtual ICollection<DownloadContent> DownloadContentUpdatedUsers { get; set; } = new List<DownloadContent>();

    public virtual ICollection<Download> DownloadCreatedUsers { get; set; } = new List<Download>();

    public virtual ICollection<Download> DownloadDeletedUsers { get; set; } = new List<Download>();

    public virtual ICollection<DownloadTag> DownloadTagCreatedUsers { get; set; } = new List<DownloadTag>();

    public virtual ICollection<DownloadTag> DownloadTagDeletedUsers { get; set; } = new List<DownloadTag>();

    public virtual ICollection<DownloadTagTranslation> DownloadTagTranslationCreatedUsers { get; set; } = new List<DownloadTagTranslation>();

    public virtual ICollection<DownloadTagTranslation> DownloadTagTranslationUpdatedUsers { get; set; } = new List<DownloadTagTranslation>();

    public virtual ICollection<DownloadTag> DownloadTagUpdatedUsers { get; set; } = new List<DownloadTag>();

    public virtual ICollection<Download> DownloadUpdatedUsers { get; set; } = new List<Download>();

    public virtual ICollection<FaqContent> FaqContentCreatedUsers { get; set; } = new List<FaqContent>();

    public virtual ICollection<FaqContent> FaqContentUpdatedUsers { get; set; } = new List<FaqContent>();

    public virtual ICollection<Faq> FaqCreatedUsers { get; set; } = new List<Faq>();

    public virtual ICollection<Faq> FaqDeletedUsers { get; set; } = new List<Faq>();

    public virtual ICollection<FaqTagContent> FaqTagContentCreatedUsers { get; set; } = new List<FaqTagContent>();

    public virtual ICollection<FaqTagContent> FaqTagContentUpdatedUsers { get; set; } = new List<FaqTagContent>();

    public virtual ICollection<FaqTag> FaqTagCreatedUsers { get; set; } = new List<FaqTag>();

    public virtual ICollection<FaqTag> FaqTagDeletedUsers { get; set; } = new List<FaqTag>();

    public virtual ICollection<FaqTag> FaqTagUpdatedUsers { get; set; } = new List<FaqTag>();

    public virtual ICollection<Faq> FaqUpdatedUsers { get; set; } = new List<Faq>();

    public virtual ICollection<FriendlyLink> FriendlyLinkCreatedUsers { get; set; } = new List<FriendlyLink>();

    public virtual ICollection<FriendlyLink> FriendlyLinkDeletedUsers { get; set; } = new List<FriendlyLink>();

    public virtual ICollection<FriendlyLinkTag> FriendlyLinkTagCreatedUsers { get; set; } = new List<FriendlyLinkTag>();

    public virtual ICollection<FriendlyLinkTag> FriendlyLinkTagDeletedUsers { get; set; } = new List<FriendlyLinkTag>();

    public virtual ICollection<FriendlyLinkTagTranslation> FriendlyLinkTagTranslationCreatedUsers { get; set; } = new List<FriendlyLinkTagTranslation>();

    public virtual ICollection<FriendlyLinkTagTranslation> FriendlyLinkTagTranslationUpdatedUsers { get; set; } = new List<FriendlyLinkTagTranslation>();

    public virtual ICollection<FriendlyLinkTag> FriendlyLinkTagUpdatedUsers { get; set; } = new List<FriendlyLinkTag>();

    public virtual ICollection<FriendlyLinkTranslation> FriendlyLinkTranslationCreatedUsers { get; set; } = new List<FriendlyLinkTranslation>();

    public virtual ICollection<FriendlyLinkTranslation> FriendlyLinkTranslationUpdatedUsers { get; set; } = new List<FriendlyLinkTranslation>();

    public virtual ICollection<FriendlyLink> FriendlyLinkUpdatedUsers { get; set; } = new List<FriendlyLink>();

    public virtual ICollection<GovernmentUnit> GovernmentUnitCreatedUsers { get; set; } = new List<GovernmentUnit>();

    public virtual ICollection<GovernmentUnit> GovernmentUnitDeletedUsers { get; set; } = new List<GovernmentUnit>();

    public virtual ICollection<GovernmentUnitTranslation> GovernmentUnitTranslationCreatedUsers { get; set; } = new List<GovernmentUnitTranslation>();

    public virtual ICollection<GovernmentUnitTranslation> GovernmentUnitTranslationUpdatedUsers { get; set; } = new List<GovernmentUnitTranslation>();

    public virtual ICollection<GovernmentUnit> GovernmentUnitUpdatedUsers { get; set; } = new List<GovernmentUnit>();

    public virtual GuidanceTag? GuidanceTag { get; set; }

    public virtual ICollection<GuidanceTagContent> GuidanceTagContentCreatedUsers { get; set; } = new List<GuidanceTagContent>();

    public virtual ICollection<GuidanceTagContent> GuidanceTagContentUpdatedUsers { get; set; } = new List<GuidanceTagContent>();

    public virtual ICollection<GuidanceTag> GuidanceTagCreatedUsers { get; set; } = new List<GuidanceTag>();

    public virtual ICollection<GuidanceTag> GuidanceTagDeletedUsers { get; set; } = new List<GuidanceTag>();

    public virtual ICollection<GuidanceTag> GuidanceTagUpdatedUsers { get; set; } = new List<GuidanceTag>();

    public virtual ICollection<HomeBannerContent> HomeBannerContentCreatedUsers { get; set; } = new List<HomeBannerContent>();

    public virtual ICollection<HomeBannerContent> HomeBannerContentUpdatedUsers { get; set; } = new List<HomeBannerContent>();

    public virtual ICollection<HomeBanner> HomeBannerCreatedUsers { get; set; } = new List<HomeBanner>();

    public virtual ICollection<HomeBanner> HomeBannerDeletedUsers { get; set; } = new List<HomeBanner>();

    public virtual ICollection<HomeBanner> HomeBannerUpdatedUsers { get; set; } = new List<HomeBanner>();

    public virtual ICollection<Account> InverseCreatedUser { get; set; } = new List<Account>();

    public virtual ICollection<Account> InverseDeletedUser { get; set; } = new List<Account>();

    public virtual ICollection<Account> InverseUpdatedUser { get; set; } = new List<Account>();

    public virtual ICollection<MemberProfile> MemberProfileAccounts { get; set; } = new List<MemberProfile>();

    public virtual ICollection<MemberProfile> MemberProfileCreatedUsers { get; set; } = new List<MemberProfile>();

    public virtual ICollection<MemberProfile> MemberProfileUpdatedUsers { get; set; } = new List<MemberProfile>();

    public virtual ICollection<Question> QuestionCreatedUsers { get; set; } = new List<Question>();

    public virtual ICollection<Question> QuestionDeletedUsers { get; set; } = new List<Question>();

    public virtual ICollection<Question> QuestionUpdatedUsers { get; set; } = new List<Question>();

    public virtual ICollection<SchoolEnvironmentalPathStatus> SchoolEnvironmentalPathStatusCreatedUsers { get; set; } = new List<SchoolEnvironmentalPathStatus>();

    public virtual ICollection<SchoolEnvironmentalPathStatus> SchoolEnvironmentalPathStatusDeletedUsers { get; set; } = new List<SchoolEnvironmentalPathStatus>();

    public virtual ICollection<SchoolEnvironmentalPathStatus> SchoolEnvironmentalPathStatusUpdatedUsers { get; set; } = new List<SchoolEnvironmentalPathStatus>();

    public virtual ICollection<SocialAgencyContent> SocialAgencyContentCreatedUsers { get; set; } = new List<SocialAgencyContent>();

    public virtual ICollection<SocialAgencyContent> SocialAgencyContentUpdatedUsers { get; set; } = new List<SocialAgencyContent>();

    public virtual ICollection<SocialAgency> SocialAgencyCreatedUsers { get; set; } = new List<SocialAgency>();

    public virtual ICollection<SocialAgency> SocialAgencyDeletedUsers { get; set; } = new List<SocialAgency>();

    public virtual ICollection<SocialAgencyTagContent> SocialAgencyTagContentCreatedUsers { get; set; } = new List<SocialAgencyTagContent>();

    public virtual ICollection<SocialAgencyTagContent> SocialAgencyTagContentUpdatedUsers { get; set; } = new List<SocialAgencyTagContent>();

    public virtual ICollection<SocialAgencyTag> SocialAgencyTagCreatedUsers { get; set; } = new List<SocialAgencyTag>();

    public virtual ICollection<SocialAgencyTag> SocialAgencyTagDeletedUsers { get; set; } = new List<SocialAgencyTag>();

    public virtual ICollection<SocialAgencyTagMapping> SocialAgencyTagMappings { get; set; } = new List<SocialAgencyTagMapping>();

    public virtual ICollection<SocialAgencyTag> SocialAgencyTagUpdatedUsers { get; set; } = new List<SocialAgencyTag>();

    public virtual ICollection<SocialAgency> SocialAgencyUpdatedUsers { get; set; } = new List<SocialAgency>();

    public virtual Account? UpdatedUser { get; set; }

    public virtual ICollection<UserToken> UserTokens { get; set; } = new List<UserToken>();

    public virtual ICollection<Video> VideoCreatedUsers { get; set; } = new List<Video>();

    public virtual ICollection<Video> VideoDeletedUsers { get; set; } = new List<Video>();

    public virtual ICollection<VideoTranslation> VideoTranslationCreatedUsers { get; set; } = new List<VideoTranslation>();

    public virtual ICollection<VideoTranslation> VideoTranslationUpdatedUsers { get; set; } = new List<VideoTranslation>();

    public virtual ICollection<Video> VideoUpdatedUsers { get; set; } = new List<Video>();
}

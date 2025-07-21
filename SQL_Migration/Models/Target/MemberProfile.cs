using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class MemberProfile
{
    public long MemberProfileId { get; set; }

    public long AccountId { get; set; }

    public string LocaleCode { get; set; } = null!;

    public string? CitizenDigitalNumber { get; set; }

    public string? Captcha { get; set; }

    public string? Code { get; set; }

    public string? MemberName { get; set; }

    public string? MemberAddress { get; set; }

    public string? MemberTelephone { get; set; }

    public string? MemberPhone { get; set; }

    public string? MemberEmail { get; set; }

    public int? JobId { get; set; }

    public string? JobName { get; set; }

    public int? PlaceId { get; set; }

    public string? PlaceName { get; set; }

    public string? MemberIntroduction { get; set; }

    public string? MemberPhotoFileId { get; set; }

    public string? MemberRole { get; set; }

    public string? MemberExchange { get; set; }

    public string? MemberUrl { get; set; }

    public int? TagId { get; set; }

    public int? Isuse { get; set; }

    public int? IsDeleted { get; set; }

    public int? IsInternal { get; set; }

    public string? AreaAttributes { get; set; }

    public DateTime? UpdatePasswordTime { get; set; }

    public DateTime? MemberPassTime { get; set; }

    public string? RegisterReview { get; set; }

    public int? UseMemberRecordId { get; set; }

    public int? ReviewMemberRecordId { get; set; }

    public int? CreateDateTimestamp { get; set; }

    public string? CreateUserName { get; set; }

    public string? CreateIp { get; set; }

    public int? UpdateDateTimestamp { get; set; }

    public string? UpdateUserName { get; set; }

    public string? UpdateIp { get; set; }

    public DateTime CreatedTime { get; set; }

    public long? CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual Account? CreatedUser { get; set; }

    public virtual Account? UpdatedUser { get; set; }
}

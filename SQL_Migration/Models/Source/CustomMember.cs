using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 紀錄各身份使用者資料
/// </summary>
public partial class CustomMember
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long? GroupsSid { get; set; }

    /// <summary>
    /// 帳號
    /// </summary>
    public string? Account { get; set; }

    /// <summary>
    /// 自然人憑證序號
    /// </summary>
    public string? CitizenDigitalNumber { get; set; }

    /// <summary>
    /// 密碼
    /// </summary>
    public string? Password { get; set; }

    /// <summary>
    /// 密碼加密編碼
    /// </summary>
    public string? PasswordSalt { get; set; }

    /// <summary>
    /// 驗證碼
    /// </summary>
    public string? Captcha { get; set; }

    /// <summary>
    /// 學校代碼
    /// </summary>
    public string? Code { get; set; }

    /// <summary>
    /// 使用者名稱
    /// </summary>
    public string? MemberCname { get; set; }

    /// <summary>
    /// 使用者名稱(英文)
    /// </summary>
    public string? MemberCnameEn { get; set; }

    /// <summary>
    /// 縣市sid
    /// </summary>
    public int? CitySid { get; set; }

    /// <summary>
    /// 地區sid
    /// </summary>
    public int? AreaSid { get; set; }

    /// <summary>
    /// 地址
    /// </summary>
    public string? MemberAddress { get; set; }

    /// <summary>
    /// 使用者電話
    /// </summary>
    public string? MemberTel { get; set; }

    /// <summary>
    /// 使用者手機
    /// </summary>
    public string? MemberPhone { get; set; }

    /// <summary>
    /// 使用者信箱
    /// </summary>
    public string? MemberEmail { get; set; }

    public int? JobSid { get; set; }

    public int? PlaceSid { get; set; }

    /// <summary>
    /// 單位名稱
    /// </summary>
    public string? PlaceCname { get; set; }

    /// <summary>
    /// 職稱名稱
    /// </summary>
    public string? JobCname { get; set; }

    /// <summary>
    /// 地址(英文)
    /// </summary>
    public string? MemberAddressEn { get; set; }

    /// <summary>
    /// 使用者介紹
    /// </summary>
    public string? MemberIntroduction { get; set; }

    /// <summary>
    /// 使用者介紹(英文)
    /// </summary>
    public string? MemberIntroductionEn { get; set; }

    /// <summary>
    /// 使用者照片
    /// </summary>
    public string? MemberPhoto { get; set; }

    /// <summary>
    /// 使用者身份；生態學校:school, 環保局人員:epa , 輔導人員:tutor
    /// </summary>
    public string? MemberRole { get; set; }

    /// <summary>
    /// 1:是、0:否
    /// </summary>
    public string? MemberExchange { get; set; }

    public string? MemberUrl { get; set; }

    /// <summary>
    /// 使用者身份的分類sid
    /// </summary>
    public int? TagSid { get; set; }

    /// <summary>
    /// 是否啟用；1:是、0:否
    /// </summary>
    public int? Isuse { get; set; }

    /// <summary>
    /// 假刪除；1:是、0:否
    /// </summary>
    public int IsDel { get; set; }

    /// <summary>
    /// 內部測試；1:是、0:否
    /// </summary>
    public int IsInternal { get; set; }

    /// <summary>
    /// 地區屬性 (&apos;general&apos;=&gt;一般 ,&apos;remote&apos;=&gt;偏遠 ,&apos;particularly&apos;=&gt;特偏 ,&apos;extremely_biased&apos;=&gt;極偏)
    /// </summary>
    public string? AreaAttributes { get; set; }

    /// <summary>
    /// 通過時間
    /// </summary>
    public string? MemberPassdate { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public string? RegisterReview { get; set; }

    public int? UseMemberRecordSid { get; set; }

    public int? ReviewMemberRecordSid { get; set; }

    /// <summary>
    /// 轉換用的新密碼更新時間
    /// </summary>
    public DateTime? UpdatePasswordDateNew { get; set; }

    public virtual ICollection<CustomCertification> CustomCertifications { get; set; } = new List<CustomCertification>();

    public virtual ICollection<CustomContact> CustomContacts { get; set; } = new List<CustomContact>();

    public virtual ICollection<CustomMemberLevel> CustomMemberLevels { get; set; } = new List<CustomMemberLevel>();

    public virtual ICollection<CustomMemberPath> CustomMemberPaths { get; set; } = new List<CustomMemberPath>();

    public virtual ICollection<CustomSchoolPrincipal> CustomSchoolPrincipals { get; set; } = new List<CustomSchoolPrincipal>();

    public virtual ICollection<CustomSchoolStatistic> CustomSchoolStatistics { get; set; } = new List<CustomSchoolStatistic>();
}

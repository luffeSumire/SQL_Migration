using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class School
{
    public int Id { get; set; }

    public string SchoolCode { get; set; } = null!;

    public int CountyId { get; set; }

    public int DistrictId { get; set; }

    public int SchoolTypeId { get; set; }

    public string? Phone { get; set; }

    public string? MobilePhone { get; set; }

    public string? Email { get; set; }

    public bool IsExchangeSchool { get; set; }

    public DateTime? CertifiedDate { get; set; }

    public bool IsInternalTest { get; set; }

    public int SortOrder { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public virtual ICollection<CampusSubmission> CampusSubmissions { get; set; } = new List<CampusSubmission>();

    public virtual ICollection<Certification> Certifications { get; set; } = new List<Certification>();

    public virtual County County { get; set; } = null!;

    public virtual District District { get; set; } = null!;

    public virtual ICollection<SchoolContact> SchoolContacts { get; set; } = new List<SchoolContact>();

    public virtual ICollection<SchoolContent> SchoolContents { get; set; } = new List<SchoolContent>();

    public virtual ICollection<SchoolEnvironmentalPathStatus> SchoolEnvironmentalPathStatuses { get; set; } = new List<SchoolEnvironmentalPathStatus>();

    public virtual ICollection<SchoolPrincipal> SchoolPrincipals { get; set; } = new List<SchoolPrincipal>();

    public virtual ICollection<SchoolStatistic> SchoolStatistics { get; set; } = new List<SchoolStatistic>();

    public virtual SchoolType SchoolType { get; set; } = null!;
}

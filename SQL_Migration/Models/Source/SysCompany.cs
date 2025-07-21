using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysCompany
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long ParentSid { get; set; }

    public string? Cname { get; set; }

    public string? CnameEn { get; set; }

    public string? Opendate { get; set; }

    public string? Invoice { get; set; }

    public string? Vatnumber { get; set; }

    public string? Ceo { get; set; }

    public string? Tel { get; set; }

    public string? TelEn { get; set; }

    public string? TelExt { get; set; }

    public string? TelService { get; set; }

    public string? Fax1 { get; set; }

    public string? Fax2 { get; set; }

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public int? CitySid { get; set; }

    public int? AreaSid { get; set; }

    public string? PostCode { get; set; }

    public string? Address { get; set; }

    public string? AddressEn { get; set; }

    public byte[]? ServiceTime { get; set; }

    public int Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// line API 所需
    /// </summary>
    public string? LineChannelAccessToken { get; set; }

    /// <summary>
    /// line API 所需
    /// </summary>
    public string? LineChannelSecret { get; set; }
}

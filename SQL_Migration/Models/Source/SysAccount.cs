using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysAccount
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public long GroupsSid { get; set; }

    public long CompanySid { get; set; }

    public long? CompanyTitleSid { get; set; }

    public string? Account { get; set; }

    public string? Password { get; set; }

    public string? PasswordSalt { get; set; }

    public string? Cname { get; set; }

    public string? CnameEn { get; set; }

    public string? Email { get; set; }

    public string? Tel { get; set; }

    public string? Phone { get; set; }

    public string? Birthday { get; set; }

    public int? CitySid { get; set; }

    public int? AreaSid { get; set; }

    public string? PostCode { get; set; }

    public string? Address { get; set; }

    public string? Dutydate { get; set; }

    public string? Departuredate { get; set; }

    public string? ContactName { get; set; }

    public string? ContactPhone { get; set; }

    public string? ContactRelationship { get; set; }

    public string? Picinfo { get; set; }

    public int? Isuse { get; set; }

    public string? Remark { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}
